import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/network/dio_client.dart';
import '../models/auth_response_model.dart';
import '../models/user_model.dart';

abstract class AuthRemoteDataSource {
  Future<AuthResponseModel> login(String phone, String password);
  Future<UserModel> register(String phone, String password, String role);
}

@Injectable(as: AuthRemoteDataSource)
class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final DioClient _client;

  AuthRemoteDataSourceImpl(this._client);

  @override
  Future<AuthResponseModel> login(String phone, String password) async {
    final response = await _client.dio.post(
      '/api/v1/auth/login',
      data: {
        'phoneNumber': phone,
        'password': password,
      },
    );
    return AuthResponseModel.fromJson(response.data);
  }

  @override
  Future<UserModel> register(String phone, String password, String role) async {
    final response = await _client.dio.post(
      '/api/v1/auth/register',
      data: {
        'phoneNumber': phone,
        'password': password,
        'role': role,
      },
    );
    return UserModel.fromJson(response.data);
  }
}
