import 'package:flutter/material.dart';
import 'package:promise/const/text.dart';
import 'package:promise/util/layout_util.dart';

class SettingsLanguageIcon extends StatelessWidget {
  final String languageCode;

  const SettingsLanguageIcon({super.key, required this.languageCode});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Container(
        height: 24,
        width: 24,
        decoration: BoxDecoration(
          border: Border.all(
              width: 1.5,
              color: context.containerLayoutColor),
          borderRadius: const BorderRadius.all(
            Radius.circular(50),
          ),
        ),
        child: Center(
          child: Text(
            languageCode,
            style: const TextStyle(fontSize: textFontSize),
          ),
        ),
      ),
    );
  }
}
