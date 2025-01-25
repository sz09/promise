import 'package:flutter/material.dart';
import 'package:flutter_web_auth/flutter_web_auth.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:promise/const/text.dart';
import 'package:promise/di/service_locator.dart';
import 'package:promise/features/auth/login/login.controller.dart';
import 'package:promise/features/auth/login/ui/google_login_page.dart';
import 'package:promise/features/auth/router/auth_router_delegate.dart';
import 'package:promise/features/page.deletegate.dart';
import 'package:promise/main.dart';
import 'package:promise/notifications/local/local_notification_manager.dart';
import 'package:promise/resources/localization/app_localization.dart';
import 'package:promise/util/localize.ext.dart';
import 'package:promise/widgets/disable_button.dart';
import 'package:promise/widgets/wrap/wrap_password.dart';
import 'package:promise/widgets/wrap/wrap_text_field.dart';
import 'package:provider/provider.dart';
import 'package:googleapis_auth/auth_io.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:oauth2/oauth2.dart' as oauth2;


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
  LoginView({super.key, this.sessionExpiredRedirect = false});
  @override
  Widget build(BuildContext context) {
    serviceLocator.get<LocalNotificationsManager>().requestUserPermission();
    return Scaffold(
        appBar: AppBar(
          actions: [
            PopupMenuButton<String>(
                onSelected: (item) => onSelected(context, item),
                itemBuilder: (context) => [
                      PopupMenuItem(
                        value: 'en',
                        child: Text(context.translate('language.english')),
                      ),
                      PopupMenuItem(
                        value: 'vi',
                        child: Text(context.translate('language.vietnamese')),
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
                      fontSize: textFontSize,
                    ),
                  ),
                  Text(context.translate('login.page_title')),
                  WrapTextFormField(
                      labelText: context.translate("login.label_username"),
                      controller: _userNameController,
                      hintText: context.translate("login.username_hint")),
                  WrapPasswordFormField(
                      labelText: context.translate("login.label_password"),
                      controller: _passwordController,
                      hintText: context.translate("login.password_hint")),
                  DisablableButton(
                      text: context.translate("login.label_login"),
                      applyPaddingTop: true,
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
                  ElevatedButton(
                    onPressed: () => _signInWithGoogle(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black,
                      //primary: Colors.grey[300],
                    ),
                    child: const Text('Google signin'),
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

  Future<void> _signInWithGoogle(BuildContext context) async {
    final authorizationEndpoint = Uri.parse("https://accounts.google.com/o/oauth2/auth");
    final tokenEndpoint = Uri.parse("https://oauth2.googleapis.com/token");
    final redirectUri = Uri.parse("com.promise:/oauth2redirect");

    final grant = oauth2.AuthorizationCodeGrant(
      "678731460115-nn4qrmid3ckpf3kkotqvk3hk5bovn6d3.apps.googleusercontent.com",
      authorizationEndpoint,
      tokenEndpoint,
      secret: "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",
    );

    final authUrl = grant.getAuthorizationUrl(redirectUri);
    print("Auth URL: $authUrl");
    if (await canLaunchUrl(authUrl)) {
      try {
        var r = await launchUrl(authUrl);
        var x = r;
      }
      catch(ex){
        var r = ex;
      }
    } else {
      throw "Could not launch $authUrl";
    }
    // Gửi mã code này lên server backend để đổi lấy access_token và refresh_token

    // final code = await showDialog(
    //   context: context,
    //   builder: (context) => GoogleLoginPopup(),
    // );

    // if (code != null) {
    //   print("Authorization Code: $code");
    // Gửi mã này lên server để đổi access_token và refresh_token
  }
  // try {
  //     final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
  //     if (googleUser == null) {
  //       print("Login cancelled");
  //       return;
  //     }

  //     final GoogleSignInAuthentication googleAuth =
  //         await googleUser.authentication;

  //     print("Access Token: ${googleAuth.accessToken}");
  //     print("ID Token: ${googleAuth.idToken}");
  //   } catch (e) {
  //     print("Error logging in with Google: $e");
  //   }
  // }
}
