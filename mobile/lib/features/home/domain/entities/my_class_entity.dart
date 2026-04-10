import 'package:equatable/equatable.dart';

/// Lớp học của phụ huynh/học sinh — domain entity.
class MyClassEntity extends Equatable {
  final String id;
  final String? classCode;
  final String title;
  final String subject;
  final String grade;
  final String status;
  final String? mode;
  final String? tutorName;
  final String? tutorPhone;
  final String? schedule;
  final int? sessionsPerWeek;
  final int? sessionDurationMin;
  final String? levelFees;
  final String? genderRequirement;
  final double? parentFee;
  final int pendingApplicationCount;
  final List<String> studentIds;

  const MyClassEntity({
    required this.id,
    this.classCode,
    required this.title,
    required this.subject,
    required this.grade,
    required this.status,
    this.mode,
    this.tutorName,
    this.tutorPhone,
    this.schedule,
    this.sessionsPerWeek,
    this.sessionDurationMin,
    this.levelFees,
    this.genderRequirement,
    this.parentFee,
    this.pendingApplicationCount = 0,
    this.studentIds = const [],
  });

  factory MyClassEntity.fromJson(Map<String, dynamic> json) {
    return MyClassEntity(
      id: json['id']?.toString() ?? '',
      classCode: json['classCode']?.toString(),
      title: json['title']?.toString() ?? 'Lớp học',
      subject: json['subject']?.toString() ?? '',
      grade: json['grade']?.toString() ?? '',
      status: json['status']?.toString() ?? '',
      mode: json['mode']?.toString(),
      tutorName: json['tutorName']?.toString(),
      tutorPhone: json['tutorPhone']?.toString(),
      schedule: json['schedule']?.toString(),
      sessionsPerWeek: json['sessionsPerWeek'] as int?,
      sessionDurationMin: json['sessionDurationMin'] as int?,
      levelFees: json['levelFees']?.toString(),
      genderRequirement: json['genderRequirement']?.toString(),
      parentFee: json['parentFee'] != null ? (json['parentFee'] as num).toDouble() : null,
      pendingApplicationCount: json['pendingApplicationCount'] as int? ?? 0,
      studentIds: (json['studentIds'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          [],
    );
  }

  @override
  List<Object?> get props => [id, classCode, title, subject, grade, status, tutorName, studentIds, sessionDurationMin, levelFees, parentFee, genderRequirement];
}
