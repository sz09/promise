import 'package:dio/dio.dart';
  import 'dart:convert';

class JsonResponseConverter extends Interceptor {
  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    response.data = json.encode(response.data);
    super.onResponse(response, handler);
  }
}

T createInstanceFromJson<T>(String jsonString, T Function(Map<String, dynamic>) factoryMethod) {
  // Decode JSON string to Map
  Map<String, dynamic> jsonMap = jsonDecode(jsonString);

  // Use the factory method to create an instance from JSON map
  return factoryMethod(jsonMap);
}

List<T> createInstancesFromJson<T>(String jsonString, T Function(Map<String, dynamic>) factoryMethod) {
  // Decode JSON string to Map
  List<Map<String, dynamic>> jsonMap = jsonDecode(jsonString);

  // Use the factory method to create an instance from JSON map
  return jsonMap.map((d) => factoryMethod(d)).toList();
}