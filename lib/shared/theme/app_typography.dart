import 'package:flutter/painting.dart';

/// Typefaces beyond the app font configured on `ThemeData`.
abstract final class AppTypography {
  /// The serif of printed cards ("COGNOME", "INGRESSI"), from the platform:
  /// Noto Serif on Android, Times New Roman on iOS.
  static const printSerif = TextStyle(
    fontFamily: 'serif',
    fontFamilyFallback: ['Noto Serif', 'Times New Roman', 'Georgia'],
  );
}
