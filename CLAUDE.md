# Punchy — agent instructions

Flutter 3.47 / Dart 3.13, Android (flutter.minSdkVersion) + iOS 15.0. Locales: `it` (template) and
`en`.

The project follows the Seshat house Flutter architecture (`seshat-flutter` plugin:
`flutter-architecture`, `flutter-feature`, `flutter-review`). Declared choices are in
`docs/DECISIONS.md`; product behaviour in `docs/specs/`.

## Rules that are easy to miss

- Features never import each other; navigate by the names in `lib/core/navigation/routes.dart`.
- Every I/O call lives in a `services/` class behind an abstract interface, with a `Mock*` and an
  `Http*` implementation bound in `lib/main.dart` according to `USE_MOCK_API`.
- No hex colours or raw dimensions outside `lib/shared/theme/`; no user-facing string literals —
  add keys to both `lib/l10n/app_it.arb` and `app_en.arb`, then `flutter gen-l10n`.
- `package:` imports only.

## Templates by shape

- Form screen with a sealed state: `features/auth`.
- List + detail over one resource, with mock and HTTP services: `features/cards`.

## Domain

Cards are generic (`DigitalCard`): an `Issuer` of any category and a `CardProgram` (`entries`,
`monthly`, `loyalty`), drawn in a `CardDesign` (`gradient`, `paper`) with a `StampStyle` (`round`,
`signature`). Never special-case a category or an issuer in behaviour; business names and rewards are
backend content, not ARB keys. See `docs/specs/2026-09-30-tessere-digitali.md`.

## Run and check

```bash
flutter run --dart-define-from-file=env/dev.json
dart analyze
flutter test
```

No custom platform channels.
