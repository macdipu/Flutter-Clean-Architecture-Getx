import 'dart:convert';
import 'dart:io';

import 'tool/feature_generator/templates.dart';

const _usage =
    '''Usage: dart generate_feature.dart <snake_case_name> [--dry-run] [--force]

Run from the template project root after installing dependencies.
  --dry-run  List the files without writing anything.
  --force    Replace generated files in an existing feature; keep other files.
  --help     Show this help.
''';

void main(List<String> arguments) {
  try {
    if (arguments.length == 1 && arguments.single == '--help') {
      stdout.write(_usage);
      return;
    }
    final names = arguments.where((arg) => !arg.startsWith('--')).toList();
    final unknown = arguments.where(
      (arg) => arg.startsWith('--') && arg != '--dry-run' && arg != '--force',
    );
    if (names.length != 1 || unknown.isNotEmpty) {
      throw const FormatException(_usage);
    }

    final root = Directory.current;
    final name = names.single;
    validateFeatureName(name);
    final package = readPackageName(root);
    final files = featureFiles(name, package);
    final target = Directory('${root.path}/lib/features/$name');
    if (FileSystemEntity.typeSync(target.path, followLinks: false) !=
            FileSystemEntityType.notFound &&
        !arguments.contains('--force')) {
      throw StateError(
          'Feature "$name" already exists. Use --force to replace generated files.');
    }
    // Do not follow links when overwriting generated files.
    for (final relative in files.keys) {
      var path = root.path;
      for (final segment in 'lib/features/$name/$relative'.split('/')) {
        path = '$path/$segment';
        if (FileSystemEntity.isLinkSync(path)) {
          throw StateError('Refusing to write through a symbolic link: $path');
        }
      }
    }
    if (arguments.contains('--dry-run')) {
      stdout.writeln('Would generate ${files.length} files for $package:');
      for (final path in files.keys) {
        stdout.writeln('  lib/features/$name/$path');
      }
      return;
    }

    // Validate and format every template before touching the destination.
    final staging = Directory.systemTemp.createTempSync('getx-feature-');
    try {
      File('${staging.path}/pubspec.yaml').writeAsStringSync(
        File('${root.path}/pubspec.yaml').readAsStringSync(),
      );
      final analysisOptions = File('${root.path}/analysis_options.yaml');
      if (analysisOptions.existsSync()) {
        File('${staging.path}/analysis_options.yaml').writeAsStringSync(
          'include: ${jsonEncode(analysisOptions.path)}\n',
        );
      }
      // Preserve the project's language version when formatting outside its root.
      final configFile = File('${root.path}/.dart_tool/package_config.json');
      if (configFile.existsSync()) {
        final config =
            jsonDecode(configFile.readAsStringSync()) as Map<String, dynamic>;
        for (final entry in config['packages'] as List<dynamic>) {
          final dependency = entry as Map<String, dynamic>;
          dependency['rootUri'] = dependency['name'] == package
              ? staging.uri.toString()
              : configFile.uri
                  .resolve(dependency['rootUri'] as String)
                  .toString();
        }
        final stagedConfig =
            File('${staging.path}/.dart_tool/package_config.json');
        stagedConfig.parent.createSync(recursive: true);
        stagedConfig.writeAsStringSync(jsonEncode(config));
      }
      for (final entry in files.entries) {
        final file = File('${staging.path}/${entry.key}');
        file.parent.createSync(recursive: true);
        file.writeAsStringSync(entry.value);
      }
      final formatted = Process.runSync(Platform.resolvedExecutable, [
        'format',
        ...files.keys.map((path) => '${staging.path}/$path'),
      ]);
      if (formatted.exitCode != 0) {
        throw StateError(
            'Generated code could not be formatted: ${formatted.stderr}');
      }
      for (final path in files.keys) {
        final file = File('${target.path}/$path');
        file.parent.createSync(recursive: true);
        file.writeAsStringSync(
            File('${staging.path}/$path').readAsStringSync());
      }
    } finally {
      staging.deleteSync(recursive: true);
    }
    final type = toPascalCase(name);
    stdout.writeln('Generated ${files.length} files in lib/features/$name.');
    stdout.writeln('Next steps:');
    stdout.writeln(
        '  1. Configure the endpoint in data/repo_impl/${name}_http_impl.dart.');
    stdout.writeln('  2. Update the entity and DTO mappings in data/model/.');
    stdout.writeln(
        '  3. Import ${type}Pages and spread ...${type}Pages.routes in AppPages.routes.');
    stdout.writeln('  4. Navigate with Get.toNamed(${type}Pages.routeName).');
  } on Object catch (error) {
    stderr.writeln('Feature generation failed: $error');
    exitCode = 1;
  }
}

String readPackageName(Directory root) {
  final pubspec = File('${root.path}/pubspec.yaml');
  if (!pubspec.existsSync() ||
      !File('${root.path}/lib/core/domain/usecase/usecase.dart').existsSync()) {
    throw StateError(
        'Run from the template project root (pubspec.yaml and lib/core are required).');
  }
  final match = RegExp(
    r'''^name:\s*([a-z][a-z0-9_]*|'[a-z][a-z0-9_]*'|"[a-z][a-z0-9_]*")\s*(?:#.*)?$''',
    multiLine: true,
  ).firstMatch(pubspec.readAsStringSync());
  if (match == null) {
    throw const FormatException(
        'pubspec.yaml must declare a valid top-level package name.');
  }
  return match.group(1)!.replaceAll(RegExp('[\'\"]'), '');
}

void validateFeatureName(String name) {
  if (!RegExp(r'^[a-z][a-z0-9]*(?:_[a-z][a-z0-9]*)*$').hasMatch(name) ||
      name.length < 2 ||
      dartReservedWords.contains(name)) {
    throw const FormatException(
      'Use a non-reserved snake_case name of at least two characters, such as user_profile.',
    );
  }
}
