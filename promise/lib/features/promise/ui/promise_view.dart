import 'package:get/get.dart';
import 'package:promise/di/service_locator.dart';
import 'package:flutter/material.dart';
import 'package:promise/features/create.controller.dart';
import 'package:promise/main.dart';
import 'package:promise/services/person/person.service.dart';
import 'package:promise/util/layout_util.dart';
import 'package:promise/util/localize.ext.dart';
import 'package:promise/widgets/dropdown/dropdown_textfield.dart';
import 'package:promise/widgets/wrap/wrap_checkbox.dart';
import 'package:promise/widgets/wrap/wrap_datetime.dart';
import 'package:promise/widgets/wrap/wrap_multi_dropdown.dart';
import 'package:promise/widgets/wrap/wrap_textarea.dart';
final _controller = Get.find<CreatePromiseController>(tag: applicationTag);

class PromiseDialog extends StatefulWidget {
  const PromiseDialog({super.key});

  @override
  _PromiseDialogState createState() => _PromiseDialogState();
}

class _PromiseDialogState extends State<PromiseDialog> {
  final _contentController = TextEditingController();
  final _toController = MultiValueDropDownController();
  late bool _isForYourSelf = true;
  final _formKey = GlobalKey<FormState>();
  void _toggleForYourSelfCheckbox(bool value) {
    setState(() {
      _isForYourSelf = value;
    });
  }
  @override
  void dispose() {
    _contentController.dispose();
    _toController.clearDropDown();
    _toController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Get.lazyPut(() => DropdownController(), tag: "$applicationTag.Create_Promise_With");
    return Padding(
      padding: contentPadding,
      child: Form(
        key: _formKey,
        child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            context.translate("promise_list_create_new"),
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          WrapTextAreaFormField(
            controller: _contentController,
            maxLines: 8,
            minLines: 3,
            labelText: context.translate("promise.label_content"),
            hintText: context.translate("promise.content_hint"),
          ),
          WrapCheckbox(
            label: context.translate("promise.label_for_yourself"),
            isChecked: _isForYourSelf,
            onChanged: _toggleForYourSelfCheckbox,
          ),
          if(!_isForYourSelf) WrapMultiDropdownFormField(
            uniqueName: "Create_Promise_With",
            loadItemsFunc: () async {
              final items = await serviceLocator.get<PersonService>().getUserReferences();
              return items.map((d) => DropDownValueModel(name: d.hint, value: d.referenceUserId)).toList();
            },
            controller: _toController,
            labelText: context.translate("promise.label_with"),
            hintText: context.translate("promise.with_hint"),
          ),
          WrapDateTimePicker(
            controller: _dueDateController,
          )
          Align(
            alignment: Alignment.centerRight,
            child: ElevatedButton(
              onPressed: () {
                _onCreatePromise(context);
              },
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 25,
                  vertical: 10,
                ),
              ),
              child: Text(context.translate("common.save")),
            ),
          ),
        ],
      ),
    ));
  }
  
  void _onCreatePromise(BuildContext context) {
    if (_formKey.currentState!.validate()) {
      
      final content = _contentController.text;
      final tos = _toController.dropDownValueList?.map((d) => d.value.toString()).toList() ?? [];
       _controller.create(content: content, forYourself: _isForYourSelf, to: tos);
      // BlocProvider.of<CreatePromiseCubit>(context).onCreatePromise(Promise(
      //     id: 'id',
      //     content: _promiseDescriptionController.text,
      //     to: _cntMulti.dropDownValueList?.map((x) => x.value).join(', '),
      //     dueDate: null));
    }

    
  }
}