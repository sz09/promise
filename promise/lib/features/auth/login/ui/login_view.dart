import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:promise/const/text.dart';
import 'package:promise/features/auth/login/bloc/login_cubit.dart';
import 'package:promise/features/auth/router/auth_router_delegate.dart';
import 'package:promise/resources/localization/app_localization.dart';
import 'package:promise/routers/router.config.dart';
import 'package:promise/util/localize.ext.dart';
import 'package:promise/widgets/pm_textform_field.dart';

class LoginView extends StatelessWidget {
  final bool sessionExpiredRedirect;
  final TextEditingController _userNameController = TextEditingController(text: "phatph");
  final TextEditingController _passwordController = TextEditingController(text: "Sz19@2107");
  final paddingBox = const SizedBox(height: 10);
  LoginView({super.key, this.sessionExpiredRedirect = false});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          PopupMenuButton<String>(
              onSelected: (item) => onSelected(context, item),
              itemBuilder: (context) => [
                    const PopupMenuItem(
                      value: 'en',
                      child: Text('English'),
                    ),
                    const PopupMenuItem(
                      value: 'vi',
                      child: Text('Tiếng Việt'),
                    ),
                  ])
        ],
      ),
      body: BlocConsumer<LoginCubit, LoginState>(
        listener: (context, state) async {
          switch(state) {
            case LoginSuccess _:
             await Get.toNamed(homeRoute);
              // await Navigator.of(rootNavigatorKey.currentContext!).pushNamed('/');
              break;
            case LoginFailure _ :
              break;
            case LoginInProgress _ :
              break;
          }
        },
        builder: (context, state) {
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      context.translate('application.title'),
                      style: const TextStyle(
                        color: Colors.blueAccent,
                        fontSize: textFontSize,
                      ),
                    ),
                    Text(context.translate('login.page_title')),
                    paddingBox,
                    PTextFormField(
                      labelText: context.translate("login.label_username"),
                      controller: _userNameController,
                      hintText: context.translate("login.label_username")
                    ),
                    paddingBox,
                    PTextFormField(
                      labelText: context.translate("login.label_password"),
                      controller: _passwordController,
                      hintText: context.translate("login.label_password")
                    ),
                    paddingBox,
                    ElevatedButton(
                      child: const Text('Login'),
                      onPressed: () => _onLoginPressed(context),
                    ),
                    ElevatedButton(
                      onPressed: () => _onSignUpPressed(context),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.black,
                        //primary: Colors.grey[300],
                      ),
                      child: const Text('Sign up'),
                    ),
                  ],
                ),
              )
          );
        },
      ),
    );
  }

  void _onLoginPressed(BuildContext context) {
    BlocProvider.of<LoginCubit>(context)
        .onUserLogin(_userNameController.text, _passwordController.text);
  }

  void _onSignUpPressed(BuildContext context) {
    context.read<AuthRouterDelegate>().setSignupUsernameNavState();
  }

  onSelected(BuildContext context, String item) {
    LocalizationService.changeLocale(item);
  }
}
