
class SyncResult<T> {

  List<T> _data =  List<T>.empty();
  late int _version = 0;
  late int _lastVersion = 0;
  late T Function(Map<String, dynamic>) _itemFactoryMethod;
  late Map<String, dynamic> _response;
  set resolveItem (T Function(Map<String, dynamic>) itemFactoryMethod) {
    this._itemFactoryMethod = itemFactoryMethod;
  }

  set response (Map<String, dynamic> response) {
    this._response = response;
  }

  int get version => _version;
  int get lastVersion => _lastVersion;
  List<T> get data => _data;
  void create() {
    List<T> result = [];
    final data = _response['data'] as List<dynamic>;
    if(data.isNotEmpty){
      result = data.map((e) => _itemFactoryMethod(e)).toList();
    }
    var version = _response['version'] as int;
    var lastVersion = _response['lastVersion'] as int;

    this._data = result;
    this._version = version;
    this._lastVersion = lastVersion;
  }

  SyncResult.defaultValue() {
    this._data = [];
    this._version = 0;
  }
  
  SyncResult.set(this._data, this._version);
}

class SyncDataItemResult {
  final String tableName;
  final bool isContinue;
  late bool isSynced = false;
  SyncDataItemResult({required this.tableName, required this.isContinue});
}