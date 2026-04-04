import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/open_class_entity.dart';
import '../../domain/repositories/class_repository.dart';
import '../datasources/class_remote_data_source.dart';

@LazySingleton(as: ClassRepository)
class ClassRepositoryImpl implements ClassRepository {
  final ClassRemoteDataSource remoteDataSource;

  ClassRepositoryImpl(this.remoteDataSource);

  @override
  Future<Either<Failure, List<OpenClassEntity>>> getOpenClasses() async {
    try {
      final models = await remoteDataSource.getOpenClasses();
      return Right(models);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure('Lỗi không xác định: $e'));
    }
  }
}
