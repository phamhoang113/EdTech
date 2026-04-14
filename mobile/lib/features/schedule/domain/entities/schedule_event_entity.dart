import 'package:equatable/equatable.dart';

/// Union type cho calendar events: session + deadline BT + lịch KT.
class ScheduleEventEntity extends Equatable {
  final String type; // SESSION | HOMEWORK_DEADLINE | EXAM
  final String title;
  final String date; // yyyy-MM-dd
  final String? startTime; // HH:mm
  final String? endTime;
  final int? durationMin;
  final String? className;
  final String? assessmentId;
  final String? submissionStatus;
  final String? status; // cho SESSION

  const ScheduleEventEntity({
    required this.type,
    required this.title,
    required this.date,
    this.startTime,
    this.endTime,
    this.durationMin,
    this.className,
    this.assessmentId,
    this.submissionStatus,
    this.status,
  });

  factory ScheduleEventEntity.fromJson(Map<String, dynamic> json) {
    return ScheduleEventEntity(
      type: json['type'] as String,
      title: json['title'] as String,
      date: json['date'] as String,
      startTime: json['startTime'] as String?,
      endTime: json['endTime'] as String?,
      durationMin: (json['durationMin'] as num?)?.toInt(),
      className: json['className'] as String?,
      assessmentId: json['assessmentId'] as String?,
      submissionStatus: json['submissionStatus'] as String?,
      status: json['status'] as String?,
    );
  }

  bool get isSession => type == 'SESSION';
  bool get isHomeworkDeadline => type == 'HOMEWORK_DEADLINE';
  bool get isExam => type == 'EXAM';

  /// Dot color cho calendar grid
  int get dotColorValue {
    switch (type) {
      case 'HOMEWORK_DEADLINE': return 0xFFF59E0B; // Orange
      case 'EXAM': return 0xFFEF4444; // Red
      default: return 0xFF6366F1; // Indigo (session)
    }
  }

  /// Icon cho event card
  String get iconName {
    switch (type) {
      case 'HOMEWORK_DEADLINE': return 'assignment';
      case 'EXAM': return 'quiz';
      default: return 'event';
    }
  }

  @override
  List<Object?> get props => [type, title, date, startTime, assessmentId];
}
