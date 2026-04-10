import '../../../../core/error/exceptions.dart';
import '../../../../core/network/dio_client.dart';
import '../models/parent_link_model.dart';

/// Datasource gọi API liên kết phụ huynh — học sinh
class StudentRemoteDataSource {
  final DioClient _dioClient;

  StudentRemoteDataSource(this._dioClient);

  /// Lấy danh sách phụ huynh liên kết với HS đang đăng nhập
  Future<List<ParentLinkModel>> getParentLinks() async {
    try {
      final response = await _dioClient.dio.get('/api/v1/student/parent-links');
      final data = response.data['data'];
      if (data == null) return [];
      return (data as List)
          .map((e) => ParentLinkModel.fromJson(e as Map<String, dynamic>))
          .toList();
    } on ServerException {
      rethrow;
    } catch (e) {
      throw ServerException('Lỗi tải danh sách phụ huynh: $e');
    }
  }

  /// HS gửi yêu cầu liên kết PH bằng SĐT
  Future<void> requestParentLink(String parentPhone) async {
    try {
      await _dioClient.dio.post(
        '/api/v1/student/parent-links',
        queryParameters: {'parentPhone': parentPhone},
      );
    } on ServerException {
      rethrow;
    } catch (e) {
      throw ServerException('Lỗi gửi yêu cầu liên kết: $e');
    }
  }

  /// HS chấp nhận yêu cầu liên kết từ PH
  Future<void> acceptParentLink(String linkId) async {
    try {
      await _dioClient.dio.post('/api/v1/student/parent-links/$linkId/accept');
    } on ServerException {
      rethrow;
    } catch (e) {
      throw ServerException('Lỗi chấp nhận liên kết: $e');
    }
  }

  /// HS từ chối yêu cầu liên kết từ PH
  Future<void> rejectParentLink(String linkId) async {
    try {
      await _dioClient.dio.post('/api/v1/student/parent-links/$linkId/reject');
    } on ServerException {
      rethrow;
    } catch (e) {
      throw ServerException('Lỗi từ chối liên kết: $e');
    }
  }
}
