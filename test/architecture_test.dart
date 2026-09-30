import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

/// Enforces the dependency direction of `docs/DECISIONS.md` /
/// house architecture in CI, independent of any agent tooling.
void main() {
  final files = Directory('lib')
      .listSync(recursive: true)
      .whereType<File>()
      .where((f) => f.path.endsWith('.dart'))
      .where((f) => !f.path.contains('${Platform.pathSeparator}l10n'))
      .toList();

  String rel(File f) => f.path.replaceAll(r'\', '/');

  List<String> imports(File f) => RegExp(
    r"^import 'package:punchy/([^']+)'",
    multiLine: true,
  ).allMatches(f.readAsStringSync()).map((m) => m.group(1)!).toList();

  String? featureOf(String path) =>
      RegExp(r'features/([^/]+)/').firstMatch(path)?.group(1);

  test('no feature imports another feature', () {
    final violations = <String>[];
    for (final f in files) {
      final own = featureOf(rel(f));
      if (own == null) continue;
      for (final i in imports(f)) {
        final target = featureOf(i);
        if (target != null && target != own) violations.add('${rel(f)} → $i');
      }
    }
    expect(violations, isEmpty);
  });

  test('core and shared never import features or app', () {
    final violations = [
      for (final f in files)
        if (rel(f).contains('lib/core/') || rel(f).contains('lib/shared/'))
          for (final i in imports(f))
            if (i.startsWith('features/') || i.startsWith('app/'))
              '${rel(f)} → $i',
    ];
    expect(violations, isEmpty);
  });

  test('shared never imports core', () {
    final violations = [
      for (final f in files)
        if (rel(f).contains('lib/shared/'))
          for (final i in imports(f))
            if (i.startsWith('core/')) '${rel(f)} → $i',
    ];
    expect(violations, isEmpty);
  });

  test('layering inside features', () {
    const banned = {
      'models': ['/services/', '/repository/', '/view_model/', '/widgets/'],
      'services': ['/view_model/', '/widgets/'],
      'repository': ['/view_model/', '/widgets/'],
      'view_model': ['/services/', '/widgets/'],
    };
    final violations = <String>[];
    for (final f in files) {
      final layer = RegExp(r'features/[^/]+/([^/]+)/')
          .firstMatch(rel(f))
          ?.group(1);
      final rules = banned[layer];
      if (rules == null) continue;
      for (final i in imports(f)) {
        if (rules.any(i.contains)) violations.add('${rel(f)} → $i');
      }
      final source = f.readAsStringSync();
      if (layer == 'view_model' &&
          RegExp(r"package:flutter/(material|widgets|cupertino)\.dart")
              .hasMatch(source)) {
        violations.add('${rel(f)} imports Flutter UI');
      }
      if (layer == 'models' && source.contains("package:flutter/")) {
        violations.add('${rel(f)} imports Flutter');
      }
    }
    expect(violations, isEmpty);
  });

  test('widgets other than screen roots never import services', () {
    final violations = [
      for (final f in files)
        if (rel(f).contains('/widgets/') && rel(f).contains('lib/features/'))
          for (final i in imports(f))
            if (i.contains('/services/') ||
                (i.contains('/repository/') &&
                    !rel(f).endsWith('_screen.dart')))
              '${rel(f)} → $i',
    ];
    expect(violations, isEmpty);
  });
}
