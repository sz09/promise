import 'package:flutter/material.dart';

class TimelineItem {
  final String title;
  final String description;
  final DateTime time;

  const TimelineItem({
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
                width: 10.0,
                height: 10.0,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.blue,
                ),
              ),
              Container(
                width: 2.0,
                height: 50.0,
                color: Colors.blue,
              ),
            ],
          ),
          const SizedBox(width: 20.0),
           Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.title,
                  style: const TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
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
