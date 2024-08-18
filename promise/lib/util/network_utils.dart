import 'dart:async';

// import 'package:connectivity/connectivity.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';

/// Network connectivity utils.
///
/// To obtain instance use serviceLocator.get<NetworkUtils>()
class NetworkUtils {
  final Connectivity _connectivity;

  NetworkUtils(this._connectivity);

  Stream<List<ConnectivityResult>> get connectionUpdates =>
      _connectivity.onConnectivityChanged;

  Future<List<ConnectivityResult>> getConnectivityResult() =>
      _connectivity.checkConnectivity();

  /// There is no guarantee that the user has network connection
  /// it only returns true if the device is connected with wi-fi or mobile data
  Future<bool> isConnected() async {
    var result = await _connectivity.checkConnectivity();
    return result.isNotEmpty;
  }
}


// Request applyHeader(Request request, String headerKey, String headerValue, [bool override = true]){
//   if(override){
//     request.headers.update(headerKey, (value) => headerValue);
//   }
//   request.headers.putIfAbsent(headerKey, () => headerValue);

//   return request;
// }


RequestOptions applyHeader(RequestOptions request, String headerKey, String headerValue, [bool override = true]){
  // if(override){
  //   request.headers.update(headerKey, (value) => headerValue);
  // }
  request.headers.putIfAbsent(headerKey, () => headerValue);

  return request;
}