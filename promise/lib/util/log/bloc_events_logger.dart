import 'package:bloc/bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:promise/util/log/log.dart';
/// Logs blog memories.
///
/// To apply globally, before the app starts, set it as bloc observer:
///       Bloc.observer = BlocMemoriesLogger();
///
/// See [preAppConfig]
class BlocEvensLogger extends BlocObserver {
  @override
  void onEvent(Bloc bloc, Object? event) {
    if (event != null) {
      Log.d(event.toString());
    }
    super.onEvent(bloc, event);
  }

  @override
  void onTransition(Bloc bloc, Transition transition) {
    Log.d(transition.toString());
    super.onTransition(bloc, transition);
  }

  @override
  void onError(BlocBase bloc, Object error, StackTrace stackTrace) {
    Log.e(error);
    super.onError(bloc, error, stackTrace);
  }
}
