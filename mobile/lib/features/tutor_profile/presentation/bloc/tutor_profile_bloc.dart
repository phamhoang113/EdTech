import 'package:dartz/dartz.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/di/injection.dart';
import '../../../../core/di/tutor_verification_notifier.dart';
import '../../../../core/error/failures.dart';

import '../../data/models/tutor_class_model.dart';
import '../../data/models/tutor_session_model.dart';
import '../../domain/entities/tutor_profile_entity.dart';
import '../../domain/repositories/tutor_profile_repository.dart';
import 'tutor_profile_event.dart';
import 'tutor_profile_state.dart';

@injectable
class TutorProfileBloc extends Bloc<TutorProfileEvent, TutorProfileState> {
  final TutorProfileRepository repository;

  TutorProfileBloc(this.repository) : super(TutorProfileInitial()) {
    on<LoadTutorProfile>(_onLoadTutorProfile);
    on<LoadTutorDashboard>(_onLoadDashboard);
    on<VerifyTutorProfile>(_onVerifyTutorProfile);
  }

  Future<void> _onLoadTutorProfile(
    LoadTutorProfile event,
    Emitter<TutorProfileState> emit,
  ) async {
    emit(TutorProfileLoading());
    final result = await repository.getMyProfile();
    result.fold(
      (failure) => emit(TutorProfileError(failure.message)),
      (profile) => emit(TutorProfileLoaded(profile)),
    );
  }

  /// Load all dashboard data: profile + classes + sessions.
  /// Uses Completer + Timer to guarantee state emission within 6s,
  /// even if Dio/SecureStorage hangs on web.
  Future<void> _onLoadDashboard(
    LoadTutorDashboard event,
    Emitter<TutorProfileState> emit,
  ) async {
    emit(TutorProfileLoading());

    const fallbackProfile = TutorProfileEntity(verificationStatus: 'UNVERIFIED');
    const fallbackState = TutorDashboardLoaded(
      profile: fallbackProfile,
      classes: [],
      sessions: [],
    );

    try {
      // Race: API calls vs 6s deadline
      final state = await Future.any<TutorDashboardLoaded>([
        _loadDashboardData(),
        Future.delayed(const Duration(seconds: 6), () => fallbackState),
      ]);

      getIt<TutorVerificationNotifier>().updateStatus(state.profile.verificationStatus);
      emit(state);
    } catch (e) {
      getIt<TutorVerificationNotifier>().updateStatus('UNVERIFIED');
      emit(fallbackState);
    }
  }

  /// Actual API calls separated from timeout logic.
  Future<TutorDashboardLoaded> _loadDashboardData() async {
    final profileResult = await repository.getMyProfile();

    TutorProfileEntity profile;
    if (profileResult.isLeft()) {
      profile = const TutorProfileEntity(verificationStatus: 'UNVERIFIED');
    } else {
      profile = profileResult.getOrElse(() => const TutorProfileEntity());
    }

    // Classes & sessions — silent failures
    final classesResult = await repository.getMyClasses();
    final sessions = <TutorSessionModel>[];
    try {
      final sessionsResult = await repository.getMySessions();
      sessions.addAll(sessionsResult.getOrElse(() => []));
    } catch (_) {}

    final classes = classesResult.getOrElse(() => <TutorClassModel>[]);

    return TutorDashboardLoaded(
      profile: profile,
      classes: classes,
      sessions: sessions,
    );
  }

  Future<void> _onVerifyTutorProfile(
    VerifyTutorProfile event,
    Emitter<TutorProfileState> emit,
  ) async {
    emit(TutorProfileLoading());
    final result = await repository.verifyProfile(
      tutorType: event.tutorType,
      idCardNumber: event.idCardNumber,
      degree: event.degree,
      dateOfBirth: event.dateOfBirth,
      subjects: event.subjects,
      teachingLevels: event.teachingLevels,
      achievements: event.achievements,
      experienceYears: event.experienceYears,
      location: event.location,
    );
    result.fold(
      (failure) => emit(TutorProfileError(failure.message)),
      (profile) => emit(TutorProfileVerificationSuccess(profile)),
    );
  }
}
