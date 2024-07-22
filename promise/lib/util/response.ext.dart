import 'package:promise/models/memory/memory.dart';

class PageResult<T> {

  List<T> _data =  List<T>.empty();
  late int _total = 0;
  late T Function(Map<String, dynamic>) _itemFactoryMethod;
  late Map<String, dynamic> _response;
  set resolveItem (T Function(Map<String, dynamic>) itemFactoryMethod) {
    this._itemFactoryMethod = itemFactoryMethod;
  }

  set response (Map<String, dynamic> response) {
    this._response = response;
  }

  int get total => _total;
  List<T> get data => _data;
  void create() {
    List<T> result = [];
    final data = _response['data'] as List<dynamic>;
    if(data.isNotEmpty){
      result = data.map((e) => _itemFactoryMethod(e)).toList();
    }
    var total = _response['total'] as int;

    this._data = result;
    this._total = total;
  }

  PageResult.defaultValue() {
    this._data = [];
    this._total = 0;
  }
  PageResult.set(this._data, this._total);
}

extension DynamicCreateInstance on Type {
  T Function(Map<String, dynamic>) getFactoryMethod<T>() {
    var runtimeType = (T).toString();
    switch(runtimeType) {
      case "BaseAuditModel": 
        return Memory.fromJson as T Function(Map<String, dynamic>);
      default: 
        throw Exception("Not implement exception");
    }
  }
}