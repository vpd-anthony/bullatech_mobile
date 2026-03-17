/// Helper: Extracts user-friendly error message from any error
String getErrorMessage(final Object e) {
  if (e is Exception) {
    return e.toString().replaceFirst('Exception: ', '');
  }
  return 'An unexpected error occurred';
}
