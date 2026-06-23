import 'dart:io';

const _dartReservedWords = {
  'assert', 'break', 'case', 'catch', 'class', 'const', 'continue', 'default',
  'do', 'else', 'enum', 'extends', 'false', 'final', 'finally', 'for', 'if',
  'in', 'is', 'new', 'null', 'rethrow', 'return', 'super', 'switch', 'this',
  'throw', 'true', 'try', 'var', 'void', 'while', 'with', 'async', 'await',
  'yield', 'abstract', 'as', 'covariant', 'dynamic', 'export', 'external',
  'factory', 'Function', 'get', 'hide', 'implements', 'import', 'interface',
  'late', 'library', 'mixin', 'operator', 'part', 'required', 'set', 'show',
  'static', 'typedef',
};

void main(List<String> arguments) {
  print('');
  print('🚀 Feature Generator for Flutter Project');
  print('=========================================\n');

  if (arguments.isEmpty) {
    print('❌ Error: Feature name is required!');
    print('📝 Usage: dart generate_feature.dart <feature_name>');
    print('📝 Example: dart generate_feature.dart user_profile');
    exit(1);
  }

  final featureName = arguments[0];

  if (!RegExp(r'^[a-z][a-z0-9_]*$').hasMatch(featureName) || featureName.length < 2) {
    print('❌ Error: Feature name must be snake_case, start with a lowercase letter, min 2 chars.');
    print('📝 Example: dart generate_feature.dart user_profile');
    exit(1);
  }

  if (_dartReservedWords.contains(featureName)) {
    print('❌ Error: "$featureName" is a reserved Dart keyword. Choose a different name.');
    exit(1);
  }

  final featureNamePascal = toPascalCase(featureName);
  final featureNameCamel = toCamelCase(featureName);

  print('📦 Generating feature: $featureName');
  print('');

  try {
    final baseDir = Directory.current;
    final libPath = '${baseDir.path}${Platform.pathSeparator}lib';
    final featuresPath = '$libPath${Platform.pathSeparator}features';
    final featurePath = '$featuresPath${Platform.pathSeparator}$featureName';

    if (Directory(featurePath).existsSync()) {
      print('⚠️  Warning: Feature "$featureName" already exists!');
      print('❓ Do you want to overwrite it? (y/n): ');
      final response = stdin.readLineSync();
      if (response?.toLowerCase() != 'y') {
        print('❌ Operation cancelled.');
        exit(0);
      }
    }

    print('📁 Creating directory structure...');
    createDirectoryStructure(featurePath);

    print('');
    print('📄 Generating files...');
    generateFiles(featurePath, featureName, featureNamePascal, featureNameCamel);

    print('');
    print('✅ Feature "$featureName" generated successfully!');
    print('');
    print('📂 Feature location: $featurePath');
    print('');
    print('📌 Next steps:');
    print('   1. Update the entity model with your data fields');
    print('   2. Update the response model to match your API schema');
    print('   3. Update the HTTP impl endpoint URL (search TODO)');
    print('   4. Add AppRoutes.$featureNameCamel constant to lib/res/routes/app_routes.dart');
    print('   5. Add ${featureNamePascal}Pages.routes to lib/res/routes/app_pages.dart');
    print('');
  } catch (e) {
    print('');
    print('❌ Error generating feature: $e');
    exit(1);
  }
}

void createDirectoryStructure(String basePath) {
  final sep = Platform.pathSeparator;
  final directories = [
    '$basePath${sep}data${sep}model',
    '$basePath${sep}data${sep}repo_impl',
    '$basePath${sep}domain${sep}entity',
    '$basePath${sep}domain${sep}repo',
    '$basePath${sep}domain${sep}usecase',
    '$basePath${sep}presentation${sep}bindings',
    '$basePath${sep}presentation${sep}controller',
    '$basePath${sep}presentation${sep}screens',
  ];

  for (final dir in directories) {
    final directory = Directory(dir);
    if (!directory.existsSync()) {
      directory.createSync(recursive: true);
      print('   ✓ Created: ${_getRelativePath(dir)}');
    }
  }
}

void generateFiles(String basePath, String featureName, String featureNamePascal, String featureNameCamel) {
  final sep = Platform.pathSeparator;

  final files = {
    '$basePath${sep}domain${sep}entity$sep${featureName}_item.dart': generateEntityFile(featureName, featureNamePascal),
    '$basePath${sep}domain${sep}repo$sep${featureName}_repository.dart': generateRepositoryFile(featureName, featureNamePascal),
    '$basePath${sep}domain${sep}usecase$sep${featureName}_use_case.dart': generateUseCaseFile(featureName, featureNamePascal, featureNameCamel),
    '$basePath${sep}data${sep}model$sep${featureName}_list_response.dart': generateResponseModelFile(featureName, featureNamePascal),
    '$basePath${sep}data${sep}repo_impl$sep${featureName}_http_impl.dart': generateHttpImplFile(featureName, featureNamePascal, featureNameCamel),
    '$basePath${sep}data${sep}repo_impl$sep${featureName}_cache_impl.dart': generateCacheImplFile(featureName, featureNamePascal, featureNameCamel),
    '$basePath${sep}presentation${sep}controller$sep${featureName}_screen_controller.dart': generateControllerFile(featureName, featureNamePascal, featureNameCamel),
    '$basePath${sep}presentation${sep}screens$sep${featureName}_screen.dart': generateScreenFile(featureName, featureNamePascal, featureNameCamel),
    '$basePath${sep}presentation${sep}bindings$sep${featureName}_binding.dart': generateBindingFile(featureName, featureNamePascal, featureNameCamel),
    '$basePath${sep}presentation${sep}pages.dart': generatePagesFile(featureName, featureNamePascal, featureNameCamel),
  };

  for (final entry in files.entries) {
    File(entry.key).writeAsStringSync(entry.value);
    print('   ✓ ${_getRelativePath(entry.key)}');
  }
}

String generateEntityFile(String featureName, String featureNamePascal) {
  return '''class ${featureNamePascal}Item {
  final String? id;
  final String? name;
  // TODO: Add your entity fields here

  const ${featureNamePascal}Item({this.id, this.name});
}

class ${featureNamePascal}ItemList {
  final List<${featureNamePascal}Item> items;

  const ${featureNamePascal}ItemList({this.items = const []});
}
''';
}

String generateRepositoryFile(String featureName, String featureNamePascal) {
  return '''import 'package:customer/core/domain/usecase/usecase.dart';

import '../entity/${featureName}_item.dart';

abstract class ${featureNamePascal}Repository {
  ResultFuture<${featureNamePascal}ItemList> get${featureNamePascal}List();
}
''';
}

String generateUseCaseFile(String featureName, String featureNamePascal, String featureNameCamel) {
  return '''import 'package:dartz/dartz.dart';
import 'package:customer/core/domain/usecase/usecase.dart';

import '../entity/${featureName}_item.dart';
import '../repo/${featureName}_repository.dart';

class ${featureNamePascal}UseCase extends UseCaseWithoutParams<${featureNamePascal}ItemList> {
  final ${featureNamePascal}Repository _repo;

  ${featureNamePascal}UseCase(this._repo);

  @override
  ResultFuture<${featureNamePascal}ItemList> call() async {
    return _repo.get${featureNamePascal}List();
  }
}
''';
}

String generateResponseModelFile(String featureName, String featureNamePascal) {
  return '''class ${featureNamePascal}ListResponse {
  final bool? success;
  final List<${featureNamePascal}ItemData>? data;
  final dynamic errorMessage;

  const ${featureNamePascal}ListResponse({this.success, this.data, this.errorMessage});

  factory ${featureNamePascal}ListResponse.fromJson(Map<String, dynamic> json) {
    return ${featureNamePascal}ListResponse(
      success: json['Success'] as bool?,
      data: (json['Data'] as List<dynamic>?)
          ?.map((v) => ${featureNamePascal}ItemData.fromJson(v as Map<String, dynamic>))
          .toList(),
      errorMessage: json['ErrorMessage'],
    );
  }
}

class ${featureNamePascal}ItemData {
  final String? id;
  final String? name;
  // TODO: Add your API response fields here

  const ${featureNamePascal}ItemData({this.id, this.name});

  factory ${featureNamePascal}ItemData.fromJson(Map<String, dynamic> json) {
    return ${featureNamePascal}ItemData(
      id: json['id'] as String?,
      name: json['name'] as String?,
      // TODO: Map your fields from JSON
    );
  }
}
''';
}

String generateHttpImplFile(String featureName, String featureNamePascal, String featureNameCamel) {
  return '''import 'package:dartz/dartz.dart';
import 'package:customer/core/data/http/client/base_http_repository.dart';
import 'package:customer/core/domain/error/failure.dart';
import 'package:customer/core/domain/usecase/usecase.dart';

import '../../domain/entity/${featureName}_item.dart';
import '../../domain/repo/${featureName}_repository.dart';
import '../model/${featureName}_list_response.dart';

class ${featureNamePascal}HttpImpl extends BaseHttpRepository implements ${featureNamePascal}Repository {
  ${featureNamePascal}HttpImpl(super.client);

  @override
  ResultFuture<${featureNamePascal}ItemList> get${featureNamePascal}List() async {
    try {
      // TODO: Replace with your actual API endpoint URL
      final response = await client.authorizedGet('');
      if (response.messageCode == 200) {
        final listResponse = ${featureNamePascal}ListResponse.fromJson(
            response.response as Map<String, dynamic>);

        final items = (listResponse.data ?? [])
            .map((d) => ${featureNamePascal}Item(id: d.id, name: d.name))
            .toList();

        return Right(${featureNamePascal}ItemList(items: items));
      } else {
        return Left(ServerFailure(response.message ?? 'Failed to fetch data'));
      }
    } catch (e) {
      return Left(ConnectionFailure(e.toString()));
    }
  }
}
''';
}

String generateCacheImplFile(String featureName, String featureNamePascal, String featureNameCamel) {
  return '''import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:customer/core/data/cache/client/base_cache_repository.dart';
import 'package:customer/core/domain/domain_export.dart';
import 'package:customer/core/domain/usecase/usecase.dart';

import '../../domain/entity/${featureName}_item.dart';
import '../../domain/repo/${featureName}_repository.dart';
import '${featureName}_http_impl.dart';

class ${featureNamePascal}CacheImpl extends BaseCacheRepository implements ${featureNamePascal}Repository {
  static const _cacheKey = 'project:${featureName}';
  static const _cacheDuration = Duration(days: 1);

  final ${featureNamePascal}HttpImpl _remote;

  ${featureNamePascal}CacheImpl(super.cache, this._remote);

  @override
  ResultFuture<${featureNamePascal}ItemList> get${featureNamePascal}List() async {
    final cached = await cache.get(_cacheKey);
    if (cached != null) {
      final json = jsonDecode(cached) as List<dynamic>;
      final items = json
          .map((e) => ${featureNamePascal}Item(
                id: e['id'] as String?,
                name: e['name'] as String?,
              ))
          .toList();
      return Right(${featureNamePascal}ItemList(items: items));
    }
    return _fetchAndCache();
  }

  Future<Either<Failure, ${featureNamePascal}ItemList>> _fetchAndCache() async {
    final result = await _remote.get${featureNamePascal}List();
    if (result.isRight()) {
      final itemList = result.fold((l) => null, (r) => r)!;
      final json = itemList.items.map((e) => {'id': e.id, 'name': e.name}).toList();
      await cache.put(_cacheKey, jsonEncode(json), _cacheDuration);
    }
    return result;
  }
}
''';
}

String generateControllerFile(String featureName, String featureNamePascal, String featureNameCamel) {
  return '''import 'package:get/get.dart';
import 'package:customer/core/presentation/controllers/base_controller.dart';

import '../../domain/entity/${featureName}_item.dart';
import '../../domain/usecase/${featureName}_use_case.dart';

class ${featureNamePascal}ScreenController extends BaseController {
  final ${featureNamePascal}UseCase _useCase = Get.find<${featureNamePascal}UseCase>();

  final RxList<${featureNamePascal}Item> items = RxList();

  @override
  void onInit() {
    super.onInit();
    getData();
  }

  Future<void> getData() async {
    await doAction<${featureNamePascal}ItemList>(
      action: _useCase,
      onSuccess: (result) => items.assignAll(result.items),
    );
  }
}
''';
}

String generateScreenFile(String featureName, String featureNamePascal, String featureNameCamel) {
  return '''import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../domain/entity/${featureName}_item.dart';
import '../controller/${featureName}_screen_controller.dart';

class ${featureNamePascal}Screen extends StatelessWidget {
  const ${featureNamePascal}Screen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<${featureNamePascal}ScreenController>();
    return Scaffold(
      appBar: AppBar(
        title: const Text('${featureNamePascal}'),
      ),
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: controller.getData,
          child: Obx(() {
            if (controller.isLoading.value) {
              return const Center(child: CircularProgressIndicator());
            }
            if (controller.items.isEmpty) {
              return LayoutBuilder(builder: (context, box) {
                return SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  child: SizedBox(
                    height: box.maxHeight,
                    child: const Center(child: Text('No data found')),
                  ),
                );
              });
            }
            return _${featureNamePascal}List(items: controller.items);
          }),
        ),
      ),
    );
  }
}

class _${featureNamePascal}List extends StatelessWidget {
  const _${featureNamePascal}List({required this.items});
  final List<${featureNamePascal}Item> items;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: items.length,
      itemBuilder: (context, index) => _${featureNamePascal}ListTile(item: items[index]),
    );
  }
}

class _${featureNamePascal}ListTile extends StatelessWidget {
  const _${featureNamePascal}ListTile({required this.item});
  final ${featureNamePascal}Item item;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: Text(item.name ?? ''),
        subtitle: Text(item.id ?? ''),
        // TODO: Customize your list tile UI here
      ),
    );
  }
}
''';
}

String generateBindingFile(String featureName, String featureNamePascal, String featureNameCamel) {
  return '''import 'package:get/get.dart';
import 'package:customer/core/data/cache/client/preference_cache.dart';
import 'package:customer/core/data/http/client/api_client.dart';
import 'package:customer/features/$featureName/data/repo_impl/${featureName}_cache_impl.dart';
import 'package:customer/features/$featureName/data/repo_impl/${featureName}_http_impl.dart';
import 'package:customer/features/$featureName/domain/repo/${featureName}_repository.dart';
import 'package:customer/features/$featureName/domain/usecase/${featureName}_use_case.dart';
import 'package:customer/features/$featureName/presentation/controller/${featureName}_screen_controller.dart';

class ${featureNamePascal}Binding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<${featureNamePascal}HttpImpl>(
      () => ${featureNamePascal}HttpImpl(Get.find<ApiClient>()),
      fenix: true,
    );

    Get.lazyPut<${featureNamePascal}Repository>(
      () => ${featureNamePascal}CacheImpl(Get.find<PreferenceCache>(), Get.find<${featureNamePascal}HttpImpl>()),
      fenix: true,
    );

    Get.lazyPut<${featureNamePascal}UseCase>(
      () => ${featureNamePascal}UseCase(Get.find<${featureNamePascal}Repository>()),
      fenix: true,
    );

    Get.lazyPut<${featureNamePascal}ScreenController>(
      () => ${featureNamePascal}ScreenController(),
      fenix: true,
    );
  }
}
''';
}

String generatePagesFile(String featureName, String featureNamePascal, String featureNameCamel) {
  return '''import 'package:get/get.dart';
import 'package:customer/res/routes/app_routes.dart';

import 'bindings/${featureName}_binding.dart';
import 'screens/${featureName}_screen.dart';

class ${featureNamePascal}Pages {
  static final routes = [
    GetPage(
      name: AppRoutes.$featureNameCamel,
      page: () => const ${featureNamePascal}Screen(),
      binding: ${featureNamePascal}Binding(),
    ),
  ];
}
''';
}

String toPascalCase(String input) {
  return input
      .split('_')
      .map((word) => word.isEmpty ? '' : word[0].toUpperCase() + word.substring(1).toLowerCase())
      .join('');
}

String toCamelCase(String input) {
  final pascal = toPascalCase(input);
  return pascal.isEmpty ? '' : pascal[0].toLowerCase() + pascal.substring(1);
}

String _getRelativePath(String fullPath) {
  final parts = fullPath.split('${Platform.pathSeparator}lib${Platform.pathSeparator}');
  return parts.length > 1 ? 'lib${Platform.pathSeparator}${parts[1]}' : fullPath;
}
