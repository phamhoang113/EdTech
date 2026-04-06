import 'package:equatable/equatable.dart';

/// Lớp đã nhận của gia sư — domain entity.
class TutorClassEntity extends Equatable {
  final String id;
  final String classCode;
  final String title;
  final String subject;
  final String grade;
  final String mode;
  final String status;
  final int sessionsPerWeek;
  final int sessionDurationMin;
  final num tutorFee;
  final String? startDate;
  final String? endDate;
  final String? schedule;
  final String? address;
  final String? description;

  const TutorClassEntity({
    required this.id,
    required this.classCode,
    required this.title,
    required this.subject,
    required this.grade,
    required this.mode,
    required this.status,
    required this.sessionsPerWeek,
    required this.sessionDurationMin,
    required this.tutorFee,
    this.startDate,
    this.endDate,
    this.schedule,
    this.address,
    this.description,
  });

  @override
  List<Object?> get props => [id, classCode, title, subject, grade, mode, status];
}
