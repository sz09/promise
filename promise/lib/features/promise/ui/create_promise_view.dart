import 'package:dropdown_textfield/dropdown_textfield.dart';
import 'package:promise/features/promise/bloc/create_promise_cubit.dart';
import 'package:promise/features/promise/bloc/create_promise_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:promise/models/promise/promise.dart';

class CreatePromiseView extends StatefulWidget {
  const CreatePromiseView({super.key});

  @override
  _CreatePromiseViewState createState() => _CreatePromiseViewState();
}

class _CreatePromiseViewState extends State<CreatePromiseView> {
  final TextEditingController _promiseDescriptionController =
      TextEditingController();

  final MultiValueDropDownController _cntMulti = MultiValueDropDownController();
  FocusNode searchFocusNode = FocusNode();
  FocusNode textFieldFocusNode = FocusNode();
  final _formKey = GlobalKey<FormState>();
  final double egdeSize = 8;
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Create Promise'),
          centerTitle: true,
          leading: Container(),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
          ],
        ),
        body: BlocConsumer<CreatePromiseCubit, CreatePromiseState>(
            listener: (listenerContext, state) {
          if (state is CreatePromiseSuccess) {

          }
          if (state is CreatePromiseInProgress) {
            
          }
        }, builder: (context, state) {
          return Padding(
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
                            clearIconProperty: IconProperty(
                                color: Colors.red, icon: Icons.clear),
                            dropDownIconProperty: IconProperty(
                                color: Colors.red, icon: Icons.abc),
                            controller: _cntMulti,
                            checkBoxProperty: CheckBoxProperty(
                                fillColor:
                                    WidgetStateProperty.all<Color>(Colors.red)),
                            dropDownList: const [
                              DropDownValueModel(
                                  name: '@me', value: 1),
                              DropDownValueModel(
                                  name: '@her',
                                  value: 2
                              )
                            ],
                            onChanged: (val) {
                              setState(() {});
                            },
                          ),
                          const SizedBox(height: 10)
                        ],
                      ),
                    ),
                  ),
                  floatingActionButton: FloatingActionButton.extended(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        BlocProvider.of<CreatePromiseCubit>(context).onCreatePromise(
                            Promise(id: 'id', 
                            content: _promiseDescriptionController.text, 
                            to: _cntMulti.dropDownValueList?.map((x) => x.value).join(', '),
                            dueDate: null
                            ));
                      }
                    },
                    label: const Text("Submit"),
                  )));
        }),
      ),
    );
  }

  @override
  dispose(){
    _cntMulti.clearDropDown();
    super.dispose();
  }
}
