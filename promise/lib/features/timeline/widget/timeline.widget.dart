import 'package:flutter/material.dart';
import 'package:promise/features/timeline/widget/timeline.dart';

class Timeline extends StatelessWidget {
  final List<TimelineItem> events;

  const Timeline({super.key, required this.events});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: events.length,
      itemBuilder: (context, index) {
        return TimelineItemWidget(
          item: events[index]
        );
      },
    );
  }
}
