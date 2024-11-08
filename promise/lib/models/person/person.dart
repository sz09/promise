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

  Person({required String id, required  String userId, required this.email, required this.firstName, required this.lastName, required this.references, required this.nickname}) {
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
    );
    person.createdAt = json.tryGetCast<DateTime?, String>(key: 'createdAt', func: DateTime.tryParse) ?? DateTimeConst.min;
    // person.updatedAt = json.tryGet<DateTime?>('updatedAt', func: DateTime.tryParse) ?? DateTimeConst.min; 
    return person;
  }
}

@HiveType(typeId: UserReferenceHiveType)
@hiveTypeReflector
class UserReference {
  UserReference({required this.referenceUserId, required this.hint} );
  factory UserReference.fromJson(Map<String, dynamic> json) {
    return UserReference(
      referenceUserId: json.tryGet("referenceUserId") ?? "",
      hint: json.tryGet("hint") ?? ""
    );
  }
  @HiveField(0)
  late String referenceUserId;
  @HiveField(1)
  late String hint;
}