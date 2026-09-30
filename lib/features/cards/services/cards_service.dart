import 'package:punchy/features/cards/models/digital_card.dart';

/// Reads the digital cards (memberships, loyalty cards, …) of the signed-in user.
abstract interface class CardsService {
  Future<List<DigitalCard>> fetchCards();

  Future<DigitalCard> fetchCard(String id);
}

/// Raised when a card cannot be loaded.
final class CardsException implements Exception {
  const CardsException(this.message);

  final String message;

  @override
  String toString() => 'CardsException: $message';
}
