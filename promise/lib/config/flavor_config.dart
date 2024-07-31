import 'package:promise/util/enum_util.dart';

// ignore: constant_identifier_names
enum Flavor { MOCK, Dev, STAGING, PRODUCTION }

/// App specific flavor values.
class FlavorValues {
  final String baseUrlApi;
  //todo add flavor specific values here

  FlavorValues({required this.baseUrlApi});
}

/// Flavor static configuration. Use it to access flavor specific settings.
abstract class FlavorConfig {
  static Flavor? _flavor;
  static String? _flavorName;
  static FlavorValues? _values;

  /// Sets the flavor configuration.
  /// Should be called just when the app starts before any access calls.
  static void set(Flavor flavor, FlavorValues values) {
    _flavor = flavor;
    _flavorName = enumToString(flavor);
    _values = values;
  }

  static bool isInitialized() => _flavor != null; //in tests it's not

  static bool isMock() => _flavor! == Flavor.MOCK;

  static bool isDev() => _flavor! == Flavor.Dev;

  static bool isStaging() => _flavor! == Flavor.STAGING;

  static bool isProduction() => _flavor! == Flavor.PRODUCTION;

  static String get flavorName => _flavorName!;

  static FlavorValues get values => _values!;
}
