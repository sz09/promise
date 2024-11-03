
import 'package:hive/hive.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:promise/models/base/base.model.dart';
import 'package:promise/models/hive_type_model.const.dart';
import 'package:promise/util/json_ext.dart';
import 'package:promise/util/reflectable.hive.dart';

@HiveType(typeId: UserHypeType)
@JsonSerializable()
@hiveTypeReflector
class User extends BaseAuditModel {
  @HiveField(5)
  late String email;
  @HiveField(6)
  late String firstName;
  @HiveField(7)
  late String lastName;
  @HiveField(8)
  late List<String> references;
  User({required String id, required this.email, required this.firstName, required this.lastName});
  
  @override
  BaseAuditModel Function(Map<String, dynamic> p1) fromJsonMethod() => User.fromJson;

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: (json['id'] ?? '') as String,
      email: (json['email'] ?? '') as String,
      firstName: json.tryGet<String>('firstName') ?? 
    );
  }
}