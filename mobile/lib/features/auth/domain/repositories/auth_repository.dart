import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/user_entity.dart';

abstract class AuthRepository {
  Future<Either<Failure, UserEntity>> login(String phone, String password);
  Future<Either<Failure, UserEntity>> register(String phone, String password, String role);
  Future<void> logout();
  Future<UserEntity?> getAuthenticatedUser();
}
