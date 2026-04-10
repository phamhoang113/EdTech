import '../../../../core/network/dio_client.dart';
import '../../domain/entities/applicant_entity.dart';

abstract class ApplicantDataSource {
  /// Lấy danh sách GS đề xuất (APPROVED) cho 1 lớp.
  Future<List<ApplicantEntity>> getProposedTutors(String classId);

  /// PH chọn GS → lớp chuyển ACTIVE.
  Future<void> selectTutor(String applicationId);
}

class ApplicantRemoteDataSource implements ApplicantDataSource {
  final DioClient _dioClient;

  ApplicantRemoteDataSource(this._dioClient);

  @override
  Future<List<ApplicantEntity>> getProposedTutors(String classId) async {
    final response = await _dioClient.dio.get(
      '/api/v1/classes/$classId/proposed-tutors',
    );
    final data = response.data['data'] as List? ?? [];
    return data
        .map((e) => ApplicantEntity.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  @override
  Future<void> selectTutor(String applicationId) async {
    await _dioClient.dio.post(
      '/api/v1/class-applications/$applicationId/select',
    );
  }
}
