// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Italian (`it`).
class AppLocalizationsIt extends AppLocalizations {
  AppLocalizationsIt([String locale = 'it']) : super(locale);

  @override
  String get appTitle => 'Punchy';

  @override
  String get configErrorTitle => 'Configurazione mancante';

  @override
  String configErrorMessage(String key) {
    return 'Il valore \"$key\" non è impostato o non è valido. Avvia l\'app con --dart-define-from-file=env/dev.json.';
  }

  @override
  String get loginWelcome => 'Bentornato';

  @override
  String get loginSubtitle => 'Abbonamenti e tessere fedeltà, sempre con te.';

  @override
  String get loginEmailLabel => 'Email';

  @override
  String get loginPasswordLabel => 'Password';

  @override
  String get loginSubmit => 'Accedi';

  @override
  String get loginShowPassword => 'Mostra password';

  @override
  String get loginHidePassword => 'Nascondi password';

  @override
  String get loginErrorInvalidEmail => 'Inserisci un indirizzo email valido.';

  @override
  String loginErrorPasswordTooShort(int min) {
    return 'La password deve avere almeno $min caratteri.';
  }

  @override
  String get loginErrorInvalidCredentials => 'Email o password non corrette.';

  @override
  String get loginErrorNetwork =>
      'Impossibile contattare il server. Controlla la connessione.';

  @override
  String get loginErrorUnknown => 'Qualcosa è andato storto. Riprova.';

  @override
  String get loginDemoHint =>
      'Modalità demo: qualsiasi email e una password di almeno 6 caratteri.';

  @override
  String get cardsTitle => 'Le mie tessere';

  @override
  String cardsGreeting(String name) {
    return 'Ciao $name 👋';
  }

  @override
  String get cardsGreetingAnonymous => 'Ciao 👋';

  @override
  String get cardsEmpty => 'Non hai ancora nessuna tessera.';

  @override
  String get cardsError => 'Non è stato possibile caricare le tessere.';

  @override
  String get cardsRetry => 'Riprova';

  @override
  String get cardsLogout => 'Esci';

  @override
  String cardsProgressEntries(int used, int total) {
    return '$used di $total ingressi';
  }

  @override
  String cardsProgressMonths(int used, int total) {
    return '$used di $total mesi pagati';
  }

  @override
  String get cardNumberLabel => 'TESSERA N.';

  @override
  String get cardSurnameLabel => 'COGNOME';

  @override
  String get cardNameLabel => 'NOME';

  @override
  String get cardInfoLabel => 'Info';

  @override
  String get cardEntriesHeader => 'INGRESSI';

  @override
  String get cardMonthlyHeader => 'MENSILITÀ';

  @override
  String get cardDetailFront => 'Fronte';

  @override
  String get cardDetailBack => 'Retro';

  @override
  String get cardDetailFlipHint => 'Tocca o scorri la tessera per girarla';

  @override
  String get cardDetailEntriesUsed => 'Ingressi usati';

  @override
  String get cardDetailMonthsPaid => 'Mesi pagati';

  @override
  String get cardDetailRemaining => 'Rimanenti';

  @override
  String get cardDetailValidUntil => 'Valida fino al';

  @override
  String get cardDetailNoExpiry => '—';

  @override
  String get cardDetailHistory => 'Storico';

  @override
  String get cardDetailHistoryEmpty =>
      'Nessun ingresso o pagamento registrato.';

  @override
  String get cardDetailStampEntry => 'Ingresso';

  @override
  String cardDetailStampMonth(String month) {
    return 'Mensilità di $month';
  }

  @override
  String cardDetailStampOperator(String date, String initials) {
    return 'Timbrato il $date da $initials';
  }

  @override
  String cardDetailStampDate(String date) {
    return 'Timbrato il $date';
  }

  @override
  String get cardDetailError => 'Tessera non disponibile.';

  @override
  String get cardsFilterAll => 'Tutte';

  @override
  String get cardsFilterMemberships => 'Abbonamenti';

  @override
  String get cardsFilterLoyalty => 'Fedeltà';

  @override
  String get cardsFilterEmpty => 'Nessuna tessera in questa categoria.';

  @override
  String cardsProgressLoyalty(int used, int total) {
    return '$used di $total timbri';
  }

  @override
  String get cardsRewardReady => 'Premio pronto!';

  @override
  String get cardLoyaltyHeader => 'RACCOLTA TIMBRI';

  @override
  String get cardRewardLabel => 'PREMIO';

  @override
  String get cardDetailStampsCollected => 'Timbri raccolti';

  @override
  String get cardDetailToReward => 'Al premio';

  @override
  String get cardDetailRewardTitle => 'Il tuo premio';

  @override
  String cardDetailRewardProgress(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Ancora $count timbri',
      one: 'Ancora 1 timbro',
    );
    return '$_temp0';
  }

  @override
  String get cardDetailRewardReady =>
      'Premio sbloccato! Mostra la tessera in cassa.';

  @override
  String get cardDetailStampLoyalty => 'Timbro';
}
