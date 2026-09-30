import 'package:intl/intl.dart';

/// Display formatters. Each takes the locale tag of the current
/// `Localizations`, so formatting follows the language the user reads.
abstract final class Formatters {
  /// 15/09/2026
  static String shortDate(DateTime date, String locale) =>
      DateFormat('dd/MM/yyyy', locale).format(date);

  /// 15/09
  static String dayMonth(DateTime date, String locale) =>
      DateFormat('dd/MM', locale).format(date);

  /// SET, GEN, …
  static String monthAbbreviation(DateTime date, String locale) =>
      DateFormat.MMM(locale).format(date).replaceAll('.', '').toUpperCase();

  /// settembre 2026
  static String monthYear(DateTime date, String locale) =>
      DateFormat.yMMMM(locale).format(date);

  /// 45,00 €
  static String euroCents(int cents, String locale) =>
      NumberFormat.simpleCurrency(
        locale: locale,
        name: 'EUR',
      ).format(cents / 100);
}
