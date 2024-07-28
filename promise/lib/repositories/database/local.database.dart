import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';
import 'package:promise/util/log/log.dart';
import 'package:promise/util/reflectable.hive.dart';
import 'package:promise/util/string_util.dart';
import 'package:reflectable/reflectable.dart';

class LocalDatabaseWrapper {

  final String _databaseName = "Promise";
  init(Set<String> tableNames) async {
    final directory = await getApplicationDocumentsDirectory();
    await BoxCollection.open(
      _databaseName, // Name of your database
      tableNames, // Names of your boxes
      path: directory.path, // Path where to store your boxes (Only used in Flutter / Dart IO)
     );
  }

  LocalDatabase<T> getLocalDatabase<T>() {
    return LocalDatabase<T>();
  }
}
class LocalDatabase<T> extends TypeAdapter<T>{
  late int _typeId;
  LocalDatabase() {
    var itemMirror = hiveTypeReflector.reflectType(T) as ClassMirror;
    var hiveTypeAnnotation = itemMirror.metadata
      .firstWhere((metadata) => metadata is HiveType) as HiveType;
    _typeId = hiveTypeAnnotation.typeId;
  }
  Future<Box<T>> getBoxAsync() async {
    return Hive.openBox<T>((T).toPlural());
  }
  
  @override
  T read(BinaryReader reader) {
    return null as T;
  }
  
  @override
  int get typeId => _typeId;
  
  @override
  void write(BinaryWriter writer, T obj) {
    // TODO: implement write
  }
}