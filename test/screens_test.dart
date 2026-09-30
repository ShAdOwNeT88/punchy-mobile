import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:punchy/core/navigation/routes.dart';
import 'package:punchy/features/cards/widgets/card_detail_screen.dart';
import 'package:punchy/features/cards/widgets/cards_screen.dart';
import 'package:punchy/features/cards/widgets/card_back.dart';
import 'package:punchy/features/cards/widgets/card_front.dart';

import 'helpers.dart';

void main() {
  testWidgets('login leads to the card list', (tester) async {
    final session = await pumpApp(tester, initialRoute: Routes.login);
    expect(find.text('Bentornato'), findsOneWidget);

    await tester.enterText(
      find.byType(TextField).at(0),
      'mario.rossi@example.com',
    );
    await tester.enterText(find.byType(TextField).at(1), 'secret1');
    await tester.tap(find.text('Accedi'));
    await tester.pumpAndSettle();

    expect(session.isAuthenticated, isTrue);
    expect(find.byType(CardsScreen), findsOneWidget);
  });

  testWidgets('login shows a validation error', (tester) async {
    await pumpApp(tester, initialRoute: Routes.login);
    await tester.tap(find.text('Accedi'));
    await tester.pumpAndSettle();
    expect(find.text('Inserisci un indirizzo email valido.'), findsOneWidget);
  });

  testWidgets('card list shows the cards and opens the detail', (tester) async {
    await pumpApp(tester, initialRoute: Routes.cards, session: testSession);
    // The large app bar renders its title in both collapsed and expanded form.
    expect(find.text('Le mie tessere'), findsWidgets);
    expect(find.text('Life'), findsOneWidget);

    await tester.tap(find.byType(CardFront).first);
    await tester.pumpAndSettle();
    expect(find.byType(CardDetailScreen), findsOneWidget);
  });

  testWidgets('card list shows an error with retry', (tester) async {
    await pumpApp(
      tester,
      initialRoute: Routes.cards,
      session: testSession,
      cardsService: FailingCardsService(),
    );
    expect(find.text('Riprova'), findsOneWidget);
  });

  testWidgets('logout returns to the login', (tester) async {
    final session = await pumpApp(
      tester,
      initialRoute: Routes.cards,
      session: testSession,
    );
    await tester.tap(find.byTooltip('Esci'));
    await tester.pumpAndSettle();
    expect(session.isAuthenticated, isFalse);
    expect(find.text('Bentornato'), findsOneWidget);
  });

  testWidgets('card detail flips between front and back', (tester) async {
    tester.view
      ..physicalSize = const Size(390, 844)
      ..devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    await pumpApp(
      tester,
      initialRoute: Routes.cardDetail,
      arguments: 'card-gym-01',
      session: testSession,
    );
    expect(find.byType(CardFront), findsOneWidget);
    expect(find.byType(CardBack), findsNothing);

    await tester.tap(find.byType(CardFront));
    await tester.pumpAndSettle();
    expect(find.byType(CardBack), findsOneWidget);
    expect(find.text('MENSILITÀ'), findsOneWidget);

    await tester.tap(find.text('Fronte'));
    await tester.pumpAndSettle();
    expect(find.byType(CardFront), findsOneWidget);
  });

  testWidgets('card list filters loyalty cards', (tester) async {
    await pumpApp(tester, initialRoute: Routes.cards, session: testSession);
    expect(find.text('Life'), findsOneWidget);

    await tester.tap(find.text('Fedeltà'));
    await tester.pumpAndSettle();
    expect(find.text('Life'), findsNothing);
    expect(find.text('Caffè Centrale'), findsOneWidget);
  });

  testWidgets('loyalty card detail shows the reward', (tester) async {
    tester.view
      ..physicalSize = const Size(390, 1400)
      ..devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    await pumpApp(
      tester,
      initialRoute: Routes.cardDetail,
      arguments: 'card-beauty-01',
      session: testSession,
    );
    expect(find.text('Il tuo premio'), findsOneWidget);
    expect(
      find.text('Premio sbloccato! Mostra la tessera in cassa.'),
      findsOneWidget,
    );

    await tester.tap(find.byType(CardFront));
    await tester.pumpAndSettle();
    expect(find.text('RACCOLTA TIMBRI'), findsOneWidget);
  });

  testWidgets('stat tiles share one height when a label wraps', (tester) async {
    // Narrow enough for "Timbri raccolti" to wrap on two lines.
    tester.view
      ..physicalSize = const Size(320, 1400)
      ..devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    await pumpApp(
      tester,
      initialRoute: Routes.cardDetail,
      arguments: 'card-cafe-01',
      session: testSession,
    );

    Size tile(String label) => tester.getSize(
      find
          .ancestor(of: find.text(label), matching: find.byType(Expanded))
          .first,
    );
    final collected = tile('Timbri raccolti');
    expect(tile('Al premio').height, collected.height);
    expect(tile('Valida fino al').height, collected.height);
  });
}
