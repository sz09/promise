
import 'package:hive/hive.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:promise/models/base/base.model.dart';
import 'package:promise/models/hive_type_model.const.dart';
import 'package:promise/models/work/work.dart';
import 'package:promise/util/invalid_operation_exception.dart';
import 'package:promise/util/json_ext.dart';
import 'package:promise/util/reflectable.hive.dart';
part 'objective.g.dart';

@HiveType(typeId: ObjectiveHiveType)
@JsonSerializable()
@hiveTypeReflector
class Objective extends BaseAuditModel {
  @HiveField(5)
  late String promiseId;
  @HiveField(6)
  late String content;
  @HiveField(7)
  late List<Work> progressions = [];
  
  Objective({required this.content, required this.promiseId}) {
    progressions = List.empty();
  }
  
  @override
  BaseAuditModel Function(Map<String, dynamic> p1) fromJsonMethod() {
    return Objective.fromJson;
  } 

  factory Objective.fromJson(dynamic input){
    switch(input){
      case Map<String, dynamic> json:
        return Objective(
          content:  (json['content'] ?? '') as String, 
          promiseId:  (json['promiseId'] ?? '') as String)
          ..id = (json['id'] ?? '') as String
         ..isDeleted = json.tryGet<bool>('isDeleted') ?? false
         ..createdAt = json.tryGetCast<DateTime, String>(key: 'createdAt',  func: (s) => DateTime.parse(s)) ?? DateTime.now()
         ..userId = json.tryGet('userId') ?? '';
      case Objective objective:
        return objective;
      default:
        throw InvalidOperationException();
    }

  }


  
  Map<String, dynamic> toJson() => _$ObjectiveToJson(this);

  _$ObjectiveToJson(Objective instance) => <String, dynamic>{
      'id': instance.id,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt?.toIso8601String(),
      'promiseId': instance.promiseId.toString(),
      'content': instance.content,
      'isDeleted': instance.isDeleted,

    };
}