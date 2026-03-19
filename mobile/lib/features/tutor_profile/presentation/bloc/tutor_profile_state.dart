import 'package:equatable/equatable.dart';
import '../../domain/entities/tutor_profile_entity.dart';

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
