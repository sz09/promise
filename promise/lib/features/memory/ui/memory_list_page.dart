import 'package:promise/features/memory/bloc/memory_list_bloc.dart';
import 'package:promise/features/memory/bloc/memory_list_event.dart';
import 'package:promise/features/memory/ui/memory_list_view.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:promise/di/service_locator.dart';
import 'package:promise/services/memory/memory.service.dart';
import 'package:promise/user/user_manager.dart';

class MemoryListPage extends StatelessWidget {
  MemoryListPage({super.key});

  @override
  Widget build(BuildContext context) {
     return BlocProvider<MemoryListBloc>(
        create: (BuildContext context) => MemoryListBloc(
        serviceLocator.get<MemoryService>(),
        serviceLocator.get<UserManager>())
        ..add(LoadMemories()),
        child: const MemoryListView()
     );
  }
}
