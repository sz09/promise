import 'package:promise/models/base/base.model.dart';
import 'package:promise/util/json_ext.dart';

class User {
  final String id;
  final String username;
  factory User.fromJson(Map<String, dynamic> json){
    return User(
      id: jsonTryGet(json, 'id'),
      username: jsonTryGet(json, 'username')
    );
  }
  User({required this.id, required this.username});
}

class Story extends BaseModel {
  Story({
    required String id, 
    required this.user,
    required this.title,
    required this.content,
    required this.time,
    }) {
    this.id = id;
  }
  final String content;
  final String title;
  final DateTime time;
  final User user;

  factory Story.fromJson(Map<String, dynamic> json) {
    return Story(
      id: jsonTryGet<String>(json, 'id') ?? '',
      user: User.fromJson(jsonTryGet<Map<String, dynamic>>(json, 'user')!),
      title: jsonTryGet<String>(json, 'title') ?? '',
      time: jsonTryGet<DateTime>(json, 'time', func: (x) => DateTime.parse(x)) ?? DateTime.now(),
      content: jsonTryGet<String>(json, 'content') ?? ''
    );
  }
}