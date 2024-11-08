import 'package:flutter/material.dart';
import 'package:promise/util/layout_util.dart';
import 'package:promise/util/localize.ext.dart';
import 'package:promise/widgets/dropdown/dropdown_textfield.dart';

@immutable
class WrapMultiDropdownFormField extends StatefulWidget {
  final String labelText;
  final String uniqueName;
  final List<String> selectedValues;
  final List<DropDownValueModel> items;
  final MultiValueDropDownController controller;
  late String? errorText;
  late bool required;
  late bool clearable;

  WrapMultiDropdownFormField(
      {required this.controller,
      required this.uniqueName,
      required this.items,
      required this.selectedValues,
      required this.labelText,
      required this.errorText,
      this.required = false,
      this.clearable = false,
      String? hintText = null,
      super.key}) {}

  @override
  State<WrapMultiDropdownFormField> createState() {
    return _StateWrapMultiDropdownFormField();
  }
}

class _StateWrapMultiDropdownFormField
    extends State<WrapMultiDropdownFormField> {
  late bool _validState = true;
  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: paddingTop,
        child: DropDownTextField.multiSelection(
          onChanged: (value) {
            if (widget.required) {
              setState(() {
                _validState = value.length > 0;
              });
            }
          },
          displayCompleteItem: true,
          clearOption: widget.clearable,
          controller: widget.controller,
          listTextStyle: TextStyle(
            color: context.textColor,
            backgroundColor: context.containerLayoutColor,
          ),
          textStyle: TextStyle(backgroundColor: context.containerLayoutColor),
          textFieldDecoration: InputDecoration(
              labelText: widget.labelText,
              errorText: !_validState
                  ? (widget.errorText ??
                      context.translate('common.value.cannot_be_empty'))
                  : null,
              border: OutlineInputBorder(
                borderRadius: roundedItem,
              )),
          dropDownList: widget.items,
          checkBoxProperty: CheckBoxProperty(checkColor: context.textColor),
          submitButtonColor: context.containerLayoutColor,
          validator: (value) {
            if (widget.required) {
              setState(() {
                _validState = value != null && value.isNotEmpty;
              });

              if(!_validState){
                return widget.errorText ??
                        context.translate('common.value.cannot_be_empty');
              }
            }
            return null; 
          },
        ));
  }

  @override
  void initState() {
    _setSelected();
    super.initState();
  }

  _setSelected() {
    if (widget.selectedValues.isNotEmpty) {
      final items = widget.items
          .where((d) => widget.selectedValues.contains(d.value))
          .toList();
      widget.controller.setDropDown(items);
    }
  }
}
