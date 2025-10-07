class ProviderException implements Exception {
  ProviderException(this.cause);

  final Exception cause;

  @override
  String toString() => 'ProviderException: ${cause.toString()}';
}
