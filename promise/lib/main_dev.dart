
import 'package:azure_app_config/azure_app_config.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:promise/config/flavor_config.dart';
import 'package:promise/config/network.const.dart';
import 'package:promise/main.dart';

void main() async {
  FlutterError.onError = (details) {
    FlutterError.presentError(details);
    if (kReleaseMode) {}
  };
  
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  Map<String, String> result = {};
  try{
    final service = AzureAppConfig(connectionString: azureAppConfigConnectionStringDev);
    var configs = (await service.findKeyValuesBy(key: "Mobile/*", label: Flavor.Dev.name));
    result = {
      for (var v in configs) v.key.replaceFirst('Mobile/', ''): v.value
    };
  }
  catch(e){
      result.addAll({"BaseUrlApi": "https://promisewebapi-gtcsakhza7f5hvd9.southeastasia-01.azurewebsites.net"});
  }

  result.addAll({"BaseUrlApi": "https://de54-116-111-185-87.ngrok-free.app"});
  
  FlavorConfig.set(
    Flavor.Dev,
    FlavorValues(baseUrlApi: result['BaseUrlApi']!),
  );

  await runApplication();
  FlutterNativeSplash.remove();
}