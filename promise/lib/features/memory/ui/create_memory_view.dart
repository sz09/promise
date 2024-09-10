import 'package:flutter/material.dart';
import 'package:promise/widgets/disable_button.dart';

class CreateMemoryView extends StatefulWidget {
  const CreateMemoryView({super.key});

  @override
  _CreateMemoryViewState createState() => _CreateMemoryViewState();
}

class _CreateMemoryViewState extends State<CreateMemoryView> {
  final TextEditingController _memoryDescriptionController =
      TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(height: 10),
                  TextFormField(
                    controller: _memoryDescriptionController,
                    cursorColor: Colors.black,
                    decoration: const InputDecoration(
                      contentPadding: EdgeInsets.all(15),
                      hintText: "Description",
                    ),
                  ),
                  const SizedBox(height: 10),
                  DisablableButton(
                    text: 'Create',
                    enableFunc: () => true,
                    mainContext: context,
                    action: _onCreatePressed(context),
                  )
                ],
              ),
            ),
          ));
  }

  _onCreatePressed(BuildContext context) {
    if (_formKey.currentState!.validate()) {
     
    }
  }
}
