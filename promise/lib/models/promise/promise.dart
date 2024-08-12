import 'package:hive/hive.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:promise/models/base/base.model.dart';
import 'package:promise/util/json_ext.dart';
import 'package:promise/util/reflectable.hive.dart';
part 'promise.g.dart'; 

@HiveType(typeId: 0)
@JsonSerializable()
@hiveTypeReflector
class Promise extends BaseAuditModel {
  @HiveField(5)
  late String content;
  @HiveField(6)
  late DateTime? dueDate;
  late String? to;
  Promise({required String id, required this.content, this.to = null, this.dueDate = null}) {
    this.id = id;
  }
  
  factory Promise.fromJson(Map<String, dynamic> json) {
    return Promise(
      id: (json['id'] ?? '') as String,
      content: (json['content'] ?? '') as String,
      to: json.tryGet<String>('to')
    );
  }


  Map<String, dynamic> toJson() => _$PromiseToJson(this);

  _$PromiseToJson(Promise instance) => <String, dynamic>{
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt?.toIso8601String(),
      'dueDate': instance.dueDate?.toIso8601String(),
      'content': instance.content,
      'to': instance.to
    };

  @override
  BaseAuditModel Function(Map<String, dynamic> p1) fromJsonMethod() {
    return Promise.fromJson;
  }
}