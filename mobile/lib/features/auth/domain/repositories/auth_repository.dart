import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/user_entity.dart';

abstract class AuthRepository {
  Future<Either<Failure, UserEntity>> login(String phone, String password);

  /// Register via Firebase auth (mock on test env)
  Future<Either<Failure, UserEntity>> registerWithFirebase({
    required String phone,
    required String fullName,
    required String password,
    required String role,
  });

  /// OAuth social login (Google/Facebook)
  Future<Either<Failure, UserEntity>> socialLogin({
    required String idToken,
    String? role,
  });

  /// Forgot password step 1: returns { maskedPhone, fullPhone }
  Future<Either<Failure, Map<String, String>>> initForgotPassword(String identifier);

  /// Forgot password step 2: returns new random password
  Future<Either<Failure, String>> resetForgotPassword(String identifier, String idToken);

  Future<void> logout();
  Future<UserEntity?> getAuthenticatedUser();

  /// Check if phone number is already registered — call BEFORE OTP
  Future<Either<Failure, bool>> checkPhoneExists(String phone);
}
