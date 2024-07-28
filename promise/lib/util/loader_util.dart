import 'package:flutter/material.dart';

// ignore: avoid_init_to_null
// showLoaderDialog(BuildContext context, {String? message = null}) async {
//    var builder = AlertDialog.Builder(context);
//   AlertDialog alert = AlertDialog(
//     content: Row(
//       children: [
//         const CircularProgressIndicator(),
//         Container(margin: const EdgeInsets.only(left: 7),child:Text(message ?? "Loading..." )),
//       ],),
//   );
//   var x = await showAdaptiveDialog(
//     barrierDismissible: false,
//     routeSettings: RouteSettings(name: "/login"),
//     context: context,
//     builder: (BuildContext context) {
//       return PopScope(
//           canPop: true,
          
//           onPopInvoked: (didPop) {

//           },
//           child: alert
//       );
//     },
//   );
//   return x;
// }


void showCustomDialog(BuildContext context, {String? message}) {
    showAdaptiveDialog(
      context: context,
      builder: (BuildContext context) {
        var mediaQuery = MediaQuery.of(context);
        var isLargeScreen = mediaQuery.size.width > 600;

        return AlertDialog(
          title: const Text('Adaptive Dialog'),
          content: isLargeScreen
              ?  Row(
                  children: [
                    Expanded(child: Text(message ?? 'This is a wide screen dialog')),
                    const Icon(Icons.info),
                  ],
                )
              : Text(message ?? 'This is a small screen dialog'),
          actions: <Widget>[
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
}