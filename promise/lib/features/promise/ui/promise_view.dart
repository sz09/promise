import 'package:confirm_dialog/confirm_dialog.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:promise/features/promise/const/const.dart';
import 'package:promise/features/promise/controller/controller.dart';
import 'package:promise/features/promise/ui/widgets/objective_view.dart';
import 'package:promise/main.dart';
import 'package:promise/models/person/person.dart';
import 'package:promise/models/promise/promise.dart';
import 'package:promise/util/date_time_util.dart';
import 'package:promise/util/dialog_util.dart';
import 'package:promise/util/localize.ext.dart';
import 'package:promise/widgets/custom_stateful.dialog.dart';
import 'package:promise/widgets/wrap/wrap_checkbox.dart';
import 'package:promise/widgets/wrap/wrap_datepicker.dart';
import 'package:promise/widgets/wrap/wrap_multi_dropdown.dart';
import 'package:promise/widgets/wrap/wrap_textarea.dart';

final _controller = Get.find<PromiseDialogController>(tag: applicationTag);

class PromiseDialog extends StatefulWidget {
  Promise? promise;
  final Function reloadData;
  final DialogMode mode;
  final String dialogTitleKey;

  PromiseDialog(
      {super.key,
      required this.promise,
      required this.reloadData,
      required this.mode,
      required this.dialogTitleKey});

  factory PromiseDialog.create({required Function reloadData}) {
    return PromiseDialog(
        reloadData: reloadData,
        mode: DialogMode.Create,
        dialogTitleKey: "promise.create",
        promise: null);
  }

  factory PromiseDialog.edit(
      {required Promise promise, required Function reloadData}) {
    return PromiseDialog(
        promise: promise,
        mode: DialogMode.Modify,
        reloadData: reloadData,
        dialogTitleKey: "promise.modify");
  }

  @override
  _PromiseDialogState createState() => _PromiseDialogState();
}

class _PromiseDialogState extends State<PromiseDialog> {
  final _formKey = GlobalKey<FormState>();
  final _contentController = TextEditingController();
  final today =
      DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);
  final MultiDropdownController _withController = MultiDropdownController();
  late DateTime? _selectedDate = null;
  late bool _isForYourSelf = true;

  void _toggleForYourSelfCheckbox(bool value) {
    setState(() {
      _isForYourSelf = value;
    });
  }

  @override
  void initState() {
    super.initState();
    if(widget.promise != null){
      widget.promise = widget.promise;
      _contentController.text = widget.promise!.content;
      _selectedDate = widget.promise!.expectedTime;
      _isForYourSelf = widget.promise!.forYourself;
      if (widget.promise!.to?.isNotEmpty ?? false) {
        _withController.value = widget.promise!.to!;
      }
    }

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _controller.loadUserRefereces();
    });
  }

  @override
  void dispose() {
    _contentController.dispose();
    super.dispose();
  }

  Widget _getBodyWidget(BuildContext context) {
    return Column(
      children: [
        WrapTextAreaFormField(
          controller: _contentController,
          maxLines: 8,
          minLines: 3,
          required: true,
          errorText: context.translate('promise.content.error.required'),
          labelText: context.translate("promise.label_content"),
          hintText: context.translate("promise.content_hint"),
        ),
        WrapCheckbox(
          label: context.translate("promise.label_for_yourself"),
          isChecked: _isForYourSelf,
          onChanged: _toggleForYourSelfCheckbox,
        ),
        if (!_isForYourSelf)
          Obx(() => _controller.loadingReferenceState.value.completed
              ? WrapMultiDropdownFormField<UserReference>(
                  required: true,
                  controller: _withController,
                  items: _controller.userReferences.value,
                  getDisplayTextFn: (d) => d.hint,
                  getValueFn: (d) => d.referenceUserId,
                  buttonIcon: Icon(FontAwesomeIcons.peopleGroup),
                  searchHint: context.translate("promise.with.search_hint"),
                  errorText: context.translate("promise.with.cannot_be_empty"),
                  labelText: context.translate("promise.label_with"),
                  hintText: context.translate("promise.with_hint"),
                )
              : Container()),
        WrapDatePicker(
          clearable: true,
          selectedDate: _selectedDate,
          firstDate: _selectedDate == null
              ? DateTime(today.year)
              : (_selectedDate!.difference(today).inMicroseconds > 0
                  ? DateTime(today.year)
                  : DateTime(_selectedDate!.year)),
          lastDate: DateTime(today.year + extendPromiseTimeByYear),
          onChanged: (dateTime) {
            _selectedDate = dateTime;
          },
          labelText: context.translate("promise.label_duedate"),
          hintText: context.translate("promise.duedate_hint"),
        ),
        if (widget.mode == DialogMode.Modify) ObjectiveView(promiseId: widget.promise!.id)
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return commonDialog(
      context: context,
      formKey: _formKey,
      dialogTitleKey: widget.dialogTitleKey,
      bodyWidgets: (context) => _getBodyWidget(context),
      onSave: () {
        _onSavePromise(context);
      },
      action: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
                  icon: const Icon(FontAwesomeIcons.shareFromSquare),
                  onPressed: () {
                    _onPublishPromise(context);
                  }),
          IconButton(
                  icon: Icon(FontAwesomeIcons.trash, color: Colors.red),
                  onPressed: () {
                    _onDeletePromise(context);
                  })
        ],
    ));
  }

  void _onDeletePromise(BuildContext context) async {
    if (await confirm(context,
        textOK: Text(context.translate('common.ok')),
        textCancel: Text(context.translate('common.cancel')),
        title: Text(context.translate('promise.confirm_delete_title')),
        content: Container())) {
      await _controller.delete(
          id: widget.promise!.id, completeFunc: () => _closeDialog(context));
    }
  }

  void _onSavePromise(BuildContext context) async {
    if (_formKey.currentState!.validate()) {
      final tos = _isForYourSelf ? List<String>.empty() : _withController.value;
      switch (widget.mode) {
        case DialogMode.Create:
          await _controller.create(
              content: _contentController.text,
              forYourself: _isForYourSelf,
              to: tos,
              dueDate: _selectedDate?.endOfDay(),
              completeFunc: () => _closeDialog(context));
          break;
        case DialogMode.Modify:
          await _controller.modify(
              id: widget.promise!.id,
              content: _contentController.text,
              forYourself: _isForYourSelf,
              to: tos,
              dueDate: _selectedDate?.endOfDay(),
              completeFunc: () => _closeDialog(context));
          break;
        default:
          break;
      }
    }
  }

  void _onPublishPromise(BuildContext context) async {
    if (await confirm(context,
        textOK: Text(context.translate('common.ok')),
        textCancel: Text(context.translate('common.cancel')),
        title: Text(context.translate('promise.confirm_publishwidget.promise_title')),
        content: Text(
            context.translate('promise.confirm_publishwidget.promise_content')))) {
      await _controller.publish(
          id: widget.promise!.id, completeFunc: () => _closeDialog(context));
    }
  }

  void _closeDialog(BuildContext context) {
    Navigator.of(context).pop();
    widget.reloadData();
  }
}
