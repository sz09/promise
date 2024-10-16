
import 'package:flutter/material.dart';

abstract class StateView<T> extends StatefulWidget {
 late Widget Function(BuildContext) buildWidgetFunc;
  StateView({super.key});

  @override
  State<StatefulWidget> createState() {
    // ignore: no_logic_in_create_state
    return _StateViewState<T>(buildWidgetFunc: this.buildWidgetFunc);
  }
}

class _StateViewState<T> extends State<StateView<T>> {
 final Widget Function(BuildContext) buildWidgetFunc;
  _StateViewState({required this.buildWidgetFunc});
  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) => setState(() {}));
    return buildWidgetFunc(context);
  }

}