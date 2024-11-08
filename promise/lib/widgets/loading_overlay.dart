// ignore_for_file: use_build_context_synchronously
// ignore_for_file: avoid_init_to_null

import 'dart:io' show Platform;

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:queue/queue.dart';
import 'package:synchronized/synchronized.dart';

LoadingOverlay? _loadingOverlay = null;

set loadingOverlay(LoadingOverlay loadingOverlay) {
  _loadingOverlay = loadingOverlay;
}

LoadingOverlay get loadingOverlay {
  if (_loadingOverlay == null) {
    loadingOverlay = LoadingOverlay._create(Get.context!);
  }
  return _loadingOverlay!;
}

class LoadingOverlay {
  final BuildContext _context;
  int _counter = 0;
  bool _showingDialog = false;
  final Lock _lock = Lock();

  final Queue queue = Queue(delay: const Duration(milliseconds: 10));

  void _hide() {
    queue.add(() => Future.microtask(() async {
          await _lock.synchronized(() {
            _counter--;
          });
          if (_counter == 0 && _showingDialog) {
            Navigator.of(_context).pop();
            _showingDialog = false;
          }

          Future.sync(() => {});
        }));
  }

  void _show() {
    queue.add(() => Future.microtask(() async {
          await _lock.synchronized(() async {
            _counter++;
            if (_counter > 0 && !_showingDialog) {
              _showingDialog = true;
              showDialog(
                useSafeArea: false,
                context: _context,
                barrierDismissible: false,
                builder: (builderContext) => PopScope(
                  onPopInvokedWithResult: (x, y) async {},
                  child: _FullScreenLoader(),
                ),
              ).then((value) {});
            }
          });
        }));
  }

  Future<T> during<T>(Future<T> future,
      {T Function(T)? doneHandler = null,
      Function? finallyHandler = null,
      Function? errorHandler = null}) async {
    _show();
   return future.then((r) async {
        _hide();
        if (doneHandler != null) {
          return doneHandler.call(r);
        }
        return r;
      })
        // ignore: argument_type_not_assignable_to_error_handler
        .catchError(() async {
          errorHandler?.call();
          _hide();
        });
  }

  LoadingOverlay._create(this._context);
}

class _FullScreenLoader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);

    return Theme(
      data: themeData.copyWith(
        cupertinoOverrideTheme:
            const CupertinoThemeData(brightness: Brightness.dark),
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

Widget loadingWidget() {
  return const Center(child: CircularProgressIndicator());
}
