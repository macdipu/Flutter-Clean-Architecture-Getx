import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

import '../../generate_feature.dart' as generator;

void main() {
  final root = Directory.current;
  final originalPackageName = generator.readPackageName(root);
  final configFile = File('${root.path}/.dart_tool/package_config.json');
  final config =
      jsonDecode(configFile.readAsStringSync()) as Map<String, dynamic>;
  final packages = config['packages'] as List<dynamic>;
  final flutterPackage = packages.cast<Map<String, dynamic>>().singleWhere(
        (package) => package['name'] == 'flutter',
      );
  final flutterRoot = Directory.fromUri(
    configFile.uri.resolve(flutterPackage['rootUri'] as String),
  ).parent.parent;
  final dart =
      '${flutterRoot.path}/bin/cache/dart-sdk/bin/dart${Platform.isWindows ? '.exe' : ''}';
  final flutter =
      '${flutterRoot.path}/bin/flutter${Platform.isWindows ? '.bat' : ''}';
  final script = '${root.path}/generate_feature.dart';
  late Directory fixture;

  setUp(() {
    fixture = Directory.systemTemp.createTempSync('getx-generator-test-');
    fixture = Directory(fixture.resolveSymbolicLinksSync());
    File('${fixture.path}/pubspec.yaml')
        .writeAsStringSync('''name: renamed_template
publish_to: none
environment:
  sdk: '>=3.2.3 <4.0.0'
dependencies:
  flutter:
    sdk: flutter
dev_dependencies:
  flutter_test:
    sdk: flutter
flutter:
  uses-material-design: true
''');
    final marker = File('${fixture.path}/lib/core/domain/usecase/usecase.dart');
    marker.parent.createSync(recursive: true);
    marker.writeAsStringSync('');
  });

  tearDown(() => fixture.deleteSync(recursive: true));

  Future<ProcessResult> run(List<String> args) => Process.run(
        dart,
        [script, ...args],
        workingDirectory: fixture.path,
      );

  test('accepts quoted package names and comments', () {
    File('${fixture.path}/pubspec.yaml').writeAsStringSync(
      'name: "another_app" # project name\n',
    );
    expect(generator.readPackageName(fixture), 'another_app');
  });

  test('rejects invalid, ambiguous, reserved and traversal names', () {
    for (final name in [
      'a',
      '../escape',
      'bad__name',
      'bad_',
      '2bad',
      'class',
      'bad_1name',
      'BadName'
    ]) {
      expect(() => generator.validateFeatureName(name), throwsFormatException);
    }
    expect(
        () => generator.validateFeatureName('user_profile2'), returnsNormally);
  });

  test('dry-run makes no feature files and invalid options fail', () async {
    final result = await run(['sample_items', '--dry-run']);
    expect(result.exitCode, 0, reason: '${result.stderr}');
    expect(result.stdout, contains('renamed_template'));
    expect(Directory('${fixture.path}/lib/features').existsSync(), isFalse);
    for (final args in <List<String>>[
      [],
      ['sample_items', '--unknown'],
      ['one', 'two']
    ]) {
      expect((await run(args)).exitCode, isNot(0));
    }
  });

  test('wrong project root fails without writing files', () async {
    File('${fixture.path}/pubspec.yaml').deleteSync();
    final result = await run(['sample_items']);
    expect(result.exitCode, isNot(0));
    expect(Directory('${fixture.path}/lib/features').existsSync(), isFalse);
  });

  test('requires force for overwrite and preserves unrelated files', () async {
    expect((await run(['sample_items'])).exitCode, 0);
    final entity = File(
        '${fixture.path}/lib/features/sample_items/domain/entity/sample_items_item.dart');
    entity.writeAsStringSync('// customized');
    final extra = File('${entity.parent.path}/custom.dart')
      ..writeAsStringSync('// keep');
    expect((await run(['sample_items'])).exitCode, isNot(0));
    expect(entity.readAsStringSync(), '// customized');
    expect((await run(['sample_items', '--force'])).exitCode, 0);
    expect(entity.readAsStringSync(), contains('class SampleItemsItem'));
    expect(extra.readAsStringSync(), '// keep');
  });

  test('refuses writes through symbolic links even with force', () async {
    final outside = Directory('${fixture.path}/outside')..createSync();
    final features = Directory('${fixture.path}/lib/features')..createSync();
    Link('${features.path}/sample_items').createSync(outside.path);
    expect((await run(['sample_items', '--force'])).exitCode, isNot(0));
    expect(outside.listSync(), isEmpty);
  },
      skip: Platform.isWindows
          ? 'Creating symlinks requires Windows privileges.'
          : false);

  test('renamed project output analyzes and passes behavior/widget tests',
      () async {
    // Reuse installed packages without a network resolution or modifying this repo.
    for (final entity
        in Directory('${root.path}/lib').listSync(recursive: true)) {
      if (entity is! File || !entity.path.endsWith('.dart')) continue;
      final relative = entity.path.substring('${root.path}/'.length);
      final target = File('${fixture.path}/$relative');
      target.parent.createSync(recursive: true);
      target.writeAsStringSync(entity.readAsStringSync().replaceAll(
          'package:$originalPackageName/', 'package:renamed_template/'));
    }
    final fixtureConfig =
        jsonDecode(jsonEncode(config)) as Map<String, dynamic>;
    for (final entry in fixtureConfig['packages'] as List<dynamic>) {
      final package = entry as Map<String, dynamic>;
      if (package['name'] == originalPackageName) {
        package['name'] = 'renamed_template';
        package['rootUri'] = fixture.uri.toString();
      } else {
        package['rootUri'] =
            configFile.uri.resolve(package['rootUri'] as String).toString();
      }
    }
    final targetConfig = File('${fixture.path}/.dart_tool/package_config.json');
    targetConfig.parent.createSync(recursive: true);
    targetConfig.writeAsStringSync(jsonEncode(fixtureConfig));
    final graphFile = File('${root.path}/.dart_tool/package_graph.json');
    if (graphFile.existsSync()) {
      File('${fixture.path}/.dart_tool/package_graph.json').writeAsStringSync(
        graphFile.readAsStringSync().replaceAll(
              jsonEncode(originalPackageName),
              jsonEncode('renamed_template'),
            ),
      );
    }
    File('${fixture.path}/analysis_options.yaml').writeAsStringSync(
      File('${root.path}/analysis_options.yaml').readAsStringSync(),
    );
    final generated = await run(['sample_items']);
    expect(generated.exitCode, 0, reason: '${generated.stderr}');
    final featurePath = '${fixture.path}/lib/features/sample_items';
    expect(
        Directory(featurePath)
            .listSync(recursive: true)
            .whereType<File>()
            .length,
        10);
    final analyzed = await Process.run(
        dart, ['analyze', '--fatal-infos', featurePath],
        workingDirectory: fixture.path);
    expect(analyzed.exitCode, 0,
        reason: '${analyzed.stdout}\n${analyzed.stderr}');
    final formatted = await Process.run(
        dart, ['format', '--output=none', '--set-exit-if-changed', featurePath],
        workingDirectory: fixture.path);
    expect(formatted.exitCode, 0,
        reason: '${formatted.stdout}\n${formatted.stderr}');
    final tests = File('${fixture.path}/test/generated_feature_test.dart');
    tests.parent.createSync(recursive: true);
    tests.writeAsStringSync(File(
            '${root.path}/test/tool/fixtures/generated_feature_checks.dart.txt')
        .readAsStringSync());
    final checked = await Process.run(
        flutter, ['test', '--no-pub', '--reporter', 'expanded'],
        workingDirectory: fixture.path);
    expect(checked.exitCode, 0, reason: '${checked.stdout}\n${checked.stderr}');
  }, timeout: const Timeout(Duration(minutes: 3)));
}
