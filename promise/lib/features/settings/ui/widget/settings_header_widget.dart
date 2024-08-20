import 'package:flutter/material.dart';
import 'package:promise/const/text.dart';
import 'package:promise/util/layout_util.dart';

class SettingsHeader extends StatelessWidget {
  final String header;

  const SettingsHeader({super.key, required this.header});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(56, 12, 0, 0),
      child: Text(
        header,
        style: TextStyle(
            color: context.containerLayoutColor,
            fontSize: textFontSize,
            fontStyle: FontStyle.italic),
      ),
    );
  }
}
