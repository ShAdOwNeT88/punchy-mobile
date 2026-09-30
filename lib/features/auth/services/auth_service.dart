import 'package:punchy/core/session/session.dart';

/// Authenticates a user against the backend.
///
/// Throws [AuthException] (see `models/auth_failure.dart`) on failure.
abstract interface class AuthService {
  Future<Session> login({required String email, required String password});
}
