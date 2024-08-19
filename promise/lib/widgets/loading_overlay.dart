// ignore_for_file: use_build_context_synchronously

import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:synchronized/synchronized.dart';

class LoadingOverlay {
  BuildContext _context;
  final Lock _lock = Lock();
  int _counter = 0;

  Future<void> hide() async {
    await _lock.synchronized((){
      _counter--;
    });
    if(_counter == 0){
      Navigator.of(_context).pop();
    }
  }

  Future<void> show({bool shouldPop = true}) async {
    await _lock.synchronized((){
      _counter++;
    });
    if(_counter > 0){
      showDialog(
        useSafeArea: false,
        context: _context,
        barrierDismissible: false,
        builder: (builderContext) => PopScope(
          onPopInvokedWithResult: (x, y) async{

          },
          child: _FullScreenLoader(),
        ),
      );
    }
  }

  Future<T> during<T>(Future<T> future) async {
    await show();
    return future.whenComplete(() async => await hide());
  }

  LoadingOverlay._create(this._context);

  factory LoadingOverlay.of(BuildContext context) {
    return LoadingOverlay._create(context);
  }
}

class _FullScreenLoader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);

    return Theme(
      data: themeData.copyWith(
        cupertinoOverrideTheme: const CupertinoThemeData(brightness: Brightness.dark),
      ),
      child: Container(
        decoration: const BoxDecoration(
          color: Color.fromRGBO(0, 0, 0, 0.5),
        ),
        child: Center(
          child: Platform.isIOS
              ? const CupertinoActivityIndicator(
                  radius: 15,
                )
              : const CircularProgressIndicator(),
        ),
      ),
    );
  }
}
