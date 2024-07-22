class InvalidOperationException implements Exception {

  final String? message;
  InvalidOperationException([this.message]);

  @override
  String toString() {
    return 'InvalidOperationException{message: $message}';
  }
}