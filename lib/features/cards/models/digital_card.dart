/// What kind of business issued the card. Drives the icon and the pattern
/// printed on the front; it never changes behaviour.
enum IssuerCategory { pool, gym, studio, cafe, restaurant, shop, beauty, other }

/// How the boxes on the back of the card are earned.
enum CardProgram {
  /// A prepaid package: one box per entry.
  entries,

  /// A subscription: one box per monthly fee paid.
  monthly,

  /// A loyalty card: one box per purchase, a reward when the card is full.
  loyalty;

  bool get isMembership => this != loyalty;
}

/// Visual style chosen by the issuer: the colour palette.
enum CardStyle { ocean, ember, violet, forest, coffee, rose }

/// Layout of the card, chosen by the issuer.
enum CardDesign {
  /// Full-bleed gradient, the app's own look.
  gradient,

  /// A white printed card with a picture band on top, like most paper cards
  /// handed out at the counter.
  paper,
}

/// How staff mark a box on the back.
enum StampStyle {
  /// A round rubber stamp.
  round,

  /// Initials signed by hand with a pen.
  signature,
}

/// Symbol of the issuer's logo. Until the backend serves logo images, the
/// app draws one of these; without one it falls back to the category icon.
enum IssuerEmblem { leaf, wave, star, heart, bolt, crown }

/// One stamp on the back of the card: an entry, a monthly payment or a
/// purchase.
final class CardStamp {
  const CardStamp({
    required this.date,
    this.period,
    this.amountCents,
    this.operatorInitials,
  });

  /// When the stamp was put on the card.
  final DateTime date;

  /// For monthly cards, the month the payment covers.
  final DateTime? period;

  final int? amountCents;

  /// The staff member who stamped the card, as on the paper one.
  final String? operatorInitials;

  factory CardStamp.fromJson(Map<String, Object?> json) {
    final date = _parseDate(json['date']);
    if (date == null) throw const FormatException('Stamp without date');
    final amount = json['amountCents'];
    return CardStamp(
      date: date,
      period: _parseDate(json['period']),
      amountCents: amount is num ? amount.toInt() : null,
      operatorInitials: _nonEmpty(json['operatorInitials']),
    );
  }
}

/// The business that issued the card: a pool, a gym, a café, a shop…
final class Issuer {
  const Issuer({
    required this.name,
    required this.category,
    this.emblem,
    this.tagline,
    this.contactName,
    this.contactPhone,
  });

  final String name;
  final IssuerCategory category;
  final IssuerEmblem? emblem;

  /// Short line printed under the name ("swimming", "caffetteria").
  final String? tagline;
  final String? contactName;
  final String? contactPhone;

  factory Issuer.fromJson(Map<String, Object?> json) => Issuer(
    name: json['name'] as String? ?? '',
    category: _enumByName(
      IssuerCategory.values,
      json['category'],
      IssuerCategory.other,
    ),
    emblem: _enumByNameOrNull(IssuerEmblem.values, json['emblem']),
    tagline: _nonEmpty(json['tagline']),
    contactName: _nonEmpty(json['contactName']),
    contactPhone: _nonEmpty(json['contactPhone']),
  );
}

/// The person the card is issued to. Loyalty cards are often anonymous.
final class CardHolder {
  const CardHolder({required this.firstName, required this.lastName});

  final String firstName;
  final String lastName;

  /// Null when the payload names nobody.
  static CardHolder? fromJson(Object? json) {
    final map = _map(json);
    final first = _nonEmpty(map['firstName']) ?? '';
    final last = _nonEmpty(map['lastName']) ?? '';
    if (first.isEmpty && last.isEmpty) return null;
    return CardHolder(firstName: first, lastName: last);
  }
}

/// The digital version of a paper card that gets stamped: a pool or gym
/// membership, or a shop's loyalty card.
final class DigitalCard {
  const DigitalCard({
    required this.id,
    required this.issuer,
    required this.style,
    required this.program,
    required this.totalSlots,
    required this.stamps,
    this.design = CardDesign.gradient,
    this.stampStyle = StampStyle.round,
    this.number,
    this.holder,
    this.reward,
    this.validUntil,
  });

  final String id;
  final Issuer issuer;
  final CardStyle style;
  final CardDesign design;
  final StampStyle stampStyle;
  final CardProgram program;

  /// Boxes printed on the back of the card. Never fewer than [stamps].
  final int totalSlots;

  /// Stamps in chronological order.
  final List<CardStamp> stamps;

  final String? number;
  final CardHolder? holder;

  /// What a full loyalty card earns ("Un caffè omaggio"). Content from the
  /// issuer, already in the user's language.
  final String? reward;
  final DateTime? validUntil;

  int get usedSlots => stamps.length;
  int get remainingSlots => totalSlots - usedSlots;
  bool get isComplete => usedSlots >= totalSlots;

  /// A full loyalty card whose reward can be claimed.
  bool get isRewardReady => program == CardProgram.loyalty && isComplete;

  static const defaultSlots = 12;

  factory DigitalCard.fromJson(Map<String, Object?> json) {
    final id = json['id'];
    if (id == null) throw const FormatException('Card without id');
    final stamps =
        (json['stamps'] is List ? json['stamps'] as List : const [])
            .whereType<Map<String, Object?>>()
            .map(CardStamp.fromJson)
            .toList()
          ..sort((a, b) => a.date.compareTo(b.date));
    final slots = json['totalSlots'];
    final declaredSlots = slots is num && slots > 0
        ? slots.toInt()
        : defaultSlots;

    return DigitalCard(
      id: '$id',
      number: _nonEmpty(json['number']?.toString()),
      issuer: Issuer.fromJson(_map(json['issuer'])),
      holder: CardHolder.fromJson(json['holder']),
      style: _enumByName(CardStyle.values, json['style'], CardStyle.ocean),
      design: _enumByName(
        CardDesign.values,
        json['design'],
        CardDesign.gradient,
      ),
      stampStyle: _enumByName(
        StampStyle.values,
        json['stampStyle'],
        StampStyle.round,
      ),
      program: _enumByName(
        CardProgram.values,
        json['program'],
        CardProgram.entries,
      ),
      totalSlots: declaredSlots < stamps.length ? stamps.length : declaredSlots,
      stamps: List.unmodifiable(stamps),
      reward: _nonEmpty(json['reward']),
      validUntil: _parseDate(json['validUntil']),
    );
  }
}

Map<String, Object?> _map(Object? value) =>
    value is Map<String, Object?> ? value : const {};

String? _nonEmpty(Object? value) =>
    value is String && value.trim().isNotEmpty ? value.trim() : null;

DateTime? _parseDate(Object? value) =>
    value is String ? DateTime.tryParse(value) : null;

T _enumByName<T extends Enum>(List<T> values, Object? name, T fallback) =>
    _enumByNameOrNull(values, name) ?? fallback;

T? _enumByNameOrNull<T extends Enum>(List<T> values, Object? name) {
  for (final value in values) {
    if (value.name == name) return value;
  }
  return null;
}
