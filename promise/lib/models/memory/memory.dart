import 'package:hive/hive.dart';
import 'package:promise/models/base/base.model.dart';
import 'package:promise/util/reflectable.hive.dart';
part 'memory.g.dart';

@HiveType(typeId: 1)
@hiveTypeReflector
class Memory extends BaseAuditModel {
  @HiveField(5)
  late String description;
  @HiveField(6)
  late DateTime? dueDate;
  Memory({required String id, required this.description}) {
    this.id = id;
  }
  
  factory Memory.fromJson(Map<String, dynamic> json) {
    return Memory(
      id: (json['id'] ?? '') as String,
      description: (json['description'] ?? '') as String
    );
  }
  
  @override
  BaseAuditModel Function(Map<String, dynamic> p1) fromJsonMethod() {
    return Memory.fromJson;
  }
}