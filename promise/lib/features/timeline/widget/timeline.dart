import 'package:flutter/material.dart';
import 'package:promise/const/text.dart';
import 'package:promise/models/story/story.model.dart';
import 'package:promise/util/layout_util.dart';
import 'package:promise/util/localize.ext.dart';

class TimelineItem {
  final String title;
  final String description;
  final DateTime time;
  final User user;
  final String to;

  const TimelineItem({
    required this.to,
    required this.user,
    required this.title,
    required this.description,
    required this.time,
  });
}

class TimelineItemWidget extends StatelessWidget {
  final TimelineItem item;
  final int index;

  const TimelineItemWidget(
      {super.key, required this.item, required this.index});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: const BorderRadius.all(Radius.circular(16.0)),
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 10.0),
        decoration: BoxDecoration(
          color: context.containerLayoutColor,
          borderRadius: BorderRadius.circular(5),
          shape: BoxShape.rectangle,
          boxShadow: [
            BoxShadow(color: context.containerLayoutColor, spreadRadius: 3)
          ],
        ),
        
        child: Row(
          children: [
            const SizedBox(width: 20.0),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(children: [
                  Text(
                    "${item.user.username}: ",
                    style: const TextStyle(
                      fontSize: textFontSize,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  
                  Text(
                    "${context.translate("timeline.with")} ${item.to} ",
                    style: const TextStyle(
                        fontSize: textFontSize, fontWeight: FontWeight.normal),
                  ),
                  Text(
                    item.title,
                    style: const TextStyle(
                        fontSize: textFontSize, fontWeight: FontWeight.normal),
                  )
                ]),
                const SizedBox(height: 5.0),
                Text(
                  "${item.time.year}-${item.time.month}-${item.time.day} ${item.time.hour}:${item.time.minute}",
                  style: const TextStyle(color: Colors.grey, fontSize: 12, fontStyle: FontStyle.italic),
                ),
                const SizedBox(height: 5.0),
                Text(item.description),
              ],
            )
          ],
        ),
      ),
    );
  }
}
