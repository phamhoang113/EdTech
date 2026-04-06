import 'package:injectable/injectable.dart';

import '../../../../core/error/exceptions.dart';
import '../../../../core/network/dio_client.dart';
import '../../domain/entities/my_class_entity.dart';

abstract class HomeRemoteDataSource {
  Future<List<MyClassEntity>> getMyClasses(String role);
}

@LazySingleton(as: HomeRemoteDataSource)
class HomeRemoteDataSourceImpl implements HomeRemoteDataSource {
  final DioClient _dioClient;

  HomeRemoteDataSourceImpl(this._dioClient);

  @override
  Future<List<MyClassEntity>> getMyClasses(String role) async {
    try {
      final endpoint = role == 'STUDENT'
          ? '/api/v1/student/classes'
          : '/api/v1/parent/classes';

      final response = await _dioClient.dio.get(endpoint);
      final data = response.data['data'] as List? ?? [];
      return data
          .map((e) => MyClassEntity.fromJson(e as Map<String, dynamic>))
          .toList();
    } on ServerException {
      rethrow;
    } catch (e) {
      throw ServerException('Lỗi tải lớp học: $e');
    }
  }
}
