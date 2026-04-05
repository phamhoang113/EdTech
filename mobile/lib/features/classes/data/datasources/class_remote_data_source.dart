import 'package:injectable/injectable.dart';

import '../../../../core/error/exceptions.dart';
import '../../../../core/network/dio_client.dart';
import '../../domain/entities/class_filter_entity.dart';
import '../models/open_class_model.dart';

/// Represents a province/city from the location API
class ProvinceDto {
  final String code;
  final String name;

  ProvinceDto({required this.code, required this.name});

  factory ProvinceDto.fromJson(Map<String, dynamic> json) {
    return ProvinceDto(
      code: json['code']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
    );
  }
}

/// Represents a ward/district from the location API
class WardDto {
  final String code;
  final String name;
  final String provinceCode;

  WardDto({required this.code, required this.name, required this.provinceCode});

  factory WardDto.fromJson(Map<String, dynamic> json) {
    return WardDto(
      code: json['code']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      provinceCode: json['provinceCode']?.toString() ?? '',
    );
  }
}

abstract class ClassRemoteDataSource {
  Future<List<OpenClassModel>> getOpenClasses();
  Future<ClassFilterEntity> getClassFilters();
  Future<List<ProvinceDto>> getProvinces();
  Future<List<WardDto>> getWardsByProvince(String provinceCode);
}

@LazySingleton(as: ClassRemoteDataSource)
class ClassRemoteDataSourceImpl implements ClassRemoteDataSource {
  final DioClient _dioClient;

  ClassRemoteDataSourceImpl(this._dioClient);

  @override
  Future<List<OpenClassModel>> getOpenClasses() async {
    try {
      final response = await _dioClient.dio.get('/api/v1/classes/open');
      if (response.data['data'] != null) {
        final data = response.data['data'] as List;
        return data.map((e) => OpenClassModel.fromJson(e)).toList();
      }
      return [];
    } on ServerException {
      rethrow;
    } catch (e) {
      throw ServerException('Lỗi tải danh sách lớp học: $e');
    }
  }

  @override
  Future<ClassFilterEntity> getClassFilters() async {
    try {
      final response = await _dioClient.dio.get('/api/v1/classes/filters');
      final data = response.data['data'];
      if (data == null) return ClassFilterEntity.empty;

      return ClassFilterEntity(
        subjects: _castStringList(data['subjects']),
        levels: _castStringList(data['levels']),
        genders: _castStringList(data['genders']),
        tutorLevels: _castStringList(data['tutorLevels']),
      );
    } on ServerException {
      rethrow;
    } catch (e) {
      throw ServerException('Lỗi tải bộ lọc: $e');
    }
  }

  @override
  Future<List<ProvinceDto>> getProvinces() async {
    try {
      final response = await _dioClient.dio.get('/api/v1/locations/provinces');
      final data = response.data['data'];
      if (data == null) return [];
      return (data as List).map((e) => ProvinceDto.fromJson(e)).toList();
    } on ServerException {
      rethrow;
    } catch (e) {
      throw ServerException('Lỗi tải danh sách tỉnh thành: $e');
    }
  }

  @override
  Future<List<WardDto>> getWardsByProvince(String provinceCode) async {
    try {
      final response = await _dioClient.dio.get('/api/v1/locations/provinces/$provinceCode/wards');
      final data = response.data['data'];
      if (data == null) return [];
      return (data as List).map((e) => WardDto.fromJson(e)).toList();
    } on ServerException {
      rethrow;
    } catch (e) {
      throw ServerException('Lỗi tải danh sách quận huyện: $e');
    }
  }

  List<String> _castStringList(dynamic value) {
    if (value is List) return value.map((e) => e.toString()).toList();
    return [];
  }
}
