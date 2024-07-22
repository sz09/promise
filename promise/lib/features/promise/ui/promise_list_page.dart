import 'package:promise/features/promise/bloc/promise_list_bloc.dart';
import 'package:promise/features/promise/bloc/promise_list_event.dart';
import 'package:promise/features/promise/ui/promise_list_view.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:promise/di/service_locator.dart';
import 'package:promise/services/promise/promise.service.dart';
import 'package:promise/user/user_manager.dart';

class PromiseListPage extends StatelessWidget {
  late PromiseListBloc _bloc;
  PromiseListPage({super.key});
  @override
  Widget build(BuildContext context) {
     return BlocProvider<PromiseListBloc>(
        create: (BuildContext context) => PromiseListBloc(
            serviceLocator.get<PromiseService>(),
            serviceLocator.get<UserManager>())
            ..add(LoadPromises()),
        child: const PromiseListView()
     );
  }
}
