import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:promise/const/text.dart';
import 'package:promise/features/auth/login/login.controller.dart';
import 'package:promise/features/auth/router/auth_router_delegate.dart';
import 'package:promise/features/page.deletegate.dart';
import 'package:promise/main.dart';
import 'package:promise/resources/localization/app_localization.dart';
import 'package:promise/util/localize.ext.dart';
import 'package:promise/widgets/disable_button.dart';
import 'package:promise/widgets/pm_textform_field.dart';
import 'package:provider/provider.dart';

final _controller = Get.find<LoginController>(tag: applicationTag);

class LoginWidget extends StatelessWidget {
  const LoginWidget({super.key});
  @override
  Widget build(BuildContext context) {
    return onCreateRoute(
        settings: const RouteSettings(name: "/login"),
        builder: (BuildContext context) => LoginView());
  }
}

class LoginPage extends Page {
  const LoginPage({super.key});

  @override
  Route createRoute(BuildContext context) {
    return onCreateRoute(
        settings: this, builder: (BuildContext context) => LoginView());
  }
}

class LoginView extends StatelessWidget {
  final bool sessionExpiredRedirect;
  final TextEditingController _userNameController =
      TextEditingController(text: "phatph");
  final TextEditingController _passwordController =
      TextEditingController(text: "Sz19@2107");
  final paddingBox = const SizedBox(height: 10);
  LoginView({super.key, this.sessionExpiredRedirect = false});
  @override
  Widget build(BuildContext context) {
    Get.put<LoginController>(LoginController(), tag: applicationTag);
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
        body: Padding(
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
                      hintText: context.translate("login.label_username")),
                  paddingBox,
                  PTextFormField(
                      labelText: context.translate("login.label_password"),
                      controller: _passwordController,
                      hintText: context.translate("login.label_password")),
                  paddingBox,
                  DisablableButton(
                      text: "Login",
                      mainContext: context,
                      action: () => _onLoginPressed(context),
                      enableFunc: () =>
                          !_controller.loginState.value.isInprogress),
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
            )));
  }

  void _onLoginPressed(BuildContext context) {
    _controller.login(_userNameController.text, _passwordController.text);
  }

  void _onSignUpPressed(BuildContext context) {
    context.read<AuthRouterDelegate>().setSignupUsernameNavState();
  }

  onSelected(BuildContext context, String item) {
    LocalizationService.changeLocale(item);
  }
}
