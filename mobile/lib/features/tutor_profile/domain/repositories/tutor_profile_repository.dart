import 'dart:io';
import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/tutor_profile_entity.dart';
import '../entities/tutor_public_entity.dart';
import '../../data/models/tutor_class_model.dart';
import '../../data/models/tutor_session_model.dart';

abstract class TutorProfileRepository {
  Future<Either<Failure, TutorProfileEntity>> getMyProfile();

  Future<Either<Failure, TutorProfileEntity>> verifyProfile({
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

  Future<Either<Failure, List<TutorPublicEntity>>> getPublicTutors({int size = 9});
  Future<Either<Failure, List<TutorClassModel>>> getMyClasses();
  Future<Either<Failure, List<TutorSessionModel>>> getMySessions();

  /// Get available subjects + grade levels for class filters
  Future<Map<String, List<String>>> getClassFilters();
}
