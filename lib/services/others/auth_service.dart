import 'dart:async';
import 'package:dio/dio.dart';

class AuthService {
  AuthService._();
  static final AuthService instance = AuthService._();

  Dio get _dio => AppConfig.dio;

  final StreamController<Map<String, dynamic>?> _authStateController =
      StreamController<Map<String, dynamic>?>.broadcast();

  /// Stream of auth state changes. Emits the current user map or null.
  Stream<Map<String, dynamic>?> get authStateChanges => _authStateController.stream;

  FutureEither<void> logout() async {
    return runTask(() async {
      await _dio.post<void>('/auth/logout');
      _authStateController.add(null);
    }, requiresNetwork: true);
  }

  FutureEither<Map<String, dynamic>?> getCurrentUser() async {
    return runTask(() async {
      final response = await _dio.get<Map<String, dynamic>>('/auth/me');
      return response.data;
    });
  }

  void dispose() {
    _authStateController.close();
  }
}
