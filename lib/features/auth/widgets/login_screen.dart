import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:punchy/core/navigation/routes.dart';
import 'package:punchy/features/auth/repository/auth_repository.dart';
import 'package:punchy/features/auth/view_model/login_view_model.dart';
import 'package:punchy/l10n/app_localizations.dart';
import 'package:punchy/shared/theme/app_colors.dart';
import 'package:punchy/shared/theme/app_dimensions.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => LoginViewModel(context.read<AuthRepository>()),
      child: const _LoginView(),
    );
  }
}

class _LoginView extends StatefulWidget {
  const _LoginView();

  @override
  State<_LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<_LoginView> {
  final _email = TextEditingController();
  final _password = TextEditingController();
  late final LoginViewModel _viewModel = context.read<LoginViewModel>();

  @override
  void initState() {
    super.initState();
    _viewModel.addListener(_onStateChanged);
  }

  @override
  void dispose() {
    _viewModel.removeListener(_onStateChanged);
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  void _onStateChanged() {
    if (_viewModel.state is LoginSucceeded && mounted) {
      Navigator.of(context).pushReplacementNamed(Routes.cards);
    }
  }

  void _submit() {
    FocusScope.of(context).unfocus();
    _viewModel.submit(email: _email.text, password: _password.text);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: AppColors.loginGradient,
          ),
        ),
        child: Stack(
          children: [
            const _Bubble(alignment: Alignment(-1.4, -1.1), diameter: 260),
            const _Bubble(alignment: Alignment(1.5, -0.35), diameter: 180),
            const _Bubble(alignment: Alignment(-1.3, 0.2), diameter: 120),
            SafeArea(
              child: Center(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(AppSpacing.xl),
                  child: Column(
                    children: [
                      const _Header(),
                      const SizedBox(height: AppSpacing.xxl),
                      _FormCard(
                        email: _email,
                        password: _password,
                        onSubmit: _submit,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header();

  static const double _logoSize = 76;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Column(
      children: [
        Container(
          width: _logoSize,
          height: _logoSize,
          decoration: BoxDecoration(
            color: AppColors.glass,
            borderRadius: BorderRadius.circular(AppRadii.lg),
            border: Border.all(color: AppColors.glassBorder),
          ),
          child: const Icon(
            Icons.style_rounded,
            color: AppColors.onDark,
            size: AppFontSize.hero + AppSpacing.xs,
          ),
        ),
        const SizedBox(height: AppSpacing.lg),
        Text(
          l10n.appTitle,
          style: const TextStyle(
            color: AppColors.onDark,
            fontSize: AppFontSize.hero,
            fontWeight: FontWeight.w800,
            letterSpacing: -0.5,
          ),
        ),
        const SizedBox(height: AppSpacing.sm),
        Text(
          l10n.loginSubtitle,
          textAlign: TextAlign.center,
          style: const TextStyle(
            color: AppColors.onDarkMuted,
            fontSize: AppFontSize.bodyLarge,
          ),
        ),
      ],
    );
  }
}

class _FormCard extends StatelessWidget {
  const _FormCard({
    required this.email,
    required this.password,
    required this.onSubmit,
  });

  final TextEditingController email;
  final TextEditingController password;
  final VoidCallback onSubmit;

  static const double _maxWidth = 440;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final viewModel = context.read<LoginViewModel>();
    final state = context.select<LoginViewModel, LoginState>((vm) => vm.state);
    final submitting = state is LoginSubmitting;

    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: _maxWidth),
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.xl),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(AppRadii.xl),
          boxShadow: const [
            BoxShadow(
              color: AppColors.shadow,
              blurRadius: AppSpacing.xxl,
              offset: Offset(0, AppSpacing.md),
            ),
          ],
        ),
        child: AutofillGroup(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                l10n.loginWelcome,
                style: const TextStyle(
                  fontSize: AppFontSize.headline,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: AppSpacing.xl),
              TextField(
                controller: email,
                enabled: !submitting,
                keyboardType: TextInputType.emailAddress,
                textInputAction: TextInputAction.next,
                autofillHints: const [AutofillHints.email],
                onChanged: (_) => viewModel.onInputChanged(),
                decoration: InputDecoration(
                  labelText: l10n.loginEmailLabel,
                  prefixIcon: const Icon(Icons.alternate_email_rounded),
                ),
              ),
              const SizedBox(height: AppSpacing.lg),
              _PasswordField(
                controller: password,
                enabled: !submitting,
                onSubmit: onSubmit,
              ),
              AnimatedSize(
                duration: AppDurations.fast,
                child: state is LoginFailed
                    ? _ErrorBanner(message: _errorText(l10n, state.error))
                    : const SizedBox(width: double.infinity),
              ),
              const SizedBox(height: AppSpacing.xl),
              _SubmitButton(submitting: submitting, onSubmit: onSubmit),
              const SizedBox(height: AppSpacing.lg),
              Text(
                l10n.loginDemoHint,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: AppFontSize.small,
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  static String _errorText(AppLocalizations l10n, LoginError error) =>
      switch (error) {
        LoginError.invalidEmail => l10n.loginErrorInvalidEmail,
        LoginError.passwordTooShort => l10n.loginErrorPasswordTooShort(
          LoginViewModel.minPasswordLength,
        ),
        LoginError.invalidCredentials => l10n.loginErrorInvalidCredentials,
        LoginError.network => l10n.loginErrorNetwork,
        LoginError.unknown => l10n.loginErrorUnknown,
      };
}

class _PasswordField extends StatelessWidget {
  const _PasswordField({
    required this.controller,
    required this.enabled,
    required this.onSubmit,
  });

  final TextEditingController controller;
  final bool enabled;
  final VoidCallback onSubmit;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final viewModel = context.read<LoginViewModel>();
    final obscure = context.select<LoginViewModel, bool>(
      (vm) => vm.obscurePassword,
    );
    return TextField(
      controller: controller,
      enabled: enabled,
      obscureText: obscure,
      textInputAction: TextInputAction.done,
      autofillHints: const [AutofillHints.password],
      onChanged: (_) => viewModel.onInputChanged(),
      onSubmitted: (_) => onSubmit(),
      decoration: InputDecoration(
        labelText: l10n.loginPasswordLabel,
        prefixIcon: const Icon(Icons.lock_outline_rounded),
        suffixIcon: IconButton(
          tooltip: obscure ? l10n.loginShowPassword : l10n.loginHidePassword,
          icon: Icon(
            obscure ? Icons.visibility_outlined : Icons.visibility_off_outlined,
          ),
          onPressed: viewModel.togglePasswordVisibility,
        ),
      ),
    );
  }
}

class _SubmitButton extends StatelessWidget {
  const _SubmitButton({required this.submitting, required this.onSubmit});

  final bool submitting;
  final VoidCallback onSubmit;

  static const double _spinnerStroke = 2.5;

  @override
  Widget build(BuildContext context) {
    return FilledButton(
      onPressed: submitting ? null : onSubmit,
      child: AnimatedSwitcher(
        duration: AppDurations.fast,
        child: submitting
            ? const SizedBox.square(
                dimension: AppSpacing.xl,
                child: CircularProgressIndicator(
                  strokeWidth: _spinnerStroke,
                  color: AppColors.onDark,
                ),
              )
            : Text(AppLocalizations.of(context).loginSubmit),
      ),
    );
  }
}

class _ErrorBanner extends StatelessWidget {
  const _ErrorBanner({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: AppSpacing.lg),
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.md),
        decoration: BoxDecoration(
          color: AppColors.error.withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(AppRadii.sm),
        ),
        child: Row(
          children: [
            const Icon(Icons.error_outline_rounded, color: AppColors.error),
            const SizedBox(width: AppSpacing.sm),
            Expanded(
              child: Text(
                message,
                style: const TextStyle(
                  color: AppColors.error,
                  fontSize: AppFontSize.body,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// A soft translucent circle decorating the background.
class _Bubble extends StatelessWidget {
  const _Bubble({required this.alignment, required this.diameter});

  final Alignment alignment;
  final double diameter;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: alignment,
      child: IgnorePointer(
        child: Container(
          width: diameter,
          height: diameter,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: AppColors.glass.withValues(alpha: 0.08),
            border: Border.all(color: AppColors.glass),
          ),
        ),
      ),
    );
  }
}
