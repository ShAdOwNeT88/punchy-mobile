import 'package:punchy/features/cards/models/digital_card.dart';
import 'package:punchy/features/cards/services/cards_service.dart';

/// Wraps [CardsService] with an in-memory cache, so the detail screen opens
/// instantly on a card the list has already loaded.
class CardsRepository {
  CardsRepository(this._service);

  final CardsService _service;
  List<DigitalCard>? _cache;

  Future<List<DigitalCard>> getCards({bool forceRefresh = false}) async {
    final cached = _cache;
    if (cached != null && !forceRefresh) return cached;
    final cards = await _service.fetchCards();
    _cache = List.unmodifiable(cards);
    return _cache!;
  }

  Future<DigitalCard> getCard(String id) async {
    final cached = _cache?.where((c) => c.id == id);
    if (cached != null && cached.isNotEmpty) return cached.first;
    return _service.fetchCard(id);
  }

  /// Called on sign-out, so the next user never sees these cards.
  void clear() => _cache = null;
}
