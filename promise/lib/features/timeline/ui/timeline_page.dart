import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:promise/di/service_locator.dart';
import 'package:promise/features/page.controller.dart';
import 'package:promise/features/timeline/widget/timeline.dart';
import 'package:promise/features/timeline/widget/timeline.widget.dart';
import 'package:promise/main.dart';
import 'package:promise/services/public/story/story.service.dart';
import 'package:promise/util/layout_util.dart';
import 'package:promise/util/localize.ext.dart';
import 'package:promise/util/log/log.dart';
import 'package:promise/widgets/loading_overlay.dart';

final _controller = Get.find<TimelineController>(tag: applicationTag);

class TimelinePage extends StatelessWidget {
  const TimelinePage({super.key});

  @override
  Widget build(BuildContext context) {
    Future.microtask(() async {
      _controller.loadingState.value.isInprogress = true;
      _controller.loadingState.refresh();
      var storyService = serviceLocator.get<StoryService>();
      var res = await storyService.fetchAsync();
      var x = 0;
      var data = res.data
          .map((d) => TimelineItem(
              to: d.to,
              title: 'title ${x++}',
              user: d.user,
              description: d.content,
              time: DateTime.now()))
          .toList();
      _controller.reset();
      _controller.setData(data);
    });
    return const TimelineView();
  }
}

class TimelineView extends StatelessWidget {
  const TimelineView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: Obx(() => _getBodyForState(context)));
  }

  Widget _getBodyForState(BuildContext context) {
    if (_controller.loadingState.value.isInprogress) {
      return loadingWidget();
    } else if (!_controller.loadingState.value.isInprogress) {
      final List<TimelineItem> timelineItems = _controller.items;
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
    } else if (_controller.loadingState.value.isError) {
      return _errorWidget(_controller.loadingState.value.errorKey, context);
    } else {
      Log.e(UnimplementedError('EventListState not consumed'));
      return _errorWidget("EventListState not consumed", context);
    }
  }

  Widget _timelineWidget(
      BuildContext context, List<TimelineItem> timelineItems) {
    return SingleChildScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      child: Container(
        color: context.containerLayoutColor,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [Timeline(timeLineItems: timelineItems)],
        ),
      ),
    );
  }

  Widget _emptyListWidget(BuildContext context) {
    return Center(
        child: Text(context.translate("timeline_page_no_timeline_items_message")));
  }

  Widget _errorWidget(String errorKey, BuildContext context) {
    return Center(child: Text(context.translate(errorKey)));
  }
}
