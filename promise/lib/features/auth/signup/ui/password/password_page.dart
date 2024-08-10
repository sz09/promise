import 'package:flutter/cupertino.dart';
import 'package:promise/features/auth/signup/ui/password/password_view.dart';
import 'package:promise/features/page.deletegate.dart';

class PasswordPage extends Page {
  @override
  Route createRoute(BuildContext context) {
    return onCreateRoute(
      settings: this,
      builder: (BuildContext context) => PasswordView(),
    );
  }
}
