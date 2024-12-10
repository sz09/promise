
import 'dart:convert';

T? _jsonTryGet<T, T1>(Map<String, dynamic> json, String key,
    {T Function(T1)? func}) {
  if (json.containsKey(key)) {
    if (func != null) {
      final value = json[key];
      if(value != null){
        return func(value);
      }
      return null;
    }
    
    return json[key] as T?;
  }

  return null;
}

extension ConvertMap on Object {
  toJson(){
    final endcoded = jsonEncode(this);
    final decoded = jsonDecode(endcoded);
    return decoded;
  }
}


extension JsonExtensions on Map<String, dynamic> {
  T? tryGet<T>(String key) {
      return _jsonTryGet<T, String>(this, key);
    }
    
  T? tryGetCast<T, T1>({required String key, required T Function(T1) func}) {
      return _jsonTryGet<T, T1>(this, key, func: func);
    }
}