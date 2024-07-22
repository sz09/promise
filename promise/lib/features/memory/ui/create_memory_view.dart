import 'package:promise/features/memory/bloc/create_memory_cubit.dart';
import 'package:promise/features/memory/bloc/create_memory_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:promise/models/memory/memory.dart';

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
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Create Memory'),
          centerTitle: true,
          leading: Container(),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
          ],
        ),
        body: BlocConsumer<CreateMemoryCubit, CreateMemoryState>(
            listener: (listenerContext, state) {
          if (state is CreateMemorySuccess) {
            Navigator.of(context).pop();
          }
        }, builder: (context, state) {
          if (state is CreateMemoryInProgress) {
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
                    controller: _memoryDescriptionController,
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
      BlocProvider.of<CreateMemoryCubit>(context).onCreateMemory(
          Memory(id: 'id', description: _memoryDescriptionController.text));
    }
  }
}
