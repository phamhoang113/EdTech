import 'dart:io';
import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:http_parser/http_parser.dart';

import '../../../../core/network/dio_client.dart';
import '../../../../core/error/exceptions.dart';
import '../models/tutor_profile_model.dart';
import '../models/tutor_public_model.dart';
import '../models/tutor_class_model.dart';
import '../models/tutor_session_model.dart';

abstract class TutorProfileRemoteDataSource {
  Future<TutorProfileModel> getMyProfile();

  Future<TutorProfileModel> verifyProfile({
    required String tutorType,
    required String idCardNumber,
    File? degree,
    String? dateOfBirth,
    List<String>? subjects,
    List<String>? teachingLevels,
    String? achievements,
    int? experienceYears,
    String? location,
  });

  Future<List<TutorPublicModel>> getPublicTutors({int size = 9});
  Future<List<TutorClassModel>> getMyClasses();
  Future<List<TutorSessionModel>> getMySessions();

  /// Fetch subjects + grade levels for filters
  Future<Map<String, List<String>>> getClassFilters();
}

@Injectable(as: TutorProfileRemoteDataSource)
class TutorProfileRemoteDataSourceImpl implements TutorProfileRemoteDataSource {
  final DioClient _dioClient;

  TutorProfileRemoteDataSourceImpl(this._dioClient);

  @override
  Future<TutorProfileModel> getMyProfile() async {
    try {
      final response = await _dioClient.dio.get('/api/v1/tutors/profile/me');
      if (response.statusCode == 200 && response.data['data'] != null) {
        return TutorProfileModel.fromJson(response.data['data']);
      } else {
        throw ServerException(response.data['message'] ?? 'Failed to get profile');
      }
    } on DioException catch (e) {
      throw ServerException(_extractErrorMessage(e));
    }
  }

  @override
  Future<TutorProfileModel> verifyProfile({
    required String tutorType,
    required String idCardNumber,
    File? degree,
    String? dateOfBirth,
    List<String>? subjects,
    List<String>? teachingLevels,
    String? achievements,
    int? experienceYears,
    String? location,
  }) async {
    try {
      final Map<String, dynamic> formMap = {
        'tutorType': tutorType,
        'idCardNumber': idCardNumber,
      };

      // Optional fields
      if (dateOfBirth != null) formMap['dateOfBirth'] = dateOfBirth;
      if (achievements != null && achievements.isNotEmpty) {
        formMap['achievements'] = achievements;
      }
      if (experienceYears != null) formMap['experienceYears'] = experienceYears;
      if (location != null && location.isNotEmpty) formMap['location'] = location;

      // MultipartFile — degree image
      if (degree != null) {
        final ext = degree.path.split('.').last.toLowerCase();
        formMap['degree'] = await MultipartFile.fromFile(
          degree.path,
          contentType: MediaType('image', ext == 'jpg' ? 'jpeg' : ext),
        );
      }

      // List params need special handling for FormData
      final formData = FormData.fromMap(formMap);

      // Append lists separately (FormData.fromMap doesn't handle list correctly for BE @RequestParam)
      if (subjects != null) {
        for (final s in subjects) {
          formData.fields.add(MapEntry('subjects', s));
        }
      }
      if (teachingLevels != null) {
        for (final l in teachingLevels) {
          formData.fields.add(MapEntry('teachingLevels', l));
        }
      }

      final response = await _dioClient.dio.post(
        '/api/v1/tutors/profile/verify',
        data: formData,
      );

      if (response.statusCode == 200 && response.data['data'] != null) {
        return TutorProfileModel.fromJson(response.data['data']);
      } else {
        throw ServerException(response.data['message'] ?? 'Xác thực thất bại');
      }
    } on DioException catch (e) {
      throw ServerException(_extractErrorMessage(e));
    }
  }

  @override
  Future<List<TutorPublicModel>> getPublicTutors({int size = 9}) async {
    try {
      final response = await _dioClient.dio.get(
        '/api/v1/public/tutors',
        queryParameters: {'size': size, 'sort': 'rating,desc'},
      );
      if (response.statusCode == 200 && response.data['data'] != null) {
        final content = response.data['data']['content'] as List? ?? [];
        return content
            .map((e) => TutorPublicModel.fromJson(e as Map<String, dynamic>))
            .toList();
      }
      return [];
    } on DioException catch (e) {
      throw ServerException(_extractErrorMessage(e));
    }
  }

  @override
  Future<List<TutorClassModel>> getMyClasses() async {
    try {
      final response = await _dioClient.dio.get('/api/v1/tutor/classes');
      if (response.data is List) {
        return (response.data as List)
            .map((e) => TutorClassModel.fromJson(e as Map<String, dynamic>))
            .toList();
      }
      return [];
    } on DioException catch (e) {
      throw ServerException(_extractErrorMessage(e));
    }
  }

  @override
  Future<List<TutorSessionModel>> getMySessions() async {
    try {
      final response = await _dioClient.dio.get('/api/v1/tutor/sessions');
      if (response.data is List) {
        return (response.data as List)
            .map((e) => TutorSessionModel.fromJson(e as Map<String, dynamic>))
            .toList();
      }
      return [];
    } on DioException catch (e) {
      throw ServerException(_extractErrorMessage(e));
    }
  }

  @override
  Future<Map<String, List<String>>> getClassFilters() async {
    try {
      final response = await _dioClient.dio.get('/api/v1/classes/filters');
      final data = response.data['data'] as Map<String, dynamic>? ?? {};
      final subjects = (data['subjects'] as List?)?.cast<String>() ?? [];
      final levels = (data['levels'] as List?)?.cast<String>() ?? [];
      return {'subjects': subjects, 'levels': levels};
    } on DioException {
      // Fallback defaults (same as web)
      return {
        'subjects': ['Toán', 'Vật Lý', 'Hóa Học', 'Sinh Học', 'Ngữ Văn', 'Tiếng Anh', 'Tin Học'],
        'levels': ['Mầm non', 'Lớp 1', 'Lớp 2', 'Lớp 3', 'Lớp 4', 'Lớp 5', 'Lớp 6', 'Lớp 7', 'Lớp 8', 'Lớp 9', 'Lớp 10', 'Lớp 11', 'Lớp 12', 'Đại học'],
      };
    }
  }

  String _extractErrorMessage(DioException e) =>
      e.response?.data?['message'] as String? ?? e.message ?? 'Network error';
}
