import 'package:hive/hive.dart';
import 'package:reflectable/reflectable.dart';

abstract class BaseModel extends Reflectable{
  @HiveField(0)
  late String id;
  @HiveField(1)
  late String userId;
}

abstract class BaseAuditModel extends BaseModel {
  @HiveField(3)
  late DateTime createdAt;

  @HiveField(4)
  late DateTime? updatedAt;
  BaseAuditModel Function(Map<String, dynamic>) fromJsonMethod();
}

