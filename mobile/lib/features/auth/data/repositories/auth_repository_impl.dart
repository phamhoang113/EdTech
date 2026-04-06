import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import '../../../../core/storage/platform_storage.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/error/failures.dart';
import '../../domain/entities/user_entity.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_local_datasource.dart';
import '../datasources/auth_remote_datasource.dart';

@Injectable(as: AuthRepository)
class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource _remoteDataSource;
  final AuthLocalDataSource _localDataSource;
  final PlatformStorage _secureStorage;

  AuthRepositoryImpl(
    this._remoteDataSource,
    this._localDataSource,
    this._secureStorage,
  );

  @override
  Future<Either<Failure, UserEntity>> login(String phone, String password) async {
    try {
      final response = await _remoteDataSource.login(phone, password);
      await _saveSession(
        phone: phone,
        role: response.role,
        fullName: response.fullName,
        accessToken: response.accessToken,
        refreshToken: response.refreshToken,
        mustChangePassword: response.mustChangePassword,
      );
      return Right(UserEntity(
        id: phone,
        phoneNumber: phone,
        role: response.role,
        name: response.fullName,
        mustChangePassword: response.mustChangePassword ?? false,
      ));
    } on DioException catch (e) {
      return Left(ServerFailure(_extractMessage(e, 'Đăng nhập thất bại')));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  /// Register via Firebase auth endpoint.
  /// On test env: generates MOCK_TOKEN_+84xxx (BE bypasses Firebase check).
  /// On production: would use real Firebase Phone Auth SDK.
  @override
  Future<Either<Failure, UserEntity>> registerWithFirebase({
    required String phone,
    required String fullName,
    required String password,
    required String role,
  }) async {
    try {
      // Normalize phone to +84 format (same as web)
      String formattedPhone = phone.trim();
      if (formattedPhone.startsWith('0')) {
        formattedPhone = '+84${formattedPhone.substring(1)}';
      } else if (!formattedPhone.startsWith('+')) {
        formattedPhone = '+$formattedPhone';
      }

      // Test env: mock idToken (same as web localhost bypass)
      // Production: would call Firebase signInWithPhoneNumber here
      final idToken = 'MOCK_TOKEN_$formattedPhone';

      final response = await _remoteDataSource.firebaseAuth(
        idToken: idToken,
        fullName: fullName,
        password: password,
        role: role,
      );

      await _saveSession(
        phone: phone,
        role: response.role,
        fullName: response.fullName,
        accessToken: response.accessToken,
        refreshToken: response.refreshToken,
        mustChangePassword: response.mustChangePassword,
      );

      return Right(UserEntity(
        id: phone,
        phoneNumber: phone,
        role: response.role,
        name: response.fullName,
        mustChangePassword: response.mustChangePassword ?? false,
      ));
    } on DioException catch (e) {
      return Left(ServerFailure(_extractMessage(e, 'Đăng ký thất bại')));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Map<String, String>>> initForgotPassword(String identifier) async {
    try {
      final data = await _remoteDataSource.initForgotPassword(identifier);
      return Right(data);
    } on DioException catch (e) {
      return Left(ServerFailure(_extractMessage(e, 'Không tìm thấy tài khoản')));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, String>> resetForgotPassword(String identifier, String idToken) async {
    try {
      final newPassword = await _remoteDataSource.resetForgotPassword(identifier, idToken);
      return Right(newPassword);
    } on DioException catch (e) {
      return Left(ServerFailure(_extractMessage(e, 'Đặt lại mật khẩu thất bại')));
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
  Future<UserEntity?> getAuthenticatedUser() async {
    final token = await _secureStorage.read(key: 'accessToken');
    if (token == null) return null;

    final phone = await _secureStorage.read(key: 'userPhone') ?? '';
    final role = await _secureStorage.read(key: 'userRole') ?? '';
    final fullName = await _secureStorage.read(key: 'userFullName') ?? '';
    final mustChangePwdStr = await _secureStorage.read(key: 'mustChangePassword');
    final mustChangePassword = mustChangePwdStr == 'true';

    return UserEntity(
      id: phone,
      phoneNumber: phone,
      role: role,
      name: fullName,
      mustChangePassword: mustChangePassword,
    );
  }

  // ─── Helpers ───

  Future<void> _saveSession({
    required String phone,
    required String role,
    required String fullName,
    required String accessToken,
    required String refreshToken,
    bool? mustChangePassword,
  }) async {
    await Future.wait([
      _secureStorage.write(key: 'accessToken', value: accessToken),
      _secureStorage.write(key: 'refreshToken', value: refreshToken),
      _secureStorage.write(key: 'userPhone', value: phone),
      _secureStorage.write(key: 'userRole', value: role),
      _secureStorage.write(key: 'userFullName', value: fullName),
      if (mustChangePassword != null)
        _secureStorage.write(key: 'mustChangePassword', value: mustChangePassword.toString()),
    ]);
  }

  String _extractMessage(DioException e, String fallback) =>
      e.response?.data?['message'] as String? ?? e.message ?? fallback;
}
