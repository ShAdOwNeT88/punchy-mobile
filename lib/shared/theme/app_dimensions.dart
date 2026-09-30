/// Spacing scale, in logical pixels.
abstract final class AppSpacing {
  static const double xxs = 2;
  static const double xs = 4;
  static const double sm = 8;
  static const double md = 12;
  static const double lg = 16;
  static const double xl = 24;
  static const double xxl = 32;
  static const double xxxl = 48;
}

/// Corner radii scale.
abstract final class AppRadii {
  static const double sm = 8;
  static const double md = 12;
  static const double lg = 20;
  static const double xl = 28;
  static const double pill = 999;
}

/// Font size scale.
abstract final class AppFontSize {
  static const double micro = 9;
  static const double caption = 11;
  static const double small = 12;
  static const double body = 14;
  static const double bodyLarge = 16;
  static const double title = 18;
  static const double headline = 22;
  static const double display = 28;
  static const double hero = 34;
}

/// Durations shared by animations.
abstract final class AppDurations {
  static const fast = Duration(milliseconds: 200);
  static const medium = Duration(milliseconds: 350);
  static const flip = Duration(milliseconds: 650);
}
