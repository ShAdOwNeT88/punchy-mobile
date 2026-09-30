import 'package:punchy/core/network/api_client.dart';
import 'package:punchy/core/session/session.dart';
import 'package:punchy/features/auth/models/auth_failure.dart';
import 'package:punchy/features/auth/services/auth_service.dart';

/// `POST auth/login` → `{ "token": "...", "user": { ... } }`
class HttpAuthService implements AuthService {
  HttpAuthService(this._client);

  final ApiClient _client;

  @override
  Future<Session> login({
    required String email,
    required String password,
  }) async {
    try {
      final body = await _client.post('auth/login', {
        'email': email,
        'password': password,
      });
      if (body is! Map<String, Object?>) {
        throw const AuthException(AuthFailureReason.unknown);
      }
      return Session.fromJson(body);
    } on ApiException catch (e) {
      throw AuthException(
        e.isUnauthorized
            ? AuthFailureReason.invalidCredentials
            : AuthFailureReason.unknown,
      );
    } on NetworkException {
      throw const AuthException(AuthFailureReason.network);
    } on FormatException {
      throw const AuthException(AuthFailureReason.unknown);
    }
  }
}
