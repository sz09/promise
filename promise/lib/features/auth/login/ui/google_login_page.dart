import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

class GoogleLoginPopup extends StatefulWidget {
  @override
  _GoogleLoginPopupState createState() => _GoogleLoginPopupState();
}

class _GoogleLoginPopupState extends State<GoogleLoginPopup> {
  InAppWebViewController? webViewController;

  @override
  Widget build(BuildContext context) {
    final clientId = "678731460115-nn4qrmid3ckpf3kkotqvk3hk5bovn6d3.apps.googleusercontent.com";
    return Dialog(
      child: Container(
        height: 400,
        width: 300,
        child: InAppWebView(
          initialUrlRequest: URLRequest(
            url: WebUri.uri( Uri.parse(
                "https://accounts.google.com/o/oauth2/v2/auth?"
                "client_id=$clientId&"
                "redirect_uri=com.promise:/oauth2redirect&"
                "response_type=code&"
                "scope=email%20profile%20openid&"
                "access_type=offline")),
          ),
          onLoadStop: (controller, url) {
            if (url != null && url.toString().startsWith("com.promise:/oauth2redirect")) {
              // Lấy code từ URL
              final code = Uri.parse(url.toString()).queryParameters['code'];
              print("Authorization Code: $code");

              // Đóng modal sau khi lấy code
              Navigator.pop(context, code);
            }
          },
        ),
      ),
    );
  }
}
