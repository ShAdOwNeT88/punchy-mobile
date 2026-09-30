import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:punchy/core/session/session.dart';

/// Persists the current session across app launches.
abstract interface class SessionStore {
  Future<Session?> read();
  Future<void> write(Session session);
  Future<void> clear();
}

class SharedPrefsSessionStore implements SessionStore {
  SharedPrefsSessionStore(this._prefs);

  final SharedPreferences _prefs;

  static const _key = 'session';

  @override
  Future<Session?> read() async {
    final raw = _prefs.getString(_key);
    if (raw == null) return null;
    try {
      return Session.fromJson(jsonDecode(raw) as Map<String, Object?>);
    } on Object {
      await clear();
      return null;
    }
  }

  @override
  Future<void> write(Session session) =>
      _prefs.setString(_key, jsonEncode(session.toJson()));

  @override
  Future<void> clear() => _prefs.remove(_key);
}

/// In-memory store, for tests and previews.
class InMemorySessionStore implements SessionStore {
  InMemorySessionStore([this._session]);

  Session? _session;

  @override
  Future<Session?> read() async => _session;

  @override
  Future<void> write(Session session) async => _session = session;

  @override
  Future<void> clear() async => _session = null;
}
