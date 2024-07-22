import 'package:promise/util/log/log.dart';
import 'package:promise/main.dart';
import 'package:promise/routing/app_router_delegate.dart';
import 'package:provider/provider.dart';

/// Handles [ForceUpdateException].
class ForceUpdateHandler {
  ForceUpdateHandler();

  void onForceUpdateEvent() {
    final rootContext = rootNavigatorKey.currentContext;
    if (rootContext != null) {
      rootContext.read<AppRouterDelegate>().setForceUpdateNavState();
    } else {
      Log.e(Exception('Force update dialog not shown: rootContext == null'));
    }
  }
}
