# Punchy

Paper punch cards, gone digital: memberships (swimming pool, gym) and loyalty cards (cafés, shops,
hairdressers…). Login, a filterable list and an animated detail view with front and back (the stamp
grid for entries, monthly passes or points collection).

Spec: [`docs/specs/2026-09-30-tessere-digitali.md`](docs/specs/2026-09-30-tessere-digitali.md).
Architecture decisions: [`docs/DECISIONS.md`](docs/DECISIONS.md).

## Getting started

```bash
cp env/dev.json.example env/dev.json
flutter pub get
flutter run --dart-define-from-file=env/dev.json
```

`env/dev.json` sets `USE_MOCK_API=true`: login and cards are served by in-memory mocks. Any email
and a password of at least 6 characters will work; the password `sbagliata` simulates wrong
credentials. Without `--dart-define-from-file` the app shows a screen naming the missing key.

In Android Studio: *Run → Edit Configurations → Additional run args*:
`--dart-define-from-file=env/dev.json`. In VS Code the configuration is already in
`.vscode/launch.json`.

## Checks

```bash
dart analyze
flutter test
```

`test/architecture_test.dart` enforces the dependency direction in CI (no feature imports another
feature, internal layering, `core`/`shared` never import features).

## Structure

```
lib/
├── main.dart                composition root: config, dependencies, mock vs HTTP
├── app/                     MaterialApp, route table, config error screen
├── core/
│   ├── config/              AppConfig (dart-define, validated at startup)
│   ├── network/             shared ApiClient
│   ├── navigation/          route names
│   ├── services/            SessionStore (shared_preferences)
│   └── session/             Session, SessionController
├── shared/
│   ├── theme/               colours, spacing, radii, fonts, ThemeData
│   ├── ui/                  UiState<T>, formatters
│   └── widgets/             FlipCard (3D flip), MessageView
├── features/
│   ├── auth/                login
│   └── cards/               DigitalCard: filterable list, detail, front/back, reward, history
└── l10n/                    ARB it (template) + en
```

To connect the real backend: set `USE_MOCK_API=false` and `API_BASE_URL` in `env/<env>.json`. The
expected contracts are in the spec.
