import 'package:flutter/material.dart';
import 'package:promise/features/timeline/widget/timeline.dart';

class Timeline extends StatelessWidget {
  final List<TimelineItem> timeLineItems;

  const Timeline({super.key, required this.timeLineItems});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: timeLineItems.length,
      itemBuilder: (context, index) {
        return TimelineItemWidget(
          item: timeLineItems[index],
          index: index,
        );
      },
    );
  }
}
