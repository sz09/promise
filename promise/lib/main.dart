import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:promise/..config/flavor_config.dart';
import 'package:promise/..config/network.const.dart';
import 'package:promise/app_1.dart';
import 'package:promise/pre_app_config.dart';
import 'package:promise/util/log/bloc_events_logger.dart';

final rootNavigatorKey = GlobalKey<NavigatorState>();
final authNavigatorKey = GlobalKey<NavigatorState>();
final homeNavigatorKey = GlobalKey<NavigatorState>();
// coverage:ignore-start
void main() async {
  FlavorConfig.set(
    Flavor.DEV,
    FlavorValues(baseUrlApi: baseUrlDev),
  );
  await preAppConfig();
  Bloc.observer = BlocEvensLogger();
  // runApp(const ProviderScope(child: App()));
  runApp(const MyApp());
}
