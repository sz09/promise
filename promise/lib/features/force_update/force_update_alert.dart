import 'dart:io';
import 'package:promise/config/app.update.dart';
import 'package:promise/util/log/log.dart';
import 'package:promise/widgets/alert_dialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

const forceUpdateDialogRouteName = '/forceUpdateDialog';

Future<void> showForceUpdateAlert(BuildContext context) {
  final storeUrl = Platform.isIOS ? APP_STORE_URL : PLAY_STORE_URL;

  return showAlert(
    context,
    title: 'force_update_title', //todo change
    message: 'force_update_message', //todo change
    primaryButtonText: 'force_update_button_title', //todo change
    onPrimaryClick: () => _launchURL(storeUrl),
    isDismissible: false,
    willPopScope: false,
    settings: const RouteSettings(name: forceUpdateDialogRouteName),
  );
}

void _launchURL(String url) async {
  var encodedUrl = Uri.parse(url);
  if (await canLaunchUrl(encodedUrl)) {
    await launchUrl(encodedUrl);
  } else {
    Log.e(Exception('Could not launch $encodedUrl'));
  }
}
