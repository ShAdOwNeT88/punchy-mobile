import 'dart:convert';

import 'package:punchy/features/cards/models/digital_card.dart';
import 'package:punchy/features/cards/services/cards_service.dart';

/// Serves a recorded payload in the same shape the backend will return, so
/// the parsing path is exercised exactly as in production.
class MockCardsService implements CardsService {
  MockCardsService({this.latency = const Duration(milliseconds: 700)});

  final Duration latency;

  @override
  Future<List<DigitalCard>> fetchCards() async {
    await Future<void>.delayed(latency);
    return _decode().map(DigitalCard.fromJson).toList();
  }

  @override
  Future<DigitalCard> fetchCard(String id) async {
    await Future<void>.delayed(latency);
    final match = _decode().where((json) => json['id'] == id);
    if (match.isEmpty) throw CardsException('Card $id not found');
    return DigitalCard.fromJson(match.first);
  }

  static List<Map<String, Object?>> _decode() =>
      (jsonDecode(payload) as List).cast<Map<String, Object?>>();

  /// Example `GET cards` response.
  static const payload = '''
[
  {
    "id": "card-pool-01",
    "issuer": {
      "name": "Life",
      "category": "pool",
      "emblem": "leaf",
      "tagline": "swimming",
      "contactName": "Luigi",
      "contactPhone": "345.0000000"
    },
    "holder": { "firstName": "Mario", "lastName": "Rossi" },
    "style": "ocean",
    "design": "paper",
    "stampStyle": "signature",
    "program": "entries",
    "totalSlots": 12,
    "validUntil": "2027-06-30",
    "stamps": [
      { "date": "2026-09-29", "operatorInitials": "Lb" }
    ]
  },
  {
    "id": "card-gym-01",
    "number": "1182",
    "issuer": {
      "name": "Iron District",
      "category": "gym",
      "tagline": "fitness club",
      "contactName": "Reception",
      "contactPhone": "081 000 0000"
    },
    "holder": { "firstName": "Mario", "lastName": "Rossi" },
    "style": "ember",
    "program": "monthly",
    "totalSlots": 12,
    "validUntil": "2026-12-31",
    "stamps": [
      { "date": "2026-01-05", "period": "2026-01-01", "amountCents": 4500, "operatorInitials": "SV" },
      { "date": "2026-02-03", "period": "2026-02-01", "amountCents": 4500, "operatorInitials": "SV" },
      { "date": "2026-03-02", "period": "2026-03-01", "amountCents": 4500, "operatorInitials": "AR" },
      { "date": "2026-04-07", "period": "2026-04-01", "amountCents": 4500, "operatorInitials": "SV" },
      { "date": "2026-05-04", "period": "2026-05-01", "amountCents": 4500, "operatorInitials": "SV" },
      { "date": "2026-06-01", "period": "2026-06-01", "amountCents": 4500, "operatorInitials": "AR" },
      { "date": "2026-07-06", "period": "2026-07-01", "amountCents": 3500, "operatorInitials": "SV" },
      { "date": "2026-09-01", "period": "2026-09-01", "amountCents": 4500, "operatorInitials": "SV" }
    ]
  },
  {
    "id": "card-studio-01",
    "number": "0063",
    "issuer": {
      "name": "Studio Loto",
      "category": "studio",
      "tagline": "yoga & pilates",
      "contactName": "Chiara",
      "contactPhone": "333 000 0000"
    },
    "holder": { "firstName": "Mario", "lastName": "Rossi" },
    "style": "violet",
    "program": "entries",
    "totalSlots": 10,
    "stamps": [
      { "date": "2026-09-10" },
      { "date": "2026-09-17", "operatorInitials": "CF" }
    ]
  },
  {
    "id": "card-cafe-01",
    "issuer": {
      "name": "Caffè Centrale",
      "category": "cafe",
      "tagline": "torrefazione dal 1962"
    },
    "style": "coffee",
    "program": "loyalty",
    "totalSlots": 10,
    "reward": "Un caffè omaggio",
    "stamps": [
      { "date": "2026-09-14" },
      { "date": "2026-09-16" },
      { "date": "2026-09-19" },
      { "date": "2026-09-22" },
      { "date": "2026-09-24" },
      { "date": "2026-09-26" },
      { "date": "2026-09-29" }
    ]
  },
  {
    "id": "card-beauty-01",
    "number": "B-208",
    "issuer": {
      "name": "Salone Aurora",
      "category": "beauty",
      "tagline": "hair & beauty",
      "contactPhone": "089 000 0000"
    },
    "holder": { "firstName": "Mario", "lastName": "Rossi" },
    "style": "rose",
    "program": "loyalty",
    "totalSlots": 6,
    "reward": "Piega gratuita",
    "stamps": [
      { "date": "2026-04-11", "operatorInitials": "AB" },
      { "date": "2026-05-09", "operatorInitials": "AB" },
      { "date": "2026-06-13", "operatorInitials": "MV" },
      { "date": "2026-07-11", "operatorInitials": "AB" },
      { "date": "2026-08-29", "operatorInitials": "AB" },
      { "date": "2026-09-26", "operatorInitials": "MV" }
    ]
  }
]
''';
}
