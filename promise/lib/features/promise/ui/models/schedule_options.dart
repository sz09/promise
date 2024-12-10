import 'package:hive/hive.dart';
import 'package:promise/models/hive_type_model.const.dart';
import 'package:promise/util/reflectable.hive.dart';
part 'schedule_options.g.dart';
@HiveType(typeId: ScheduleTypeHiveType)
@hiveTypeReflector
enum ScheduleType {
  @HiveField(0)
  Range,
  @HiveField(1)
  WorkingDays
}

class ScheduleOption {
    final String  text;
    final ScheduleType value;
    ScheduleOption({required this.text, required this.value});
}