import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:promise/di/service_locator.dart';
import 'package:promise/features/auth/login/bloc/login_cubit.dart';
import 'package:promise/features/auth/login/ui/login_view.dart';
import 'package:promise/features/page.deletegate.dart';
import 'package:promise/user/user_manager.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});
  
  @override
  Widget build(BuildContext context) {
    return BlocProvider<LoginCubit>(
        create: (BuildContext context) =>
            LoginCubit(serviceLocator.get<UserManager>()),
        child: LoginView(),
      );
  }
}


class LoginPage1 extends Page {
  const LoginPage1({super.key});
  
  @override
  Route createRoute(BuildContext context) {
    return onCreateRoute(
      settings: this, 
      builder: (BuildContext context) => BlocProvider<LoginCubit>(
        create: (BuildContext context) =>
            LoginCubit(serviceLocator.get<UserManager>()),
        child: LoginView(),
      ));
  }
}
