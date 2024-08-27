import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:promise/di/public.resource.di.dart';
import 'package:promise/features/auth/user_api_service.dart';
import 'package:promise/models/user/user_credentials.dart';
import 'package:promise/networks/http_api_service_provider.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:promise/config/firebase_config.dart';
import 'package:promise/config/flavor_config.dart';
import 'package:promise/di/user_scope_hook.dart';
import 'package:promise/features/settings/preferences_helper.dart';
import 'package:promise/networks/user_auth_api_service.dart';
import 'package:promise/networks/authenticator/dio_authenticator_helper_jwt.dart';
import 'package:promise/notifications/data/data_notification_consumer.dart';
import 'package:promise/notifications/data/data_notification_consumer_factory.dart';
import 'package:promise/notifications/fcm/firebase_user_hook.dart';
import 'package:promise/notifications/fcm/fcm_notifications_listener.dart';
import 'package:promise/notifications/local/local_notification_manager.dart';
import 'package:promise/platform_comm/platform_comm.dart';
import 'package:promise/repositories/memories/memory.remote.repository.dart';
import 'package:promise/repositories/people/people.remote.repository.dart';
import 'package:promise/repositories/promises/promise.remote.repository.dart';
import 'package:promise/user/user_event_hook.dart';
import 'package:promise/user/user_manager.dart';
import 'package:promise/util/app_lifecycle_observer.dart';
import 'package:get_it/get_it.dart';
import 'package:promise/util/network_utils.dart';
import 'package:single_item_secure_storage/single_item_secure_storage.dart';
import 'package:single_item_shared_prefs/single_item_shared_prefs.dart';
import 'package:single_item_storage/cached_storage.dart';
import 'package:single_item_storage/observed_storage.dart';
import 'package:single_item_storage/storage.dart';

final GetIt serviceLocator = GetIt.asNewInstance();

// Storage constants
const String preferredLocalizationKey = 'preferred-language';
const String preferredThemeModeKey = 'preferred-theme-mode';

// Build Version
const String buildVersionKey = 'build-version-key';

/// Sets up the app global (baseScope) component's dependencies.
///
/// This method is called before the app launches, suspending any further
/// execution until it finishes. To minimize the app loading time keep this
/// setup fast and simple.
Future<void> setupGlobalDependencies() async {
  // Data
  final ObservedStorage<UserCredentials> userStorage =
      ObservedStorage<UserCredentials>(CachedStorage(SecureStorage(
    itemKey: 'model.user.user-credentials',
    fromMap: (map) => UserCredentials.fromJson(map),
    toMap: (user) => user.toJson(),
    iosOptions: const IOSOptions(accessibility: KeychainAccessibility.first_unlock),
  )));

  // Network
  final NetworkUtils networkUtils = NetworkUtils(Connectivity());
  final String baseUrlApi = FlavorConfig.values.baseUrlApi;

  HttpApiServiceProvider apiProvider = HttpApiServiceProvider(
    baseUrl: baseUrlApi,
    userStore: userStorage,
    packageInfo: await PackageInfo.fromPlatform(),
  );

  final AuthenticatorHelperJwt authHelperJwt = apiProvider.getAuthHelperJwt();
  UserApiService userApi = apiProvider.getUserApiService();
  final UserAuthApiService userAuthApi = apiProvider.getUserAuthApiService();
  final apiClient = apiProvider.apiClient;

  // if (FlavorConfig.isMock()) {
  //   userApi = MockUserApiService();
  //   //memoriesApi = MockTasksApiService();
  // }

  // Notifications

  //// DataNotificationManager
  final dataNotificationConsumer = DataNotificationConsumerFactory.create();

  //// Local
  final localNotificationsManager = LocalNotificationsManager.create();

  //// Data Notification Handlers
  DataNotificationConsumerFactory.registerNewMessageHandlers(
    dataNotificationConsumer,
    localNotificationsManager,
    PlatformComm.generalAppChannel(), //maybe not use general
  );

  //// FCM
  final fcmNotificationsListener = FcmNotificationsListener(
    dataNotificationConsumer: dataNotificationConsumer,
    localNotificationsManager: localNotificationsManager,
    showInForeground: true,
    fcm: SharedPrefsStorage<String>.primitive(itemKey: fcmTokenKey),
    userApiService: userApi,
  );

  final firebaseUserHook = shouldConfigureFirebase()
      ? FirebaseUserHook(FirebaseCrashlytics.instance, fcmNotificationsListener)
      : StubUserEventHook<UserCredentials>();

  // User Manager
  final UserScopeHook userScopeHook = UserScopeHook();
  final UserManager userManager = UserManager(
    userApi,
    userStorage,
    userEventHooks: [
      firebaseUserHook,
      userScopeHook,
    ],
  );

  // Platform comm
  final PlatformComm platformComm = PlatformComm.generalAppChannel()
    ..listenToNativeLogs();

  // UI
  final AppLifecycleObserver appLifecycleObserver = AppLifecycleObserver();

  // Preferences
  final PreferencesHelper preferences = PreferencesHelper();

  // Build version
  final PackageInfo packageInfo = await PackageInfo.fromPlatform();
  final String buildVersion =
      'Build version ${packageInfo.version} (${packageInfo.buildNumber})';
  serviceLocator
    // ..registerSingleton<LocalNotificationsManager>(localNotificationsManager)
    ..registerDIForPublicResources(apiClient)
    ..registerSingleton<DataNotificationConsumer>(dataNotificationConsumer)
    ..registerSingleton<FcmNotificationsListener>(fcmNotificationsListener)
    ..registerSingleton<Storage<UserCredentials>>(userStorage)
    ..registerSingleton<AuthenticatorHelperJwt>(authHelperJwt)
    ..registerSingleton<UserApiService>(userApi)
    ..registerSingleton<UserAuthApiService>(userAuthApi)
    ..registerSingleton<MemoryRemoteRepository>(MemoryRemoteRepository(client: apiClient))
    ..registerSingleton<PromiseRemoteRepository>(PromiseRemoteRepository(client: apiClient))
    ..registerSingleton<PersonRemoteRepository>(PersonRemoteRepository(client: apiClient))
    ..registerSingleton<UserManager>(userManager)
    ..registerSingleton<AppLifecycleObserver>(appLifecycleObserver)
    ..registerSingleton<PlatformComm>(platformComm)
    ..registerSingleton<NetworkUtils>(networkUtils)
    ..registerSingleton<PreferencesHelper>(preferences)
    ..registerSingleton<String>(buildVersion, instanceName: buildVersionKey)
    ..registerLazySingleton<Storage<String>>(
        () => SharedPrefsStorage<String>.primitive(
            itemKey: preferredLocalizationKey),
        instanceName: preferredLocalizationKey)
    ..registerLazySingleton<Storage<bool>>(
        () =>
            SharedPrefsStorage<bool>.primitive(itemKey: preferredThemeModeKey),
        instanceName: preferredThemeModeKey);
}

Future<void> teardown() async {
  try {
    await serviceLocator.get<UserManager>().teardown();
  // ignore: empty_catches
  } catch (exp) {}
}
