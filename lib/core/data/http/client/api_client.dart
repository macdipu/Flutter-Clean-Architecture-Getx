import 'dart:async';
import 'dart:io';
import 'package:clean_architecture_getx/app/flavours/app_config.dart';
import 'package:clean_architecture_getx/res/strings/app_translations.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart' as getx;
import 'package:logger/logger.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

import '../../../../features/authentication/data/model/auth_login_response.dart';
import '../../../../features/authentication/domain/model/user_info.dart';
import '../../../../features/welcome/presentation/splash/screen/splash_screen.dart';
import '../../../domain/domain_export.dart';
import '../../cache/client/preference_cache.dart';
import '../../cache/preference/shared_preference_constants.dart';
import '../../dto/jwt.dart';
import '../urls/api_urls.dart';
import 'api_client_config.dart';
import 'resource.dart';

const bool canShowLog = kDebugMode;

final _dio = Dio()
  ..interceptors.add(
    PrettyDioLogger(
      requestHeader: true,
      request: true,
      requestBody: true,
      responseBody: true,
      error: true,
      enabled: canShowLog,
    ),
  );

class ApiClient extends getx.GetxController {
  final AppConfig _appConfig = getx.Get.find();
  final PreferenceCache _cache = getx.Get.find();
  final ApiUrl url = ApiUrl();

  JWT? _token;
  Logger _logger = Logger();

  ApiClient() {
    setToken();
  }

  ApiClientConfig get config => _appConfig.getApiClientConfig();

  bool hasToken() {
    return _token != null;
  }

  Future<void> setToken() async {
    var userInfo = await _cache.get(SharedPreferenceConstant.customerInfo);

    if (userInfo != null) {
      UserInfo info = UserInfo.fromJsonString(userInfo);
      _token = JWT(info.accessToken, info.refreshToken ?? 'No refresh token');
    }
  }

  JWT? getToken() {
    return _token;
  }

  get logger => _logger;

  set logger(value) {
    _logger = value;
  }

  void removeToken() {
    _token = null;

    _cache.flushAll().then((value) {
      getx.Get.offAll(() => SplashScreen());
    });
  }

  Future<Resource> get(String uri, {Map<String, dynamic>? queryParams}) async {
    return await _get(uri, false, queryParams);
  }

  Future<Resource> authorizedGet(String uri, {Map<String, dynamic>? queryParams}) async {
    return await _handleAuthorizationError(() {
      return _get(uri, true, queryParams);
    });
  }

  Future<Resource> post(String uri, Map<String, dynamic> data) async {
    return await _post(uri, false, data);
  }

  Future<Resource> authorizedPost(String uri, Map<String, dynamic> data, {bool? isFormData = false}) async {
    return await _handleAuthorizationError(() {
      return _post(uri, true, data, isFormData: isFormData);
    });
  }

  Future<Resource> authorizedPut(String uri, Map<String, dynamic> data, {bool? isFormData = false}) async {
    bool hasFile = _processFiles(data);

    return _getDataOrHandleDioError(() async {
      Options options = await _makeOptions(true);
      return await _dio.put(
        _makeUrl(uri),
        data: hasFile
            ? FormData.fromMap(data).clone()
            : isFormData == true
                ? FormData.fromMap(data).clone()
                : data,
        options: options,
      );
    });
  }

  Future<Resource> delete(String uri) async {
    return await _delete(uri, false);
  }

  Future<Resource> authorizedDelete(String uri) async {
    return _handleAuthorizationError(() {
      return _delete(uri, true);
    });
  }

  Future<Resource> _get(String uri, bool tokenize, Map<String, dynamic>? queryParams) async {
    return _getDataOrHandleDioError(() async {
      Options options = await _makeOptions(tokenize);
      String url = _makeUrl(uri);
      return await _dio.get(
        url,
        queryParameters: queryParams,
        options: options,
      );
    });
  }

  Future<Resource> _post(String uri, bool tokenize, Map<String, dynamic>? data, {bool? isFormData}) async {
    bool hasFile = data != null ? _processFiles(data) : false;

    return _getDataOrHandleDioError(() async {
      Options options = await _makeOptions(tokenize);
      return await _dio.post(
        _makeUrl(uri),
        data: hasFile
            ? FormData.fromMap(data).clone()
            : isFormData == true
                ? FormData.fromMap(data!).clone()
                : data,
        options: options,
      );
    });
  }

  Future<Resource> _delete(String uri, bool tokenize) async {
    return _getDataOrHandleDioError(() async {
      Options options = await _makeOptions(tokenize);
      return await _dio.delete(
        _makeUrl(uri),
        options: options,
      );
    });
  }

  bool _processFiles(Map<String, dynamic> data) {
    bool hasFile = false;
    data.forEach((key, value) {
      if (value is List<File>) {
        List<MultipartFile> multipartFiles = [];
        for (var file in value) {
          multipartFiles.add(MultipartFile.fromFileSync(file.path));
        }
        data[key] = multipartFiles;
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
      switch (e.code) {
        case 401:
          return await _handleUnauthorized(func);
        default:
          rethrow;
      }
    }
  }

  Future<Resource> _getDataOrHandleDioError(Function func) async {
    try {
      final Response response = await func();
      if (response.statusCode! >= 200 && response.statusCode! < 300) {
        return Resource(response: response.data, messageCode: response.statusCode);
      } else if (response.statusCode == 401) {
        throw UnauthorizedException('unauthorized exception');
      } else if (response.statusCode == 403) {
        throw ForbiddenException('forbidden exception');
      } else if (response.statusCode == 417) {
        throw UserDeactivatedException('UserDeactivatedException');
      } else if (response.statusCode == 500) {
        return Resource(
            response: response.data ??
                {
                  'message': 'Internal Server Error'
                },
            message: 'Internal Server Error',
            messageCode: 500);
      } else {
        return Resource(status: ResourceStatus.failed, messageCode: response.statusCode, message: response.data != null ? response.data['message'] : 'Failed');
      }
    } on DioException catch (error) {
      logger.wtf(error, error.message, StackTrace.current);
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

  String _makeUrl(String uri) {
    return uri;
  }

  Future<Options> _makeOptions(bool tokenize) async {
    var version = await _cache.get(SharedPreferenceConstant.version);
    var headers = generateHeader(version: version);

    if (tokenize) {
      headers = await _addAuthHeader(headers);
    }
    return Options(
        headers: headers,
        sendTimeout: const Duration(milliseconds: 60 * 1000),
        receiveTimeout: const Duration(milliseconds: 30 * 1000),
        followRedirects: false,
        validateStatus: (status) {
          return status! <= 500;
        });
  }

  Map<String, dynamic> generateHeader({String? version}) {
    var header = {
      'Accept': 'application/json',
      'Platform': Platform.isIOS ? 'ios' : 'android',
      'Accept-language': getx.Get.locale?.languageCode ?? AppTranslations.supportedLocales.first,
      'Version': version,
    };
    return header;
  }

  Future<Map<String, dynamic>> _addAuthHeader(Map<String, dynamic> headers) async {
    JWT? token = await _getToken();
    headers['authorization'] = 'Bearer ${token.getToken()}';
    return headers;
  }

  Future<JWT> _getToken() async {
    if (_token == null) throw ArgumentError.notNull("Token");
    if (_token!.isAlive()) return _token!;

    await _handleUnauthorized(null);
    return _token!;
  }

  bool _isRefreshing = false;
  final List<Function> _refreshListeners = [];

  Future<Resource> _handleUnauthorized(Function? originalRequest) async {
    if (!_isRefreshing) {
      _isRefreshing = true;
      try {
        await _refreshToken();
        _isRefreshing = false;
        for (var listener in _refreshListeners) {
          listener();
        }
        _refreshListeners.clear();
        debugPrint('Token refreshed');

        if (originalRequest != null) {
          return await originalRequest();
        } else {
          return Resource(
            messageCode: 200,
          );
        }
      } catch (e) {
        _isRefreshing = false;
        _refreshListeners.clear();
        removeToken();
        rethrow;
      }
    } else {
      return await _waitForRefresh(originalRequest);
    }
  }

  Future<Resource> _waitForRefresh(Function? originalRequest) {
    Completer<Resource> completer = Completer<Resource>();

    _refreshListeners.add(() async {
      try {
        if (originalRequest != null) {
          final result = await originalRequest();
          completer.complete(result);
        } else {
          completer.complete(Resource(
            messageCode: 200,
          ));
        }
      } catch (e) {
        completer.completeError(e);
      }
    });

    return completer.future;
  }

  Future<void> _refreshToken() async {
    final Map<String, dynamic> data = <String, dynamic>{};
    final refreshToken = getToken()?.getRefreshToken();
    data['refresh_token'] = refreshToken;
    var response = await post(url.refreshTokenUrl, data);
    if (response.messageCode == 200) {
      AuthLoginResponse authResponse = AuthLoginResponse.fromJson(response.response);
      var userInfo = UserInfo(accessToken: authResponse.accessToken ?? '', refreshToken: authResponse.refreshToken ?? '');
      await _cache.forever(SharedPreferenceConstant.customerInfo, userInfo.toJsonString());
      await setToken();
    } else {
      throw ApiException(response.messageCode ?? 400, response.message ?? 'Failed to refresh');
    }
  }
}
