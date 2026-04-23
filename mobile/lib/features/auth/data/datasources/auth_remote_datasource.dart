import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/network/dio_client.dart';
import '../models/auth_response_model.dart';

abstract class AuthRemoteDataSource {
  Future<AuthResponseModel> login(String phone, String password);

  /// Firebase auth — register/login via Firebase idToken
  /// This is the ONLY registration path (same as web)
  Future<AuthResponseModel> firebaseAuth({
    required String idToken,
    String? fullName,
    String? password,
    String? role,
  });

  /// OAuth social login — gửi idToken từ Google/Facebook
  Future<AuthResponseModel> socialAuth({
    required String idToken,
    String? role,
  });

  /// Forgot password step 1: init → returns maskedPhone + fullPhone
  Future<Map<String, String>> initForgotPassword(String identifier);

  /// Forgot password step 2: reset with mock/Firebase idToken
  Future<String> resetForgotPassword(String identifier, String idToken);

  /// Refresh expired access token
  Future<AuthResponseModel> refreshToken(String refreshToken);

  /// Check if phone number already registered — call BEFORE OTP generation
  Future<bool> checkPhoneExists(String phone);
}

@Injectable(as: AuthRemoteDataSource)
class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final DioClient _client;

  AuthRemoteDataSourceImpl(this._client);

  /// Backend bọc response trong ApiResponse: { success, message, data }
  dynamic _unwrap(Response response) => response.data['data'];

  @override
  Future<AuthResponseModel> login(String phone, String password) async {
    final response = await _client.dio.post(
      '/api/v1/auth/login',
      data: {'phone': phone, 'password': password},
    );
    return AuthResponseModel.fromJson(_unwrap(response) as Map<String, dynamic>);
  }

  @override
  Future<AuthResponseModel> firebaseAuth({
    required String idToken,
    String? fullName,
    String? password,
    String? role,
  }) async {
    final data = <String, dynamic>{'idToken': idToken};
    if (fullName != null) data['fullName'] = fullName;
    if (password != null) data['password'] = password;
    if (role != null) data['role'] = role;

    final response = await _client.dio.post(
      '/api/v1/auth/firebase',
      data: data,
    );
    return AuthResponseModel.fromJson(_unwrap(response) as Map<String, dynamic>);
  }

  @override
  Future<AuthResponseModel> socialAuth({
    required String idToken,
    String? role,
  }) async {
    final data = <String, dynamic>{'idToken': idToken};
    if (role != null) data['role'] = role;

    final response = await _client.dio.post(
      '/api/v1/auth/firebase',
      data: data,
    );
    return AuthResponseModel.fromJson(_unwrap(response) as Map<String, dynamic>);
  }

  @override
  Future<Map<String, String>> initForgotPassword(String identifier) async {
    final response = await _client.dio.post(
      '/api/v1/auth/forgot-password/init',
      data: {'identifier': identifier},
    );
    final data = _unwrap(response) as Map<String, dynamic>;
    return {
      'maskedPhone': data['maskedPhone'] as String? ?? '',
      'fullPhone': data['fullPhone'] as String? ?? '',
    };
  }

  @override
  Future<String> resetForgotPassword(String identifier, String idToken) async {
    final response = await _client.dio.post(
      '/api/v1/auth/forgot-password/reset',
      data: {
        'identifier': identifier,
        'idToken': idToken,
      },
    );
    final data = _unwrap(response) as Map<String, dynamic>;
    return data['newPassword'] as String? ?? '';
  }

  @override
  Future<AuthResponseModel> refreshToken(String refreshToken) async {
    final response = await _client.dio.post(
      '/api/v1/auth/refresh',
      data: {'refreshToken': refreshToken},
    );
    return AuthResponseModel.fromJson(_unwrap(response) as Map<String, dynamic>);
  }

  @override
  Future<bool> checkPhoneExists(String phone) async {
    final response = await _client.dio.get(
      '/api/v1/auth/check-phone',
      queryParameters: {'phone': phone},
    );
    final data = _unwrap(response) as Map<String, dynamic>;
    return data['exists'] as bool? ?? false;
  }
}
