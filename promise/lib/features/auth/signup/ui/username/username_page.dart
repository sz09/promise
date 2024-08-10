import 'package:flutter/cupertino.dart';
import 'package:promise/features/auth/signup/ui/username/username_view.dart';
import 'package:promise/features/page.deletegate.dart';

class UsernamePage extends Page {
  @override
  Route createRoute(BuildContext context) {
    return onCreateRoute(
      settings: this,
      builder: (BuildContext context) => UsernameView(),
    );
  }
}
