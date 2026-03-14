import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/error/failures.dart';
import '../entities/user_entity.dart';
import '../repositories/auth_repository.dart';

@injectable
class LoginUseCase {
  final AuthRepository repository;

  LoginUseCase(this.repository);

  Future<Either<Failure, UserEntity>> call(LoginParams params) {
    return repository.login(params.phone, params.password);
  }
}

class LoginParams {
  final String phone;
  final String password;

  LoginParams({required this.phone, required this.password});
}
