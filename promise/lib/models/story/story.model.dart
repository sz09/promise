import 'package:promise/models/base/base.model.dart';
import 'package:promise/util/json_ext.dart';

class Story extends BaseModel {
  Story({
    required String id, 
    required this.title,
    required this.content,
    required this.time,
    }) {
    this.id = id;
  }
  final String content;
  final String title;
  final DateTime time;

  factory Story.fromJson(Map<String, dynamic> json) {
    return Story(
      id: jsonTryGet<String>(json, 'id') ?? '',
      title: jsonTryGet<String>(json, 'title') ?? '',
      time: jsonTryGet<DateTime>(json, 'time', func: (x) => DateTime.parse(x)) ?? DateTime.now(),
      content: jsonTryGet<String>(json, 'content') ?? ''
    );
  }
}