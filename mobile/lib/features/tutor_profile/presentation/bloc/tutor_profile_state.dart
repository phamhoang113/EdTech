import 'package:equatable/equatable.dart';

import '../../domain/entities/tutor_profile_entity.dart';
import '../../domain/entities/tutor_class_entity.dart';
import '../../domain/entities/tutor_session_entity.dart';

abstract class TutorProfileState extends Equatable {
  const TutorProfileState();

  @override
  List<Object?> get props => [];
}

class TutorProfileInitial extends TutorProfileState {}

class TutorProfileLoading extends TutorProfileState {}

class TutorProfileLoaded extends TutorProfileState {
  final TutorProfileEntity profile;

  const TutorProfileLoaded(this.profile);

  @override
  List<Object> get props => [profile];
}

/// Full dashboard state with profile + classes + sessions
class TutorDashboardLoaded extends TutorProfileState {
  final TutorProfileEntity profile;
  final List<TutorClassEntity> classes;
  final List<TutorSessionEntity> sessions;

  const TutorDashboardLoaded({
    required this.profile,
    required this.classes,
    required this.sessions,
  });

  /// Upcoming sessions: SCHEDULED + future date only
  List<TutorSessionEntity> get upcomingSessions {
    final now = DateTime.now();
    final todayStr = DateTime(now.year, now.month, now.day);
    return sessions
        .where((s) =>
            s.status == 'SCHEDULED' &&
            DateTime.tryParse(s.sessionDate)
                    ?.isAfter(todayStr.subtract(const Duration(days: 1))) ==
                true)
        .take(4)
        .toList();
  }

  /// Total monthly revenue from classes
  num get totalRevenue => classes.fold<num>(0, (sum, c) => sum + c.tutorFee);

  bool get isApproved => profile.verificationStatus == 'APPROVED';
  bool get isPending => profile.verificationStatus == 'PENDING';
  bool get isUnverified => profile.verificationStatus == 'UNVERIFIED';

  @override
  List<Object> get props => [profile, classes, sessions];
}

class TutorProfileError extends TutorProfileState {
  final String message;

  const TutorProfileError(this.message);

  @override
  List<Object> get props => [message];
}

class TutorProfileVerificationSuccess extends TutorProfileState {
  final TutorProfileEntity profile;

  const TutorProfileVerificationSuccess(this.profile);

  @override
  List<Object> get props => [profile];
}

/// State emitted when class filter data is loaded for the verification form.
class ClassFiltersLoaded extends TutorProfileState {
  final List<String> subjects;
  final List<String> levels;

  const ClassFiltersLoaded({required this.subjects, required this.levels});

  @override
  List<Object> get props => [subjects, levels];
}
