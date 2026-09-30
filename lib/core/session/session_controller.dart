import 'package:flutter/foundation.dart';
import 'package:punchy/core/services/session_store.dart';
import 'package:punchy/core/session/session.dart';

/// Single owner of the authentication state. Created at the composition root.
class SessionController extends ChangeNotifier {
  SessionController(this._store);

  final SessionStore _store;
  Session? _current;

  Session? get current => _current;
  bool get isAuthenticated => _current != null;
  String? get token => _current?.token;

  /// Restores a session persisted by a previous launch.
  Future<void> restore() async {
    _current = await _store.read();
    notifyListeners();
  }

  Future<void> start(Session session) async {
    await _store.write(session);
    _current = session;
    notifyListeners();
  }

  Future<void> end() async {
    await _store.clear();
    _current = null;
    notifyListeners();
  }
}
