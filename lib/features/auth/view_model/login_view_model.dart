import 'package:flutter/foundation.dart';
import 'package:punchy/features/auth/models/auth_failure.dart';
import 'package:punchy/features/auth/repository/auth_repository.dart';

enum LoginError {
  invalidEmail,
  passwordTooShort,
  invalidCredentials,
  network,
  unknown,
}

/// Login flow state: a feature-sealed state, since the form has an idle
/// phase that `UiState` does not model.
sealed class LoginState {
  const LoginState();
}

final class LoginIdle extends LoginState {
  const LoginIdle();
}

final class LoginSubmitting extends LoginState {
  const LoginSubmitting();
}

final class LoginFailed extends LoginState {
  const LoginFailed(this.error);

  final LoginError error;
}

final class LoginSucceeded extends LoginState {
  const LoginSucceeded();
}

class LoginViewModel extends ChangeNotifier {
  LoginViewModel(this._repository);

  final AuthRepository _repository;

  static const minPasswordLength = 6;
  static final _emailPattern = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');

  LoginState _state = const LoginIdle();
  LoginState get state => _state;

  bool _obscurePassword = true;
  bool get obscurePassword => _obscurePassword;

  void togglePasswordVisibility() {
    _obscurePassword = !_obscurePassword;
    notifyListeners();
  }

  /// Clears a previous error once the user edits the form.
  void onInputChanged() {
    if (_state is LoginFailed) _emit(const LoginIdle());
  }

  Future<void> submit({required String email, required String password}) async {
    if (_state is LoginSubmitting) return;
    final trimmedEmail = email.trim();
    if (!_emailPattern.hasMatch(trimmedEmail)) {
      return _emit(const LoginFailed(LoginError.invalidEmail));
    }
    if (password.length < minPasswordLength) {
      return _emit(const LoginFailed(LoginError.passwordTooShort));
    }

    _emit(const LoginSubmitting());
    try {
      await _repository.login(email: trimmedEmail, password: password);
      _emit(const LoginSucceeded());
    } on AuthException catch (e) {
      _emit(
        LoginFailed(switch (e.reason) {
          AuthFailureReason.invalidCredentials => LoginError.invalidCredentials,
          AuthFailureReason.network => LoginError.network,
          AuthFailureReason.unknown => LoginError.unknown,
        }),
      );
    }
  }

  void _emit(LoginState state) {
    _state = state;
    notifyListeners();
  }
}
