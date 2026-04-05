import 'package:equatable/equatable.dart';

/// A teaching session (from GET /api/v1/tutor/sessions)
class TutorSessionModel extends Equatable {
  final String id;
  final String classId;
  final String? classCode;
  final String classTitle;
  final String subject;
  final String tutorName;
  final String tutorPhone;
  final String sessionDate;
  final String startTime;
  final String endTime;
  final String? meetLink;
  final String status; // DRAFT, SCHEDULED, LIVE, COMPLETED, CANCELLED
  final String sessionType; // REGULAR, MAKEUP, EXTRA
  final String? tutorNote;
  final String? address;

  const TutorSessionModel({
    required this.id,
    required this.classId,
    this.classCode,
    required this.classTitle,
    required this.subject,
    required this.tutorName,
    required this.tutorPhone,
    required this.sessionDate,
    required this.startTime,
    required this.endTime,
    this.meetLink,
    required this.status,
    required this.sessionType,
    this.tutorNote,
    this.address,
  });

  factory TutorSessionModel.fromJson(Map<String, dynamic> json) {
    return TutorSessionModel(
      id: json['id']?.toString() ?? '',
      classId: json['classId']?.toString() ?? '',
      classCode: json['classCode'] as String?,
      classTitle: json['classTitle']?.toString() ?? '',
      subject: json['subject']?.toString() ?? '',
      tutorName: json['tutorName']?.toString() ?? '',
      tutorPhone: json['tutorPhone']?.toString() ?? '',
      sessionDate: json['sessionDate']?.toString() ?? '',
      startTime: json['startTime']?.toString() ?? '',
      endTime: json['endTime']?.toString() ?? '',
      meetLink: json['meetLink'] as String?,
      status: json['status']?.toString() ?? 'DRAFT',
      sessionType: json['sessionType']?.toString() ?? 'REGULAR',
      tutorNote: json['tutorNote'] as String?,
      address: json['address'] as String?,
    );
  }

  @override
  List<Object?> get props => [id, classId, sessionDate, status];
}
