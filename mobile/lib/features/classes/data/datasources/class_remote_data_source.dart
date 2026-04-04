import 'package:injectable/injectable.dart';

import '../../../../core/error/exceptions.dart';
import '../../../../core/network/dio_client.dart';
import '../models/open_class_model.dart';

abstract class ClassRemoteDataSource {
  Future<List<OpenClassModel>> getOpenClasses();
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
}
