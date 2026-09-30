import 'package:punchy/core/session/session_controller.dart';
import 'package:punchy/features/auth/services/auth_service.dart';

/// Logs in through the service and hands the resulting session to the
/// application-wide [SessionController].
class AuthRepository {
  AuthRepository(this._service, this._session);

  final AuthService _service;
  final SessionController _session;

  Future<void> login({required String email, required String password}) async {
    final session = await _service.login(email: email, password: password);
    await _session.start(session);
  }
}
