import 'package:dropdown_textfield/dropdown_textfield.dart';
import 'package:get/get.dart';
import 'package:promise/di/service_locator.dart';
import 'package:promise/features/create.controller.dart';
import 'package:flutter/material.dart';
import 'package:promise/main.dart';
import 'package:promise/services/person/person.service.dart';
import 'package:promise/widgets/disable_button.dart';

final _controller = Get.find<CreatePromiseController>(tag: applicationTag);

class CreatePromiseView extends StatelessWidget {
  const CreatePromiseView({super.key});
  @override
  Widget build(BuildContext context) {
    return _CreatePromiseView();
  }
}

class _CreatePromiseView extends StatelessWidget {
  final TextEditingController _promiseDescriptionController =
      TextEditingController();

  final MultiValueDropDownController _cntMulti = MultiValueDropDownController();
  FocusNode searchFocusNode = FocusNode();
  FocusNode textFieldFocusNode = FocusNode();
  final _formKey = GlobalKey<FormState>();
  final double egdeSize = 8;
  @override
  Widget build(BuildContext context) {
    _controller.loadPeople(serviceLocator.get<PersonService>().fetchAsync);
    return Obx(() => Padding(
          padding: EdgeInsets.all(egdeSize),
          child: Scaffold(
              body: SingleChildScrollView(
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(height: 10),
                      TextFormField(
                        controller: _promiseDescriptionController,
                        cursorColor: Colors.black,
                        decoration: const InputDecoration(
                          contentPadding: EdgeInsets.all(15),
                          hintText: "Description",
                        ),
                      ),
                      const SizedBox(height: 10),
                      DropDownTextField.multiSelection(
                        clearOption: true,
                        displayCompleteItem: true,
                        clearIconProperty:
                            IconProperty(color: Colors.red, icon: Icons.clear),
                        dropDownIconProperty:
                            IconProperty(color: Colors.red, icon: Icons.abc),
                        controller: _cntMulti,
                        checkBoxProperty: CheckBoxProperty(
                            fillColor:
                                WidgetStateProperty.all<Color>(Colors.red)),
                        dropDownList:
                            _controller.loadingPeopleState.value.isInprogress
                                ? []
                                : [
                                    for (var item in _controller.people)
                                      DropDownValueModel(
                                          name: item.nickname, value: item.id)
                                  ],
                        onChanged: (val) {},
                      ),
                      const SizedBox(height: 10)
                    ],
                  ),
                ),
              ),
              floatingActionButton: DisablableButton(
                  text: "Create",
                  mainContext: context,
                  action: _onCreatePromise,
                  enableFunc: () {
                    return _controller.loadingState.value.isInprogress;
                  })),
        ));
  }

  _onCreatePromise() {
    if (_formKey.currentState!.validate()) {
      // BlocProvider.of<CreatePromiseCubit>(context).onCreatePromise(Promise(
      //     id: 'id',
      //     content: _promiseDescriptionController.text,
      //     to: _cntMulti.dropDownValueList?.map((x) => x.value).join(', '),
      //     dueDate: null));
    }
  }
}
