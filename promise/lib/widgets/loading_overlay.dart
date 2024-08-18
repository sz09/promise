import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class LoadingOverlay {
  BuildContext _context;

  void hide() {
    Navigator.of(_context).pop();
  }

  void show({bool shouldPop = true}) {
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

  Future<T> during<T>(Future<T> future) {
    show();
    return future.whenComplete(() => hide());
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
