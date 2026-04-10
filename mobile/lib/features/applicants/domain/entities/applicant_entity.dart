import 'package:equatable/equatable.dart';

/// Gia sư được đề xuất cho lớp — domain entity cho ApplicantsScreen.
class ApplicantEntity extends Equatable {
  final String applicationId;
  final String classId;
  final String classTitle;
  final String tutorId;
  final String tutorName;
  final String? tutorPhone;
  final String? tutorType;
  final String? dateOfBirth;
  final String? achievements;
  final double? rating;
  final int? ratingCount;
  final double? proposedSalary;
  final int tutorActiveClassesCount;
  final int tutorPendingApplicationsCount;
  final String status;
  final String? note;
  final String? appliedAt;
  final List<String>? certBase64s;

  const ApplicantEntity({
    required this.applicationId,
    required this.classId,
    required this.classTitle,
    required this.tutorId,
    required this.tutorName,
    this.tutorPhone,
    this.tutorType,
    this.dateOfBirth,
    this.achievements,
    this.rating,
    this.ratingCount,
    this.proposedSalary,
    this.tutorActiveClassesCount = 0,
    this.tutorPendingApplicationsCount = 0,
    required this.status,
    this.note,
    this.appliedAt,
    this.certBase64s,
  });

  factory ApplicantEntity.fromJson(Map<String, dynamic> json) {
    return ApplicantEntity(
      applicationId: json['applicationId']?.toString() ?? '',
      classId: json['classId']?.toString() ?? '',
      classTitle: json['classTitle']?.toString() ?? '',
      tutorId: json['tutorId']?.toString() ?? '',
      tutorName: json['tutorName']?.toString() ?? 'Gia sư',
      tutorPhone: json['tutorPhone']?.toString(),
      tutorType: json['tutorType']?.toString(),
      dateOfBirth: json['dateOfBirth']?.toString(),
      achievements: json['achievements']?.toString(),
      rating: (json['rating'] ?? 0).toDouble(),
      ratingCount: json['ratingCount'] as int?,
      proposedSalary: json['proposedSalary'] != null
          ? (json['proposedSalary']).toDouble()
          : null,
      tutorActiveClassesCount:
          json['tutorActiveClassesCount'] as int? ?? 0,
      tutorPendingApplicationsCount:
          json['tutorPendingApplicationsCount'] as int? ?? 0,
      status: json['status']?.toString() ?? '',
      note: json['note']?.toString(),
      appliedAt: json['appliedAt']?.toString(),
      certBase64s: (json['certBase64s'] as List<dynamic>?)
          ?.map((e) => e.toString())
          .toList(),
    );
  }

  @override
  List<Object?> get props => [applicationId, tutorId, status];
}
