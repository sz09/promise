import 'package:hive/hive.dart';

abstract class BaseModel {
  @HiveField(0)
  late String id;
  @HiveField(1)
  late String userId;
}

abstract class BaseAuditModel extends BaseModel {
  @HiveField(2)
  late bool isDeleted = false;

  @HiveField(3)
  late DateTime createdAt = DateTime.now();

  @HiveField(4)
  late DateTime? updatedAt = DateTime.now();
  
  BaseAuditModel Function(Map<String, dynamic>) fromJsonMethod(); 
}

