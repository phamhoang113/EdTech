import 'package:equatable/equatable.dart';

/// Buổi học sắp tới — domain entity cho Home screen.
class UpcomingSessionEntity extends Equatable {
  final String id;
  final String classTitle;
  final String subject;
  final String sessionDate;
  final String startTime;
  final String endTime;
  final String status;
  final String? tutorName;

  const UpcomingSessionEntity({
    required this.id,
    required this.classTitle,
    required this.subject,
    required this.sessionDate,
    required this.startTime,
    required this.endTime,
    required this.status,
    this.tutorName,
  });

  factory UpcomingSessionEntity.fromJson(Map<String, dynamic> json) {
    return UpcomingSessionEntity(
      id: json['id']?.toString() ?? '',
      classTitle: json['classTitle']?.toString() ?? '',
      subject: json['subject']?.toString() ?? '',
      sessionDate: json['sessionDate']?.toString() ?? '',
      startTime: json['startTime']?.toString() ?? '',
      endTime: json['endTime']?.toString() ?? '',
      status: json['status']?.toString() ?? '',
      tutorName: json['tutorName']?.toString(),
    );
  }

  @override
  List<Object?> get props => [id, sessionDate, startTime];
}
