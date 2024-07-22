import 'dart:io';

class HttpExceptionCode extends HttpException {
  final int? statusCode;
  final dynamic errorResponse;

  HttpExceptionCode(
    super.message, {
    super.uri,
    required this.statusCode,
    this.errorResponse = 'no error response',
  });

  @override
  String toString() {
    return 'HttpExceptionCode{'
        'message: $message, '
        'uri: $uri, '
        'statusCode: $statusCode, '
        'errorResponse: $errorResponse}';
  }
}
