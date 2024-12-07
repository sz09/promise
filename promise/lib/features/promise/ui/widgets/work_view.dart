import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:promise/features/promise/const/const.dart';
import 'package:promise/features/promise/ui/models/schedule_options.dart';
import 'package:promise/models/work/work.dart';
import 'package:promise/models/reminders/reminder.dart';
import 'package:promise/util/background_tasks_util.dart';
import 'package:promise/util/date_time_util.dart';
import 'package:promise/util/layout_util.dart';
import 'package:promise/util/localize.ext.dart';
import 'package:promise/widgets/wrap/wrap_checkbox.dart';
import 'package:promise/widgets/wrap/wrap_datepicker.dart';
import 'package:promise/widgets/wrap/wrap_radio.dart';
import 'package:promise/widgets/wrap/wrap_textarea.dart';
import 'package:promise/widgets/wrap/wrap_timepicker.dart';

class WorkView extends StatefulWidget {
  final String promiseId;
  final String objectiveId;
  final List<Work> works;
  final Function(List<Work> works) onModifyWorks;
  const WorkView({super.key, required this.works, required this.promiseId, required this.onModifyWorks, required this.objectiveId});

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

    widget.onModifyWorks(items);
  }

  _newWork() {
    return Work.create(
      content: "",
      scheduleType: ScheduleType.Range,
      from: DateTime.now().startOfDay(),
      to: null,
      reminder: Reminder(
          notiicationContent: "", 
          notiicationDetails: "", 
          expression: ""
      ));
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
                              objectiveId: widget.objectiveId,
                              index: i,
                              item: items[i],
                              onModifyWork: (item){
                                items[i] = item;
                                widget.onModifyWorks(items);
                              },
                              removeItem: () {
                                setState(() {
                                  items.removeAt(i);
                                  widget.onModifyWorks(items);
                                });
                              },
                              insertItem: () {
                                setState(() {
                                  items.insert(i, _newWork());
                                  widget.onModifyWorks(items);
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
  final int index;
  final String promiseId;
  final String objectiveId;
  final Function removeItem;
  final Function insertItem;
  final Function(Work work) onModifyWork;
  const _WorkItem(
      {required this.item, required this.removeItem, required this.insertItem, required this.promiseId, required this.onModifyWork, required this.objectiveId, required this.index});

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

  _onChange(){ 
    widget.onModifyWork.call(widget.item);
  }

  _calculateCRONTime(){
    final String taskName = "${widget.promiseId}-${widget.objectiveId}"; 
    // showNotification();
    if(scheduleTypeSelected.value == ScheduleType.WorkingDays){
      cancelByUniqueName(taskName: taskName);
      registerPeriodicTask(
       taskName: taskName,
        tag: "#${widget.index}",
        frequency: Duration(minutes: 1),
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
          text: context.translate("work.range"),
          value: ScheduleType.Range),
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
  late TextEditingController _controller;
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
                              onChange: (text) {
                                widget.item.content = text;
                                _onChange();
                              },
                              required: true),
                        )),
                    SizedBox(
                        width: 50,
                        height: 150,
                        child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              removeButton(onRemove: () {
                                widget.removeItem();
                              })
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
                                selectedDate: _selectedFrom,
                                onChanged: (value) {
                                  setState(() {
                                    widget.item.from = value;
                                    _selectedFrom = value;
                                    _onChange();
                                  });
                                }))),
                Flexible(
                        flex: 1,
                        child: Padding(
                            padding: paddingHorizontal,
                            child: WrapDatePicker(
                                labelText: context.translate("work.to_label"),
                                hintText: context.translate("work.to_hint"),
                                firstDate: _minTo,
                                lastDate: _maxTo,
                                selectedDate: _selectedTo,
                                onChanged: (value) {
                                  setState(() {
                                    widget.item.to = value;
                                    _selectedTo = value;
                                    _onChange();
                                  });
                                },
                               ))),
                  ],
                ),
                WrapRadio(
                    label: context.translate("work.schedule"),
                    onChanged: (t) {
                      setState(() {
                        scheduleTypeSelected = t;
                      });
                      _onChange();
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
                      _onChange();
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
                                    minuteType: MinuteType.Per15Minutes,
                                      labelText:
                                          context.translate("work.notify_on_label"),
                                      hintText:
                                          context.translate("work.notify_on_hint"),
                                          onChanged: (value) {
                                            setState(() {
                                              _notifyOn = value;
                                            });
                                            _onChange();
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
