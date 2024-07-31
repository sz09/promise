import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:promise/config/flavor_config.dart';
import 'package:promise/config/network.const.dart';
import 'package:promise/app_1.dart';
import 'package:promise/pre_app_config.dart';
import 'package:promise/util/log/bloc_events_logger.dart';
import 'package:azure_app_config/azure_app_config.dart';
import 'main.reflectable.dart';

final rootNavigatorKey = GlobalKey<NavigatorState>();
final authNavigatorKey = GlobalKey<NavigatorState>();
final homeNavigatorKey = GlobalKey<NavigatorState>();

void main() async {
  final service = AzureAppConfig(connectionString: azureAppConfigConnectionStringDev);
  var configs = (await service.findKeyValuesBy(key: "Mobile/*", label: Flavor.Dev.name));
  var result = { for (var v in configs) v.key.replaceFirst('Mobile/', ''): v.value };
  FlavorConfig.set(
    Flavor.Dev,
    FlavorValues(baseUrlApi: result['BaseUrlApi']!),
  );
  initializeReflectable();
  await preAppConfig();
  Bloc.observer = BlocEvensLogger();
  // runApp(const ProviderScope(child: App()));
  runApp(const MyApp());
}