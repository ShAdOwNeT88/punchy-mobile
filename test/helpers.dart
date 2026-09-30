import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:punchy/app/route_table.dart';
import 'package:punchy/core/services/session_store.dart';
import 'package:punchy/core/session/session.dart';
import 'package:punchy/core/session/session_controller.dart';
import 'package:punchy/features/auth/repository/auth_repository.dart';
import 'package:punchy/features/auth/services/mock_auth_service.dart';
import 'package:punchy/features/cards/models/digital_card.dart';
import 'package:punchy/features/cards/repository/cards_repository.dart';
import 'package:punchy/features/cards/services/cards_service.dart';
import 'package:punchy/features/cards/services/mock_cards_service.dart';
import 'package:punchy/l10n/app_localizations.dart';

const testSession = Session(
  token: 't',
  userId: 'u1',
  email: 'mario.rossi@example.com',
  firstName: 'Mario',
  lastName: 'Rossi',
);

class FailingCardsService implements CardsService {
  int calls = 0;

  @override
  Future<List<DigitalCard>> fetchCards() async {
    calls++;
    throw const CardsException('boom');
  }

  @override
  Future<DigitalCard> fetchCard(String id) async {
    calls++;
    throw const CardsException('boom');
  }
}

/// Pumps the real route table with instant mock services.
Future<SessionController> pumpApp(
  WidgetTester tester, {
  required String initialRoute,
  Object? arguments,
  Session? session,
  CardsService? cardsService,
}) async {
  final controller = SessionController(InMemorySessionStore(session));
  await controller.restore();
  await tester.pumpWidget(
    MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: controller),
        Provider.value(
          value: AuthRepository(
            MockAuthService(latency: Duration.zero),
            controller,
          ),
        ),
        Provider.value(
          value: CardsRepository(
            cardsService ?? MockCardsService(latency: Duration.zero),
          ),
        ),
      ],
      child: MaterialApp(
        locale: const Locale('it'),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        onGenerateInitialRoutes: (_) => [
          RouteTable.onGenerateRoute(
            RouteSettings(name: initialRoute, arguments: arguments),
          )!,
        ],
        onGenerateRoute: RouteTable.onGenerateRoute,
      ),
    ),
  );
  await tester.pumpAndSettle();
  return controller;
}
