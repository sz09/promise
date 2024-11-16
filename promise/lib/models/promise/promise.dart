import 'package:hive/hive.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:promise/models/base/base.model.dart';
import 'package:promise/models/hive_type_model.const.dart';
import 'package:promise/util/invalid_operation_exception.dart';
import 'package:promise/util/json_ext.dart';
import 'package:promise/util/reflectable.hive.dart';
part 'promise.g.dart'; 

@HiveType(typeId: PromiseHiveType)
@JsonSerializable()
@hiveTypeReflector
class Promise extends BaseAuditModel {
  @HiveField(5)
  final String content;
  @HiveField(6)
  final DateTime? expectedTime;
  
  @HiveField(7)
  final List<String>? to;

  @HiveField(8)
  final bool forYourself;
  
  Promise({required this.content, this.expectedTime = null, this.to = null, this.forYourself = false}) {}
  
  factory Promise.create({required String content, required bool forYourself, List<String>? to = null, DateTime? expectedTime = null}) {
    return Promise(content: content, expectedTime: expectedTime, forYourself:  forYourself, to: to) 
    ..id = ''
    ..createdAt = DateTime.now()
    ..isDeleted = false
    ..updatedAt = null;
  }
  
  factory Promise.modify({required String id, required String userId, required String content, required bool forYourself, List<String>? to = null, DateTime? expectedTime = null}) {
    return Promise(content: content, expectedTime: expectedTime, forYourself:  forYourself, to: to)
          ..id = id
          ..userId = userId
          ..createdAt = DateTime.now()
          ..isDeleted = false
          ..updatedAt = null;
  }

  factory Promise.fromJson(dynamic input) {
    switch(input){
      case Map<String, dynamic> json:
        return Promise(
          content: (json['content'] ?? '') as String,
          to: json.tryGetCast<List<String>, List>(key: 'to', func: (list) {
              if(list.isNotEmpty) {
                return list.cast<String>();
              }
              return [];
          } ),
          expectedTime: json.tryGetCast<DateTime, String>(key: 'expectedTime',  func: (s) => DateTime.parse(s)),
          forYourself: json.tryGet<bool>('forYourself') ?? false,
        )..id = (json['id'] ?? '') as String
         ..isDeleted = json.tryGet<bool>('isDeleted') ?? false
         ..createdAt = json.tryGetCast<DateTime, String>(key: 'createdAt',  func: (s) => DateTime.parse(s)) ?? DateTime.now()
         ..userId = json.tryGet('userId') ?? '';
      case Promise promise:
        return promise;
      default:
        throw InvalidOperationException();
    }
  }


  Map<String, dynamic> toJson() => _$PromiseToJson(this);

  _$PromiseToJson(Promise instance) => <String, dynamic>{
      'id': instance.id,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt?.toIso8601String(),
      'dueDate': instance.expectedTime?.toIso8601String(),
      'content': instance.content,
      'isDeleted': instance.isDeleted,
      'to': instance.to,
      'forYourself': instance.forYourself
    };

  @override
  BaseAuditModel Function(Map<String, dynamic> p1) fromJsonMethod() {
    return Promise.fromJson;
  }
}