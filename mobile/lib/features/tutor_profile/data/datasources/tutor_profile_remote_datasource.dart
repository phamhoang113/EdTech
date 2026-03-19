import 'dart:io';
import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/network/dio_client.dart';
import '../models/tutor_profile_model.dart';
import '../../../../core/error/exceptions.dart';
import 'package:http_parser/http_parser.dart';

abstract class TutorProfileRemoteDataSource {
  Future<TutorProfileModel> getMyProfile();
  Future<TutorProfileModel> verifyProfile({
    required String tutorType,
    required File idCardFront,
    required File idCardBack,
    required File degree,
  });
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
      if (e.response != null && e.response!.data is Map<String, dynamic>) {
        throw ServerException(e.response!.data['message'] ?? 'Network error');
      }
      throw const ServerException('Network error');
    }
  }

  @override
  Future<TutorProfileModel> verifyProfile({
    required String tutorType,
    required File idCardFront,
    required File idCardBack,
    required File degree,
  }) async {
    try {
      final String frontExt = idCardFront.path.split('.').last;
      final String backExt = idCardBack.path.split('.').last;
      final String degreeExt = degree.path.split('.').last;

      final formData = FormData.fromMap({
        'tutorType': tutorType,
        'idCardFront': await MultipartFile.fromFile(
          idCardFront.path,
          contentType: MediaType('image', frontExt == 'jpg' ? 'jpeg' : frontExt),
        ),
        'idCardBack': await MultipartFile.fromFile(
          idCardBack.path,
          contentType: MediaType('image', backExt == 'jpg' ? 'jpeg' : backExt),
        ),
        'degree': await MultipartFile.fromFile(
          degree.path,
          contentType: MediaType('image', degreeExt == 'jpg' ? 'jpeg' : degreeExt),
        ),
      });

      final response = await _dioClient.dio.post(
        '/api/v1/tutors/profile/verify',
        data: formData,
      );

      if (response.statusCode == 200 && response.data['data'] != null) {
        return TutorProfileModel.fromJson(response.data['data']);
      } else {
        throw ServerException(response.data['message'] ?? 'Failed to verify profile');
      }
    } on DioException catch (e) {
      if (e.response != null && e.response!.data is Map<String, dynamic>) {
        throw ServerException(e.response!.data['message'] ?? 'Network error');
      }
      throw const ServerException('Network error');
    }
  }
}
