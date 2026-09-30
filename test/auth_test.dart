import 'package:flutter_test/flutter_test.dart';
import 'package:punchy/core/services/session_store.dart';
import 'package:punchy/core/session/session_controller.dart';
import 'package:punchy/features/auth/repository/auth_repository.dart';
import 'package:punchy/features/auth/services/mock_auth_service.dart';
import 'package:punchy/features/auth/view_model/login_view_model.dart';

void main() {
  late SessionController session;
  late LoginViewModel vm;

  setUp(() {
    session = SessionController(InMemorySessionStore());
    vm = LoginViewModel(
      AuthRepository(MockAuthService(latency: Duration.zero), session),
    );
  });

  LoginError? errorOf(LoginState s) => s is LoginFailed ? s.error : null;

  test('rejects an invalid email without calling the service', () async {
    await vm.submit(email: 'not-an-email', password: 'secret1');
    expect(errorOf(vm.state), LoginError.invalidEmail);
    expect(session.isAuthenticated, isFalse);
  });

  test('rejects a short password', () async {
    await vm.submit(email: 'a@b.it', password: '123');
    expect(errorOf(vm.state), LoginError.passwordTooShort);
  });

  test('maps wrong credentials', () async {
    await vm.submit(
      email: 'a@b.it',
      password: MockAuthService.rejectedPassword,
    );
    expect(errorOf(vm.state), LoginError.invalidCredentials);
  });

  test('starts a session on success, with the name from the email', () async {
    await vm.submit(email: ' mario.rossi@example.com ', password: 'secret1');
    expect(vm.state, isA<LoginSucceeded>());
    expect(session.current?.firstName, 'Mario');
    expect(session.current?.lastName, 'Rossi');
  });

  test('editing clears a previous error', () async {
    await vm.submit(email: 'x', password: 'secret1');
    vm.onInputChanged();
    expect(vm.state, isA<LoginIdle>());
  });

  test('toggles password visibility', () {
    expect(vm.obscurePassword, isTrue);
    vm.togglePasswordVisibility();
    expect(vm.obscurePassword, isFalse);
  });
}
