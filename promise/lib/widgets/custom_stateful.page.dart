import 'package:flutter/material.dart';

abstract class StateView<T> extends StatefulWidget {
  final Widget Function(BuildContext) buildWidgetFunc;
  final Function? loadDataFunc;
  final Function? disposeFunc;
  
  const StateView({required this.buildWidgetFunc, this.loadDataFunc = null, this.disposeFunc = null, super.key});

  @override
  State<StatefulWidget> createState() {
    return _StateViewState<T>();
  }
}

class _StateViewState<T> extends State<StateView<T>> {
  @override @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if(widget.loadDataFunc != null){
        widget.loadDataFunc!.call();
      }
    });
    super.initState();
  } 

  @override
  Widget build(BuildContext context) {
    return widget.buildWidgetFunc(context);
  }
}

abstract class PullToRefreshStateView extends StatefulWidget {
  late Widget Function(BuildContext) buildWidgetFunc;
  late VoidCallback? initialFunc = null;
  late Function loadDataFunc;
  final Function? disposeFunc;
  final stateKey = GlobalKey<RefreshIndicatorState>();
  PullToRefreshStateView({this.disposeFunc = null, super.key});
  reloadData(){
    (stateKey.currentWidget as RefreshIndicator).onRefresh();
  }
  @override
  State<StatefulWidget> createState() {
    return _StatePullToRefreshStateView();
  }
}

class _StatePullToRefreshStateView extends State<PullToRefreshStateView> {
  @override @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      widget.loadDataFunc();
      if(widget.initialFunc != null){
        widget.initialFunc!.call();
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
   return RefreshIndicator(
        key: widget.stateKey,
        onRefresh: () async {
          widget.loadDataFunc();
        },
        child: widget.buildWidgetFunc(context)
   );
  }
}