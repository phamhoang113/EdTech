import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/error/failures.dart';
import '../../presentation/bloc/auth_state.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_local_datasource.dart';
import '../datasources/auth_remote_datasource.dart';

@Injectable(as: AuthRepository)
class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource _remoteDataSource;
  final AuthLocalDataSource _localDataSource;
  final FlutterSecureStorage _secureStorage;

  AuthRepositoryImpl(
    this._remoteDataSource,
    this._localDataSource,
    this._secureStorage,
  );

  @override
  Future<Either<Failure, AuthAuthenticated>> login(String phone, String password) async {
    try {
      final response = await _remoteDataSource.login(phone, password);
      await _saveSession(
        phone: phone,
        role: response.role,
        fullName: response.fullName,
        accessToken: response.accessToken,
        refreshToken: response.refreshToken,
      );
      return Right(AuthAuthenticated(phone: phone, role: response.role, fullName: response.fullName));
    } on DioException catch (e) {
      return Left(ServerFailure(_extractMessage(e, 'Đăng nhập thất bại')));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  /// Register thành công → trả otpToken UUID để navigate sang OtpVerifyScreen
  @override
  Future<Either<Failure, String>> register(
    String phone,
    String password,
    String role, {
    String fullName = '',
  }) async {
    try {
      final otpToken = await _remoteDataSource.register(phone, password, fullName, role);
      return Right(otpToken);
    } on DioException catch (e) {
      return Left(ServerFailure(_extractMessage(e, 'Đăng ký thất bại')));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  /// Verify OTP bằng otpToken UUID + code (không cần phone)
  Future<Either<Failure, AuthAuthenticated>> verifyOtp(String otpToken, String code) async {
    try {
      final response = await _remoteDataSource.verifyOtp(otpToken, code);
      // phone không có trong TokenResponse, lấy từ secure storage nếu có
      final savedPhone = await _secureStorage.read(key: 'userPhone') ?? '';
      await _saveSession(
        phone: savedPhone,
        role: response.role,
        fullName: response.fullName,
        accessToken: response.accessToken,
        refreshToken: response.refreshToken,
      );
      return Right(AuthAuthenticated(
        phone: savedPhone,
        role: response.role,
        fullName: response.fullName,
      ));
    } on DioException catch (e) {
      return Left(ServerFailure(_extractMessage(e, 'OTP không hợp lệ')));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<void> logout() async {
    await _secureStorage.deleteAll();
    await _localDataSource.clearCache();
  }

  @override
  Future<AuthAuthenticated?> getAuthenticatedUser() async {
    final token = await _secureStorage.read(key: 'accessToken');
    if (token == null) return null;

    final phone = await _secureStorage.read(key: 'userPhone') ?? '';
    final role = await _secureStorage.read(key: 'userRole') ?? '';
    final fullName = await _secureStorage.read(key: 'userFullName') ?? '';

    return AuthAuthenticated(phone: phone, role: role, fullName: fullName);
  }

  // ─── Helpers ───

  Future<void> _saveSession({
    required String phone,
    required String role,
    required String fullName,
    required String accessToken,
    required String refreshToken,
  }) async {
    await Future.wait([
      _secureStorage.write(key: 'accessToken', value: accessToken),
      _secureStorage.write(key: 'refreshToken', value: refreshToken),
      _secureStorage.write(key: 'userPhone', value: phone),
      _secureStorage.write(key: 'userRole', value: role),
      _secureStorage.write(key: 'userFullName', value: fullName),
    ]);
  }

  String _extractMessage(DioException e, String fallback) =>
      e.response?.data?['message'] as String? ?? e.message ?? fallback;
}
