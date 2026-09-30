import 'package:flutter/material.dart';
import 'package:punchy/core/navigation/routes.dart';
import 'package:punchy/features/auth/widgets/login_screen.dart';
import 'package:punchy/features/cards/widgets/card_detail_screen.dart';
import 'package:punchy/features/cards/widgets/cards_screen.dart';

/// The only place that knows every screen. Features navigate by route name.
abstract final class RouteTable {
  static Route<void>? onGenerateRoute(RouteSettings settings) {
    return switch (settings.name) {
      Routes.login => _fade(settings, const LoginScreen()),
      Routes.cards => _fade(settings, const CardsScreen()),
      Routes.cardDetail => MaterialPageRoute(
        settings: settings,
        builder: (_) => CardDetailScreen(cardId: settings.arguments! as String),
      ),
      _ => null,
    };
  }

  static Route<void> _fade(RouteSettings settings, Widget screen) =>
      PageRouteBuilder(
        settings: settings,
        pageBuilder: (_, _, _) => screen,
        transitionsBuilder: (_, animation, _, child) =>
            FadeTransition(opacity: animation, child: child),
      );
}
