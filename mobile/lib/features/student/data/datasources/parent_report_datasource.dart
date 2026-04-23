import 'package:dio/dio.dart';

/// Model cho từng bài tập / kiểm tra của học sinh.
class StudentProgressItem {
  final String assessmentId;
  final String assessmentTitle;
  final String type; // 'HOMEWORK' | 'EXAM'
  final String status; // 'PENDING' | 'SUBMITTED' | 'GRADED' | 'COMPLETED'
  final double? score;
  final double? totalScore;
  final String? tutorComment;
  final DateTime? closesAt;
  final DateTime? submittedAt;
  final DateTime? gradedAt;

  const StudentProgressItem({
    required this.assessmentId,
    required this.assessmentTitle,
    required this.type,
    required this.status,
    this.score,
    this.totalScore,
    this.tutorComment,
    this.closesAt,
    this.submittedAt,
    this.gradedAt,
  });

  factory StudentProgressItem.fromJson(Map<String, dynamic> json) {
    return StudentProgressItem(
      assessmentId: json['assessmentId'] as String? ?? '',
      assessmentTitle: json['assessmentTitle'] as String? ?? '',
      type: json['type'] as String? ?? 'HOMEWORK',
      status: json['status'] as String? ?? 'PENDING',
      score: (json['score'] as num?)?.toDouble(),
      totalScore: (json['totalScore'] as num?)?.toDouble(),
      tutorComment: json['tutorComment'] as String?,
      closesAt: json['closesAt'] != null ? DateTime.tryParse(json['closesAt']) : null,
      submittedAt: json['submittedAt'] != null ? DateTime.tryParse(json['submittedAt']) : null,
      gradedAt: json['gradedAt'] != null ? DateTime.tryParse(json['gradedAt']) : null,
    );
  }
}

/// Tổng hợp tiến độ học tập cho 1 lớp.
class ProgressSummary {
  final double homeworkAvgScore;
  final double examAvgScore;
  final int pendingHomeworkCount;
  final int upcomingExamCount;
  final int totalHomework;
  final int totalExam;
  final List<StudentProgressItem> details;

  const ProgressSummary({
    required this.homeworkAvgScore,
    required this.examAvgScore,
    required this.pendingHomeworkCount,
    required this.upcomingExamCount,
    required this.totalHomework,
    required this.totalExam,
    required this.details,
  });

  factory ProgressSummary.fromJson(Map<String, dynamic> json) {
    final rawDetails = json['details'] as List<dynamic>? ?? [];
    return ProgressSummary(
      homeworkAvgScore: (json['homeworkAvgScore'] as num?)?.toDouble() ?? 0,
      examAvgScore: (json['examAvgScore'] as num?)?.toDouble() ?? 0,
      pendingHomeworkCount: (json['pendingHomeworkCount'] as num?)?.toInt() ?? 0,
      upcomingExamCount: (json['upcomingExamCount'] as num?)?.toInt() ?? 0,
      totalHomework: (json['totalHomework'] as num?)?.toInt() ?? 0,
      totalExam: (json['totalExam'] as num?)?.toInt() ?? 0,
      details: rawDetails.map((e) => StudentProgressItem.fromJson(e as Map<String, dynamic>)).toList(),
    );
  }
}

/// Model lớp học rút gọn cho class selector.
class SimpleClassInfo {
  final String id;
  final String title;
  final String subject;
  final String status;

  const SimpleClassInfo({
    required this.id,
    required this.title,
    required this.subject,
    required this.status,
  });

  factory SimpleClassInfo.fromJson(Map<String, dynamic> json) {
    return SimpleClassInfo(
      id: json['id'] as String? ?? '',
      title: json['title'] as String? ?? '',
      subject: json['subject'] as String? ?? '',
      status: json['status'] as String? ?? '',
    );
  }
}

/// Datasource gọi API báo cáo học tập cho PH.
class ParentReportDatasource {
  final Dio _dio;

  const ParentReportDatasource(this._dio);

  /// Lấy danh sách lớp của PH (chỉ ACTIVE/MATCHED).
  Future<List<SimpleClassInfo>> getParentClasses() async {
    final response = await _dio.get('/api/v1/parent/classes');
    final data = response.data['data'] as List<dynamic>? ?? [];
    return data
        .map((e) => SimpleClassInfo.fromJson(e as Map<String, dynamic>))
        .where((c) => c.status == 'ACTIVE' || c.status == 'MATCHED')
        .toList();
  }

  /// Lấy báo cáo tiến độ học tập cho lớp.
  Future<ProgressSummary> getProgressSummary(String classId) async {
    final response = await _dio.get('/api/v1/classes/$classId/progress/summary');
    final data = response.data['data'] as Map<String, dynamic>? ?? {};
    return ProgressSummary.fromJson(data);
  }
}
