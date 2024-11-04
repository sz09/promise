import 'package:promise/models/base/base.model.dart';
import 'package:promise/models/person/person.dart';
import 'package:promise/util/json_ext.dart';

class Story extends BaseModel {
  Story({
    required String id, 
    required this.to,
    required this.user,
    required this.title,
    required this.content,
    required this.time,
    }) {
    this.id = id;
  }
  final String to;
  final String content;
  final String title;
  final DateTime time;
  final Person user;

  factory Story.fromJson(Map<String, dynamic> json) {
    return Story(
      id: json.tryGet<String>('id') ?? '',
      to: json.tryGet<String>('to') ?? '',
      user: Person.fromJson(json.tryGet<Map<String, dynamic>>('user')!),
      title: json.tryGet<String>('title') ?? '',
      time: json.tryGet<DateTime>('time', func: (x) => DateTime.parse(x)) ?? DateTime.now(),
      content: json.tryGet<String>('content') ?? ''
    );
  }
}