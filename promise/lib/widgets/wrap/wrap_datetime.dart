
import 'package:flutter/material.dart';
import 'package:promise/util/layout_util.dart';

@immutable
class WrapDateTimePicker extends StatelessWidget {
  late String _hintText;
  late String _labelText;
  late bool validState;
  late TextEditingController? _controller;

  WrapDateTimePicker(
      {required TextEditingController? controller,
      required String labelText,
      super.key,
      String? hintText = null,
      this.validState = true}) {
    _controller = controller;
    _labelText = labelText;
    _hintText = hintText ?? '';
  }

  @override
  Widget build(BuildContext context) {
    return Padding(padding: paddingTop, child: TextField(
        controller: _controller,
        keyboardType: TextInputType.datetime,
        decoration: InputDecoration(
          labelText: _labelText,
          hintText: _hintText,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      ));
  }
}
