import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:injectable/injectable.dart';

/// Auth interceptor that adds Bearer token from secure storage.
/// Uses QueuedInterceptor to properly handle async token reading
/// (regular Interceptor's async void methods can cause Dio to hang).
@injectable
class AuthInterceptor extends QueuedInterceptor {
  final FlutterSecureStorage _secureStorage;

  AuthInterceptor(this._secureStorage);

  @override
  Future<void> onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
    try {
      final token = await _secureStorage.read(key: 'accessToken');
      if (token != null) {
        options.headers['Authorization'] = 'Bearer $token';
      }
    } catch (_) {
      // Secure storage may fail on web — continue without token
    }
    handler.next(options);
  }

  @override
  Future<void> onError(DioException err, ErrorInterceptorHandler handler) async {
    if (err.response?.statusCode == 401) {
      final refreshed = await _tryRefreshToken(err.requestOptions);
      if (refreshed != null) {
        handler.resolve(refreshed);
        return;
      }
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
      if (refreshToken == null) return null;

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

      await _secureStorage.write(key: 'accessToken', value: newAccessToken);
      if (newRefreshToken != null) {
        await _secureStorage.write(key: 'refreshToken', value: newRefreshToken);
      }

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
        ),
      );
    } catch (_) {
      return null;
    }
  }
}
