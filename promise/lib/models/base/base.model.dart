import 'package:reflectable/reflectable.dart';

abstract class BaseModel extends Reflectable{
  late String id;
  late String userId;
}

abstract class BaseAuditModel extends BaseModel {
  late DateTime createdAt;
  late DateTime? updatedAt;
  BaseAuditModel Function(Map<String, dynamic>) fromJsonMethod();
}

