import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_it.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('it'),
  ];

  /// No description provided for @appTitle.
  ///
  /// In it, this message translates to:
  /// **'Punchy'**
  String get appTitle;

  /// No description provided for @configErrorTitle.
  ///
  /// In it, this message translates to:
  /// **'Configurazione mancante'**
  String get configErrorTitle;

  /// No description provided for @configErrorMessage.
  ///
  /// In it, this message translates to:
  /// **'Il valore \"{key}\" non è impostato o non è valido. Avvia l\'app con --dart-define-from-file=env/dev.json.'**
  String configErrorMessage(String key);

  /// No description provided for @loginWelcome.
  ///
  /// In it, this message translates to:
  /// **'Bentornato'**
  String get loginWelcome;

  /// No description provided for @loginSubtitle.
  ///
  /// In it, this message translates to:
  /// **'Abbonamenti e tessere fedeltà, sempre con te.'**
  String get loginSubtitle;

  /// No description provided for @loginEmailLabel.
  ///
  /// In it, this message translates to:
  /// **'Email'**
  String get loginEmailLabel;

  /// No description provided for @loginPasswordLabel.
  ///
  /// In it, this message translates to:
  /// **'Password'**
  String get loginPasswordLabel;

  /// No description provided for @loginSubmit.
  ///
  /// In it, this message translates to:
  /// **'Accedi'**
  String get loginSubmit;

  /// No description provided for @loginShowPassword.
  ///
  /// In it, this message translates to:
  /// **'Mostra password'**
  String get loginShowPassword;

  /// No description provided for @loginHidePassword.
  ///
  /// In it, this message translates to:
  /// **'Nascondi password'**
  String get loginHidePassword;

  /// No description provided for @loginErrorInvalidEmail.
  ///
  /// In it, this message translates to:
  /// **'Inserisci un indirizzo email valido.'**
  String get loginErrorInvalidEmail;

  /// No description provided for @loginErrorPasswordTooShort.
  ///
  /// In it, this message translates to:
  /// **'La password deve avere almeno {min} caratteri.'**
  String loginErrorPasswordTooShort(int min);

  /// No description provided for @loginErrorInvalidCredentials.
  ///
  /// In it, this message translates to:
  /// **'Email o password non corrette.'**
  String get loginErrorInvalidCredentials;

  /// No description provided for @loginErrorNetwork.
  ///
  /// In it, this message translates to:
  /// **'Impossibile contattare il server. Controlla la connessione.'**
  String get loginErrorNetwork;

  /// No description provided for @loginErrorUnknown.
  ///
  /// In it, this message translates to:
  /// **'Qualcosa è andato storto. Riprova.'**
  String get loginErrorUnknown;

  /// No description provided for @loginDemoHint.
  ///
  /// In it, this message translates to:
  /// **'Modalità demo: qualsiasi email e una password di almeno 6 caratteri.'**
  String get loginDemoHint;

  /// No description provided for @cardsTitle.
  ///
  /// In it, this message translates to:
  /// **'Le mie tessere'**
  String get cardsTitle;

  /// No description provided for @cardsGreeting.
  ///
  /// In it, this message translates to:
  /// **'Ciao {name} 👋'**
  String cardsGreeting(String name);

  /// No description provided for @cardsGreetingAnonymous.
  ///
  /// In it, this message translates to:
  /// **'Ciao 👋'**
  String get cardsGreetingAnonymous;

  /// No description provided for @cardsEmpty.
  ///
  /// In it, this message translates to:
  /// **'Non hai ancora nessuna tessera.'**
  String get cardsEmpty;

  /// No description provided for @cardsError.
  ///
  /// In it, this message translates to:
  /// **'Non è stato possibile caricare le tessere.'**
  String get cardsError;

  /// No description provided for @cardsRetry.
  ///
  /// In it, this message translates to:
  /// **'Riprova'**
  String get cardsRetry;

  /// No description provided for @cardsLogout.
  ///
  /// In it, this message translates to:
  /// **'Esci'**
  String get cardsLogout;

  /// No description provided for @cardsProgressEntries.
  ///
  /// In it, this message translates to:
  /// **'{used} di {total} ingressi'**
  String cardsProgressEntries(int used, int total);

  /// No description provided for @cardsProgressMonths.
  ///
  /// In it, this message translates to:
  /// **'{used} di {total} mesi pagati'**
  String cardsProgressMonths(int used, int total);

  /// No description provided for @cardNumberLabel.
  ///
  /// In it, this message translates to:
  /// **'TESSERA N.'**
  String get cardNumberLabel;

  /// No description provided for @cardSurnameLabel.
  ///
  /// In it, this message translates to:
  /// **'COGNOME'**
  String get cardSurnameLabel;

  /// No description provided for @cardNameLabel.
  ///
  /// In it, this message translates to:
  /// **'NOME'**
  String get cardNameLabel;

  /// No description provided for @cardInfoLabel.
  ///
  /// In it, this message translates to:
  /// **'Info'**
  String get cardInfoLabel;

  /// No description provided for @cardEntriesHeader.
  ///
  /// In it, this message translates to:
  /// **'INGRESSI'**
  String get cardEntriesHeader;

  /// No description provided for @cardMonthlyHeader.
  ///
  /// In it, this message translates to:
  /// **'MENSILITÀ'**
  String get cardMonthlyHeader;

  /// No description provided for @cardDetailFront.
  ///
  /// In it, this message translates to:
  /// **'Fronte'**
  String get cardDetailFront;

  /// No description provided for @cardDetailBack.
  ///
  /// In it, this message translates to:
  /// **'Retro'**
  String get cardDetailBack;

  /// No description provided for @cardDetailFlipHint.
  ///
  /// In it, this message translates to:
  /// **'Tocca o scorri la tessera per girarla'**
  String get cardDetailFlipHint;

  /// No description provided for @cardDetailEntriesUsed.
  ///
  /// In it, this message translates to:
  /// **'Ingressi usati'**
  String get cardDetailEntriesUsed;

  /// No description provided for @cardDetailMonthsPaid.
  ///
  /// In it, this message translates to:
  /// **'Mesi pagati'**
  String get cardDetailMonthsPaid;

  /// No description provided for @cardDetailRemaining.
  ///
  /// In it, this message translates to:
  /// **'Rimanenti'**
  String get cardDetailRemaining;

  /// No description provided for @cardDetailValidUntil.
  ///
  /// In it, this message translates to:
  /// **'Valida fino al'**
  String get cardDetailValidUntil;

  /// No description provided for @cardDetailNoExpiry.
  ///
  /// In it, this message translates to:
  /// **'—'**
  String get cardDetailNoExpiry;

  /// No description provided for @cardDetailHistory.
  ///
  /// In it, this message translates to:
  /// **'Storico'**
  String get cardDetailHistory;

  /// No description provided for @cardDetailHistoryEmpty.
  ///
  /// In it, this message translates to:
  /// **'Nessun ingresso o pagamento registrato.'**
  String get cardDetailHistoryEmpty;

  /// No description provided for @cardDetailStampEntry.
  ///
  /// In it, this message translates to:
  /// **'Ingresso'**
  String get cardDetailStampEntry;

  /// No description provided for @cardDetailStampMonth.
  ///
  /// In it, this message translates to:
  /// **'Mensilità di {month}'**
  String cardDetailStampMonth(String month);

  /// No description provided for @cardDetailStampOperator.
  ///
  /// In it, this message translates to:
  /// **'Timbrato il {date} da {initials}'**
  String cardDetailStampOperator(String date, String initials);

  /// No description provided for @cardDetailStampDate.
  ///
  /// In it, this message translates to:
  /// **'Timbrato il {date}'**
  String cardDetailStampDate(String date);

  /// No description provided for @cardDetailError.
  ///
  /// In it, this message translates to:
  /// **'Tessera non disponibile.'**
  String get cardDetailError;

  /// No description provided for @cardsFilterAll.
  ///
  /// In it, this message translates to:
  /// **'Tutte'**
  String get cardsFilterAll;

  /// No description provided for @cardsFilterMemberships.
  ///
  /// In it, this message translates to:
  /// **'Abbonamenti'**
  String get cardsFilterMemberships;

  /// No description provided for @cardsFilterLoyalty.
  ///
  /// In it, this message translates to:
  /// **'Fedeltà'**
  String get cardsFilterLoyalty;

  /// No description provided for @cardsFilterEmpty.
  ///
  /// In it, this message translates to:
  /// **'Nessuna tessera in questa categoria.'**
  String get cardsFilterEmpty;

  /// No description provided for @cardsProgressLoyalty.
  ///
  /// In it, this message translates to:
  /// **'{used} di {total} timbri'**
  String cardsProgressLoyalty(int used, int total);

  /// No description provided for @cardsRewardReady.
  ///
  /// In it, this message translates to:
  /// **'Premio pronto!'**
  String get cardsRewardReady;

  /// No description provided for @cardLoyaltyHeader.
  ///
  /// In it, this message translates to:
  /// **'RACCOLTA TIMBRI'**
  String get cardLoyaltyHeader;

  /// No description provided for @cardRewardLabel.
  ///
  /// In it, this message translates to:
  /// **'PREMIO'**
  String get cardRewardLabel;

  /// No description provided for @cardDetailStampsCollected.
  ///
  /// In it, this message translates to:
  /// **'Timbri raccolti'**
  String get cardDetailStampsCollected;

  /// No description provided for @cardDetailToReward.
  ///
  /// In it, this message translates to:
  /// **'Al premio'**
  String get cardDetailToReward;

  /// No description provided for @cardDetailRewardTitle.
  ///
  /// In it, this message translates to:
  /// **'Il tuo premio'**
  String get cardDetailRewardTitle;

  /// No description provided for @cardDetailRewardProgress.
  ///
  /// In it, this message translates to:
  /// **'{count, plural, =1{Ancora 1 timbro} other{Ancora {count} timbri}}'**
  String cardDetailRewardProgress(int count);

  /// No description provided for @cardDetailRewardReady.
  ///
  /// In it, this message translates to:
  /// **'Premio sbloccato! Mostra la tessera in cassa.'**
  String get cardDetailRewardReady;

  /// No description provided for @cardDetailStampLoyalty.
  ///
  /// In it, this message translates to:
  /// **'Timbro'**
  String get cardDetailStampLoyalty;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'it'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'it':
      return AppLocalizationsIt();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
