import 'package:flutter/material.dart';
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
  late String? email;
  @HiveField(6)
  late String firstName;
  @HiveField(7)
  late String lastName;
  @HiveField(8)
  late List<UserReference> references;
  @HiveField(9)
  late String nickname;
  @HiveField(10)
  late String color;

  Person({required String id, required  String userId, required this.email, required this.firstName, required this.lastName, required this.references, required this.color, required this.nickname}) {
    this.id = id;
    this.userId = userId;
  }

  factory Person.fromJson(Map<String, dynamic> json) {
    var person = Person(
      id: (json['id'] ?? '') as String,
      userId: json.tryGet('userId') ?? '',
      email: json.tryGet<String>('email'),
      firstName: json.tryGet<String>('firstName') ?? "",
      lastName: json.tryGet<String>('lastName') ?? "",
      references: json.tryGetCast<List<Map<String, dynamic>>, List<dynamic>>(key: "references", func: (x) {
        return x.map((d) => d as Map<String, dynamic>).toList();
      })?.map((d) => UserReference.fromJson(d)).toList() ?? [],
      nickname: json.tryGet<String>('nickname') ?? "",
      color: json.tryGet<String>('nickname') ?? "",
    );
    person.createdAt = json.tryGetCast<DateTime?, String>(key: 'createdAt', func: DateTime.tryParse) ?? DateTimeConst.min;
    // person.updatedAt = json.tryGet<DateTime?>('updatedAt', func: DateTime.tryParse) ?? DateTimeConst.min; 
    return person;
  }
}

@HiveType(typeId: UserReferenceHiveType)
@hiveTypeReflector
class UserReference {
  UserReference({required this.referenceUserId, required this.hint, required this.color} );
  factory UserReference.fromJson(Map<String, dynamic> json) {
    return UserReference(
      referenceUserId: json.tryGet("referenceUserId") ?? "",
      hint: json.tryGet("hint") ?? "",
      color: ViewColor.fromJson(json.tryGet("color"))
    );
  }
  @HiveField(0)
  late String referenceUserId;
  @HiveField(1)
  late String hint;
  @HiveField(2)
  // @HiveField(2, defaultValue: ViewColor(a: 0, r: 0, g: 0, b: 0))
  late ViewColor color;

  String get value => referenceUserId;
}

@HiveType(typeId: ColorHiveType)
@hiveTypeReflector
class ViewColor {
  
  ViewColor({required this.a, required this.r, required this.g, required this.b} );
  factory ViewColor.fromJson(Map<String, dynamic>? json) {
    if(json == null){
      var defaultColor = Colors.blueAccent.withOpacity(0.2);
      return ViewColor(a: defaultColor.alpha, r: defaultColor.red, g: defaultColor.green, b: defaultColor.blue);
    }

    return ViewColor(
      a:  json.tryGet<int>("a") ?? 0,
      r:  json.tryGet<int>("r") ?? 0,
      g:  json.tryGet<int>("g") ?? 0,
      b:  json.tryGet<int>("b") ?? 0
    );
  }
  @HiveField(0)
  late int a;
  @HiveField(1)
  late int r;
  @HiveField(2)
  late int g;
  @HiveField(3)
  late int b;
}