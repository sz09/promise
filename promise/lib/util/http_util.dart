// ignore_for_file: prefer_function_declarations_over_variables

import 'dart:convert';
import 'dart:io';

import 'package:package_info_plus/package_info_plus.dart';
import 'package:promise/util/log/log.dart';
import 'package:http/http.dart';

const String authHeaderKey = 'Authorization';
String authHeaderValue(String token) => 'Bearer $token';

const String cookieHeaderKey = 'Cookie';
const String cookieSetHeaderKey = 'set-cookie';
const String greetingHeaderKey = 'no-greeting';
const String versionHeaderKey = 'App-Version';

const String headerContentTypeKey = 'Content-type';
const String headerContentTypeJsonValue = 'application/json; charset=UTF-8';
const String headerContentTypeUrlEncodedWithUTF8Value =
    'application/x-www-form-urlencoded; charset=UTF-8';
const String headerContentTypeUrlEncodedValue =
    'application/x-www-form-urlencoded';

const String headerAcceptKey = 'Accept';
const String headerAcceptJsonValue = 'application/json';

final headerAppVersionValue =
    (PackageInfo packageInfo) => packageInfo.version.split('-')[0];

const MapEntry<String, String> headerContentTypeJson =
    MapEntry(headerContentTypeKey, headerContentTypeJsonValue);
const MapEntry<String, String> headerContentTypeUrlEncoded =
    MapEntry(headerContentTypeKey, headerContentTypeUrlEncodedWithUTF8Value);

const MapEntry<String, String> headerContentTypeUrlWithoutCharset =
    MapEntry(headerContentTypeKey, headerContentTypeUrlEncodedValue);
const MapEntry<String, String> headerAcceptJson =
    MapEntry(headerAcceptKey, headerAcceptJsonValue);

/// Network util class that's used for encoding data represented
/// as json type. The key/value pairs are URI encoded with
/// [Uri.encodeQueryComponent] and converted into an HTTP query string.
String encodeQueryComponents(Map<String, String> data) {
  var parts = [];
  data.forEach((key, value) {
    parts.add('${Uri.encodeQueryComponent(key)}='
        '${Uri.encodeQueryComponent(value)}');
  });
  return parts.join('&');
}

/// Parses the response in the case where an error has occurred.
/// Returns error key which is used to display appropriate error message.
///
/// Uses different error type based on the response's body which
/// is represented as a map, that can contain [errors] or [fieldErrors]
String? parseErrorResponse(Response response) {
  dynamic responseBody;
  try {
    responseBody = jsonDecode(response.body);
    String errorType =
        (responseBody.values.toList()[0].isNotEmpty) ? 'errors' : 'fieldErrors';
    return responseBody[errorType][0]['code'];
  } catch (exp) {
    Log.e(
        'Error parsing error response - error: $exp; decoded body: $responseBody');
    return null;
  }
}

Map<String, String> splitUriFragment(Uri url) {
  Map<String, String> queryPairs = <String, String>{};
  String query = url.fragment;
  List<String> pairs = query.split("&");
  for (var pair in pairs) {
    queryPairs.putIfAbsent((pair.split('='))[0], () => (pair.split('='))[1]);
  }
  return queryPairs;
}

Future<bool> checkInternetConnection() async {
  try {
    final result = await InternetAddress.lookup('example.com');
    if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
      return Future.value(true);
    }
    return Future.value(false);
  } on SocketException catch (_) {
    return Future.value(false);
  }
}
