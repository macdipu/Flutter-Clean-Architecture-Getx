import 'dart:io';

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
  final featureNamePascal = toPascalCase(featureName);
  final featureNameCamel = toCamelCase(featureName);

  print('📦 Generating feature: $featureName');
  print('');

  try {
    final baseDir = Directory.current;
    final libPath = '${baseDir.path}${Platform.pathSeparator}lib';
    final featuresPath = '$libPath${Platform.pathSeparator}features';
    final featurePath = '$featuresPath${Platform.pathSeparator}$featureName';

    // Check if feature already exists
    if (Directory(featurePath).existsSync()) {
      print('⚠️  Warning: Feature "$featureName" already exists!');
      print('❓ Do you want to overwrite it? (y/n): ');
      final response = stdin.readLineSync();
      if (response?.toLowerCase() != 'y') {
        print('❌ Operation cancelled.');
        exit(0);
      }
    }

    // Create directory structure
    print('📁 Creating directory structure...');
    createDirectoryStructure(featurePath, featureName);

    // Generate files
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
    print('   2. Update the response model to match your API');
    print('   3. Update the repository implementation with your API endpoints');
    print('   4. Register the binding in your routes');
    print('');
    print('📖 For detailed instructions, see:');
    print('   • QUICK_START_CHEAT_SHEET.md - Fast 4-step guide');
    print('   • FEATURE_SETUP_GUIDE.md - Complete walkthrough with examples');
    print('');
    print('🎉 Happy coding!');
    print('');
  } catch (e) {
    print('');
    print('❌ Error generating feature: $e');
    exit(1);
  }
}

void createDirectoryStructure(String basePath, String featureName) {
  final directories = [
    '$basePath${Platform.pathSeparator}data${Platform.pathSeparator}model',
    '$basePath${Platform.pathSeparator}data${Platform.pathSeparator}repo_impl',
    '$basePath${Platform.pathSeparator}domain${Platform.pathSeparator}entity',
    '$basePath${Platform.pathSeparator}domain${Platform.pathSeparator}repo',
    '$basePath${Platform.pathSeparator}domain${Platform.pathSeparator}usecase',
    '$basePath${Platform.pathSeparator}presentation${Platform.pathSeparator}bindings',
    '$basePath${Platform.pathSeparator}presentation${Platform.pathSeparator}controller',
    '$basePath${Platform.pathSeparator}presentation${Platform.pathSeparator}screens',
  ];

  for (var dir in directories) {
    final directory = Directory(dir);
    if (!directory.existsSync()) {
      directory.createSync(recursive: true);
      print('   ✓ Created: ${_getRelativePath(dir)}');
    }
  }
}

void generateFiles(String basePath, String featureName, String featureNamePascal, String featureNameCamel) {
  final sep = Platform.pathSeparator;

  // 1. Entity
  final entityPath = '$basePath${sep}domain${sep}entity$sep${featureName}_item.dart';
  File(entityPath).writeAsStringSync(generateEntityFile(featureName, featureNamePascal));
  print('   ✓ ${_getRelativePath(entityPath)}');

  // 2. Repository Interface
  final repoPath = '$basePath${sep}domain${sep}repo$sep${featureName}_repository.dart';
  File(repoPath).writeAsStringSync(generateRepositoryFile(featureName, featureNamePascal));
  print('   ✓ ${_getRelativePath(repoPath)}');

  // 3. Use Case
  final useCasePath = '$basePath${sep}domain${sep}usecase$sep${featureName}_use_case.dart';
  File(useCasePath).writeAsStringSync(generateUseCaseFile(featureName, featureNamePascal, featureNameCamel));
  print('   ✓ ${_getRelativePath(useCasePath)}');

  // 4. Response Model
  final modelPath = '$basePath${sep}data${sep}model${sep}item_list_response.dart';
  File(modelPath).writeAsStringSync(generateResponseModelFile(featureName, featureNamePascal));
  print('   ✓ ${_getRelativePath(modelPath)}');

  // 5. HTTP Implementation
  final httpImplPath = '$basePath${sep}data${sep}repo_impl$sep${featureName}_http_impl.dart';
  File(httpImplPath).writeAsStringSync(generateHttpImplFile(featureName, featureNamePascal, featureNameCamel));
  print('   ✓ ${_getRelativePath(httpImplPath)}');

  // 6. Cache Implementation
  final cacheImplPath = '$basePath${sep}data${sep}repo_impl$sep${featureName}_cache_impl.dart';
  File(cacheImplPath).writeAsStringSync(generateCacheImplFile(featureName, featureNamePascal, featureNameCamel));
  print('   ✓ ${_getRelativePath(cacheImplPath)}');

  // 7. Controller
  final controllerPath = '$basePath${sep}presentation${sep}controller$sep${featureName}_screen_controller.dart';
  File(controllerPath).writeAsStringSync(generateControllerFile(featureName, featureNamePascal, featureNameCamel));
  print('   ✓ ${_getRelativePath(controllerPath)}');

  // 8. Screen
  final screenPath = '$basePath${sep}presentation${sep}screens$sep${featureName}_screen.dart';
  File(screenPath).writeAsStringSync(generateScreenFile(featureName, featureNamePascal, featureNameCamel));
  print('   ✓ ${_getRelativePath(screenPath)}');

  // 9. Binding
  final bindingPath = '$basePath${sep}presentation${sep}bindings$sep${featureName}_binding.dart';
  File(bindingPath).writeAsStringSync(generateBindingFile(featureName, featureNamePascal, featureNameCamel));
  print('   ✓ ${_getRelativePath(bindingPath)}');

  // 10. Pages
  final pagesPath = '$basePath${sep}presentation${sep}pages.dart';
  File(pagesPath).writeAsStringSync(generatePagesFile(featureName, featureNamePascal, featureNameCamel));
  print('   ✓ ${_getRelativePath(pagesPath)}');
}

String generateEntityFile(String featureName, String featureNamePascal) {
  return '''import 'dart:convert';

class ${featureNamePascal}Item {
  String? id;
  String? name;
  // TODO: Add your entity fields here

  ${featureNamePascal}Item({this.id, this.name});

  ${featureNamePascal}Item.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    // TODO: Map your fields from JSON
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    // TODO: Map your fields to JSON
    return data;
  }
}

class ${featureNamePascal}ItemList {
  List<${featureNamePascal}Item>? ${featureName}Items;

  ${featureNamePascal}ItemList({this.${featureName}Items});

  factory ${featureNamePascal}ItemList.fromDynamicList(List<dynamic> list) {
    var items = <${featureNamePascal}Item>[];
    for (var item in list) {
      items.add(${featureNamePascal}Item.fromJson(item));
    }
    return ${featureNamePascal}ItemList(${featureName}Items: items);
  }

  List<dynamic> toDynamicList() {
    var items = [];
    for (var item in ${featureName}Items!) {
      items.add(item.toJson());
    }
    return items;
  }

  String toJson() {
    return jsonEncode(toDynamicList());
  }

  factory ${featureNamePascal}ItemList.fromJson(String json) {
    return ${featureNamePascal}ItemList.fromDynamicList(jsonDecode(json));
  }
}
''';
}

String generateRepositoryFile(String featureName, String featureNamePascal) {
  return '''import 'package:aminul_haque/core/domain/usecase/usecase.dart';

import '../entity/${featureName}_item.dart';

abstract class ${featureNamePascal}Repository {
  ResultFuture<${featureNamePascal}ItemList> get${featureNamePascal}List();
}
''';
}

String generateUseCaseFile(String featureName, String featureNamePascal, String featureNameCamel) {
  return '''import 'package:dartz/dartz.dart';
import '../entity/${featureName}_item.dart';
import '../repo/${featureName}_repository.dart';
import 'package:aminul_haque/core/domain/usecase/usecase.dart';

class ${featureNamePascal}UseCase extends UseCaseWithoutParams<${featureNamePascal}ItemList> {
  final ${featureNamePascal}Repository _repo;

  ${featureNamePascal}UseCase(this._repo);

  @override
  ResultFuture<${featureNamePascal}ItemList> call() async {
    var result = await _repo.get${featureNamePascal}List();

    return result.fold(
      (l) => Left(l),
      (r) => Right(${featureNamePascal}ItemList(${featureName}Items: r.${featureName}Items)),
    );
  }
}
''';
}

String generateResponseModelFile(String featureName, String featureNamePascal) {
  return '''class ItemListResponse {
  ItemListResponse({
    bool? success,
    List<ItemData>? data,
    dynamic errorMessage,
  }) {
    _success = success;
    _data = data;
    _errorMessage = errorMessage;
  }

  ItemListResponse.fromJson(dynamic json) {
    _success = json['Success'];
    if (json['Data'] != null) {
      _data = [];
      json['Data'].forEach((v) {
        _data?.add(ItemData.fromJson(v));
      });
    }
    _errorMessage = json['ErrorMessage'];
  }

  bool? _success;
  List<ItemData>? _data;
  dynamic _errorMessage;

  ItemListResponse copyWith({
    bool? success,
    List<ItemData>? data,
    dynamic errorMessage,
  }) =>
      ItemListResponse(
        success: success ?? _success,
        data: data ?? _data,
        errorMessage: errorMessage ?? _errorMessage,
      );

  bool? get success => _success;
  List<ItemData>? get data => _data;
  dynamic get errorMessage => _errorMessage;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['Success'] = _success;
    if (_data != null) {
      map['Data'] = _data?.map((v) => v.toJson()).toList();
    }
    map['ErrorMessage'] = _errorMessage;
    return map;
  }
}

class ItemData {
  ItemData({
    String? name,
    String? id,
  }) {
    _name = name;
    _id = id;
  }

  ItemData.fromJson(dynamic json) {
    _name = json['name'];
    _id = json['id'];
    // TODO: Add your API response fields here
  }

  String? _name;
  String? _id;

  ItemData copyWith({
    String? name,
    String? id,
  }) =>
      ItemData(
        name: name ?? _name,
        id: id ?? _id,
      );

  String? get name => _name;
  String? get id => _id;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['name'] = _name;
    map['id'] = _id;
    // TODO: Add your API response fields here
    return map;
  }
}
''';
}

String generateHttpImplFile(String featureName, String featureNamePascal, String featureNameCamel) {
  return '''import 'package:aminul_haque/core/domain/usecase/usecase.dart';
import 'package:dartz/dartz.dart';
import 'package:logger/logger.dart';

import '../../../../core/data/http/client/base_http_repository.dart';
import '../../../../core/data/http/urls/api_urls.dart';
import '../../../../core/domain/error/failure.dart';
import '../../domain/entity/${featureName}_item.dart';
import '../../domain/repo/${featureName}_repository.dart';
import '../model/item_list_response.dart';

class ${featureNamePascal}HttpImpl extends BaseHttpRepository implements ${featureNamePascal}Repository {
  late final ApiUrl urls;

  ${featureNamePascal}HttpImpl(super.client, this.urls);

  @override
  ResultFuture<${featureNamePascal}ItemList> get${featureNamePascal}List() async {
    try {
      // TODO: Update with your API endpoint
      final response = await client.authorizedGet(urls.getAllTrade);
      if (response.messageCode == 200) {
        ItemListResponse itemList = ItemListResponse.fromJson(response.response);

        List<${featureNamePascal}Item> list = [];
        for (var item in itemList.data!) {
          list.add(${featureNamePascal}Item(
            id: item.id,
            name: item.name,
            // TODO: Map your fields here
          ));

          Logger().i(item.name);
        }

        return Right(${featureNamePascal}ItemList(${featureName}Items: list));
      } else {
        return const Left(ConnectionFailure("Failed to fetch data"));
      }
    } catch (e) {
      return Left(ConnectionFailure(e.toString()));
    }
  }
}
''';
}

String generateCacheImplFile(String featureName, String featureNamePascal, String featureNameCamel) {
  return '''import 'package:aminul_haque/core/domain/usecase/usecase.dart';
import 'package:dartz/dartz.dart';

import '../../../../core/data/cache/client/base_cache_repository.dart';
import '../../../../core/domain/domain_export.dart';
import '../../domain/entity/${featureName}_item.dart';
import '../../domain/repo/${featureName}_repository.dart';
import '${featureName}_http_impl.dart';

class ${featureNamePascal}CacheImpl extends BaseCacheRepository implements ${featureNamePascal}Repository {
  static const cacheKey = "project:${featureName}";

  final ${featureNamePascal}HttpImpl _repo;

  ${featureNamePascal}CacheImpl(super.cache, this._repo);

  @override
  ResultFuture<${featureNamePascal}ItemList> get${featureNamePascal}List() async {
    String? value = await cache.get(cacheKey);
    if (value == null) {
      return _getFromSourceAndSave();
    }

    return Right(${featureNamePascal}ItemList.fromJson(value));
  }

  ResultFuture<${featureNamePascal}ItemList> _getFromSourceAndSave() async {
    Either<Failure, ${featureNamePascal}ItemList> items = await _repo.get${featureNamePascal}List();

    if (items.isRight()) {
      ${featureNamePascal}ItemList? itemList = items.fold((l) => null, (r) => r);
      cache.put(cacheKey, itemList!.toJson(), const Duration(days: 1));
    }

    return items;
  }
}
''';
}

String generateControllerFile(String featureName, String featureNamePascal, String featureNameCamel) {
  return '''import 'package:get/get.dart';

import '../../../../core/presentation/widgets/snackbar/custom_snackbar.dart';
import '../../domain/entity/${featureName}_item.dart';
import '../../domain/usecase/${featureName}_use_case.dart';

class ${featureNamePascal}ScreenController extends GetxController {
  final ${featureNamePascal}UseCase ${featureNameCamel}UseCase = Get.find<${featureNamePascal}UseCase>();

  final RxBool isLoading = false.obs;
  final RxList<${featureNamePascal}Item> items = RxList();

  ${featureNamePascal}ScreenController() {
    getData();
  }

  Future<void> getData() async {
    if (isLoading.value) return;

    isLoading.value = true;

    final result = await ${featureNameCamel}UseCase();
    result.fold(
      (failure) => CustomSnackbar.error(failure.message),
      (r) => items.assignAll(r.${featureName}Items ?? []),
    );

    isLoading.value = false;
  }
}
''';
}

String generateScreenFile(String featureName, String featureNamePascal, String featureNameCamel) {
  return '''import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../domain/entity/${featureName}_item.dart';
import '../controller/${featureName}_screen_controller.dart';

class ${featureNamePascal}Screen extends StatefulWidget {
  const ${featureNamePascal}Screen({super.key});

  @override
  State<${featureNamePascal}Screen> createState() => _${featureNamePascal}ScreenState();
}

class _${featureNamePascal}ScreenState extends State<${featureNamePascal}Screen> {
  final ${featureNamePascal}ScreenController _controller = Get.put(${featureNamePascal}ScreenController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('${featureNamePascal}'),
      ),
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: _controller.getData,
          child: Obx(
            () {
              if (_controller.items.isEmpty) {
                if (_controller.isLoading.value) {
                  return const Center(child: CircularProgressIndicator());
                }

                return LayoutBuilder(builder: (context, box) {
                  return SingleChildScrollView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    child: Container(
                      constraints: BoxConstraints(minHeight: box.maxHeight),
                      alignment: Alignment.center,
                      child: const Text('No data found'),
                    ),
                  );
                });
              }

              return _List();
            },
          ),
        ),
      ),
    );
  }
}

class _List extends StatelessWidget {
  _List();

  final ${featureNamePascal}ScreenController _controller = Get.find();

  @override
  Widget build(BuildContext context) {
    final List<${featureNamePascal}Item> items = _controller.items;
    return ListView.builder(
      itemCount: items.length,
      itemBuilder: (context, index) => _ListTile(item: items[index]),
    );
  }
}

class _ListTile extends StatelessWidget {
  const _ListTile({required this.item});
  final ${featureNamePascal}Item item;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Name: \${item.name}"),
            const SizedBox(height: 2),
            Text("ID: \${item.id}"),
            // TODO: Add your UI fields here
          ],
        ),
      ),
    );
  }
}
''';
}

String generateBindingFile(String featureName, String featureNamePascal, String featureNameCamel) {
  return '''import 'package:get/get.dart';
import 'package:aminul_haque/features/${featureName}/data/repo_impl/${featureName}_cache_impl.dart';
import 'package:aminul_haque/features/${featureName}/data/repo_impl/${featureName}_http_impl.dart';
import 'package:aminul_haque/features/${featureName}/domain/repo/${featureName}_repository.dart';
import 'package:aminul_haque/features/${featureName}/domain/usecase/${featureName}_use_case.dart';
import 'package:aminul_haque/features/${featureName}/presentation/controller/${featureName}_screen_controller.dart';
import 'package:aminul_haque/core/data/http/client/api_client.dart';
import 'package:aminul_haque/core/data/http/urls/api_urls.dart';
import 'package:aminul_haque/core/data/cache/client/preference_cache.dart';

class ${featureNamePascal}Binding extends Bindings {
  @override
  void dependencies() {
    // Put ${featureNamePascal}HttpImpl
    Get.lazyPut<${featureNamePascal}HttpImpl>(
      () => ${featureNamePascal}HttpImpl(Get.find<ApiClient>(), Get.find<ApiUrl>()),
      fenix: true,
    );

    // Put ${featureNamePascal}Repository as ${featureNamePascal}CacheImpl
    Get.lazyPut<${featureNamePascal}Repository>(
      () => ${featureNamePascal}CacheImpl(Get.find<PreferenceCache>(), Get.find<${featureNamePascal}HttpImpl>()),
      fenix: true,
    );

    // Put ${featureNamePascal}UseCase
    Get.lazyPut<${featureNamePascal}UseCase>(
      () => ${featureNamePascal}UseCase(Get.find<${featureNamePascal}Repository>()),
      fenix: true,
    );

    // Put ${featureNamePascal}ScreenController
    Get.lazyPut<${featureNamePascal}ScreenController>(
      () => ${featureNamePascal}ScreenController(),
      fenix: true,
    );
  }
}
''';
}

String generatePagesFile(String featureName, String featureNamePascal, String featureNameCamel) {
  return '''import 'package:aminul_haque/features/${featureName}/presentation/screens/${featureName}_screen.dart';
import 'package:get/get.dart';

import '../../../res/routes/app_routes.dart';
import 'bindings/${featureName}_binding.dart';

class ${featureNamePascal}Pages {
  static final routes = [
    GetPage(
      name: AppRoutes.${featureNameCamel},
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

