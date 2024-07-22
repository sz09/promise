import 'package:flutter/material.dart';

// ignore: avoid_init_to_null
showLoaderDialog(BuildContext context, {String? message = null}){
  AlertDialog alert = AlertDialog(
    content: Row(
      children: [
        const CircularProgressIndicator(),
        Container(margin: const EdgeInsets.only(left: 7),child:Text(message ?? "Loading..." )),
      ],),
  );
  showAdaptiveDialog(
    barrierDismissible: false,
    context: context,
    builder: (BuildContext context) {
      return PopScope(
          canPop: false,
          onPopInvoked: (didPop) => false,
          child: alert
      );
    },
  );
}