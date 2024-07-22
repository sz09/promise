import 'dart:math';

import 'package:flutter/material.dart';
import 'package:promise/di/service_locator.dart';

void debugOverlay(BuildContext context) {
  Overlay.of(context).insert(
    OverlayEntry(builder: (context) {
      var safePadding = MediaQuery.of(context).padding.bottom;
      final size = MediaQuery.of(context).size;
      final textSize = (TextPainter(
              text: TextSpan(
                  text:
                      serviceLocator.get<String>(instanceName: buildVersionKey),
                  style: Theme.of(context).textTheme.bodySmall),
              maxLines: 1,
              textScaler: MediaQuery.of(context).textScaler,
              textDirection: TextDirection.ltr)
            ..layout())
          .size;

      return Positioned(
        height: 56,
        top: size.height - max(safePadding, 20),
        left: (size.width - textSize.width) / 2,
        child: IgnorePointer(
          child: Text(
            serviceLocator.get<String>(instanceName: buildVersionKey),
            style: Theme.of(context).textTheme.bodySmall,
          ),
        ),
      );
    }),
  );
}
