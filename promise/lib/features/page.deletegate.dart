import 'package:flutter/cupertino.dart';

onCreateRoute({required RouteSettings settings, required Widget Function(BuildContext) builder }){
  return CupertinoPageRoute(
      settings: settings,
      builder: builder,
    );

    // TODO: Make behavior for android
  // if(Platform.isAndroid){
  //     return MaterialPageRoute(builder: builder);
  // }
  // else if (Platform.isIOS){
  //   return CupertinoPageRoute(
  //     settings: settings,
  //     builder: builder,
  //   );
  // }

  throw Exception('Not support exception');
}