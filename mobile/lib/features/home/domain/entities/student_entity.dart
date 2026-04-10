import 'package:equatable/equatable.dart';

/// Học sinh của phụ huynh — domain entity.
class StudentEntity extends Equatable {
  final String id;
  final String userId;
  final String fullName;
  final String? phone;
  final String? grade;
  final String? school;
  final String? avatarBase64;
  final String? linkStatus; // PENDING | ACCEPTED | REJECTED

  const StudentEntity({
    required this.id,
    required this.userId,
    required this.fullName,
    this.phone,
    this.grade,
    this.school,
    this.avatarBase64,
    this.linkStatus,
  });

  factory StudentEntity.fromJson(Map<String, dynamic> json) {
    return StudentEntity(
      id: json['id']?.toString() ?? '',
      userId: json['userId']?.toString() ?? '',
      fullName: json['fullName']?.toString() ?? 'Học sinh',
      phone: json['phone']?.toString(),
      grade: json['grade']?.toString(),
      school: json['school']?.toString(),
      avatarBase64: json['avatarBase64']?.toString(),
      linkStatus: json['linkStatus']?.toString(),
    );
  }

  @override
  List<Object?> get props => [id, userId, fullName, phone, grade, school, linkStatus];
}
