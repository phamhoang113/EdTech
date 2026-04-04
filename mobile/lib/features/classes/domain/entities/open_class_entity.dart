import 'package:equatable/equatable.dart';

class OpenClassEntity extends Equatable {
  final String id;
  final String title;
  final String subject;
  final String grade;
  final String? location;
  final String schedule;
  final String? timeFrame;
  final String classCode;
  final num feePercentage;
  final num parentFee;
  final num minTutorFee;
  final num maxTutorFee;
  final List<String> tutorLevelRequirement;
  final String genderRequirement;
  final int sessionsPerWeek;
  final int sessionDurationMin;
  final int studentCount;
  final String? levelFees;

  const OpenClassEntity({
    required this.id,
    required this.title,
    required this.subject,
    required this.grade,
    this.location,
    required this.schedule,
    this.timeFrame,
    required this.classCode,
    required this.feePercentage,
    required this.parentFee,
    required this.minTutorFee,
    required this.maxTutorFee,
    required this.tutorLevelRequirement,
    required this.genderRequirement,
    required this.sessionsPerWeek,
    required this.sessionDurationMin,
    required this.studentCount,
    this.levelFees,
  });

  @override
  List<Object?> get props => [
        id, title, subject, grade, location, schedule, timeFrame, classCode,
        feePercentage, parentFee, minTutorFee, maxTutorFee,
        tutorLevelRequirement, genderRequirement, sessionsPerWeek,
        sessionDurationMin, studentCount, levelFees,
      ];
}
