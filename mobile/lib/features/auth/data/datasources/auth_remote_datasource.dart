import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/network/dio_client.dart';
import '../models/auth_response_model.dart';

abstract class AuthRemoteDataSource {
  Future<AuthResponseModel> login(String phone, String password);

  /// Register thành công → trả về otpToken (UUID String) để verify
  Future<String> register(String phone, String password, String fullName, String role);

  /// Verify bằng otpToken + code — không cần phone
  Future<AuthResponseModel> verifyOtp(String otpToken, String code);
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
  Future<String> register(
    String phone,
    String password,
    String fullName,
    String role,
  ) async {
    final response = await _client.dio.post(
      '/api/v1/auth/register',
      data: {
        'phone': phone,
        'password': password,
        'fullName': fullName,
        'role': role,
      },
    );
    // Backend trả RegisterResponse { otpToken, message }
    final data = _unwrap(response) as Map<String, dynamic>;
    return data['otpToken'] as String;
  }

  @override
  Future<AuthResponseModel> verifyOtp(String otpToken, String code) async {
    final response = await _client.dio.post(
      '/api/v1/auth/verify-otp',
      data: {
        'otpToken': otpToken, // UUID String — không gửi phone
        'code': code,
      },
    );
    return AuthResponseModel.fromJson(_unwrap(response) as Map<String, dynamic>);
  }
}
