import 'package:hive/hive.dart';
import 'package:promise/models/base/base.model.dart';
import 'package:promise/models/hive_type_model.const.dart';
import 'package:promise/util/json_ext.dart';
import 'package:promise/util/reflectable.hive.dart';
part 'system-version.model.g.dart'; 

@HiveType(typeId: SystemVersionHypeType)
@hiveTypeReflector
class SystemVersion extends BaseModel {
  @HiveField(2)
  late Map<String, BigInt> versions;
  @HiveField(3)
  //TODO: https://chatgpt.com/c/6729d251-dd08-8007-b75f-d165a1c23c81
  late Map<String, int> modelVersions = {}; 
  SystemVersion({required String id, required String userId, required this.versions}){
    this.id = id;
    this.userId = userId;
  }

  
  factory SystemVersion.fromJson(Map<String, dynamic> json) {
    return SystemVersion(
      id: (json['id'] ?? '') as String,
      userId: (json['userId'] ?? '') as String,
      versions: json.tryGet<Map<String, BigInt>>('versions') ?? {}
    );
  }

}