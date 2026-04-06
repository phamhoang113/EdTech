import 'package:equatable/equatable.dart';

/// Lớp học của phụ huynh/học sinh — domain entity.
class MyClassEntity extends Equatable {
  final String id;
  final String? classCode;
  final String title;
  final String subject;
  final String grade;
  final String status;
  final int pendingApplicationCount;

  const MyClassEntity({
    required this.id,
    this.classCode,
    required this.title,
    required this.subject,
    required this.grade,
    required this.status,
    this.pendingApplicationCount = 0,
  });

  factory MyClassEntity.fromJson(Map<String, dynamic> json) {
    return MyClassEntity(
      id: json['id']?.toString() ?? '',
      classCode: json['classCode']?.toString(),
      title: json['title']?.toString() ?? 'Lớp học',
      subject: json['subject']?.toString() ?? '',
      grade: json['grade']?.toString() ?? '',
      status: json['status']?.toString() ?? '',
      pendingApplicationCount: json['pendingApplicationCount'] as int? ?? 0,
    );
  }

  @override
  List<Object?> get props => [id, classCode, title, subject, grade, status];
}
