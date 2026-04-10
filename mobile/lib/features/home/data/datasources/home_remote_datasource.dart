import 'package:injectable/injectable.dart';

import '../../../../core/error/exceptions.dart';
import '../../../../core/network/dio_client.dart';
import '../../domain/entities/my_class_entity.dart';
import '../../domain/entities/upcoming_session_entity.dart';
import '../../domain/entities/billing_summary_entity.dart';
import '../../domain/entities/student_entity.dart';

abstract class HomeRemoteDataSource {
  Future<List<MyClassEntity>> getMyClasses(String role);
  Future<List<UpcomingSessionEntity>> getUpcomingSessions(String role);
  Future<List<UpcomingSessionEntity>> getUpcomingSessionsRange(String role, String startDate, String endDate);
  Future<List<BillingSummaryEntity>> getUnpaidBillings();
  Future<List<StudentEntity>> getMyChildren();
  Future<MyClassEntity> updateClassStudents(String classId, List<String> studentIds);
  Future<StudentEntity> addChild(Map<String, dynamic> body);
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

  @override
  Future<List<UpcomingSessionEntity>> getUpcomingSessions(String role) async {
    try {
      final now = DateTime.now();
      final endDate = now.add(const Duration(days: 7));
      final startStr = _formatDate(now);
      final endStr = _formatDate(endDate);

      final endpoint = role == 'STUDENT'
          ? '/api/v1/student/sessions'
          : '/api/v1/parent/sessions';

      final response = await _dioClient.dio.get(
        endpoint,
        queryParameters: {'startDate': startStr, 'endDate': endStr},
      );

      // API trả về List trực tiếp hoặc trong data wrapper
      final rawData = response.data;
      final List<dynamic> data;
      if (rawData is List) {
        data = rawData;
      } else if (rawData is Map && rawData['data'] is List) {
        data = rawData['data'] as List;
      } else {
        data = [];
      }

      return data
          .map((e) => UpcomingSessionEntity.fromJson(e as Map<String, dynamic>))
          .where((s) => s.status == 'SCHEDULED' || s.status == 'DRAFT')
          .take(5)
          .toList();
    } catch (e) {
      // Không throw — trả rỗng nếu lỗi (non-critical)
      return [];
    }
  }

  @override
  Future<List<UpcomingSessionEntity>> getUpcomingSessionsRange(String role, String startDate, String endDate) async {
    try {
      final endpoint = role == 'STUDENT'
          ? '/api/v1/student/sessions'
          : '/api/v1/parent/sessions';

      final response = await _dioClient.dio.get(
        endpoint,
        queryParameters: {'startDate': startDate, 'endDate': endDate},
      );

      final rawData = response.data;
      final List<dynamic> data;
      if (rawData is List) {
        data = rawData;
      } else if (rawData is Map && rawData['data'] is List) {
        data = rawData['data'] as List;
      } else {
        data = [];
      }

      return data
          .map((e) => UpcomingSessionEntity.fromJson(e as Map<String, dynamic>))
          .toList();
    } catch (e) {
      return [];
    }
  }

  @override
  Future<List<BillingSummaryEntity>> getUnpaidBillings() async {
    try {
      final response = await _dioClient.dio.get('/api/v1/parents/billings');
      final rawData = response.data;
      final List<dynamic> data;
      if (rawData is Map && rawData['data'] is List) {
        data = rawData['data'] as List;
      } else if (rawData is List) {
        data = rawData;
      } else {
        data = [];
      }

      return data
          .map((e) => BillingSummaryEntity.fromJson(e as Map<String, dynamic>))
          .where((b) => b.isUnpaid)
          .toList();
    } catch (e) {
      // Không throw — trả rỗng nếu lỗi (non-critical)
      return [];
    }
  }

  @override
  Future<List<StudentEntity>> getMyChildren() async {
    try {
      final response = await _dioClient.dio.get('/api/v1/parent/students');
      final data = response.data['data'] as List? ?? [];
      return data
          .map((e) => StudentEntity.fromJson(e as Map<String, dynamic>))
          .toList();
    } catch (e) {
      throw ServerException('Lỗi tải danh sách học sinh: $e');
    }
  }

  @override
  Future<MyClassEntity> updateClassStudents(String classId, List<String> studentIds) async {
    try {
      final response = await _dioClient.dio.put(
        '/api/v1/parent/classes/$classId/students',
        data: studentIds,
      );
      final data = response.data['data'];
      return MyClassEntity.fromJson(data);
    } catch (e) {
      throw ServerException('Lỗi cập nhật học sinh: $e');
    }
  }

  @override
  Future<StudentEntity> addChild(Map<String, dynamic> body) async {
    try {
      final response = await _dioClient.dio.post(
        '/api/v1/parent/students',
        data: body,
      );
      final data = response.data['data'];
      return StudentEntity.fromJson(data);
    } catch (e) {
      throw ServerException('Lỗi thêm học sinh: $e');
    }
  }

  String _formatDate(DateTime d) =>
      '${d.year}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';
}
