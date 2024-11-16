import 'package:hive/hive.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:promise/models/base/base.model.dart';
import 'package:promise/models/hive_type_model.const.dart';
import 'package:promise/util/invalid_operation_exception.dart';
import 'package:promise/util/json_ext.dart';
import 'package:promise/util/reflectable.hive.dart';
part 'reminder.g.dart';

@HiveType(typeId: ReminderHiveType)
@JsonSerializable()
@hiveTypeReflector
class Reminder extends BaseAuditModel {
  
  @HiveField(5)
  late String notiicationDetails;
  
  @HiveField(6)
  late String notiicationContent;
  
  @HiveField(7)
  late String expression;

  Reminder({required this.notiicationContent, required this.notiicationDetails, required this.expression});
  @override
  BaseAuditModel Function(Map<String, dynamic> p1) fromJsonMethod() {
    return Reminder.fromJson;
  }

  
  factory Reminder.fromJson(dynamic input){
    switch(input) {
      case Reminder reminder:
        return reminder;
      case Map<String, dynamic> json:
        return Reminder(
          notiicationContent:  (json['notiicationContent'] ?? '') as String, 
          notiicationDetails: (json['notiicationDetails'] ?? '') as String, 
          expression: (json['expression'] ?? '') as String
        )
          ..id = (json['id'] ?? '') as String
         ..isDeleted = json.tryGet<bool>('isDeleted') ?? false
         ..createdAt = json.tryGetCast<DateTime, String>(key: 'createdAt',  func: (s) => DateTime.parse(s)) ?? DateTime.now()
         ..userId = json.tryGet('userId') ?? '';
      default:
        throw InvalidOperationException();
    }
  }
}