import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/tutor_profile_entity.dart';
import '../../domain/entities/tutor_public_entity.dart';
import '../../domain/entities/tutor_class_entity.dart';
import '../../domain/entities/tutor_session_entity.dart';
import '../../domain/repositories/tutor_profile_repository.dart';
import '../datasources/tutor_profile_remote_datasource.dart';

@Injectable(as: TutorProfileRepository)
class TutorProfileRepositoryImpl implements TutorProfileRepository {
  final TutorProfileRemoteDataSource remoteDataSource;

  TutorProfileRepositoryImpl(this.remoteDataSource);

  @override
  Future<Either<Failure, TutorProfileEntity>> getMyProfile() async {
    try {
      final profile = await remoteDataSource.getMyProfile();
      return Right(profile);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return const Left(ServerFailure('An unexpected error occurred.'));
    }
  }

  @override
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
  }) async {
    try {
      final profile = await remoteDataSource.verifyProfile(
        tutorType: tutorType,
        idCardNumber: idCardNumber,
        degree: degree,
        dateOfBirth: dateOfBirth,
        subjects: subjects,
        teachingLevels: teachingLevels,
        achievements: achievements,
        experienceYears: experienceYears,
        location: location,
      );
      return Right(profile);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return const Left(ServerFailure('An unexpected error occurred.'));
    }
  }

  @override
  Future<Either<Failure, List<TutorPublicEntity>>> getPublicTutors({int size = 9}) async {
    try {
      final tutors = await remoteDataSource.getPublicTutors(size: size);
      return Right(tutors);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return const Left(ServerFailure('Lỗi tải danh sách gia sư.'));
    }
  }

  @override
  Future<Either<Failure, List<TutorClassEntity>>> getMyClasses() async {
    try {
      final models = await remoteDataSource.getMyClasses();
      return Right(models.map((m) => m.toEntity()).toList());
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return const Left(ServerFailure('Lỗi tải danh sách lớp.'));
    }
  }

  @override
  Future<Either<Failure, List<TutorSessionEntity>>> getMySessions() async {
    try {
      final models = await remoteDataSource.getMySessions();
      return Right(models.map((m) => m.toEntity()).toList());
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return const Left(ServerFailure('Lỗi tải lịch dạy.'));
    }
  }

  @override
  Future<Map<String, List<String>>> getClassFilters() async {
    return remoteDataSource.getClassFilters();
  }
}
