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

