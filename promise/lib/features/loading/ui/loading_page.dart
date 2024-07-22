import 'package:flutter/material.dart';
import 'package:promise/features/loading/ui/circular_progress_indicator.dart';

class LoadingPage extends Page {
  @override
  Route createRoute(BuildContext context) {
    return MaterialPageRoute(
      settings: this,
      builder: (BuildContext context) => Scaffold(
        appBar: AppBar(),
        body: const Padding(
          padding: EdgeInsets.all(16.0),
          child: Center(
            child: PlatformCircularProgressIndicator(),
          ),
        ),
      ),
    );
  }
}
