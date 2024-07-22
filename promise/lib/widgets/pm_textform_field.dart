import 'package:flutter/material.dart';
const _contentPadding = EdgeInsets.all(15);
const _paddingBox = SizedBox(height: 10);

@immutable
// ignore: must_be_immutable
class PTextFormField extends StatelessWidget {
  late String _hintText;
  late String _labelText;
  late bool validState;
  late TextEditingController? _controller;

  // ignore: avoid_init_to_null
  PTextFormField({required TextEditingController? controller, required String labelText, super.key, String? hintText = null,  this.validState = true}) {
    _controller = controller;
    _labelText = labelText;
    _hintText = hintText ?? '';
  }
  
  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8.0, // gap between adjacent chips
      runSpacing: 4.0,
      children: [
        Text(_labelText),
        _paddingBox,
        TextFormField(
          controller: _controller,
          decoration: InputDecoration(
            contentPadding: _contentPadding,
            hintText: _hintText ,
            border: inputBorder(validState: validState)
          )
        ),
      ]
    );
  }


}


OutlineInputBorder inputBorder({bool validState = true}){ //return type is OutlineInputBorder
  return  OutlineInputBorder( //Outline border type for TextFeild
    borderRadius: const BorderRadius.all(Radius.circular(20)),
    borderSide: BorderSide(
        style:  validState ? BorderStyle.none: BorderStyle.solid,
        color: validState ? Colors.transparent: Colors.redAccent,
        width: 3,
      )
  );
}