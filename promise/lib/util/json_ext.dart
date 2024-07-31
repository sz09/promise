T? jsonTryGet<T>(Map<String, dynamic> json, String key,
    {T Function(String)? func}) {
  if (json.containsKey(key)) {
    if (func != null) {
      return func(json[key]);
    }
    return json[key] as T?;
  }

  return null;
}


extension JsonExtensions on Map<String, dynamic> {
  T? tryGet<T>(String key,
    {T Function(String)? func}) {
      return jsonTryGet<T>(this, key, func: func);
    }
}