import 'package:flutter/material.dart';
import 'package:punchy/app/route_table.dart';
import 'package:punchy/core/navigation/routes.dart';
import 'package:punchy/l10n/app_localizations.dart';
import 'package:punchy/shared/theme/app_theme.dart';

class PunchyApp extends StatelessWidget {
  const PunchyApp({super.key, required this.isAuthenticated});

  /// Decides the first screen: the card list for a restored session, the
  /// login otherwise.
  final bool isAuthenticated;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      onGenerateTitle: (context) => AppLocalizations.of(context).appTitle,
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light(),
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      initialRoute: isAuthenticated ? Routes.cards : Routes.login,
      onGenerateRoute: RouteTable.onGenerateRoute,
    );
  }
}
