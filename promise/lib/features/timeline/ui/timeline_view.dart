import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:promise/data/data_not_found_exception.dart';
import 'package:promise/features/timeline/bloc/timeline_bloc.dart';
import 'package:promise/features/timeline/widget/timeline.dart';
import 'package:promise/features/timeline/widget/timeline.widget.dart';
import 'package:promise/util/log/log.dart';
import 'package:promise/models/promise/promise.dart';
import 'package:promise/resources/colors/color_palette.dart';
import 'package:promise/util/localize.ext.dart';

class TimelineView extends StatelessWidget {
  const TimelineView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<TimelineBloc, TimelineState>(
        listener: (context, state) {
      // do stuff here based on MemoriesCubit's state
      if (state is EventOpFailure) {
        //todo display an error dialog here on top of the presented UI
        Log.e('EventOpFailure: ${state.error}');
      }
    }, builder: (context, state) {
      // return widget here based on BlocA's state, this should be a pure fn
      return Scaffold(
        body: _getBodyForState(context, state),
        // drawer: createNavigationBar(context),
        // floatingActionButton: FloatingActionButton(
        //   onPressed: () {
        //     // _openCreatePromise(context);
        //   },
        //   tooltip: context.translate('timeline_list_create_new'),
        //   child: const Icon(Icons.add),
        // ),
        // floatingActionButtonLocation: FloatingActionButtonLocation.endTop,
      );
    });
  }

  Widget _getBodyForState(BuildContext context, TimelineState state) {
    if (state is TimelineLoadInProgress) {
      return _loadingWidget();
    } else if (state is TimelineLoadSuccess) {
      final List<TimelineItem> timelineItems = state.timelineItems;
      if (timelineItems.isEmpty) {
        return _emptyListWidget(context);
      } else {
        return Column(
          children: <Widget>[
            Expanded(
              child: _timelineWidget(
                context,
                timelineItems,
              ),
            ),
          ],
        );
      }
    } else if (state is EventOpFailure) {
      return _getBodyForState(context, state.prevState);
    } else if (state is TimelineLoadFailure) {
      return _errorWidget(state, context);
    } else {
      Log.e(UnimplementedError('EventListState not consumed: $state'));
      return _errorWidget(state, context);
    }
  }

  Widget _timelineWidget(BuildContext context, List<TimelineItem> timelineItems) {
    return SingleChildScrollView(
       physics: const AlwaysScrollableScrollPhysics(),
        child: Container(
          color: Theme.of(context).brightness == Brightness.dark
              ? ColorPalette.primaryLightD
              : ColorPalette.white,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Timeline(events: timelineItems)
            ],
          ),
        ),
    );
  }

  Widget _loadingWidget() {
    return const Center(child: CircularProgressIndicator());
  }

  Widget _emptyListWidget(BuildContext context) {
    return Center(
        child: Text(
          context.translate("promise_list_no_memories_message")
        )
      );
  }

  Widget _errorWidget(var state, BuildContext context) {
    String message;
    if (state is TimelineLoadFailure && state.error is DataNotFoundException) {
      message = context.translate("promise_list_error_loading_memories");
    } else {
      message = context.translate("list_error_general");
    }
    return Center(child: Text(message));
  }

  // void _openCreatePromise(BuildContext context) {
  //   showCupertinoModalBottomSheet(
  //       context: context,
  //       builder: (context) {
  //         return BlocProvider<CreatePromiseCubit>(
  //           create: (BuildContext context) =>
  //               CreatePromiseCubit(serviceLocator.get<PromiseService>()),
  //           child: const CreatePromiseView(),
  //         );
  //       });
  // }

  ReorderableListView getItem(List<Promise> promise, BuildContext context) {
    BlocProvider.of<TimelineBloc>(context);

    return ReorderableListView(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        header: SizedBox(
          height: 50,
          child: Container(
            color: Theme.of(context).brightness == Brightness.dark
                ? ColorPalette.primaryDisabledD
                : ColorPalette.backgroundGray,
            child: const Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: EdgeInsets.fromLTRB(16.0, 8.0, 8.0, 8.0),
                child: Text(
                  "Event",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
        ),
        children: <Widget>[
          for (Promise promise in promise)
            _TimelineItem(
                key: ValueKey(promise.id),
                promise: promise,
                onClick: (promise) =>  {
                  Log.d('onClick: $promise')
                } 
                // context
                //     .read<HomeRouterDelegate>()
                //     .setPromiseDetailNavState(promise)
                ),
        ],
        onReorder: (oldIndex, newIndex) {
          // timelineBloc.add(MemoriesReordered(key, oldIndex, newIndex));
        });
  }
}

class _TimelineItem extends StatelessWidget {
  final Promise promise;
  final Function(Promise promise) onClick;

  const _TimelineItem({
    super.key,
    required this.promise,
    required this.onClick
  });

  @override
  Widget build(BuildContext context) {
    ThemeData themeData = Theme.of(context);
    return Ink(
      color: themeData.cardColor,
      child: ListTile(
        trailing: const Icon(Icons.reorder),
        title: Text(promise.content),
        onTap: () => onClick(promise),
      ),
    );
  }
}
