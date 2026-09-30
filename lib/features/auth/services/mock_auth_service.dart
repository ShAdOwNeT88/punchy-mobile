import 'package:punchy/core/session/session.dart';
import 'package:punchy/features/auth/models/auth_failure.dart';
import 'package:punchy/features/auth/services/auth_service.dart';

/// Stand-in for the backend until it exists.
///
/// Accepts any email and password, except [rejectedPassword], which simulates
/// wrong credentials. The user's name is derived from the email
/// (`mario.rossi@…` → Mario Rossi).
class MockAuthService implements AuthService {
  MockAuthService({this.latency = const Duration(milliseconds: 900)});

  final Duration latency;

  static const rejectedPassword = 'sbagliata';

  @override
  Future<Session> login({
    required String email,
    required String password,
  }) async {
    await Future<void>.delayed(latency);
    if (password == rejectedPassword) {
      throw const AuthException(AuthFailureReason.invalidCredentials);
    }
    final parts = email
        .split('@')
        .first
        .split(RegExp(r'[._\-]'))
        .where((p) => p.isNotEmpty)
        .map(_capitalize)
        .toList();
    return Session.fromJson({
      'token': 'mock-token-${email.hashCode}',
      'user': {
        'id': 'mock-user',
        'email': email,
        'firstName': parts.isNotEmpty ? parts.first : '',
        'lastName': parts.length > 1 ? parts.sublist(1).join(' ') : '',
      },
    });
  }

  static String _capitalize(String s) =>
      s[0].toUpperCase() + s.substring(1).toLowerCase();
}
