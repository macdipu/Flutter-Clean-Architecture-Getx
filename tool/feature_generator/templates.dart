const dartReservedWords = {
  'assert',
  'break',
  'case',
  'catch',
  'class',
  'const',
  'continue',
  'default',
  'do',
  'else',
  'enum',
  'extends',
  'false',
  'final',
  'finally',
  'for',
  'if',
  'in',
  'is',
  'new',
  'null',
  'rethrow',
  'return',
  'super',
  'switch',
  'this',
  'throw',
  'true',
  'try',
  'var',
  'void',
  'while',
  'with',
  'async',
  'await',
  'yield',
  'abstract',
  'as',
  'covariant',
  'dynamic',
  'export',
  'external',
  'factory',
  'Function',
  'get',
  'hide',
  'implements',
  'import',
  'interface',
  'late',
  'library',
  'mixin',
  'operator',
  'part',
  'required',
  'set',
  'show',
  'static',
  'typedef',
  'base',
  'deferred',
  'extension',
  'of',
  'on',
  'sealed',
  'sync',
  'type',
  'when',
};

String toPascalCase(String name) => name
    .split('_')
    .map((word) => '${word[0].toUpperCase()}${word.substring(1)}')
    .join();

Map<String, String> featureFiles(String name, String packageName) {
  final type = toPascalCase(name);
  return {
    for (final entry in _templates.entries)
      entry.key.replaceAll('@name', name): entry.value
          .replaceAll('@name', name)
          .replaceAll('@type', type)
          .replaceAll('@package', packageName),
  };
}

const _templates = <String, String>{
  'domain/entity/@name_item.dart': r'''
class @typeItem {
  final String? id;
  final String? name;

  const @typeItem({this.id, this.name});
}

class @typeItemList {
  final List<@typeItem> items;

  const @typeItemList({this.items = const []});
}
''',
  'domain/repo/@name_repository.dart': r'''
import 'package:@package/core/domain/usecase/usecase.dart';
import '../entity/@name_item.dart';

abstract class @typeRepository {
  ResultFuture<@typeItemList> get@typeList({bool forceRefresh = false});
}
''',
  'domain/usecase/@name_use_case.dart': r'''
import 'package:@package/core/domain/usecase/usecase.dart';
import '../entity/@name_item.dart';
import '../repo/@name_repository.dart';

class @typeUseCase extends UseCaseWithParams<@typeItemList, bool> {
  final @typeRepository _repo;

  const @typeUseCase(this._repo);

  @override
  ResultFuture<@typeItemList> call(bool forceRefresh) =>
      _repo.get@typeList(forceRefresh: forceRefresh);
}
''',
  'data/model/@name_list_response.dart': r'''
import '../../domain/entity/@name_item.dart';

class @typeListResponse {
  final bool? success;
  final List<@typeItemData> data;
  final String? errorMessage;

  const @typeListResponse({this.success, this.data = const [], this.errorMessage});

  factory @typeListResponse.fromJson(Map<String, dynamic> json) {
    // TODO: Adapt the response envelope to your API.
    return @typeListResponse(
      success: json['Success'] as bool?,
      data: (json['Data'] as List<dynamic>? ?? [])
          .map((item) => @typeItemData.fromJson(item as Map<String, dynamic>))
          .toList(),
      errorMessage: json['ErrorMessage'] as String?,
    );
  }
}

class @typeItemData {
  final String? id;
  final String? name;

  const @typeItemData({this.id, this.name});

  // TODO: Keep these mappings in sync when adding entity fields.
  factory @typeItemData.fromJson(Map<String, dynamic> json) =>
      @typeItemData(id: json['id'] as String?, name: json['name'] as String?);

  factory @typeItemData.fromEntity(@typeItem item) =>
      @typeItemData(id: item.id, name: item.name);

  Map<String, dynamic> toJson() => {'id': id, 'name': name};

  @typeItem toEntity() => @typeItem(id: id, name: name);
}
''',
  'data/repo_impl/@name_http_impl.dart': r'''
import 'package:dartz/dartz.dart';
import 'package:@package/core/data/http/client/base_http_repository.dart';
import 'package:@package/core/domain/error/failure.dart';
import 'package:@package/core/domain/usecase/usecase.dart';
import '../../domain/entity/@name_item.dart';
import '../../domain/repo/@name_repository.dart';
import '../model/@name_list_response.dart';

class @typeHttpImpl extends BaseHttpRepository implements @typeRepository {
  // TODO: Set an absolute API URL (ApiClient currently has no Dio baseUrl).
  static const _endpoint = '';

  @typeHttpImpl(super.client);

  @override
  ResultFuture<@typeItemList> get@typeList({bool forceRefresh = false}) async {
    if (_endpoint.isEmpty) {
      return const Left(ServerFailure('Configure the @name API endpoint.'));
    }
    try {
      final response = await client.authorizedGet(_endpoint);
      final code = response.messageCode ?? 0;
      if (code < 200 || code >= 300) {
        return Left(ServerFailure(response.message ?? 'Failed to fetch data'));
      }
      if (code == 204) return const Right(@typeItemList());
      final dto = @typeListResponse.fromJson(response.response as Map<String, dynamic>);
      if (dto.success == false) {
        return Left(ServerFailure(dto.errorMessage ?? 'Failed to fetch data'));
      }
      return Right(@typeItemList(items: dto.data.map((item) => item.toEntity()).toList()));
    } on FormatException {
      return const Left(ParsingFailure('The server returned invalid data.'));
    } on TypeError {
      return const Left(ParsingFailure('The server returned an unexpected data format.'));
    } on Object {
      return const Left(ConnectionFailure('Unable to load data. Please try again.'));
    }
  }
}
''',
  'data/repo_impl/@name_cache_impl.dart': r'''
import 'dart:convert';
import 'package:dartz/dartz.dart';
import 'package:@package/core/data/cache/client/base_cache_repository.dart';
import 'package:@package/core/domain/usecase/usecase.dart';
import '../../domain/entity/@name_item.dart';
import '../../domain/repo/@name_repository.dart';
import '../model/@name_list_response.dart';

class @typeCacheImpl extends BaseCacheRepository implements @typeRepository {
  static const _cacheKey = 'feature:@name:v1';
  static const _cacheDuration = Duration(days: 1);

  final @typeRepository _remote;

  @typeCacheImpl(super.cache, this._remote);

  @override
  ResultFuture<@typeItemList> get@typeList({bool forceRefresh = false}) async {
    if (!forceRefresh) {
      try {
        final cached = await cache.get(_cacheKey);
        if (cached != null) {
          final data = jsonDecode(cached) as List<dynamic>;
          return Right(@typeItemList(items: data
              .map((item) => @typeItemData.fromJson(item as Map<String, dynamic>).toEntity())
              .toList()));
        }
      } on Object {
        // A corrupt or unavailable cache must not prevent a remote fetch.
      }
    }
    final result = await _remote.get@typeList(forceRefresh: forceRefresh);
    return result.fold(
      (failure) => Left(failure),
      (items) async {
        try {
          final data = items.items.map((item) => @typeItemData.fromEntity(item).toJson()).toList();
          await cache.put(_cacheKey, jsonEncode(data), _cacheDuration);
        } on Object {
          // Cache persistence is best effort; fresh data is still usable.
        }
        return Right(items);
      },
    );
  }
}
''',
  'presentation/controller/@name_screen_controller.dart': r'''
import 'dart:async';
import 'package:get/get.dart';
import 'package:@package/core/presentation/controllers/base_controller.dart';
import 'package:@package/core/presentation/utils/state_status.dart';
import '../../domain/entity/@name_item.dart';
import '../../domain/usecase/@name_use_case.dart';

class @typeScreenController extends BaseController {
  final @typeUseCase _useCase = Get.find<@typeUseCase>();
  final items = <@typeItem>[].obs;

  @override
  void onInit() {
    super.onInit();
    unawaited(getData());
  }

  Future<void> refreshData() => getData(forceRefresh: true);

  Future<void> getData({bool forceRefresh = false}) async {
    if (isLoading.value) return;
    errorMessage.value = null;
    try {
      await doAction<@typeItemList>(
        action: () => _useCase(forceRefresh),
        onSuccess: (result) {
          if (isClosed) return;
          items.assignAll(result.items);
          status.value = items.isEmpty ? StateStatus.empty : StateStatus.success;
        },
        // The screen keeps an accessible inline error and retry action.
        onError: (_) {},
      );
    } on Object {
      if (!isClosed) {
        errorMessage.value = 'Unable to load data. Please try again.';
        status.value = StateStatus.error;
      }
    } finally {
      isLoading.value = false;
    }
  }
}
''',
  'presentation/screens/@name_screen.dart': r'''
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:@package/core/presentation/theme/app_dimensions.dart';
import '../controller/@name_screen_controller.dart';

class @typeScreen extends StatelessWidget {
  const @typeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<@typeScreenController>();
    return Scaffold(
      appBar: AppBar(title: const Text('@type')),
      body: SafeArea(
        child: Obx(() {
          final loading = controller.isLoading.value;
          final error = controller.errorMessage.value;
          // Copy the observable list while inside Obx to track list updates.
          final items = controller.items.toList();
          if (loading && items.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }
          return Column(
            children: [
              if (loading) const LinearProgressIndicator(),
              if (error != null)
                Semantics(
                  liveRegion: true,
                  child: Padding(
                    padding: AppDimens.spacing.p16,
                    child: Column(
                      children: [
                        Text(error, style: Theme.of(context).textTheme.bodyMedium),
                        FilledButton(
                          onPressed: loading ? null : controller.refreshData,
                          child: const Text('Retry'),
                        ),
                      ],
                    ),
                  ),
                ),
              Expanded(
                child: RefreshIndicator(
                  onRefresh: controller.refreshData,
                  child: CustomScrollView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    slivers: [
                      if (items.isEmpty)
                        SliverFillRemaining(
                          hasScrollBody: false,
                          child: Center(child: Text(error == null ? 'No data found' : 'Pull down to retry')),
                        )
                      else
                        SliverList(
                          delegate: SliverChildBuilderDelegate(
                            (context, index) {
                              final item = items[index];
                              return Card(
                                child: ListTile(
                                  title: Text(item.name ?? ''),
                                  subtitle: Text(item.id ?? ''),
                                ),
                              );
                            },
                            childCount: items.length,
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ],
          );
        }),
      ),
    );
  }
}
''',
  'presentation/bindings/@name_binding.dart': r'''
import 'package:get/get.dart';
import 'package:@package/core/data/cache/client/preference_cache.dart';
import 'package:@package/core/data/http/client/api_client.dart';
import '../../data/repo_impl/@name_cache_impl.dart';
import '../../data/repo_impl/@name_http_impl.dart';
import '../../domain/repo/@name_repository.dart';
import '../../domain/usecase/@name_use_case.dart';
import '../controller/@name_screen_controller.dart';

class @typeBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<@typeHttpImpl>(() => @typeHttpImpl(Get.find<ApiClient>()), fenix: true);
    Get.lazyPut<@typeRepository>(
      () => @typeCacheImpl(Get.find<PreferenceCache>(), Get.find<@typeHttpImpl>()),
      fenix: true,
    );
    Get.lazyPut<@typeUseCase>(() => @typeUseCase(Get.find<@typeRepository>()), fenix: true);
    Get.lazyPut<@typeScreenController>(() => @typeScreenController(), fenix: true);
  }
}
''',
  'presentation/pages.dart': r'''
import 'package:get/get.dart';
import 'bindings/@name_binding.dart';
import 'screens/@name_screen.dart';

class @typePages {
  static const routeName = '/@name';

  static final routes = [
    GetPage(
      name: routeName,
      page: () => const @typeScreen(),
      binding: @typeBinding(),
    ),
  ];
}
''',
};
