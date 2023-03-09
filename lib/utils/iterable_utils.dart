extension IterableUtils<T> on Iterable<T> {
  /// Separates the current elements of this [Iterable] with [separator].
  Iterable<T> separate(T separator) {
    int index = 0;
    return expand((element) => [element, if (++index != length) separator]);
  }
}
