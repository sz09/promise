import 'package:promise/models/base/base.model.dart';
import 'package:promise/util/json_ext.dart';
enum PromiseAction {
    Promise,
    CompleteChallenge
}

class Story extends BaseModel {
  Story({
    required String id, 
    required this.to,
    required this.content,
    required this.action,
    required this.from,
    required this.time,
    }) {
    this.id = id;
  }
  final List<String> to;
  final String content;
  final DateTime time;
  final PromiseAction action;
  final String from;

  factory Story.fromJson(Map<String, dynamic> json) {
    return Story(
      id: json.tryGet<String>('id') ?? '',
      from: json.tryGet<String>('from') ?? '',
      to:  json.tryGetCast<List<String>, List>(key: 'to', func: (list) {
          if(list.isNotEmpty) {
            return list.cast<String>();
          }
          return [];
      }) ?? [],
      action: json.tryGetCast<PromiseAction, int>(key: 'action', func: (a) {
        return PromiseAction.values[a];
      }) ?? PromiseAction.Promise,
      time: json.tryGetCast<DateTime, String>(key: 'time', func: (x) => DateTime.parse(x)) ?? DateTime.now(),
      content: json.tryGet<String>('content') ?? ''
    );
  }
}