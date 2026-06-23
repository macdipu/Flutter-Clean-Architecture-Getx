import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:customer/app/flavours/app_config.dart';
import 'package:customer/res/routes/app_routes.dart';
import 'package:customer/res/strings/app_translations.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart' as getx;
import 'package:logger/logger.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

import '../../../domain/domain_export.dart';
import '../../cache/client/preference_cache.dart';
import '../../cache/preference/shared_preference_constants.dart';
import '../../dto/jwt.dart';
import '../urls/api_urls.dart';
import 'api_client_config.dart';
import 'resource.dart';

class ApiClient {
  final AppConfig _appConfig;
  final PreferenceCache _cache;
  final ApiUrl _url;
  final _logger = Logger();
  late final Dio _dio;

  JWT? _token;
  bool _isRefreshing = false;
  final List<Function> _refreshListeners = [];

  ApiClient(this._appConfig, this._cache, this._url) {
    _dio = Dio()
      ..interceptors.add(
        PrettyDioLogger(
          requestHeader: true,
          request: true,
          requestBody: true,
          responseBody: true,
          error: true,
          enabled: kDebugMode,
        ),
      );
    setToken();
  }

  ApiClientConfig get config => _appConfig.getApiClientConfig();

  bool hasToken() => _token != null;

  Future<void> setToken() async {
    final cached = await _cache.get(SharedPreferenceConstant.customerInfo);
    if (cached != null) {
      final json = jsonDecode(cached) as Map<String, dynamic>;
      _token = JWT(
        json['access_token'] as String? ?? '',
        json['refresh_token'] as String? ?? '',
      );
    }
  }

  JWT? getToken() => _token;

  void removeToken() {
    _token = null;
    _cache.flushAll().then((_) {
      getx.Get.offAllNamed(AppRoutes.login);
    });
  }

  Future<Resource> get(String uri, {Map<String, dynamic>? queryParams}) async {
    return _get(uri, false, queryParams);
  }

  Future<Resource> authorizedGet(String uri, {Map<String, dynamic>? queryParams}) async {
    return _handleAuthorizationError(() => _get(uri, true, queryParams));
  }

  Future<Resource> post(String uri, Map<String, dynamic> data) async {
    return _post(uri, false, data);
  }

  Future<Resource> authorizedPost(String uri, Map<String, dynamic> data, {bool? isFormData = false}) async {
    return _handleAuthorizationError(() => _post(uri, true, data, isFormData: isFormData));
  }

  Future<Resource> authorizedPut(String uri, Map<String, dynamic> data, {bool? isFormData = false}) async {
    final hasFile = _processFiles(data);
    return _getDataOrHandleDioError(() async {
      final options = await _makeOptions(true);
      return _dio.put(
        uri,
        data: hasFile || isFormData == true ? FormData.fromMap(data).clone() : data,
        options: options,
      );
    });
  }

  Future<Resource> delete(String uri) async {
    return _delete(uri, false);
  }

  Future<Resource> authorizedDelete(String uri) async {
    return _handleAuthorizationError(() => _delete(uri, true));
  }

  Future<Resource> _get(String uri, bool tokenize, Map<String, dynamic>? queryParams) async {
    return _getDataOrHandleDioError(() async {
      final options = await _makeOptions(tokenize);
      return _dio.get(uri, queryParameters: queryParams, options: options);
    });
  }

  Future<Resource> _post(String uri, bool tokenize, Map<String, dynamic>? data, {bool? isFormData}) async {
    final hasFile = data != null ? _processFiles(data) : false;
    return _getDataOrHandleDioError(() async {
      final options = await _makeOptions(tokenize);
      return _dio.post(
        uri,
        data: hasFile || isFormData == true ? FormData.fromMap(data!).clone() : data,
        options: options,
      );
    });
  }

  Future<Resource> _delete(String uri, bool tokenize) async {
    return _getDataOrHandleDioError(() async {
      final options = await _makeOptions(tokenize);
      return _dio.delete(uri, options: options);
    });
  }

  bool _processFiles(Map<String, dynamic> data) {
    bool hasFile = false;
    data.forEach((key, value) {
      if (value is List<File>) {
        data[key] = value.map((f) => MultipartFile.fromFileSync(f.path)).toList();
        hasFile = true;
      } else if (value is File) {
        data[key] = MultipartFile.fromFileSync(value.path);
        hasFile = true;
      }
    });
    return hasFile;
  }

  Future<Resource> _handleAuthorizationError(Function func) async {
    try {
      return await func();
    } on ApiException catch (e) {
      _logger.e('Authorization Error: ${e.code}, Message: ${e.message}');
      if (e.code == 401) return _handleUnauthorized(func);
      rethrow;
    }
  }

  Future<Resource> _getDataOrHandleDioError(Function func) async {
    try {
      final Response response = await func();
      final code = response.statusCode ?? 0;
      if (code >= 200 && code < 300) {
        return Resource(response: response.data, messageCode: code);
      } else if (code == 401) {
        throw UnauthorizedException('unauthorized exception');
      } else if (code == 403) {
        throw ForbiddenException('forbidden exception');
      } else if (code == 417) {
        throw UserDeactivatedException('UserDeactivatedException');
      } else if (code == 500) {
        return Resource(
          response: response.data ?? {'message': 'Internal Server Error'},
          message: 'Internal Server Error',
          messageCode: 500,
        );
      } else {
        return Resource(
          status: ResourceStatus.failed,
          messageCode: code,
          message: response.data != null ? response.data['message'] : 'Failed',
        );
      }
    } on DioException catch (error) {
      _logger.e(error.message, error: error, stackTrace: StackTrace.current);
      if (error.type == DioExceptionType.sendTimeout) {
        throw Exception('Connection timeout exception');
      }
      if (error.type == DioExceptionType.connectionError) {
        throw const SocketException('No internet');
      }
      if (error.response == null) {
        throw RepositoryUnavailableException(error.message);
      }
      return Resource(
        status: ResourceStatus.failed,
        message: error.message,
        response: error.response,
      );
    }
  }

  Future<Options> _makeOptions(bool tokenize) async {
    final version = await _cache.get(SharedPreferenceConstant.version);
    var headers = _buildHeaders(version: version);
    if (tokenize) headers = await _addAuthHeader(headers);
    return Options(
      headers: headers,
      sendTimeout: const Duration(milliseconds: 60000),
      receiveTimeout: const Duration(milliseconds: 30000),
      followRedirects: false,
      validateStatus: (status) => status! <= 500,
    );
  }

  Map<String, dynamic> _buildHeaders({String? version}) {
    return {
      'Accept': 'application/json',
      'Platform': Platform.isIOS ? 'ios' : 'android',
      'Accept-language': getx.Get.locale?.languageCode ?? AppTranslations.supportedLocales.first.languageCode,
      'Version': version,
    };
  }

  Future<Map<String, dynamic>> _addAuthHeader(Map<String, dynamic> headers) async {
    final token = await _getValidToken();
    headers['authorization'] = 'Bearer ${token.getToken()}';
    return headers;
  }

  Future<JWT> _getValidToken() async {
    if (_token == null) throw ArgumentError.notNull('Token');
    if (_token!.isAlive()) return _token!;
    await _handleUnauthorized(null);
    return _token!;
  }

  Future<Resource> _handleUnauthorized(Function? originalRequest) async {
    if (!_isRefreshing) {
      _isRefreshing = true;
      try {
        await _refreshToken();
        _isRefreshing = false;
        for (final listener in _refreshListeners) {
          listener();
        }
        _refreshListeners.clear();
        if (originalRequest != null) return await originalRequest();
        return Resource(messageCode: 200);
      } catch (e) {
        _isRefreshing = false;
        _refreshListeners.clear();
        removeToken();
        rethrow;
      }
    } else {
      return _waitForRefresh(originalRequest);
    }
  }

  Future<Resource> _waitForRefresh(Function? originalRequest) {
    final completer = Completer<Resource>();
    _refreshListeners.add(() async {
      try {
        if (originalRequest != null) {
          completer.complete(await originalRequest());
        } else {
          completer.complete(Resource(messageCode: 200));
        }
      } catch (e) {
        completer.completeError(e);
      }
    });
    return completer.future;
  }

  Future<void> _refreshToken() async {
    final refreshToken = getToken()?.getRefreshToken();
    final response = await post(_url.refreshTokenUrl, {'refresh_token': refreshToken});
    if (response.messageCode == 200) {
      final data = response.response as Map<String, dynamic>;
      final newAccess = data['access_token'] as String? ?? '';
      final newRefresh = data['refresh_token'] as String? ?? '';

      final cached = await _cache.get(SharedPreferenceConstant.customerInfo);
      final json = cached != null ? (jsonDecode(cached) as Map<String, dynamic>) : <String, dynamic>{};
      json['access_token'] = newAccess;
      json['refresh_token'] = newRefresh;
      await _cache.forever(SharedPreferenceConstant.customerInfo, jsonEncode(json));
      await setToken();
    } else {
      throw ApiException(response.messageCode ?? 400, response.message ?? 'Failed to refresh token');
    }
  }
}
