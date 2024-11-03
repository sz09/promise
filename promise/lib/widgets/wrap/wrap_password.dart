import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:promise/util/layout_util.dart';

const WidgetStateProperty<double?> _iconSize = WidgetStatePropertyAll(18);

@immutable
class WrapPasswordFormField extends StatefulWidget {
  late String _hintText;
  late String _labelText;
  late bool validState;
  late TextEditingController _controller;

  WrapPasswordFormField(
      {required TextEditingController controller,
      required String labelText,
      super.key,
      String? hintText = null,
      this.validState = true}) {
    _controller = controller;
    _labelText = labelText;
    _hintText = hintText ?? '';
  }

  @override
  State<WrapPasswordFormField> createState() {
    return _WrapPasswordFormFieldState();
  }
}

class _WrapPasswordFormFieldState extends State<WrapPasswordFormField> {
  late String _hintText;
  late String _labelText;
  late bool validState;
  late TextEditingController? _controller;
  late bool _obscureText = true;
  _WrapPasswordFormFieldState() {}

  @override
  void initState() {
    _controller = widget._controller;
    _labelText = widget._labelText;
    _hintText = widget._hintText;
    validState = widget.validState;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: paddingTop,
        child:  TextFormField(
                  obscureText: _obscureText,
                  enableSuggestions: false,
                  autocorrect: false,
                  controller: _controller,
                  validator: (String? value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Password is required';
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                      contentPadding: contentPadding,
                      hintText: _hintText,
                      labelText: _labelText,
                      border: inputBorder(validState: validState),
                      suffix: ElevatedButton(
                          style: ButtonStyle(
                              iconSize: _iconSize,
                              backgroundColor: WidgetStatePropertyAll(
                                  context.containerLayoutColor)),
                          child: _obscureText
                              ? const Icon(FontAwesomeIcons.eye)
                              : const Icon(FontAwesomeIcons.eyeSlash),
                          onPressed: () {
                            setState(() {
                              _obscureText = !_obscureText;
                            });
                          }))));
  }
}

OutlineInputBorder inputBorder({bool validState = true}) {
  //return type is OutlineInputBorder
  return OutlineInputBorder(
      //Outline border type for TextFeild
      borderRadius: const BorderRadius.all(Radius.circular(20)),
      borderSide: BorderSide(
        style: validState ? BorderStyle.none : BorderStyle.solid,
        color: validState ? Colors.transparent : Colors.redAccent,
        width: 3,
      ));
}
