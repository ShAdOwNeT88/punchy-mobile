import 'package:flutter_test/flutter_test.dart';
import 'package:punchy/core/services/session_store.dart';
import 'package:punchy/core/session/session_controller.dart';
import 'package:punchy/features/cards/models/digital_card.dart';
import 'package:punchy/features/cards/repository/cards_repository.dart';
import 'package:punchy/features/cards/services/mock_cards_service.dart';
import 'package:punchy/features/cards/view_model/card_detail_view_model.dart';
import 'package:punchy/features/cards/view_model/cards_view_model.dart';
import 'package:punchy/features/cards/widgets/card_back.dart';
import 'package:punchy/shared/ui/ui_state.dart';

import 'helpers.dart';

void main() {
  group('DigitalCard.fromJson', () {
    test('parses the recorded payload', () async {
      final cards = await MockCardsService(latency: Duration.zero).fetchCards();
      expect(cards, hasLength(5));
      final gym = cards.firstWhere((c) => c.id == 'card-gym-01');
      expect(gym.program, CardProgram.monthly);
      expect(gym.issuer.category, IssuerCategory.gym);
      expect(gym.holder?.lastName, 'Rossi');
      expect(gym.stamps.first.period, DateTime(2026));
      expect(gym.stamps.first.amountCents, 4500);
    });

    test('parses an anonymous loyalty card with a reward', () async {
      final cards = await MockCardsService(latency: Duration.zero).fetchCards();
      final cafe = cards.firstWhere((c) => c.id == 'card-cafe-01');
      expect(cafe.program, CardProgram.loyalty);
      expect(cafe.program.isMembership, isFalse);
      expect(cafe.issuer.category, IssuerCategory.cafe);
      expect(cafe.holder, isNull);
      expect(cafe.number, isNull);
      expect(cafe.reward, 'Un caffè omaggio');
      expect(cafe.remainingSlots, 3);
      expect(cafe.isRewardReady, isFalse);

      final salon = cards.firstWhere((c) => c.id == 'card-beauty-01');
      expect(salon.isComplete, isTrue);
      expect(salon.isRewardReady, isTrue);
    });

    test('parses the printed design of the pool card', () async {
      final cards = await MockCardsService(latency: Duration.zero).fetchCards();
      final pool = cards.firstWhere((c) => c.id == 'card-pool-01');
      expect(pool.design, CardDesign.paper);
      expect(pool.stampStyle, StampStyle.signature);
      expect(pool.issuer.emblem, IssuerEmblem.leaf);
      expect(pool.usedSlots, 1);
    });

    test('defaults to the gradient design with round stamps', () {
      final card = DigitalCard.fromJson({
        'id': 'd',
        'design': 'hologram',
        'stampStyle': 'laser',
        'issuer': {'emblem': 'unicorn'},
      });
      expect(card.design, CardDesign.gradient);
      expect(card.stampStyle, StampStyle.round);
      expect(card.issuer.emblem, isNull);
    });

    test('a full membership card never has a reward ready', () {
      final card = DigitalCard.fromJson({
        'id': 'm',
        'program': 'entries',
        'totalSlots': 1,
        'stamps': [
          {'date': '2026-01-01'},
        ],
      });
      expect(card.isComplete, isTrue);
      expect(card.isRewardReady, isFalse);
    });

    test('treats a blank holder and number as absent', () {
      final card = DigitalCard.fromJson({
        'id': 'h',
        'number': ' ',
        'holder': {'firstName': '', 'lastName': '  '},
        'reward': '',
      });
      expect(card.holder, isNull);
      expect(card.number, isNull);
      expect(card.reward, isNull);
    });

    test('falls back on unknown enums and missing fields', () {
      final card = DigitalCard.fromJson({
        'id': 7,
        'issuer': {'name': 'X', 'category': 'trampoline'},
        'style': 'neon',
        'program': 'weekly',
      });
      expect(card.id, '7');
      expect(card.issuer.category, IssuerCategory.other);
      expect(card.style, CardStyle.ocean);
      expect(card.program, CardProgram.entries);
      expect(card.totalSlots, DigitalCard.defaultSlots);
      expect(card.stamps, isEmpty);
      expect(card.validUntil, isNull);
    });

    test('grows the slots to fit the stamps and sorts them by date', () {
      final card = DigitalCard.fromJson({
        'id': 'a',
        'totalSlots': 1,
        'stamps': [
          {'date': '2026-03-01'},
          {'date': '2026-01-01', 'operatorInitials': '  '},
        ],
      });
      expect(card.totalSlots, 2);
      expect(card.stamps.first.date, DateTime(2026));
      expect(card.stamps.first.operatorInitials, isNull);
    });

    test('rejects a card without id and a stamp without date', () {
      expect(() => DigitalCard.fromJson({}), throwsFormatException);
      expect(() => CardStamp.fromJson({}), throwsFormatException);
    });
  });

  group('CardsRepository', () {
    test('caches the list and serves details from it', () async {
      final repository = CardsRepository(
        MockCardsService(latency: Duration.zero),
      );
      final first = await repository.getCards();
      expect(identical(first, await repository.getCards()), isTrue);
      final detail = await repository.getCard('card-pool-01');
      expect(identical(detail, first.first), isTrue);
    });

    test('fetches a card that is not cached', () async {
      final repository = CardsRepository(
        MockCardsService(latency: Duration.zero),
      );
      final card = await repository.getCard('card-studio-01');
      expect(card.issuer.name, 'Studio Loto');
    });
  });

  group('CardsViewModel', () {
    test('loads cards and exposes the first name', () async {
      final session = SessionController(InMemorySessionStore(testSession));
      await session.restore();
      final vm = CardsViewModel(
        CardsRepository(MockCardsService(latency: Duration.zero)),
        session,
      );
      expect(vm.state, isA<UiLoading<List<DigitalCard>>>());
      await vm.load();
      expect(vm.state, isA<UiSuccess<List<DigitalCard>>>());
      expect(vm.firstName, 'Mario');
    });

    test('filters memberships and loyalty cards', () async {
      final vm = CardsViewModel(
        CardsRepository(MockCardsService(latency: Duration.zero)),
        SessionController(InMemorySessionStore()),
      );
      expect(vm.canFilter, isFalse);
      await vm.load();
      expect(vm.canFilter, isTrue);

      List<DigitalCard> visible() =>
          (vm.state as UiSuccess<List<DigitalCard>>).data;

      expect(visible(), hasLength(5));
      vm.setFilter(CardFilter.loyalty);
      expect(visible().map((c) => c.program).toSet(), {CardProgram.loyalty});
      vm.setFilter(CardFilter.memberships);
      expect(visible(), hasLength(3));
      expect(visible().every((c) => c.program.isMembership), isTrue);

      // The filter survives a refresh.
      await vm.refresh();
      expect(vm.filter, CardFilter.memberships);
      expect(visible(), hasLength(3));
    });

    test('drops the filter when only one kind of card is left', () async {
      final vm = CardsViewModel(
        CardsRepository(_OnlyMemberships()),
        SessionController(InMemorySessionStore()),
      );
      vm.setFilter(CardFilter.loyalty);
      await vm.load();
      expect(vm.canFilter, isFalse);
      expect(vm.filter, CardFilter.all);
      expect((vm.state as UiSuccess<List<DigitalCard>>).data, hasLength(3));
    });

    test('exposes errors and retries', () async {
      final service = FailingCardsService();
      final vm = CardsViewModel(
        CardsRepository(service),
        SessionController(InMemorySessionStore()),
      );
      await vm.load();
      expect(vm.state, isA<UiError<List<DigitalCard>>>());
      await vm.retry();
      expect(service.calls, 2);
    });

    test('logout ends the session', () async {
      final session = SessionController(InMemorySessionStore(testSession));
      await session.restore();
      final vm = CardsViewModel(
        CardsRepository(MockCardsService(latency: Duration.zero)),
        session,
      );
      await vm.logout();
      expect(session.isAuthenticated, isFalse);
    });
  });

  test('the back grid fits the number of boxes', () {
    expect(CardBack.columnsFor(12), 4);
    expect(CardBack.columnsFor(10), 5);
    expect(CardBack.columnsFor(8), 4);
    expect(CardBack.columnsFor(6), 3);
    expect(CardBack.columnsFor(2), 2);
    expect(CardBack.columnsFor(24), 8);
  });

  group('CardDetailViewModel', () {
    test('loads the card and flips', () async {
      final vm = CardDetailViewModel(
        CardsRepository(MockCardsService(latency: Duration.zero)),
        'card-pool-01',
      );
      await vm.load();
      final card = (vm.state as UiSuccess<DigitalCard>).data;
      expect(card.issuer.name, 'Life');
      expect(card.number, isNull);
      expect(vm.showBack, isFalse);
      vm.flip();
      expect(vm.showBack, isTrue);
      vm.setShowBack(false);
      expect(vm.showBack, isFalse);
    });

    test('reports an unknown card', () async {
      final vm = CardDetailViewModel(
        CardsRepository(MockCardsService(latency: Duration.zero)),
        'missing',
      );
      await vm.load();
      expect(vm.state, isA<UiError<DigitalCard>>());
    });
  });
}

/// The recorded payload without its loyalty cards.
class _OnlyMemberships extends MockCardsService {
  _OnlyMemberships() : super(latency: Duration.zero);

  @override
  Future<List<DigitalCard>> fetchCards() async =>
      (await super.fetchCards()).where((c) => c.program.isMembership).toList();
}
