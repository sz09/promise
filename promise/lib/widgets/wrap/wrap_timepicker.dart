import 'package:flutter/material.dart';
import 'package:flutter_time_picker_spinner/flutter_time_picker_spinner.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:promise/util/date_time_util.dart';
import 'package:promise/util/layout_util.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:promise/util/localize.ext.dart';

enum MinuteType { PerMinute, Per5Minutes, Per15Minutes }

const WidgetStateProperty<double?> _iconSize = WidgetStatePropertyAll(15);

@immutable
class WrapTimePicker extends StatefulWidget {
  late String _hintText;
  late String labelText;
  late String? selectLabelText;
  late bool validState;
  late bool clearable;
  late bool is24HourMode;
  final bool isDateOnly;
  final bool isRequired;
  final MinuteType minuteType;
  final TimeOfDay? selectedTime;

  final ValueChanged<TimeOfDay?>? onChanged;

  WrapTimePicker({
    required this.labelText,
    required this.selectedTime,
    this.selectLabelText,
    this.is24HourMode = false,
    this.isRequired = false,
    this.clearable = false,
    this.onChanged = null,
    this.isDateOnly = true,
    this.minuteType = MinuteType.PerMinute,
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
  late TimeOfDay? _tempTime = null;

  Future<void> _selectTime(BuildContext context) async {
    var time = DateTime.now().startOfDay();
    if (widget.selectedTime != null) {
      time = time.add(Duration(
          hours: widget.selectedTime!.hour,
          minutes: widget.selectedTime!.minute));
    }
    _tempTime = _selectedTime;
    showAdaptiveDialog(
        context: context,
        useSafeArea: true,
        builder: (context) {
          return AlertDialog(
            title: Text(widget.selectLabelText ?? context.translate("time.selecte_time_label")),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TimePickerSpinner(
                  is24HourMode: widget.is24HourMode,
                  time: time,
                  normalTextStyle: TextStyle(
                    color: context.textColor,
                    fontSize: context.titleMediumSize,
                    fontStyle: FontStyle.normal,
                    fontWeight: FontWeight.bold
                  ),
                  highlightedTextStyle: TextStyle(
                    color: context.textColor,
                    fontSize: context.titleLargeSize, 
                    fontStyle: FontStyle.italic
                  ),
                  minutesInterval: _minuteInterval,
                  onTimeChange: (dateTime) {
                    var time =
                        TimeOfDay(hour: dateTime.hour, minute: dateTime.minute);
                        _tempTime = time;
                  },
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextButton(
                      onPressed: () {
                        _onSelectedTime(_tempTime);
                        Navigator.of(context).pop();
                      }, 
                      style: ButtonStyle(
                        textStyle: WidgetStatePropertyAll(TextStyle(color: Colors.green))
                      ),
                      child: Text(context.translate("common.ok"))),
                    
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      style: ButtonStyle(
                        textStyle: WidgetStatePropertyAll(TextStyle(color: Colors.red))
                      ), 
                      child: Text(context.translate("common.cancel")))
                  ],
                )
            ]) ,
          );
        });
  }

  int get _minuteInterval {
    switch (widget.minuteType) {
      case MinuteType.Per5Minutes:
        return 5;
      case MinuteType.Per15Minutes:
        return 15;
      default:
        return 1;
    }
  }

  void _onSelectedTime(TimeOfDay? picked) {
    if (picked != _selectedTime) {
      setState(() {
        _selectedTime = picked;
        _controller.text = _selectedTime?.format(context) ?? '';
      });
      if (widget.onChanged != null) {
        widget.onChanged!(_selectedTime!);
      }
    }

    if (widget.isRequired && _selectedTime == null) {
      setState(() {});
    }
  }

  @override
  void initState() {
    super.initState();
    initializeDateFormatting();
    _onSelectedTime(widget.selectedTime);
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
                    height: _hasValue ? null : 40,
                    child: _hasValue
                        ? IconButton(
                            style: ButtonStyle(iconSize: _iconSize),
                            icon: const Icon(FontAwesomeIcons.x),
                            onPressed: () {
                              _onSelectedTime(null);
                            })
                        : null,
                  )),
            ),
          )
        ]));
  }

  get _hasValue {
    return widget.clearable && _controller.text != "";
  }
}
