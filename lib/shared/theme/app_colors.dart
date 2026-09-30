import 'package:flutter/painting.dart';

/// Every colour the application uses. No hex value may appear outside
/// `shared/theme/`.
abstract final class AppColors {
  // Brand
  static const primary = Color(0xFF2451E6);
  static const primaryDark = Color(0xFF14307F);
  static const secondary = Color(0xFF00B3A4);

  // Surfaces and text
  static const background = Color(0xFFF4F6FB);
  static const surface = Color(0xFFFFFFFF);
  static const surfaceMuted = Color(0xFFE9EDF5);
  static const textPrimary = Color(0xFF121826);
  static const textSecondary = Color(0xFF5B6475);
  static const outline = Color(0xFFD5DBE7);
  static const error = Color(0xFFD64545);
  static const success = Color(0xFF1E9E6A);

  // On dark gradients (login background, card fronts)
  static const onDark = Color(0xFFFFFFFF);
  static const onDarkMuted = Color(0xB3FFFFFF);
  static const glass = Color(0x29FFFFFF);
  static const glassBorder = Color(0x4DFFFFFF);
  static const shadow = Color(0x33121826);

  // Card back ("paper" side)
  static const paper = Color(0xFFFBFAF6);
  static const paperInk = Color(0xFF1F2937);
  static const paperWatermark = Color(0xFFB8BEC9);

  // Printed ("paper" design) cards
  static const printWhite = Color(0xFFFFFFFF);
  static const printBorder = Color(0xFFE3E6EC);

  /// Ballpoint pen, for handwritten names and signatures.
  static const penInk = Color(0xFF1B2250);

  /// Posts and ropes in the pool picture band.
  static const bandShadow = Color(0x66061A2A);

  // Login background
  static const loginGradient = [
    Color(0xFF0B1B4D),
    Color(0xFF1D3FB8),
    Color(0xFF12A5C9),
  ];
}

/// Gradient and stamp ink of each card style. The feature maps its own
/// style enum onto one of these.
final class CardPalette {
  const CardPalette({required this.gradient, required this.ink});

  final List<Color> gradient;

  /// Colour of the stamps printed on the back of the card.
  final Color ink;

  static const ocean = CardPalette(
    gradient: [Color(0xFF0B4F71), Color(0xFF1B8FB5), Color(0xFF5FD0E0)],
    ink: Color(0xFF1B6FA0),
  );
  static const ember = CardPalette(
    gradient: [Color(0xFF2B1B3D), Color(0xFFC2410C), Color(0xFFF59E0B)],
    ink: Color(0xFFC2410C),
  );
  static const violet = CardPalette(
    gradient: [Color(0xFF3B1C6B), Color(0xFF7C3AED), Color(0xFFC084FC)],
    ink: Color(0xFF6D28D9),
  );
  static const forest = CardPalette(
    gradient: [Color(0xFF064E3B), Color(0xFF059669), Color(0xFF6EE7B7)],
    ink: Color(0xFF047857),
  );
  static const coffee = CardPalette(
    gradient: [Color(0xFF2B1A12), Color(0xFF6F4E37), Color(0xFFC89F7C)],
    ink: Color(0xFF6F4E37),
  );
  static const rose = CardPalette(
    gradient: [Color(0xFF5B1A3A), Color(0xFFDB2777), Color(0xFFF9A8D4)],
    ink: Color(0xFFBE185D),
  );
}
