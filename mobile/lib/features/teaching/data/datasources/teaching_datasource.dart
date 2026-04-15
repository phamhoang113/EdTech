import 'package:dio/dio.dart';

import '../../../../core/di/injection.dart';
import '../../../../core/network/dio_client.dart';
import '../models/teaching_models.dart';

/// REST API datasource cho module Giảng dạy.
class TeachingDataSource {
  final _dio = getIt<DioClient>().dio;

  // ═══════════ MATERIALS ═══════════

  /// Upload tài liệu (multipart/form-data).
  Future<MaterialModel> uploadMaterial({
    required String classId,
    required String title,
    String? description,
    required String filePath,
    required String fileName,
  }) async {
    final formData = FormData.fromMap({
      'title': title,
      if (description != null) 'description': description,
      'file': await MultipartFile.fromFile(filePath, filename: fileName),
    });

    final response = await _dio.post(
      '/api/v1/classes/$classId/materials',
      data: formData,
    );
    return MaterialModel.fromJson(response.data['data'] as Map<String, dynamic>);
  }

  /// List tài liệu theo lớp.
  Future<List<MaterialModel>> getMaterials(String classId) async {
    final response = await _dio.get('/api/v1/classes/$classId/materials');
    final list = response.data['data'] as List<dynamic>? ?? [];
    return list.map((e) => MaterialModel.fromJson(e as Map<String, dynamic>)).toList();
  }

  /// Xóa tài liệu.
  Future<void> deleteMaterial(String materialId) async {
    await _dio.delete('/api/v1/materials/$materialId');
  }

  // ═══════════ ASSESSMENTS ═══════════

  /// Tạo bài tập/kiểm tra (multipart/form-data).
  Future<AssessmentModel> createAssessment({
    required String classId,
    required String title,
    String? description,
    required String type,
    DateTime? opensAt,
    DateTime? closesAt,
    int? durationMin,
    String? filePath,
    String? fileName,
  }) async {
    final map = <String, dynamic>{
      'title': title,
      'type': type,
      if (description != null) 'description': description,
      if (opensAt != null) 'opensAt': opensAt.toUtc().toIso8601String(),
      if (closesAt != null) 'closesAt': closesAt.toUtc().toIso8601String(),
      if (durationMin != null) 'durationMin': durationMin,
    };

    if (filePath != null && fileName != null) {
      map['file'] = await MultipartFile.fromFile(filePath, filename: fileName);
    }

    final response = await _dio.post(
      '/api/v1/classes/$classId/assessments',
      data: FormData.fromMap(map),
    );
    return AssessmentModel.fromJson(response.data['data'] as Map<String, dynamic>);
  }

  /// List bài tập/kiểm tra theo lớp.
  Future<List<AssessmentModel>> getAssessments(String classId, {String? type}) async {
    final response = await _dio.get(
      '/api/v1/classes/$classId/assessments',
      queryParameters: {if (type != null) 'type': type},
    );
    final list = response.data['data'] as List<dynamic>? ?? [];
    return list.map((e) => AssessmentModel.fromJson(e as Map<String, dynamic>)).toList();
  }

  /// Publish assessment.
  Future<AssessmentModel> publishAssessment(String assessmentId) async {
    final response = await _dio.patch('/api/v1/assessments/$assessmentId/publish');
    return AssessmentModel.fromJson(response.data['data'] as Map<String, dynamic>);
  }

  /// Xóa assessment.
  Future<void> deleteAssessment(String assessmentId) async {
    await _dio.delete('/api/v1/assessments/$assessmentId');
  }

  /// Chi tiết assessment.
  Future<AssessmentModel> getAssessmentDetail(String assessmentId) async {
    final response = await _dio.get('/api/v1/assessments/$assessmentId');
    return AssessmentModel.fromJson(response.data['data'] as Map<String, dynamic>);
  }

  /// Lấy danh sách lớp (dùng cho class selector trên TeachingScreen).
  /// GS: /api/v1/tutor/classes, PH: /api/v1/parent/classes, HS: /api/v1/student/classes
  Future<List<Map<String, dynamic>>> getMyClassesForRole(String role) async {
    final endpoint = switch (role) {
      'TUTOR' => '/api/v1/tutor/classes',
      'STUDENT' => '/api/v1/student/classes',
      _ => '/api/v1/parent/classes',
    };
    final response = await _dio.get(endpoint);
    final list = response.data['data'] as List<dynamic>? ?? [];
    return list.cast<Map<String, dynamic>>();
  }
  // ═══════════ SUBMISSIONS ═══════════

  /// HS nộp bài — hỗ trợ nhiều file (ảnh chụp + file thông thường).
  Future<SubmissionModel> submitAssignment({
    required String assessmentId,
    required List<Map<String, String>> files,
  }) async {
    final fileEntries = await Future.wait(
      files.map((f) => MultipartFile.fromFile(f['path']!, filename: f['name'])),
    );

    final formData = FormData.fromMap({'files': fileEntries});

    final response = await _dio.post(
      '/api/v1/assessments/$assessmentId/submissions',
      data: formData,
    );
    return SubmissionModel.fromJson(response.data['data'] as Map<String, dynamic>);
  }

  /// GS xem tất cả bài nộp.
  Future<List<SubmissionModel>> getSubmissions(String assessmentId) async {
    final response = await _dio.get('/api/v1/assessments/$assessmentId/submissions');
    final list = response.data['data'] as List<dynamic>? ?? [];
    return list.map((e) => SubmissionModel.fromJson(e as Map<String, dynamic>)).toList();
  }

  /// Chi tiết bài nộp.
  Future<SubmissionModel> getSubmissionDetail(String submissionId) async {
    final response = await _dio.get('/api/v1/submissions/$submissionId');
    return SubmissionModel.fromJson(response.data['data'] as Map<String, dynamic>);
  }

  /// GS chấm điểm.
  Future<SubmissionModel> gradeSubmission({
    required String submissionId,
    double? score,
    String? comment,
    String? tutorFilePath,
    String? tutorFileName,
  }) async {
    final map = <String, dynamic>{
      if (score != null) 'score': score,
      if (comment != null) 'comment': comment,
    };

    if (tutorFilePath != null && tutorFileName != null) {
      map['tutorFile'] = await MultipartFile.fromFile(tutorFilePath, filename: tutorFileName);
    }

    final response = await _dio.put(
      '/api/v1/submissions/$submissionId/grade',
      data: FormData.fromMap(map),
    );
    return SubmissionModel.fromJson(response.data['data'] as Map<String, dynamic>);
  }

  /// GS đánh dấu hoàn thành.
  Future<SubmissionModel> markComplete(String submissionId) async {
    final response = await _dio.patch('/api/v1/submissions/$submissionId/complete');
    return SubmissionModel.fromJson(response.data['data'] as Map<String, dynamic>);
  }

  /// HS xem bài nộp của mình trong 1 assessment.
  Future<SubmissionModel?> getMySubmission(String assessmentId) async {
    final response = await _dio.get('/api/v1/assessments/$assessmentId/my-submission');
    final data = response.data['data'];
    if (data == null) return null;
    return SubmissionModel.fromJson(data as Map<String, dynamic>);
  }

  // ═══════════ SCHEDULE EVENTS ═══════════

  /// Lấy teaching events (deadline BT + lịch KT) cho calendar.
  Future<List<Map<String, dynamic>>> getScheduleEvents({
    required String startDate,
    required String endDate,
  }) async {
    final response = await _dio.get(
      '/api/v1/schedule/events',
      queryParameters: {'startDate': startDate, 'endDate': endDate},
    );
    final list = response.data['data'] as List<dynamic>? ?? [];
    return list.cast<Map<String, dynamic>>();
  }

  // ═══════════ PROGRESS ═══════════

  /// PH xem tiến độ HS trong 1 lớp.
  Future<List<Map<String, dynamic>>> getClassProgress(String classId) async {
    final response = await _dio.get('/api/v1/classes/$classId/progress');
    final list = response.data['data'] as List<dynamic>? ?? [];
    return list.cast<Map<String, dynamic>>();
  }
}
