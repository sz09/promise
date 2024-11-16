import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:promise/features/promise/const/const.dart';
import 'package:promise/features/promise/ui/models/schedule_options.dart';
import 'package:promise/models/work/work.dart';
import 'package:promise/models/reminders/reminder.dart';
import 'package:promise/util/date_time_util.dart';
import 'package:promise/util/layout_util.dart';
import 'package:promise/util/localize.ext.dart';
import 'package:promise/widgets/wrap/wrap_checkbox.dart';
import 'package:promise/widgets/wrap/wrap_datepicker.dart';
import 'package:promise/widgets/wrap/wrap_radio.dart';
import 'package:promise/widgets/wrap/wrap_textarea.dart';
import 'package:promise/widgets/wrap/wrap_timepicker.dart';
import 'package:workmanager/workmanager.dart';

class WorkView extends StatefulWidget {
  final String promiseId;
  final List<Work> works;
  const WorkView({super.key, required this.works, required this.promiseId});

  @override
  State<StatefulWidget> createState() {
    return _WorkViewState();
  }
}

class _WorkViewState extends State<WorkView> {
  final _formKey = GlobalKey<FormState>();
  List<Work> items = [];
  late ScrollController _scrollController;

  @override
  void initState() {
    _scrollController = ScrollController();
    items = List.from(widget.works);

    if (items.isEmpty) {
      items.add(_newWork());
    }
    super.initState();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  // Function to add a new item
  void _addItem() {
    setState(() {
      items.add(_newWork());
    });
  }

  _newWork() {
    return Work(
        content: "",
        scheduleType: ScheduleType.WeekDays,
        from: null,
        to: null,
        reminder: Reminder(
            notiicationContent: "", notiicationDetails: "", expression: ""));
  }

  @override
  Widget build(BuildContext context) {
    return Form(
        key: _formKey,
        child: LayoutBuilder(builder: (context, constraints) {
          return Padding(
              padding: EdgeInsets.zero,
              child: SizedBox(
                  width: constraints.maxWidth,
                  height: constraints.maxHeight,
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              context.translate("work.work_title"),
                              style: titleFontStyle,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                IconButton(
                                  iconSize: 20,
                                  icon: Icon(
                                    FontAwesomeIcons.plus,
                                    color: Colors.green,
                                  ),
                                  onPressed: _addItem,
                                ),
                              ],
                            )
                          ],
                        ),
                        Expanded(
                            child: ListView.builder(
                          shrinkWrap: true,
                          controller: _scrollController,
                          itemCount: items.length,
                          itemBuilder: (context, i) {
                            return _WorkItem(
                              promiseId: widget.promiseId,
                              item: items[i],
                              removeItem: () {
                                setState(() {
                                  items.removeAt(i);
                                });
                              },
                              saveItem: (Work work) {

                              },
                              insertItem: () {
                                setState(() {
                                  items.insert(i, _newWork());
                                });
                              },
                            );
                          },
                        ))
                      ])));
        }));
  }
}

class _WorkItem extends StatefulWidget {
  final Work item;
  final String promiseId;
  final Function removeItem;
  final Function(Work) saveItem;
  final Function insertItem;
  const _WorkItem(
      {required this.item, required this.removeItem, required this.insertItem, required this.saveItem, required this.promiseId});

  @override
  State<StatefulWidget> createState() {
    return _WorkItemState();
  }
}

class _WorkItemState extends State<_WorkItem> {
  late List<ScheduleOption> scheduleTypes = [];
  late ScheduleOption scheduleTypeSelected;
  late TimeOfDay? _notifyOn = null;
  late DateTime _minFrom = DateTime.now();
  late DateTime _maxFrom = DateTime.now();
  late DateTime _minTo = DateTime.now();
  late DateTime _maxTo = DateTime.now();
  late DateTime? _selectedFrom = null;
  late DateTime? _selectedTo = null;
  late bool _isNotifyMe = false;
  _calculateCRONTime(){
    final String taskName = widget.promiseId; 
    if(scheduleTypeSelected.value == ScheduleType.WorkingDays){
      
      Workmanager().registerPeriodicTask(
        taskName, 
        taskName,
        tag: "#1",
        frequency: Duration(days: 1),
        inputData: {
          'startDate': _selectedFrom?.yearMonthDay(),
          'endDate': _selectedTo?.yearMonthDay(),
          'hour': _notifyOn?.hour,
          'minute': _notifyOn?.minute
        },
      );
  }
  else {

  }

  }
  @override
  void initState() {
    scheduleTypes.addAll([
      ScheduleOption(
          text: context.translate("work.week_days"),
          value: ScheduleType.WeekDays),
      ScheduleOption(
          text: context.translate("work.working_days"),
          value: ScheduleType.WorkingDays),
    ]);
    final now = DateTime.now();
    final minFrom = minWhereNotNull(widget.item.from , now) ?? now;
    _minFrom = DateTime(minFrom.year,  minFrom.month - 1, minFrom.day).startOfDay();
    _maxFrom = DateTime(_minFrom.year + extendPromiseTimeByYear);
    _selectedFrom = widget.item.from;
    
    final minTo = minWhereNotNull(widget.item.to , now) ?? now;
    _minTo = DateTime(minTo.year,  minTo.month - 1, minTo.day).startOfDay();
    _maxTo = DateTime(minTo.year + extendPromiseTimeByYear);
    _selectedTo = widget.item.to;

    scheduleTypeSelected = scheduleTypes.first;
    _controller = TextEditingController(text: widget.item.content);
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  late TextEditingController _controller =
      TextEditingController(text: widget.item.content);
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      return SizedBox(
          width: constraints.maxWidth,
          child: Card(
            elevation: 4,
            shape: RoundedRectangleBorder(borderRadius: roundedItem),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Padding(
                        padding: paddingLeft,
                        child: SizedBox(
                          width: constraints.maxWidth - 65,
                          child: WrapTextAreaFormField(
                              controller: _controller,
                              labelText:
                                  context.translate("work.content_label"),
                              hintText: context.translate("work.content_hint"),
                              maxLines: 5,
                              minLines: 5,
                              required: true),
                        )),
                    SizedBox(
                        width: 50,
                        height: 150,
                        child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Positioned.fill(
                                child: IconButton(
                                  onPressed: () {
                                    widget.removeItem();
                                  },
                                  icon: Icon(FontAwesomeIcons.x),
                                  color: Colors.red)),
                                  
                              IconButton(
                                  onPressed: () {
                                    _calculateCRONTime();
                                    widget.saveItem(widget.item);
                                  },
                                  icon: Icon(FontAwesomeIcons.floppyDisk),
                                  color: Colors.green),
                            ]))
                  ],
                ),
                Row(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Flexible(
                        flex: 1,
                        child: Padding(
                            padding: paddingLeft,
                            child: WrapDatePicker(
                                labelText: context.translate("work.from_label"),
                                hintText: context.translate("work.from_hint"),
                                firstDate: _minFrom,
                                lastDate: _maxFrom,
                                onChanged: (value) {
                                  setState(() {
                                    widget.item.from = value;
                                    _selectedFrom = value;
                                  });
                                },
                                selectedDate: _selectedFrom))),
                Flexible(
                        flex: 1,
                        child: Padding(
                            padding: paddingHorizontal,
                            child: WrapDatePicker(
                                labelText: context.translate("work.to_label"),
                                hintText: context.translate("work.to_hint"),
                                firstDate: _minTo,
                                lastDate: _maxTo,
                                onChanged: (value) {
                                  setState(() {
                                    widget.item.to = value;
                                    _selectedTo = value;
                                  });
                                },
                                selectedDate: _selectedTo))),
                  ],
                ),
                WrapRadio(
                    label: context.translate("work.schedule"),
                    onChanged: (t) {
                      setState(() {
                        scheduleTypeSelected = t;
                      });
                    },
                    options: scheduleTypes,
                    getDisplayTextFn: (d) => d.text,
                    getValueFn: (d) => d.value,
                    selected: scheduleTypeSelected),
                WrapCheckbox(
                    label: context.translate("work.notify_me_label"),
                    isChecked: _isNotifyMe,
                    onChanged: (val) {
                      setState(() {
                        _isNotifyMe = val;
                      });
                    }),
                if (_isNotifyMe)
                  Column(
                    children: [
                      Row(
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Flexible(
                              flex: 1,
                              child: Padding(
                                  padding: paddingLeft,
                                  child: WrapTimePicker(
                                      labelText:
                                          context.translate("work.notify_on_label"),
                                      hintText:
                                          context.translate("work.notify_on_hint"),
                                          onChanged: (value) {
                                            setState(() {
                                              _notifyOn = value;
                                            });
                                          },
                                      selectedTime: _notifyOn))),
                          Flexible(
                              flex: 1,
                              child: Container()),
                        ],
                      )
                    ],
                  ),
                SizedBox(height: 5, child: Container())
              ],
            ),
          ));
    });
  }
}
