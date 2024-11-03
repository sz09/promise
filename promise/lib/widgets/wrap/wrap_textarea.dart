
import 'package:flutter/material.dart';
import 'package:promise/util/layout_util.dart';

@immutable
class WrapTextAreaFormField extends StatelessWidget {
  late String _hintText;
  late String _labelText;
  late int _maxLines;
  late int _minLines;
  late bool validState;
  late TextEditingController? _controller;

  WrapTextAreaFormField(
      {required TextEditingController? controller,
      required String labelText,
      required int maxLines,
      required int minLines,
      super.key,
      String? hintText = null,
      this.validState = true}) {
    _controller = controller;
    _labelText = labelText;
    _maxLines = maxLines;
    _minLines = minLines;
    _hintText = hintText ?? '';
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: paddingTop,
      child: TextField(
        scrollPadding: const EdgeInsets.all(10),
        controller: _controller,
        maxLines: _maxLines,
        minLines: _minLines,
        decoration: InputDecoration(
          labelText: _labelText,
          hintText: _hintText,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      )
    );
  }
}
