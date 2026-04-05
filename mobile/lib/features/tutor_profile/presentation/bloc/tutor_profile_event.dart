import 'dart:io';
import 'package:equatable/equatable.dart';

abstract class TutorProfileEvent extends Equatable {
  const TutorProfileEvent();

  @override
  List<Object?> get props => [];
}

class LoadTutorProfile extends TutorProfileEvent {}

/// Loads all dashboard data: profile + classes + sessions
class LoadTutorDashboard extends TutorProfileEvent {}

/// Submit verification — all 9 fields matching BE endpoint
class VerifyTutorProfile extends TutorProfileEvent {
  final String tutorType;
  final String idCardNumber;
  final File? degree;
  final String? dateOfBirth;
  final List<String>? subjects;
  final List<String>? teachingLevels;
  final String? achievements;
  final int? experienceYears;
  final String? location;

  const VerifyTutorProfile({
    required this.tutorType,
    required this.idCardNumber,
    this.degree,
    this.dateOfBirth,
    this.subjects,
    this.teachingLevels,
    this.achievements,
    this.experienceYears,
    this.location,
  });

  @override
  List<Object?> get props => [tutorType, idCardNumber, degree, dateOfBirth, subjects, teachingLevels];
}
