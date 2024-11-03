import 'package:dropdown_textfield/dropdown_textfield.dart';
import 'package:get/get.dart';
import 'package:promise/di/service_locator.dart';
import 'package:promise/features/create.controller.dart';
import 'package:flutter/material.dart';
import 'package:promise/main.dart';
import 'package:promise/services/user/user_reference.service.dart';
import 'package:promise/util/layout_util.dart';
import 'package:promise/util/localize.ext.dart';
import 'package:promise/widgets/wrap/wrap_multi_dropdown.dart';
import 'package:promise/widgets/wrap/wrap_textarea.dart';

final _controller = Get.find<CreatePromiseController>(tag: applicationTag);
class PromiseDialog extends StatefulWidget {
  const PromiseDialog({super.key});

  @override
  _PromiseDialogState createState() => _PromiseDialogState();
}

class _PromiseDialogState extends State<PromiseDialog> {
  final _nameController = TextEditingController();
  final _withController = MultiValueDropDownController();
  final _priceController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _priceController.dispose();
    _withController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Get.lazyPut(() => DropdownController(), tag: "$applicationTag.Create_Promise_With");
    return Padding(
      padding: contentPadding,
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
            controller: _nameController,
            maxLines: 8,
            minLines: 3,
            labelText: context.translate("promise.label_content"),
            hintText: context.translate("promise.content_hint"),
          ),
          WrapMultiDropdownFormField(
            uniqueName: "Create_Promise_With",
            loadItemsFunc: () => serviceLocator.get<UserService>.),
            controller: _withController,
            labelText: context.translate("promise.label_with"),
            hintText: context.translate("promise.with_hint"),
          ),

          Align(
            alignment: Alignment.centerRight,
            child: ElevatedButton(
              onPressed: () async {
                // ignore: unused_local_variable
                final name = _nameController.text;
                // ignore: unused_local_variable
                final price = _priceController.text;
                await _onCreatePromise();
                Navigator.of(context).pop(); // Đóng dialog
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
    );
  }
  
  Future _onCreatePromise() async {
    // if (_formKey.currentState!.validate()) {
    //   // BlocProvider.of<CreatePromiseCubit>(context).onCreatePromise(Promise(
    //   //     id: 'id',
    //   //     content: _promiseDescriptionController.text,
    //   //     to: _cntMulti.dropDownValueList?.map((x) => x.value).join(', '),
    //   //     dueDate: null));
    // }

    
  }
}