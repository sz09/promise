import 'package:promise/models/base/base.model.dart';

class Memory extends BaseAuditModel {
  late String description;
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