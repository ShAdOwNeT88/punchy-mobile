// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Punchy';

  @override
  String get configErrorTitle => 'Missing configuration';

  @override
  String configErrorMessage(String key) {
    return 'The value \"$key\" is missing or invalid. Run the app with --dart-define-from-file=env/dev.json.';
  }

  @override
  String get loginWelcome => 'Welcome back';

  @override
  String get loginSubtitle => 'Memberships and loyalty cards, always with you.';

  @override
  String get loginEmailLabel => 'Email';

  @override
  String get loginPasswordLabel => 'Password';

  @override
  String get loginSubmit => 'Sign in';

  @override
  String get loginShowPassword => 'Show password';

  @override
  String get loginHidePassword => 'Hide password';

  @override
  String get loginErrorInvalidEmail => 'Enter a valid email address.';

  @override
  String loginErrorPasswordTooShort(int min) {
    return 'The password must be at least $min characters long.';
  }

  @override
  String get loginErrorInvalidCredentials => 'Wrong email or password.';

  @override
  String get loginErrorNetwork =>
      'Cannot reach the server. Check your connection.';

  @override
  String get loginErrorUnknown => 'Something went wrong. Please try again.';

  @override
  String get loginDemoHint =>
      'Demo mode: any email and a password of at least 6 characters.';

  @override
  String get cardsTitle => 'My cards';

  @override
  String cardsGreeting(String name) {
    return 'Hi $name 👋';
  }

  @override
  String get cardsGreetingAnonymous => 'Hi 👋';

  @override
  String get cardsEmpty => 'You don\'t have any card yet.';

  @override
  String get cardsError => 'Your cards could not be loaded.';

  @override
  String get cardsRetry => 'Retry';

  @override
  String get cardsLogout => 'Sign out';

  @override
  String cardsProgressEntries(int used, int total) {
    return '$used of $total entries';
  }

  @override
  String cardsProgressMonths(int used, int total) {
    return '$used of $total months paid';
  }

  @override
  String get cardNumberLabel => 'CARD NO.';

  @override
  String get cardSurnameLabel => 'SURNAME';

  @override
  String get cardNameLabel => 'NAME';

  @override
  String get cardInfoLabel => 'Info';

  @override
  String get cardEntriesHeader => 'ENTRIES';

  @override
  String get cardMonthlyHeader => 'MONTHLY FEES';

  @override
  String get cardDetailFront => 'Front';

  @override
  String get cardDetailBack => 'Back';

  @override
  String get cardDetailFlipHint => 'Tap or swipe the card to flip it';

  @override
  String get cardDetailEntriesUsed => 'Entries used';

  @override
  String get cardDetailMonthsPaid => 'Months paid';

  @override
  String get cardDetailRemaining => 'Remaining';

  @override
  String get cardDetailValidUntil => 'Valid until';

  @override
  String get cardDetailNoExpiry => '—';

  @override
  String get cardDetailHistory => 'History';

  @override
  String get cardDetailHistoryEmpty => 'No entries or payments recorded yet.';

  @override
  String get cardDetailStampEntry => 'Entry';

  @override
  String cardDetailStampMonth(String month) {
    return '$month fee';
  }

  @override
  String cardDetailStampOperator(String date, String initials) {
    return 'Stamped on $date by $initials';
  }

  @override
  String cardDetailStampDate(String date) {
    return 'Stamped on $date';
  }

  @override
  String get cardDetailError => 'Card not available.';

  @override
  String get cardsFilterAll => 'All';

  @override
  String get cardsFilterMemberships => 'Memberships';

  @override
  String get cardsFilterLoyalty => 'Loyalty';

  @override
  String get cardsFilterEmpty => 'No cards in this category.';

  @override
  String cardsProgressLoyalty(int used, int total) {
    return '$used of $total stamps';
  }

  @override
  String get cardsRewardReady => 'Reward ready!';

  @override
  String get cardLoyaltyHeader => 'STAMP CARD';

  @override
  String get cardRewardLabel => 'REWARD';

  @override
  String get cardDetailStampsCollected => 'Stamps collected';

  @override
  String get cardDetailToReward => 'To reward';

  @override
  String get cardDetailRewardTitle => 'Your reward';

  @override
  String cardDetailRewardProgress(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count stamps to go',
      one: '1 stamp to go',
    );
    return '$_temp0';
  }

  @override
  String get cardDetailRewardReady =>
      'Reward unlocked! Show the card at the counter.';

  @override
  String get cardDetailStampLoyalty => 'Stamp';
}
