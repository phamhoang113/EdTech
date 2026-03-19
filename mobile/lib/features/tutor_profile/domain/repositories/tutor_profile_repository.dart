import 'dart:io';
import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/tutor_profile_entity.dart';

abstract class TutorProfileRepository {
  Future<Either<Failure, TutorProfileEntity>> getMyProfile();
  
  Future<Either<Failure, TutorProfileEntity>> verifyProfile({
    required String tutorType,
    required File idCardFront,
    required File idCardBack,
    required File degree,
  });
}
