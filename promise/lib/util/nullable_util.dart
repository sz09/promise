extension NullSafeFuture<T> on Future<T?> {
  Future<T> asNonNullable() => then((value) => value!);
}

extension NullSafeStream<T> on Stream<T?> {
  Stream<T> ignoreNullItems() =>
      where((item) => item != null).map((item) => item!);
}
