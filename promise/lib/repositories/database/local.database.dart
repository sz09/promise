import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';
import 'package:promise/util/string_util.dart';

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
class LocalDatabase<T>{
  LocalDatabase() {}

  // Use for change model types, clean and sync from begin
  // Must have model version on both client and server
  Future clearBoxOnDiskAsync() async{
    await Hive.deleteBoxFromDisk(boxName);
  }

  Future<Box<T>> getBoxAsync() async {
    if(!Hive.isBoxOpen(boxName)){
      return await Hive.openBox<T>(boxName);
    }

    return Hive.box(boxName);
  }

  String get boxName {
    return (T).toPlural();
  }
}