import 'package:hive/hive.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:promise/features/promise/ui/models/schedule_options.dart';
import 'package:promise/models/base/base.model.dart';
import 'package:promise/models/hive_type_model.const.dart';
import 'package:promise/models/reminders/reminder.dart';
import 'package:promise/util/invalid_operation_exception.dart';
import 'package:promise/util/json_ext.dart';
import 'package:promise/util/reflectable.hive.dart';
part 'work.d.dart';

@HiveType(typeId: WorkHiveType)
@JsonSerializable()
@hiveTypeReflector
class Work extends BaseAuditModel {
  @HiveField(5)
  late String content;
  
  @HiveField(6)
  late DateTime? from;

  @HiveField(7)
  late DateTime? to;

  @HiveField(8)
  late Reminder? reminder;

  @HiveField(9)
  late ScheduleType scheduleType;

  Work({required this.content, required this.from, required this.to,  required this.scheduleType, required this.reminder});

  @override
  BaseAuditModel Function(Map<String, dynamic> p1) fromJsonMethod() {
    return Work.fromJson;
  } 


  factory Work.fromJson(dynamic input){
    switch(input){
      case Map<String, dynamic> json:
        return Work(
          content:  (json['content'] ?? '') as String, 
          from: json.tryGetCast<DateTime, String>(key: 'from',  func: (s) => DateTime.parse(s)), 
          to: json.tryGetCast<DateTime, String>(key: 'to',  func: (s) => DateTime.parse(s)),
          scheduleType: json.tryGetCast<ScheduleType, int>(key: "scheduleType", func: (i) => ScheduleType.values[i]) ?? ScheduleType.WeekDays,
          reminder: Reminder.fromJson(json['reminder']) 
        )
        ..id = (json['id'] ?? '') as String
         ..isDeleted = json.tryGet<bool>('isDeleted') ?? false
         ..createdAt = json.tryGetCast<DateTime, String>(key: 'createdAt',  func: (s) => DateTime.parse(s)) ?? DateTime.now()
         ..userId = json.tryGet('userId') ?? '';
      case Work progression:
        return progression;
      default:
        throw InvalidOperationException();
    }

  }
}