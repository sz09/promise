import 'package:hive/hive.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:promise/models/base/base.model.dart';
import 'package:promise/models/hive_type_model.const.dart';
import 'package:promise/util/date_time_util.dart';
import 'package:promise/util/json_ext.dart';
import 'package:promise/util/reflectable.hive.dart';
part 'person.g.dart';

@HiveType(typeId: PersonHiveType)
@JsonSerializable()
@hiveTypeReflector
class Person extends BaseAuditModel {
  @override
  BaseAuditModel Function(Map<String, dynamic> p1) fromJsonMethod() {
    return Person.fromJson;
  }

  @HiveField(5)
  final String nickname;

  Person({required String id, required this.nickname}) {
    this.id = id;
  }

  factory Person.fromJson(Map<String, dynamic> json) {
    var person = Person(
      id: (json['id'] ?? '') as String,
      nickname: (json['nickname'] ?? '') as String
    );
    person.createdAt = json.tryGet<DateTime?>('createdAt', func: DateTime.tryParse) ?? DateTimeConst.min;
    // person.updatedAt = json.tryGet<DateTime?>('updatedAt', func: DateTime.tryParse) ?? DateTimeConst.min; 
    return person;
  }
}