import 'package:flutter_test/flutter_test.dart';
import 'package:punchy/core/config/app_config.dart';
import 'package:punchy/core/services/session_store.dart';
import 'package:punchy/core/session/session.dart';
import 'package:punchy/core/session/session_controller.dart';

import 'helpers.dart';

void main() {
  group('AppConfig.parse', () {
    test('accepts a valid configuration', () {
      final config = AppConfig.parse({
        AppConfig.apiBaseUrlKey: 'https://api.example.com/v1/',
        AppConfig.useMockApiKey: 'true',
      });
      expect(config.apiBaseUrl.host, 'api.example.com');
      expect(config.useMockApi, isTrue);
    });

    test('names a missing base URL', () {
      expect(
        () => AppConfig.parse({AppConfig.useMockApiKey: 'false'}),
        throwsA(
          isA<ConfigException>().having(
            (e) => e.key,
            'key',
            AppConfig.apiBaseUrlKey,
          ),
        ),
      );
    });

    test('names an invalid mock flag', () {
      expect(
        () => AppConfig.parse({
          AppConfig.apiBaseUrlKey: 'https://api.example.com/',
          AppConfig.useMockApiKey: 'yes',
        }),
        throwsA(
          isA<ConfigException>().having(
            (e) => e.key,
            'key',
            AppConfig.useMockApiKey,
          ),
        ),
      );
    });
  });

  group('Session', () {
    test('round-trips through JSON', () {
      expect(Session.fromJson(testSession.toJson()), testSession);
    });

    test('rejects a payload without token', () {
      expect(
        () => Session.fromJson({'user': <String, Object?>{}}),
        throwsFormatException,
      );
    });

    test('tolerates a missing user object', () {
      final s = Session.fromJson({'token': 'abc'});
      expect(s.firstName, isEmpty);
    });
  });

  test('SessionController persists start and end', () async {
    final store = InMemorySessionStore();
    final controller = SessionController(store);
    await controller.start(testSession);
    expect(controller.isAuthenticated, isTrue);
    expect(await store.read(), testSession);

    await controller.end();
    expect(controller.isAuthenticated, isFalse);
    expect(await store.read(), isNull);
  });
}
