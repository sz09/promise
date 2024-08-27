import 'package:hive/hive.dart';
import 'package:promise/models/base/base.model.dart';
import 'package:promise/models/hive_type_model.const.dart';
import 'package:promise/util/date_time_util.dart';
import 'package:promise/util/json_ext.dart';
import 'package:promise/util/reflectable.hive.dart';
part 'memory.g.dart';

@HiveType(typeId: MemoryHiveType)
@hiveTypeReflector
class Memory extends BaseAuditModel {
  @HiveField(5)
  late String description;
  Memory({required String id, required this.description}) {
    this.id = id;
  }
  
  factory Memory.fromJson(Map<String, dynamic> json) {
    var memory =  Memory(
      id: (json['id'] ?? '') as String,
      description: (json['description'] ?? '') as String
    );
    memory.createdAt = json.tryGet<DateTime?>('createdAt', func: DateTime.tryParse) ?? DateTimeConst.min;
    memory.updatedAt = json.tryGet<DateTime?>('updatedAt', func: DateTime.tryParse); 
    return memory;
  }
  
  @override
  BaseAuditModel Function(Map<String, dynamic> p1) fromJsonMethod() {
    return Memory.fromJson;
  }
}