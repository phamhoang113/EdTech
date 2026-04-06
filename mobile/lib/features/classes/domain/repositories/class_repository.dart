import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../entities/open_class_entity.dart';
import '../entities/class_filter_entity.dart';
import '../entities/province_entity.dart';
import '../entities/ward_entity.dart';

abstract class ClassRepository {
  Future<Either<Failure, List<OpenClassEntity>>> getOpenClasses();
  Future<Either<Failure, ClassFilterEntity>> getClassFilters();
  Future<Either<Failure, List<ProvinceEntity>>> getProvinces();
  Future<Either<Failure, List<WardEntity>>> getWardsByProvince(String provinceCode);

  /// Tạo lớp mới — trả về unit nếu thành công.
  Future<Either<Failure, void>> createClass(Map<String, dynamic> data);
}
