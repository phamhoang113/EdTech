import 'package:equatable/equatable.dart';

import '../../domain/entities/tutor_public_entity.dart';

abstract class PublicTutorState extends Equatable {
  const PublicTutorState();

  @override
  List<Object> get props => [];
}

class PublicTutorInitial extends PublicTutorState {}

class PublicTutorLoading extends PublicTutorState {}

class PublicTutorLoaded extends PublicTutorState {
  final List<TutorPublicEntity> tutors;

  const PublicTutorLoaded(this.tutors);

  @override
  List<Object> get props => [tutors];
}

class PublicTutorError extends PublicTutorState {
  final String message;

  const PublicTutorError(this.message);

  @override
  List<Object> get props => [message];
}
