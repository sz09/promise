import 'package:promise/models/base/base.model.dart';

class Promise extends BaseAuditModel {
  late String description;
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