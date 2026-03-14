import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/error/failures.dart';
import '../entities/user_entity.dart';
import '../repositories/auth_repository.dart';

@injectable
class RegisterUseCase {
  final AuthRepository repository;

  RegisterUseCase(this.repository);

  Future<Either<Failure, UserEntity>> call(RegisterParams params) {
    return repository.register(params.phone, params.password, params.role);
  }
}

class RegisterParams {
  final String phone;
  final String password;
  final String role;

  RegisterParams({required this.phone, required this.password, required this.role});
}
