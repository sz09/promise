import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';
import 'package:promise/util/layout_util.dart';
import 'package:promise/util/localize.ext.dart';

class MultiDropdownController extends ValueNotifier<List<String>>{
  MultiDropdownController(): super([]);
}

@immutable
class WrapMultiDropdownFormField<T> extends StatefulWidget {
  final String labelText;
  final List<T> items;
  final MultiDropdownController controller;
  final String? errorText;
  final String? searchHint;
  final bool searchable;
  final Icon buttonIcon;
  final String Function(T) getDisplayTextFn;
  final String Function(T) getValueFn;
  final bool required;

  WrapMultiDropdownFormField(
      {
      required this.items,
      required this.labelText,
      required this.errorText,
      this.required = false,
      String? hintText = null,
      this.searchHint, 
      this.searchable = false,
      super.key, 
      required this.getDisplayTextFn, 
      required this.getValueFn, 
      required this.buttonIcon, 
      required this.controller}) {}

  @override
  State<WrapMultiDropdownFormField> createState() {
    return _StateWrapMultiDropdownFormField<T>();
  }
}

class _StateWrapMultiDropdownFormField<T>
    extends State<WrapMultiDropdownFormField<T>> {
  late bool _validState = true;
  late List<T?> _selectedValues = [];
  final _multiSelectKey = GlobalKey<FormFieldState<T>>();
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: paddingTop,
      child: MultiSelectChipField<T?>(
        headerColor: Colors.transparent,
        icon: Icon(FontAwesomeIcons.cube),
        items: widget.items.map((d) {
          return  MultiSelectItem<T>(d, widget.getDisplayTextFn(d));
        }).toList(),
        title: Text(" ${widget.labelText}"),
        key: _multiSelectKey,
        initialValue: _selectedValues,
        scroll: false,
        chipColor: context.containerLayoutColor,
        textStyle: TextStyle(
          color: context.textColor
        ),
        selectedChipColor: context.selectedColor,
        chipShape: RoundedRectangleBorder(borderRadius: roundedItem),
        onTap: _onSave,
        validator: _validate,
        decoration: BoxDecoration(
          borderRadius: roundedItem,
          border: Border.all(
            color: _validState ? context.borderWidgetColor: context.borderWidgetErrorColor,
          ),
        ),
        autovalidateMode: AutovalidateMode.onUnfocus,
        searchHint: widget.searchHint,
        searchable: widget.searchable,
        closeSearchIcon: widget.searchable ? Icon(FontAwesomeIcons.x): null
    ));
  }

  String? _validate(List<T?>? value){
     if (widget.required) {
        setState(() {
          _validState = value != null && value.isNotEmpty;
        });

        if(!_validState){
          return widget.errorText ?? context.translate('common.value.cannot_be_empty');
        }
      }
      return null; 
  }

  dynamic _onSave(List<T?>? setter){
    _setValue(setter);
  }
  _setValue(List<T?>? value){
    setState(() {
      if(value !=  null){
        _selectedValues = value;
      }
      else {
        _selectedValues = [];
      }
    });
    widget.controller.value = _selectedValues.map((d) => widget.getValueFn(d as T)).toList();
  }

  @override
  void initState() {
    _setSelected();
    super.initState();
  }

  _setSelected() {
    if (widget.controller.value.isNotEmpty) {
      final items = widget.items
          .where((d) => widget.controller.value.contains(widget.getValueFn(d)))
          .toList();
      setState(() {
        _selectedValues = items;
      });
    }
  }
}
