# Decisions

Declared choices at the variation points of the house Flutter architecture (Seshat), and any
declared deviations. Supersede entries; never erase them.

## 2026-09-30 — Declared choices

| Variation point | Choice |
|---|---|
| State management | House default: `provider` + `ChangeNotifier`. ViewModels created per screen with `ChangeNotifierProvider(create:)`; `SessionController` and repositories registered once in `MultiProvider` in `lib/main.dart`. |
| Navigation | House default: `Navigator` 1.0 with named routes. Names in `lib/core/navigation/routes.dart`, table in `lib/app/route_table.dart`. |
| Backend access | House default: one hand-written client, `lib/core/network/api_client.dart`; one abstract `*Service` per resource. |
| Mock backend | Every service has a `Mock*Service` next to its `Http*Service`, serving payloads in the backend's exact shape. `USE_MOCK_API` picks the binding at the composition root. The mocks go away once the backend is live; the interfaces stay. |
| Local persistence | House default: `shared_preferences` behind `SessionStore` (`lib/core/services/session_store.dart`). Only the session is persisted for now. |
| Model code generation | House default: hand-written `fromJson`. |
| Locales | `it` (template, `app_it.arb`) and `en`. |
| Environments | `dev` (mock API) and `prod`, one `env/<name>.json` each. |
| Persistent chrome | None. |
| Platforms and minimums | Android (`flutter.minSdkVersion`) and iOS 15.0. |

## 2026-09-30 — Session state lives in `core/session/`

Authentication state is a single instance built at the composition root, so it belongs in `core/`.
`core/session/` holds the `Session` value and the `SessionController`; persistence is in
`core/services/session_store.dart`. The `auth` feature starts a session; any feature may end it
(the card list signs out) without importing `auth`.

## 2026-09-30 — Cards are generic, not pool memberships

The first customer is a pool, but the product covers any stamped paper card, loyalty cards
included. The model is `DigitalCard` with an `Issuer` (category is cosmetic only) and a
`CardProgram` (`entries`, `monthly`, `loyalty`); holder, number and reward are optional. Anything
that names a business or a reward is content from the backend, never an ARB key. Supersedes the
`Facility` / `CardTracking` / `MembershipCard` naming of v0.1.
