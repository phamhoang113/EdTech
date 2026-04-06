import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../entities/my_class_entity.dart';

abstract class HomeRepository {
  /// Load classes cho phụ huynh hoặc học sinh dựa trên role.
  Future<Either<Failure, List<MyClassEntity>>> getMyClasses(String role);
}
