import 'package:flutter/material.dart';

class DisablableButton extends StatelessWidget {
  final String text;
  final BuildContext mainContext;
  final Function action; 
  final bool Function() enableFunc;
  DisablableButton({required this.text, required this.mainContext, required this.action, required this.enableFunc});
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ButtonStyle(),
      child: Text(text),
      onPressed: () => enableFunc() ? action : null,
    );
  }
}
