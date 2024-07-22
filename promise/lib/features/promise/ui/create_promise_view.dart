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
  final _formKey = GlobalKey<FormState>();

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
            Navigator.of(context).pop();
          }
        }, builder: (context, state) {
          if (state is CreatePromiseInProgress) {
            return const Center(child: CircularProgressIndicator());
          }
          return Padding(
            padding: const EdgeInsets.all(8.0),
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
                  ElevatedButton(
                    child: const Text('Create'),
                    onPressed: () => _onCreatePressed(context),
                  ),
                ],
              ),
            ),
          );
        }),
      ),
    );
  }

  _onCreatePressed(BuildContext context) {
    if (_formKey.currentState!.validate()) {
      BlocProvider.of<CreatePromiseCubit>(context).onCreatePromise(
          Promise(id: 'id', description: _promiseDescriptionController.text));
    }
  }
}
