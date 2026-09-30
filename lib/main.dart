import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:punchy/app/app.dart';
import 'package:punchy/app/config_error_app.dart';
import 'package:punchy/core/config/app_config.dart';
import 'package:punchy/core/network/api_client.dart';
import 'package:punchy/core/services/session_store.dart';
import 'package:punchy/core/session/session_controller.dart';
import 'package:punchy/features/auth/repository/auth_repository.dart';
import 'package:punchy/features/auth/services/auth_service.dart';
import 'package:punchy/features/auth/services/http_auth_service.dart';
import 'package:punchy/features/auth/services/mock_auth_service.dart';
import 'package:punchy/features/cards/repository/cards_repository.dart';
import 'package:punchy/features/cards/services/cards_service.dart';
import 'package:punchy/features/cards/services/http_cards_service.dart';
import 'package:punchy/features/cards/services/mock_cards_service.dart';

/// Composition root: validates configuration, builds the dependency graph
/// and runs the app.
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final AppConfig config;
  try {
    config = AppConfig.fromEnvironment();
  } on ConfigException catch (e) {
    runApp(ConfigErrorApp(configKey: e.key));
    return;
  }

  final session = SessionController(
    SharedPrefsSessionStore(await SharedPreferences.getInstance()),
  );
  await session.restore();

  final api = ApiClient(
    baseUrl: config.apiBaseUrl,
    tokenProvider: () => session.token,
  );

  // Until the backend exists, USE_MOCK_API=true binds in-memory services.
  final AuthService authService = config.useMockApi
      ? MockAuthService()
      : HttpAuthService(api);
  final CardsService cardsService = config.useMockApi
      ? MockCardsService()
      : HttpCardsService(api);

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: session),
        Provider.value(value: AuthRepository(authService, session)),
        Provider.value(value: CardsRepository(cardsService)),
      ],
      child: PunchyApp(isAuthenticated: session.isAuthenticated),
    ),
  );
}
