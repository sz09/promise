import 'package:flutter/material.dart';
import 'package:promise/util/layout_util.dart';

class DisablableButton extends StatelessWidget {
  final String text;
  final BuildContext mainContext;
  final Function action;
  final bool Function() enableFunc;
  late bool _applyPaddingTop;
  DisablableButton(
      {super.key,
      required this.text,
      required this.mainContext,
      required this.action,
      required this.enableFunc,
      bool applyPaddingTop = false}) {
    _applyPaddingTop = applyPaddingTop;
  }
  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: _applyPaddingTop ? paddingTop : EdgeInsets.zero,
        child: ElevatedButton(
          child: Text(text),
          onPressed: () => enableFunc() ? action() : null,
        ));
  }
}
