import 'package:confirm_dialog/confirm_dialog.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:promise/features/promise/controller/controller.dart';
import 'package:promise/main.dart';
import 'package:promise/models/promise/promise.dart';
import 'package:promise/util/date_time_util.dart';
import 'package:promise/util/dialog_util.dart';
import 'package:promise/util/localize.ext.dart';
import 'package:promise/util/string_util.dart';
import 'package:promise/widgets/custom_stateful.dialog.dart';
import 'package:promise/widgets/dropdown/dropdown_textfield.dart';
import 'package:promise/widgets/wrap/wrap_checkbox.dart';
import 'package:promise/widgets/wrap/wrap_datetime.dart';
import 'package:promise/widgets/wrap/wrap_multi_dropdown.dart';
import 'package:promise/widgets/wrap/wrap_textarea.dart';

final _controller = Get.find<PromiseDialogController>(tag: applicationTag);

class PromiseDialog extends StatefulWidget {
  final Promise? promise;
  final Function reloadData;
  final DialogMode mode;
  final String dialogTitleKey;

  const PromiseDialog({super.key, required this.promise, required this.reloadData, required this.mode, required this.dialogTitleKey});


  factory PromiseDialog.create(
      {required Function reloadData}) {
    return PromiseDialog(
      reloadData: reloadData,
      mode: DialogMode.Create,
      dialogTitleKey: "promise.create",
      promise: null
    );
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
  final _toController = MultiValueDropDownController();
  final int _extendYear = 100; // Support for 100 years
  final today =
      DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);
  late DateTime? _selectedDate = null;
  late bool _isForYourSelf = true;
  late List<String> _selectedTos = [];

  void _toggleForYourSelfCheckbox(bool value) {
    setState(() {
      _isForYourSelf = value;
    });
  }
  @override void initState() {
    super.initState();
    if (widget.promise != null) {
        _selectedDate = widget.promise!.expectedTime;
        _contentController.text = widget.promise!.content;
        _isForYourSelf = widget.promise!.forYourself;
        if (widget.promise!.to?.isNotEmpty ?? false) {
          _selectedTos = widget.promise!.to!;
        }
      }
      
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _controller.loadUserRefereces();
    });
  }
  @override
  void dispose() {
    _contentController.dispose();
    _toController.clearDropDown();  
    _toController.dispose();
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
        Obx(() => _controller.loadingReferenceState.value.completed ? WrapMultiDropdownFormField(
          errorText: context.translate("promise.with.cannot_be_empty"),
          clearable: false,
          required: true,
          uniqueName: (PromiseDialog).toPlural(),
          selectedValues: _selectedTos,
          items: _controller.userReferences.value
              .map((d) => DropDownValueModel(
                  name: d.hint, value: d.referenceUserId))
              .toList(),
          controller: _toController,
          labelText: context.translate("promise.label_with"),
          hintText: context.translate("promise.with_hint"),
        ): Container()),
      WrapDateTimePicker(
        clearable: true,
        selectedDate: _selectedDate,
        firstDate: _selectedDate == null
            ? DateTime(today.year)
            : (_selectedDate!.difference(today).inMicroseconds > 0
                ? DateTime(today.year)
                : DateTime(_selectedDate!.year)),
        lastDate: DateTime(today.year + _extendYear),
        onChanged: (dateTime) {
          _selectedDate = dateTime;
        },
        labelText: context.translate("promise.label_duedate"),
        hintText: context.translate("promise.duedate_hint"),
      ),
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
                icon: const Icon(FontAwesomeIcons.trash),
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
      _controller.delete(id: widget.promise!.id, completeFunc: _closeDialog);
    }
  }

  void _onSavePromise(BuildContext context) {
    if (_formKey.currentState!.validate()) {
      final tos = _isForYourSelf
          ? List<String>.empty()
          : (_toController.dropDownValueList
                  ?.map((d) => d.value.toString())
                  .toList() ??
              []);
      switch (widget.mode) {
        case DialogMode.Create:
          _controller.create(
              content: _contentController.text,
              forYourself: _isForYourSelf,
              to: tos,
              dueDate: _selectedDate?.endOfDay(),
              completeFunc: () => _closeDialog(context));
          break;
        case DialogMode.Modify:
          _controller.modify(
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
        title: Text(context.translate('promise.confirm_publish_promise_title')),
        content: Text(
            context.translate('promise.confirm_publish_promise_content')))) {
      _controller.publish(id: widget.promise!.id, completeFunc: _closeDialog);
    }
  }

  void _closeDialog(BuildContext context) {
    widget.reloadData();
    Navigator.of(context).pop();
  }
}
