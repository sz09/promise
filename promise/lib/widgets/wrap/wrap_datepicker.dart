import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:promise/util/date_time_util.dart';
import 'package:promise/util/layout_util.dart';
import 'package:intl/date_symbol_data_local.dart';

const WidgetStateProperty<double?> _iconSize = WidgetStatePropertyAll(15);

@immutable
class WrapDatePicker extends StatefulWidget {
  late String _hintText;
  late String labelText;
  late bool validState;
  late bool clearable;
  final bool isDateOnly;
  final DateTime firstDate;
  final DateTime lastDate;
  final DateTime? selectedDate;

  final ValueChanged<DateTime>? onChanged;

  WrapDatePicker(
      {required this.labelText,
      required this.firstDate,
      required this.lastDate,
      required this.selectedDate,
      this.clearable = false,
      this.onChanged = null,
      this.isDateOnly = true,
      super.key,
      String? hintText = null,
      this.validState = true}) {
    _hintText = hintText ?? '';
  }

  @override
  State<StatefulWidget> createState() {
    return _StateWrapDatePicker();
  }
}

class _StateWrapDatePicker extends State<WrapDatePicker> {
  late DateTime? _selectedDate = null;
  final TextEditingController _controller = TextEditingController();

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: _selectedDate,
        firstDate: widget.firstDate,
        lastDate: widget.lastDate,
        keyboardType: TextInputType.datetime);
    _onSelectedDate(picked);
  }

  void _onSelectedDate(DateTime? picked) {
    if (picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
        _controller.text = _selectedDate?.asString(isDateOnly: widget.isDateOnly) ?? "";
      });
      if (widget.onChanged != null && _selectedDate != null) {
        widget.onChanged!(_selectedDate!);
      }
    }
  }

  @override
  void initState() {
    super.initState();
    initializeDateFormatting();
    _onSelectedDate(widget.selectedDate);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: paddingTop,
        child: Row(children: [
          Expanded(
            child: TextFormField(
              readOnly: true,
              controller: _controller,
              minLines: 1,
              maxLines: 1,
              onTap: () => _selectDate(context),
              decoration: InputDecoration(
                  floatingLabelBehavior: FloatingLabelBehavior.always,
                  labelText: widget.labelText,
                  hintText: widget._hintText,
                  border: OutlineInputBorder(
                    borderRadius: roundedItem,
                  ),
                  isDense: true,
                  suffix: SizedBox(
                        height: _hasValue ? null: 40,
                        child: _hasValue ?  
                        IconButton(
                          style: ButtonStyle(
                              iconSize: _iconSize
                          ),
                          icon: const Icon(
                            FontAwesomeIcons.x
                          ),
                          onPressed: () {
                            _onSelectedDate(null);
                          }): null,
                      )
                      ),
            ),
          )
        ]));
  }

  get _hasValue {
  return widget.clearable && _controller.text != "";
  }
}
