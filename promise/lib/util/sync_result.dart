
class SyncResult<T> {

  List<T> _data =  List<T>.empty();
  late BigInt _version = BigInt.zero;
  late BigInt _lastVersion = BigInt.zero;
  late T Function(Map<String, dynamic>) _itemFactoryMethod;
  late Map<String, dynamic> _response;
  set resolveItem (T Function(Map<String, dynamic>) itemFactoryMethod) {
    this._itemFactoryMethod = itemFactoryMethod;
  }

  set response (Map<String, dynamic> response) {
    this._response = response;
  }

  BigInt get version => _version;
  BigInt get lastVersion => _lastVersion;
  List<T> get data => _data;
  void create() {
    List<T> result = [];
    if(_response['data'] is List<dynamic>){
      final data = _response['data'] as List<dynamic>;
      if(data.isNotEmpty){
        result = data.map((e){
          final item = e as Map<String, dynamic>;
          final a = _itemFactoryMethod(item);
         return a;
        }).toList();
      }
    }
    else if (_response['data'] is List<Map<String, dynamic>>){
      final data = _response['data'] as List<Map<String, dynamic>>;
      if(data.isNotEmpty){
        result = data.map((e) => _itemFactoryMethod(e)).toList();
      }
    }
    var version = BigInt.from(_response['version']);
    var lastVersion = BigInt.from(_response['lastVersion']);

    this._data = result;
    this._version = version;
    this._lastVersion = lastVersion;
  }

  SyncResult.defaultValue() {
    this._data = [];
    this._version = BigInt.zero;
  }
  
  SyncResult.set(this._data, this._version);
}

class SyncDataItemResult {
  final String tableName;
  final bool isContinue;
  late bool isSynced = false;
  SyncDataItemResult({required this.tableName, required this.isContinue});
}