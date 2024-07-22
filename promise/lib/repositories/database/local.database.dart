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
class LocalDatabase<T> {
  LocalDatabase();
  
  Future<Box<T>> getBoxAsync() async {
    return Hive.openBox<T>((T).toPlural());
  }
}