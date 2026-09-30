# Punchy

Le tessere cartacee da timbrare, in digitale: abbonamenti (piscina, palestra) e tessere fedeltà
(bar, negozi, parrucchieri…). Login, lista con filtri e dettaglio animato con
fronte e retro (la griglia dei timbri di ingressi, mensilità o raccolta punti).

Specifica: [`docs/specs/2026-09-30-tessere-digitali.md`](docs/specs/2026-09-30-tessere-digitali.md).
Scelte architetturali: [`docs/DECISIONS.md`](docs/DECISIONS.md).

## Avvio

```bash
cp env/dev.json.example env/dev.json
flutter pub get
flutter run --dart-define-from-file=env/dev.json
```

`env/dev.json` ha `USE_MOCK_API=true`: login e tessere sono serviti da mock in memoria.
Qualsiasi email e una password di almeno 6 caratteri funzionano; la password `sbagliata` simula
credenziali errate. Senza `--dart-define-from-file` l'app mostra una schermata che nomina la chiave
mancante.

In Android Studio: *Run → Edit Configurations → Additional run args*:
`--dart-define-from-file=env/dev.json`. In VS Code la configurazione è già in `.vscode/launch.json`.

## Verifiche

```bash
dart analyze
flutter test
```

`test/architecture_test.dart` fa rispettare in CI la direzione delle dipendenze (nessuna feature
importa un'altra feature, layering interno, `core`/`shared` che non importano feature).

## Struttura

```
lib/
├── main.dart                composition root: config, dipendenze, mock vs HTTP
├── app/                     MaterialApp, route table, schermata di errore config
├── core/
│   ├── config/              AppConfig (dart-define, validato all'avvio)
│   ├── network/             ApiClient condiviso
│   ├── navigation/          nomi delle route
│   ├── services/            SessionStore (shared_preferences)
│   └── session/             Session, SessionController
├── shared/
│   ├── theme/               colori, spaziature, raggi, font, ThemeData
│   ├── ui/                  UiState<T>, formatter
│   └── widgets/             FlipCard (flip 3D), MessageView
├── features/
│   ├── auth/                login
│   └── cards/               DigitalCard: lista con filtri, dettaglio, fronte/retro, premio, storico
└── l10n/                    ARB it (template) + en
```

Per collegare il backend reale: `USE_MOCK_API=false` e `API_BASE_URL` in `env/<env>.json`. I
contratti attesi sono nella specifica.
