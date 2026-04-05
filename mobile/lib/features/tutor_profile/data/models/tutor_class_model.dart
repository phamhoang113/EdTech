import 'package:equatable/equatable.dart';

/// A class assigned to the tutor (from GET /api/v1/tutor/classes)
class TutorClassModel extends Equatable {
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

  const TutorClassModel({
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

  factory TutorClassModel.fromJson(Map<String, dynamic> json) {
    return TutorClassModel(
      id: json['id']?.toString() ?? '',
      classCode: json['classCode']?.toString() ?? '',
      title: json['title']?.toString() ?? '',
      subject: json['subject']?.toString() ?? '',
      grade: json['grade']?.toString() ?? '',
      mode: json['mode']?.toString() ?? '',
      status: json['status']?.toString() ?? '',
      sessionsPerWeek: json['sessionsPerWeek'] as int? ?? 0,
      sessionDurationMin: json['sessionDurationMin'] as int? ?? 0,
      tutorFee: json['tutorFee'] as num? ?? 0,
      startDate: json['startDate'] as String?,
      endDate: json['endDate'] as String?,
      schedule: json['schedule']?.toString(),
      address: json['address'] as String?,
      description: json['description'] as String?,
    );
  }

  @override
  List<Object?> get props => [id, classCode, title, subject, grade, mode, status];
}
