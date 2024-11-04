T? _jsonTryGet<T, T1>(Map<String, dynamic> json, String key,
    {T Function(T1)? func}) {
  if (json.containsKey(key)) {
    if (func != null) {
      final value = json[key];
      return func(value);
    }
    return json[key] as T?;
  }

  return null;
}


extension JsonExtensions on Map<String, dynamic> {
  T? tryGet<T>(String key,
    {T Function(String)? func}) {
      return _jsonTryGet<T, String>(this, key, func: func);
    }
    
  T? tryGetCast<T, T1>(String key,
    {T Function(T1)? func}) {
      return _jsonTryGet<T, T1>(this, key, func: func);
    }
}