import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:promise/di/service_locator.dart';
import 'package:promise/features/page.controller.dart';
import 'package:promise/features/timeline/widget/timeline.widget.dart';
import 'package:promise/main.dart';
import 'package:promise/models/story/story.model.dart';
import 'package:promise/services/public/story/story.service.dart';
import 'package:promise/util/localize.ext.dart';
import 'package:promise/util/log/log.dart';
import 'package:promise/widgets/custom_stateful.page.dart';
import 'package:promise/widgets/loading_overlay.dart';

final _controller = Get.find<TimelineController>(tag: applicationTag);

class TimelinePage extends StatelessWidget {
  const TimelinePage({super.key});

  @override
  Widget build(BuildContext context) {
    return TimelineView();
  }
}

class TimelineView extends StateView<TimelineView> {
  TimelineView({super.key})
      : super(
            buildWidgetFunc: (context) =>
                Scaffold(body: Obx(() => _getBodyForState(context))),
            loadDataFunc: _loadData);
  static _loadData() async {
    _controller.loadingState.value.isInprogress = true;
    _controller.loadingState.refresh();
    var storyService = serviceLocator.get<StoryService>();
    var res = await storyService.fetchAsync();
    _controller.reset();
    _controller.setData(res.data);
  }

  static Widget _getBodyForState(BuildContext context) {
    if (_controller.loadingState.value.isInprogress) {
      return loadingWidget();
    } else if (!_controller.loadingState.value.isInprogress) {
      final List<Story> timelineItems = _controller.items.value;
      if (timelineItems.isEmpty) {
        return _emptyListWidget(context);
      } else {
        return _timelineWidget(
          context,
          timelineItems,
        );
      }
    } else if (_controller.loadingState.value.isError) {
      return _errorWidget(_controller.loadingState.value.errorKey, context);
    } else {
      Log.e(UnimplementedError('EventListState not consumed'));
      return _errorWidget("EventListState not consumed", context);
    }
  }

  static Widget _timelineWidget(
      BuildContext context, List<Story> timelineItems) {
    return RefreshIndicator(
        onRefresh: () async {
          _loadData();
        },
        child: ListView.builder(
          shrinkWrap: true,
          physics: const AlwaysScrollableScrollPhysics(),
          itemCount: timelineItems.length,
          itemBuilder: (context, index) {
            return TimelineItemWidget(
              item: timelineItems[index],
              index: index,
            );
          },
        ));
  }

  static Widget _emptyListWidget(BuildContext context) {
    return Center(
        child:
            Text(context.translate("timeline_page_no_timeline_items_message")));
  }

  static Widget _errorWidget(String errorKey, BuildContext context) {
    return Center(child: Text(context.translate(errorKey)));
  }
}
