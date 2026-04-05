import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/open_class_entity.dart';
import '../entities/class_filter_entity.dart';
import '../../data/datasources/class_remote_data_source.dart';

abstract class ClassRepository {
  Future<Either<Failure, List<OpenClassEntity>>> getOpenClasses();
  Future<Either<Failure, ClassFilterEntity>> getClassFilters();
  Future<Either<Failure, List<ProvinceDto>>> getProvinces();
  Future<Either<Failure, List<WardDto>>> getWardsByProvince(String provinceCode);
}
