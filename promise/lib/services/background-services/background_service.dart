
import 'dart:async';

import 'package:flutter_background_service/flutter_background_service.dart';

final _service = FlutterBackgroundService();
Future<void> registerBackgroundServices() async {
  _service.configure(
    androidConfiguration: AndroidConfiguration(
      onStart: _onStart,
      autoStart: true,
      isForegroundMode: true,
    ),
    iosConfiguration: IosConfiguration(
      onForeground: _onStart,
      autoStart: true,
    )
  );
}

void _onStart(ServiceInstance service) async {
  if (service is AndroidServiceInstance) {
    service.on('setAsForeground').listen((event) {
      service.setAsForegroundService();
    });

    service.on('stopService').listen((event) {
      service.stopSelf();
    });
  }

  // Gửi dữ liệu định kỳ đến frontend
  Timer.periodic(const Duration(seconds: 5), (timer) async {
    if (service is AndroidServiceInstance) {
      if (!(await service.isForegroundService())) {
        timer.cancel();
        return;
      }
    }
    
    service.invoke('update', {"current_date": DateTime.now().toIso8601String()});
  });
}