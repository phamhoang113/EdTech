import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
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

  AuthRepositoryImpl(this._remoteDataSource, this._localDataSource);

  @override
  Future<Either<Failure, UserEntity>> login(String phone, String password) async {
    try {
      final response = await _remoteDataSource.login(phone, password);
      // Cache tokens and user
      await _localDataSource.cacheTokens(
        accessToken: response.accessToken,
        refreshToken: response.refreshToken,
      );
      await _localDataSource.cacheUser(response.user);
      
      return Right(response.user);
    } on DioException catch (e) {
      return Left(ServerFailure(e.message ?? 'Server Error'));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, UserEntity>> register(String phone, String password, String role) async {
    try {
      final userModel = await _remoteDataSource.register(phone, password, role);
      // Backend should ideally log user in, but assuming it just returns user body for now
      return Right(userModel);
    } on DioException catch (e) {
      return Left(ServerFailure(e.message ?? 'Registration Error'));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<void> logout() async {
    await _localDataSource.clearCache();
  }

  @override
  Future<UserEntity?> getAuthenticatedUser() async {
    return await _localDataSource.getCachedUser();
  }
}
