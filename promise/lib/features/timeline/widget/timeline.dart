import 'package:flutter/material.dart';
import 'package:promise/models/story/story.model.dart';

class TimelineItem {
  final String title;
  final String description;
  final DateTime time;
  final User user;

  const TimelineItem({
    required this.user,
    required this.title,
    required this.description,
    required this.time,
  });
}

class TimelineItemWidget extends StatelessWidget {
  final TimelineItem item;

  const TimelineItemWidget({
    super.key,
    required this.item
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10.0),
      child: Row(
        children: [
          Column(
            children: [
              Container(
                width: 20.0,
                height: 10.0,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Color.fromARGB(255, 22, 139, 222),
                ),
              ),
              Container(
                width: 2.0,
                height: 50.0,
                color: const Color.fromARGB(255, 246, 33, 0),
              ),
            ],
          ),
          const SizedBox(width: 20.0),
           Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(children: [
                    Text(
                  item.user.username,
                  style: const TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                  Text(
                    item.title,
                    style: const TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.normal
                    ),
                  )
                ]),
                const SizedBox(height: 5.0),
                Text(item.description),
                const SizedBox(height: 5.0),
                Text(
                  "${item.time.year}-${item.time.month}-${item.time.day} ${item.time.hour}:${item.time.minute}",
                  style: const TextStyle(color: Colors.grey),
                ),
              ],
           )
        ],
      ),
    );
  }
}
