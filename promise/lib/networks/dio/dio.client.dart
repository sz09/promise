import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:promise/util/response.ext.dart';
import 'package:promise/util/sync_result.dart';

abstract class DioClient {
  late Dio _dio;
  @protected
  set client(Dio dio) {
    _dio = dio;
  }
  Future<Response<T>> post<T>(String path, Object? data, T Function(Map<String, dynamic>) factoryMethod) async {
    var response = await _dio.post(path, data: data);
    return _convert(response, factoryMethod);
  }

  Future<Response<T>> put<T>(String path, Object? data) {
    return _dio.put<T>(path, data: data);
  }

  Future<Response<PageResult<T>>> fetch<T>(String path, Object? data, 
      dynamic factoryMethod) async {
    var response = await _dio.get(path, data: data);
    return _convertResult(response: response, factoryMethod: factoryMethod);
  }


  Future<Response<SyncResult<T>>> fetchSync<T>(String path, Object? data, 
      dynamic factoryMethod) async {
    return _dio.get(path, data: data)
    .then((response) => _convertResult(response: response, factoryMethod: factoryMethod), 
    onError: (e) => {

    });
  }
  Future<Response<T>> get<T>(String path, Object? data) {
    return _dio.get<T>(path, data: data);
  } 

  Future<Response<T>> delete<T>(String path, Object? data) {
    return _dio.delete<T>(path, data: data);
  }

  Response<T> _convert<T>(Response<dynamic> response,  T Function(Map<String, dynamic>) factoryMethod) {
    final castData = factoryMethod(response.data);
    return Response(
      requestOptions: response.requestOptions, 
      data: castData,
      statusCode: response.statusCode,
      statusMessage: response.statusMessage,
      isRedirect: response.isRedirect,
      extra: response.extra,
      headers: response.headers
    );
  }


  Response<TResponse> _convertResult<TResponse, TItem>(
      { 
        required Response<dynamic> response, 
        required dynamic factoryMethod
      }) {
    final castData = factoryMethod(response);
    return Response(
      requestOptions: response.requestOptions, 
      data: castData,
      statusCode: response.statusCode,
      statusMessage: response.statusMessage,
      isRedirect: response.isRedirect,
      extra: response.extra,
      headers: response.headers
    );
  }
}