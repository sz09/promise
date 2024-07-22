class LocalDbConnectionException implements Exception {
  final String? message;
  final Type? type;

  LocalDbConnectionException([this.message, this.type]);
  static LocalDbConnectionException create(Type type, {exception}) {
    return LocalDbConnectionException('Can not access local db connection!: {$exception}', type);
  }

  @override
  String toString() {
    return 'LocalDbConnectionException{message: $message}';
  }
}


class RemoteDbConnectionException implements Exception {
  final String? message;
  final Type? type;

  RemoteDbConnectionException([this.message, this.type]);

  static RemoteDbConnectionException create(Type type, {exception}) {
    return RemoteDbConnectionException('Can not establish connection!: {$exception}', type);
  }

  @override
  String toString() {
    return 'RemoteDbConnectionException{message: $message}';
  }
}