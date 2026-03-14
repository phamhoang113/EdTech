import 'package:injectable/injectable.dart';

import '../entities/user_entity.dart';
import '../repositories/auth_repository.dart';

@injectable
class GetAuthUserUseCase {
  final AuthRepository repository;

  GetAuthUserUseCase(this.repository);

  Future<UserEntity?> call() {
    return repository.getAuthenticatedUser();
  }
}
