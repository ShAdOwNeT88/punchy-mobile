import 'package:flutter/material.dart';
import 'package:punchy/l10n/app_localizations.dart';
import 'package:punchy/shared/theme/app_colors.dart';
import 'package:punchy/shared/theme/app_dimensions.dart';
import 'package:punchy/shared/theme/app_theme.dart';

/// Shown instead of the app when build-time configuration is invalid, naming
/// the offending key.
class ConfigErrorApp extends StatelessWidget {
  const ConfigErrorApp({super.key, required this.configKey});

  final String configKey;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light(),
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: Builder(
        builder: (context) {
          final l10n = AppLocalizations.of(context);
          return Scaffold(
            body: Padding(
              padding: const EdgeInsets.all(AppSpacing.xl),
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.settings_suggest_rounded,
                      color: AppColors.error,
                      size: AppFontSize.hero * 2,
                    ),
                    const SizedBox(height: AppSpacing.lg),
                    Text(
                      l10n.configErrorTitle,
                      style: const TextStyle(
                        fontSize: AppFontSize.headline,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    Text(
                      l10n.configErrorMessage(configKey),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
