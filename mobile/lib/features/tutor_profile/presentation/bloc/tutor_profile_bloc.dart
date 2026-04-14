import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/di/injection.dart';
import '../../../../core/di/tutor_verification_notifier.dart';

import '../../domain/entities/tutor_profile_entity.dart';
import '../../domain/entities/tutor_session_entity.dart';
import '../../domain/entities/tutor_class_entity.dart';
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
    on<LoadClassFilters>(_onLoadClassFilters);
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
  /// Retries once on failure to avoid false UNVERIFIED status
  /// from transient connection issues (e.g., ADB reverse not ready).
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

    // Retry up to 2 attempts
    for (int attempt = 0; attempt < 2; attempt++) {
      try {
        final state = await _loadDashboardData()
            .timeout(const Duration(seconds: 12));

        getIt<TutorVerificationNotifier>().updateStatus(state.profile.verificationStatus);
        emit(state);
        return; // Success — exit
      } catch (_) {
        if (attempt == 0) {
          // Wait briefly before retry
          await Future.delayed(const Duration(seconds: 2));
        }
      }
    }

    // All attempts failed → fallback
    getIt<TutorVerificationNotifier>().updateStatus('UNVERIFIED');
    emit(fallbackState);
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
    final sessions = <TutorSessionEntity>[];
    try {
      final sessionsResult = await repository.getMySessions();
      sessions.addAll(sessionsResult.getOrElse(() => []));
    } catch (_) {}

    final classes = classesResult.getOrElse(() => <TutorClassEntity>[]);

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

  Future<void> _onLoadClassFilters(
    LoadClassFilters event,
    Emitter<TutorProfileState> emit,
  ) async {
    try {
      final data = await repository.getClassFilters();
      final subjects = (data['subjects'] ?? []).where((s) => s != 'Khác').toList();
      final levels = (data['levels'] ?? []).where((l) => l != 'Khác').toList();
      emit(ClassFiltersLoaded(subjects: subjects, levels: levels));
    } catch (e) {
      emit(TutorProfileError('Không thể tải dữ liệu bộ lọc: $e'));
    }
  }
}
