import 'dart:io';
import 'package:equatable/equatable.dart';

abstract class TutorProfileEvent extends Equatable {
  const TutorProfileEvent();

  @override
  List<Object?> get props => [];
}

class LoadTutorProfile extends TutorProfileEvent {}

class VerifyTutorProfile extends TutorProfileEvent {
  final String tutorType;
  final File idCardFront;
  final File idCardBack;
  final File degree;

  const VerifyTutorProfile({
    required this.tutorType,
    required this.idCardFront,
    required this.idCardBack,
    required this.degree,
  });

  @override
  List<Object> get props => [tutorType, idCardFront, idCardBack, degree];
}
