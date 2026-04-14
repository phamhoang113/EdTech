// Models cho module Giảng dạy/Học tập.

import 'dart:ui';
class MaterialModel {
  final String id;
  final String classId;
  final String uploadedBy;
  final String title;
  final String? description;
  final String type;
  final String? fileName;
  final String? mimeType;
  final int? fileSize;
  final String? downloadUrl;
  final DateTime createdAt;

  const MaterialModel({
    required this.id,
    required this.classId,
    required this.uploadedBy,
    required this.title,
    this.description,
    required this.type,
    this.fileName,
    this.mimeType,
    this.fileSize,
    this.downloadUrl,
    required this.createdAt,
  });

  factory MaterialModel.fromJson(Map<String, dynamic> json) {
    return MaterialModel(
      id: json['id'] as String,
      classId: json['classId'] as String,
      uploadedBy: json['uploadedBy'] as String,
      title: json['title'] as String,
      description: json['description'] as String?,
      type: json['type'] as String? ?? 'DOCUMENT',
      fileName: json['fileName'] as String?,
      mimeType: json['mimeType'] as String?,
      fileSize: (json['fileSize'] as num?)?.toInt(),
      downloadUrl: json['downloadUrl'] as String?,
      createdAt: DateTime.parse(json['createdAt'] as String),
    );
  }
}

class AssessmentModel {
  final String id;
  final String classId;
  final String createdBy;
  final String title;
  final String? description;
  final String type; // HOMEWORK | EXAM
  final DateTime? opensAt;
  final DateTime? closesAt;
  final int? durationMin;
  final double totalScore;
  final double? passScore;
  final String? attachmentName;
  final String? attachmentDownloadUrl;
  final bool isPublished;
  final int? submittedCount;
  final int? totalStudents;
  final DateTime createdAt;

  const AssessmentModel({
    required this.id,
    required this.classId,
    required this.createdBy,
    required this.title,
    this.description,
    required this.type,
    this.opensAt,
    this.closesAt,
    this.durationMin,
    required this.totalScore,
    this.passScore,
    this.attachmentName,
    this.attachmentDownloadUrl,
    required this.isPublished,
    this.submittedCount,
    this.totalStudents,
    required this.createdAt,
  });

  factory AssessmentModel.fromJson(Map<String, dynamic> json) {
    return AssessmentModel(
      id: json['id'] as String,
      classId: json['classId'] as String,
      createdBy: json['createdBy'] as String,
      title: json['title'] as String,
      description: json['description'] as String?,
      type: json['type'] as String? ?? 'HOMEWORK',
      opensAt: json['opensAt'] != null ? DateTime.parse(json['opensAt'] as String) : null,
      closesAt: json['closesAt'] != null ? DateTime.parse(json['closesAt'] as String) : null,
      durationMin: (json['durationMin'] as num?)?.toInt(),
      totalScore: (json['totalScore'] as num?)?.toDouble() ?? 10,
      passScore: (json['passScore'] as num?)?.toDouble(),
      attachmentName: json['attachmentName'] as String?,
      attachmentDownloadUrl: json['attachmentDownloadUrl'] as String?,
      isPublished: json['isPublished'] as bool? ?? false,
      submittedCount: (json['submittedCount'] as num?)?.toInt(),
      totalStudents: (json['totalStudents'] as num?)?.toInt(),
      createdAt: DateTime.parse(json['createdAt'] as String),
    );
  }

  bool get isHomework => type == 'HOMEWORK';
  bool get isExam => type == 'EXAM';
  bool get isOverdue => closesAt != null && DateTime.now().isAfter(closesAt!);
}

class SubmissionModel {
  final String id;
  final String assessmentId;
  final String studentId;
  final String status; // DRAFT, SUBMITTED, REVIEWING, GRADED, COMPLETED, ARCHIVED
  final double? totalScore;
  final String? tutorComment;
  final String? fileName;
  final int? fileSize;
  final String? downloadUrl;
  final String? tutorFileName;
  final String? tutorFileDownloadUrl;
  final DateTime? submittedAt;
  final DateTime? gradedAt;
  final DateTime? completedAt;
  final DateTime createdAt;
  final String? studentName;

  const SubmissionModel({
    required this.id,
    required this.assessmentId,
    required this.studentId,
    required this.status,
    this.totalScore,
    this.tutorComment,
    this.fileName,
    this.fileSize,
    this.downloadUrl,
    this.tutorFileName,
    this.tutorFileDownloadUrl,
    this.submittedAt,
    this.gradedAt,
    this.completedAt,
    required this.createdAt,
    this.studentName,
  });

  factory SubmissionModel.fromJson(Map<String, dynamic> json) {
    return SubmissionModel(
      id: json['id'] as String,
      assessmentId: json['assessmentId'] as String,
      studentId: json['studentId'] as String,
      status: json['status'] as String? ?? 'DRAFT',
      totalScore: (json['totalScore'] as num?)?.toDouble(),
      tutorComment: json['tutorComment'] as String?,
      fileName: json['fileName'] as String?,
      fileSize: (json['fileSize'] as num?)?.toInt(),
      downloadUrl: json['downloadUrl'] as String?,
      tutorFileName: json['tutorFileName'] as String?,
      tutorFileDownloadUrl: json['tutorFileDownloadUrl'] as String?,
      submittedAt: json['submittedAt'] != null ? DateTime.parse(json['submittedAt'] as String) : null,
      gradedAt: json['gradedAt'] != null ? DateTime.parse(json['gradedAt'] as String) : null,
      completedAt: json['completedAt'] != null ? DateTime.parse(json['completedAt'] as String) : null,
      createdAt: DateTime.parse(json['createdAt'] as String),
      studentName: json['studentName'] as String?,
    );
  }

  bool get isSubmitted => status == 'SUBMITTED';
  bool get isGraded => status == 'GRADED';
  bool get isCompleted => status == 'COMPLETED' || status == 'ARCHIVED';

  /// Alias: điểm GS chấm (backend field: totalScore)
  double? get score => totalScore;

  String get statusLabel => SubmissionModel.getStatusLabel(status);

  static String getStatusLabel(String status) {
    switch (status) {
      case 'DRAFT': return 'Nháp';
      case 'SUBMITTED': return 'Đã nộp';
      case 'REVIEWING': return 'Đang chấm';
      case 'GRADED': return 'Đã chấm';
      case 'COMPLETED': return 'Hoàn thành';
      case 'ARCHIVED': return 'Đã lưu trữ';
      default: return status;
    }
  }

  static Color statusColor(String status) {
    switch (status) {
      case 'SUBMITTED': return const Color(0xFF3B82F6);
      case 'REVIEWING': return const Color(0xFFF59E0B);
      case 'GRADED': return const Color(0xFF10B981);
      case 'COMPLETED': return const Color(0xFF8B5CF6);
      default: return const Color(0xFF6B7280);
    }
  }
}
