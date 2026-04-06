import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import '../storage/platform_storage.dart';
import 'package:injectable/injectable.dart';

/// Auth interceptor that adds Bearer token from secure storage.
/// Uses QueuedInterceptor to properly handle async token reading
/// (regular Interceptor's async void methods can cause Dio to hang).
@injectable
class AuthInterceptor extends QueuedInterceptor {
  final PlatformStorage _secureStorage;
  bool _isRefreshing = false;

  AuthInterceptor(this._secureStorage);

  @override
  Future<void> onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
    try {
      final token = await _secureStorage.read(key: 'accessToken');
      if (token != null) {
        options.headers['Authorization'] = 'Bearer $token';
      }
    } catch (e) {
      debugPrint('[AuthInterceptor] Failed to read token: $e');
    }
    handler.next(options);
  }

  @override
  Future<void> onError(DioException err, ErrorInterceptorHandler handler) async {
    if (err.response?.statusCode == 401 && !_isRefreshing) {
      _isRefreshing = true;
      try {
        final refreshed = await _tryRefreshToken(err.requestOptions);
        if (refreshed != null) {
          _isRefreshing = false;
          handler.resolve(refreshed);
          return;
        }
      } catch (_) {
        // Refresh failed
      }
      _isRefreshing = false;

      // Refresh failed → clear session
      try {
        await _secureStorage.deleteAll();
      } catch (_) {
        // Ignore storage errors on web
      }
    }
    handler.next(err);
  }

  Future<Response?> _tryRefreshToken(RequestOptions failedRequest) async {
    try {
      final refreshToken = await _secureStorage.read(key: 'refreshToken');
      if (refreshToken == null || refreshToken.isEmpty) {
        debugPrint('[AuthInterceptor] No refresh token available');
        return null;
      }

      final refreshDio = Dio(BaseOptions(
        baseUrl: failedRequest.baseUrl,
        connectTimeout: const Duration(seconds: 10),
        receiveTimeout: const Duration(seconds: 10),
      ));

      final response = await refreshDio.post(
        '/api/v1/auth/refresh',
        data: {'refreshToken': refreshToken},
      );

      final data = response.data['data'] as Map<String, dynamic>?;
      if (data == null) return null;

      final newAccessToken = data['accessToken'] as String?;
      final newRefreshToken = data['refreshToken'] as String?;
      if (newAccessToken == null) return null;

      // Lưu token mới
      await _secureStorage.write(key: 'accessToken', value: newAccessToken);
      if (newRefreshToken != null) {
        await _secureStorage.write(key: 'refreshToken', value: newRefreshToken);
      }

      debugPrint('[AuthInterceptor] Token refreshed successfully');

      // Retry request với token mới
      failedRequest.headers['Authorization'] = 'Bearer $newAccessToken';

      final retryDio = Dio(BaseOptions(
        baseUrl: failedRequest.baseUrl,
        connectTimeout: failedRequest.connectTimeout,
        receiveTimeout: failedRequest.receiveTimeout,
      ));

      return retryDio.request(
        failedRequest.path,
        data: failedRequest.data,
        queryParameters: failedRequest.queryParameters,
        options: Options(
          method: failedRequest.method,
          headers: failedRequest.headers,
          contentType: failedRequest.contentType,
        ),
      );
    } catch (e) {
      debugPrint('[AuthInterceptor] Refresh token failed: $e');
      return null;
    }
  }
}
