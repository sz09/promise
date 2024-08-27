import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:promise/data/data_not_found_exception.dart';
import 'package:promise/features/timeline/bloc/timeline_bloc.dart';
import 'package:promise/features/timeline/widget/timeline.dart';
import 'package:promise/features/timeline/widget/timeline.widget.dart';
import 'package:promise/util/layout_util.dart';
import 'package:promise/util/log/log.dart';
import 'package:promise/util/localize.ext.dart';
import 'package:promise/widgets/loading_overlay.dart';

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
        body: _getBodyForState(context, state)
      );
    });
  }

  Widget _getBodyForState(BuildContext context, TimelineState state) {
    if (state is TimelineLoadInProgress) {
      return loadingWidget();
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
      Log.e(UnimplementedError('TimelineState not consumed: $state'));
      return _errorWidget(state, context);
    }
  }

  Widget _timelineWidget(BuildContext context, List<TimelineItem> timelineItems) {
    return SingleChildScrollView(
       physics: const AlwaysScrollableScrollPhysics(),
        child: Container(
          color: context.containerLayoutColor,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Timeline(timeLineItems: timelineItems)
            ],
          ),
        ),
    );
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
}
