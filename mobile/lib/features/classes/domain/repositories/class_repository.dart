import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/open_class_entity.dart';

abstract class ClassRepository {
  Future<Either<Failure, List<OpenClassEntity>>> getOpenClasses();
}
