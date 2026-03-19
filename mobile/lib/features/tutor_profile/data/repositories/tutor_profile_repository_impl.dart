import 'dart:io';
import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/tutor_profile_entity.dart';
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
    required File idCardFront,
    required File idCardBack,
    required File degree,
  }) async {
    try {
      final profile = await remoteDataSource.verifyProfile(
        tutorType: tutorType,
        idCardFront: idCardFront,
        idCardBack: idCardBack,
        degree: degree,
      );
      return Right(profile);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return const Left(ServerFailure('An unexpected error occurred.'));
    }
  }
}
