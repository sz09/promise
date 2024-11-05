import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:promise/util/date_time_util.dart';
import 'package:promise/util/layout_util.dart';

const WidgetStateProperty<double?> _iconSize = WidgetStatePropertyAll(18);

@immutable
class WrapDateTimePicker extends StatefulWidget {
  late String _hintText;
  late String labelText;
  late bool validState;
  final bool isDateOnly;
  final DateTime firstDate;
  final DateTime lastDate;
  final DateTime selectedDate;

  final ValueChanged<DateTime>? onChanged;

  WrapDateTimePicker(
      {
      required this.labelText,
      required this.firstDate,
      required this.lastDate,
      required this.selectedDate,
      this.onChanged = null,
      this.isDateOnly = true,
      super.key,
      String? hintText = null,
      this.validState = true}) {
    _hintText = hintText ?? '';
  }

  @override
  State<StatefulWidget> createState() {
    return _StateWrapDateTimePicker();
  }
}

class _StateWrapDateTimePicker extends State<WrapDateTimePicker> {
  late DateTime _selectedDate;
  final TextEditingController _controller = TextEditingController();

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: _selectedDate,
        firstDate: widget.firstDate,
        lastDate: widget.lastDate
      );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
        _controller.text = _selectedDate.asString(widget.isDateOnly);
        if(widget.onChanged != null) widget.onChanged!(_selectedDate);
      });
    }
  }
  @override 
  void initState() {
    super.initState();
    _selectedDate = widget.selectedDate;
    _controller.text = _selectedDate.asString(widget.isDateOnly);
  }
  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: paddingTop,
        child:  Row(
          children: [
            Expanded(
              child: TextField(
                readOnly: true,
                controller: _controller,
                decoration: InputDecoration(
                    labelText: widget.labelText,
                    hintText: widget._hintText,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    )),
              ),
            )
            ,
            ElevatedButton(
                style: ButtonStyle(
                    iconSize: _iconSize,
                    backgroundColor:
                        WidgetStatePropertyAll(context.containerLayoutColor)),
                child: const Icon(FontAwesomeIcons.calendar),
                onPressed: () => _selectDate(context)
              )
          ]
        ));
  }
}
