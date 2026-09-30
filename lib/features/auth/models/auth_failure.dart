enum AuthFailureReason { invalidCredentials, network, unknown }

/// Raised by the auth service when a login attempt fails.
final class AuthException implements Exception {
  const AuthException(this.reason);

  final AuthFailureReason reason;

  @override
  String toString() => 'AuthException($reason)';
}
