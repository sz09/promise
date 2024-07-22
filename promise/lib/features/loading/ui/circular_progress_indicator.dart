import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class PlatformCircularProgressIndicator extends StatelessWidget {
  final double padding;
  final double height;
  final double width;

  const PlatformCircularProgressIndicator({
    super.key,
    this.padding = 0,
    this.height = 30,
    this.width = 30,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(padding),
      child: Center(
        child: SizedBox(
          height: height,
          width: width,
          child: Platform.isIOS
              ? CupertinoActivityIndicator(radius: height / 2.0)
              : const CircularProgressIndicator(),
        ),
      ),
    );
  }
}
