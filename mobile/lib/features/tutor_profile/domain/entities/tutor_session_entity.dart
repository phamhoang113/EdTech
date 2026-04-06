import 'package:equatable/equatable.dart';

/// Buổi dạy của gia sư — domain entity.
class TutorSessionEntity extends Equatable {
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

  const TutorSessionEntity({
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

  @override
  List<Object?> get props => [id, classId, sessionDate, status];
}
