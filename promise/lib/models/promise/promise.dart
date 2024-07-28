import 'package:hive/hive.dart';
import 'package:promise/models/base/base.model.dart';
import 'package:promise/util/reflectable.hive.dart';
part 'promise.g.dart'; 

@HiveType(typeId: 0)
@hiveTypeReflector
class Promise extends BaseAuditModel {
  @HiveField(5)
  late String description;
  @HiveField(6)
  late DateTime? dueDate;
  late String? toWho;
  Promise({required String id, required this.description, this.toWho = null}) {
    this.id = id;
  }
  
  factory Promise.fromJson(Map<String, dynamic> json) {
    return Promise(
      id: (json['id'] ?? '') as String,
      description: (json['description'] ?? '') as String
    );
  }
  
  @override
  BaseAuditModel Function(Map<String, dynamic> p1) fromJsonMethod() {
    return Promise.fromJson;
  }
}