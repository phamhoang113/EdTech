import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/class_filter_entity.dart';
import '../../domain/entities/open_class_entity.dart';
import '../../domain/entities/province_entity.dart';
import '../../domain/entities/ward_entity.dart';
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

  @override
  Future<Either<Failure, ClassFilterEntity>> getClassFilters() async {
    try {
      final filters = await remoteDataSource.getClassFilters();
      return Right(filters);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure('Lỗi không xác định: $e'));
    }
  }

  @override
  Future<Either<Failure, List<ProvinceEntity>>> getProvinces() async {
    try {
      final dtos = await remoteDataSource.getProvinces();
      final entities = dtos
          .map((dto) => ProvinceEntity(code: dto.code, name: dto.name))
          .toList();
      return Right(entities);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure('Lỗi không xác định: $e'));
    }
  }

  @override
  Future<Either<Failure, List<WardEntity>>> getWardsByProvince(String provinceCode) async {
    try {
      final dtos = await remoteDataSource.getWardsByProvince(provinceCode);
      final entities = dtos
          .map((dto) => WardEntity(
                code: dto.code,
                name: dto.name,
                provinceCode: dto.provinceCode,
              ))
          .toList();
      return Right(entities);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure('Lỗi không xác định: $e'));
    }
  }

  @override
  Future<Either<Failure, void>> createClass(Map<String, dynamic> data) async {
    try {
      await remoteDataSource.createClass(data);
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure('Lỗi tạo lớp: $e'));
    }
  }
}
