import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:promise/util/layout_util.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:promise/util/localize.ext.dart';

const WidgetStateProperty<double?> _iconSize = WidgetStatePropertyAll(15);

@immutable
class WrapTimePicker extends StatefulWidget {
  late String _hintText;
  late String labelText;
  late bool validState;
  late bool clearable;
  final bool isDateOnly;
  final bool isRequired;
  final TimeOfDay? selectedTime;

  final ValueChanged<TimeOfDay?>? onChanged;

  WrapTimePicker(
      {required this.labelText,
      required this.selectedTime,
      this.isRequired = false,
      this.clearable = false,
      this.onChanged = null,
      this.isDateOnly = true,
      super.key,
      String? hintText = null,
       }) {
    _hintText = hintText ?? '';
  }

  @override
  State<StatefulWidget> createState() {
    return _StateWrapTimePicker();
  }
}

class _StateWrapTimePicker extends State<WrapTimePicker> {
  late TimeOfDay? _selectedTime = null;
  final TextEditingController _controller = TextEditingController();

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
        context: context,
        initialTime: _selectedTime ?? TimeOfDay(hour: 0, minute: 0),
        
        hourLabelText: context.translate("time.hour"),
        minuteLabelText: context.translate("time.minute"),
      );
    _onSelectedDate(picked);
  }

  void _onSelectedDate(TimeOfDay? picked) {
    if (picked != _selectedTime) {
      setState(() {
        _selectedTime = picked;
        _controller.text = _selectedTime?.format(context) ?? '';
      });
      if (widget.onChanged != null) {
        widget.onChanged!(_selectedTime!);
      }
    }

    if(widget.isRequired && _selectedTime == null){
      setState(() {
      });
    }
  }

  @override
  void initState() {
    super.initState();
    initializeDateFormatting();
    _onSelectedDate(widget.selectedTime);
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
              onTap: () => _selectTime(context),
              validator: (value) {
                return null;
              },
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
