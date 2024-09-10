import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';

class DisablableButton extends StatelessWidget {
  final String text;
  final BuildContext mainContext;
  final Function action;
  final bool Function() enableFunc;
  const DisablableButton(
      {super.key,
      required this.text,
      required this.mainContext,
      required this.action,
      required this.enableFunc});
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: const ButtonStyle(),
      child: Text(text),
      onPressed: () => enableFunc() ? action() : null,
    );
  }
}

class ObxDisablableButton extends DisablableButton {
  const ObxDisablableButton(
      {super.key,
      required super.text,
      required super.mainContext,
      required super.action,
      required super.enableFunc});
  @override
  Widget build(BuildContext context) {
    return Obx(() => build(context));
  }
}
