import 'package:punchy/core/network/api_client.dart';
import 'package:punchy/features/cards/models/digital_card.dart';
import 'package:punchy/features/cards/services/cards_service.dart';

/// `GET cards` → `[ {card}, … ]`, `GET cards/{id}` → `{card}`.
/// The card payload is documented in `docs/specs/2026-09-30-tessere-digitali.md`.
class HttpCardsService implements CardsService {
  HttpCardsService(this._client);

  final ApiClient _client;

  @override
  Future<List<DigitalCard>> fetchCards() async {
    final body = await _client.get('cards');
    if (body is! List) throw const CardsException('Expected a list of cards');
    return body
        .whereType<Map<String, Object?>>()
        .map(DigitalCard.fromJson)
        .toList();
  }

  @override
  Future<DigitalCard> fetchCard(String id) async {
    final body = await _client.get('cards/${Uri.encodeComponent(id)}');
    if (body is! Map<String, Object?>) {
      throw const CardsException('Expected a card object');
    }
    return DigitalCard.fromJson(body);
  }
}
