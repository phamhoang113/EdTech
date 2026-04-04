import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/user_entity.dart';

abstract class AuthRepository {
  Future<Either<Failure, UserEntity>> login(String phone, String password);
  Future<Either<Failure, String>> register(String phone, String password, String role, {String fullName});
  Future<Either<Failure, UserEntity>> verifyOtp(String otpToken, String code);
  Future<void> logout();
  Future<UserEntity?> getAuthenticatedUser();
}
