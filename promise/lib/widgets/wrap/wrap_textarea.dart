
import 'package:flutter/material.dart';
import 'package:promise/util/layout_util.dart';
import 'package:promise/util/localize.ext.dart';

@immutable
class WrapTextAreaFormField extends StatefulWidget {
  final String labelText;
  final int maxLines;
  final int minLines;
  final bool required;
  late String? errorText;
  late String hintText;
  late TextEditingController controller;

  WrapTextAreaFormField(
      {required this.controller,
      required this.labelText,
      required this.maxLines,
      required this.minLines,
      required this.required,
      this.errorText = null,
      super.key,
      this.hintText = ''
    }) {}

  @override
  State<StatefulWidget> createState() {
    return _StateWrapTextAreaFormField();
  }
}

class _StateWrapTextAreaFormField extends State<WrapTextAreaFormField>{
  late bool _validState = true;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: paddingTop,
      child: TextFormField(
        scrollPadding: const EdgeInsets.all(10),
        controller: widget.controller,
        maxLines: widget.maxLines,
        minLines: widget.minLines,
        onChanged: (value) {
          setState(() {
            _validState = value.isNotEmpty ;
          });
        },
        validator: (value) {
          if(widget.required){
            setState(() {
              _validState = value?.isNotEmpty ?? false;
            });
           return _errorText;
          }

          return null;
        },
        decoration: InputDecoration(
          labelText: widget.labelText,
          hintText: widget.hintText,
          errorText: _errorText,
          border: OutlineInputBorder(
            borderRadius: roundedItem,
          ),
        ),
      )
    );
  }

  String? get _errorText {
    return !_validState ? widget.errorText ?? context.translate("common.text.cannot_be_empty") : null;
  }
}
