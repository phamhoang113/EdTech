import '../../../../core/network/dio_client.dart';

/// Model cho Admin Dashboard Stats từ API
class AdminStatsModel {
  final int totalUsers;
  final int activeTutors;
  final int openClasses;
  final int activeClasses;
  final int pendingVerifications;
  final int tutorCount;
  final int parentCount;
  final int studentCount;
  final int adminCount;
  final double estimatedMonthlyRevenue;

  const AdminStatsModel({
    required this.totalUsers,
    required this.activeTutors,
    required this.openClasses,
    required this.activeClasses,
    required this.pendingVerifications,
    required this.tutorCount,
    required this.parentCount,
    required this.studentCount,
    required this.adminCount,
    required this.estimatedMonthlyRevenue,
  });

  factory AdminStatsModel.fromJson(Map<String, dynamic> json) {
    return AdminStatsModel(
      totalUsers: (json['totalUsers'] as num?)?.toInt() ?? 0,
      activeTutors: (json['activeTutors'] as num?)?.toInt() ?? 0,
      openClasses: (json['openClasses'] as num?)?.toInt() ?? 0,
      activeClasses: (json['activeClasses'] as num?)?.toInt() ?? 0,
      pendingVerifications: (json['pendingVerifications'] as num?)?.toInt() ?? 0,
      tutorCount: (json['tutorCount'] as num?)?.toInt() ?? 0,
      parentCount: (json['parentCount'] as num?)?.toInt() ?? 0,
      studentCount: (json['studentCount'] as num?)?.toInt() ?? 0,
      adminCount: (json['adminCount'] as num?)?.toInt() ?? 0,
      estimatedMonthlyRevenue: (json['estimatedMonthlyRevenue'] as num?)?.toDouble() ?? 0,
    );
  }
}

/// Model cho Admin badge counts
class AdminBadgesModel {
  final int pendingApplications;
  final int pendingVerifications;
  final int pendingClassRequests;

  const AdminBadgesModel({
    required this.pendingApplications,
    required this.pendingVerifications,
    required this.pendingClassRequests,
  });

  factory AdminBadgesModel.fromJson(Map<String, dynamic> json) {
    return AdminBadgesModel(
      pendingApplications: (json['pendingApplications'] as num?)?.toInt() ?? 0,
      pendingVerifications: (json['pendingVerifications'] as num?)?.toInt() ?? 0,
      pendingClassRequests: (json['pendingClassRequests'] as num?)?.toInt() ?? 0,
    );
  }

  int get totalPending => pendingApplications + pendingVerifications + pendingClassRequests;
}

/// Datasource gọi Admin Dashboard APIs
class AdminDashboardDataSource {
  final DioClient _client;

  AdminDashboardDataSource(this._client);

  /// Lấy thống kê tổng quan
  Future<AdminStatsModel> getStats() async {
    final response = await _client.dio.get('/api/v1/admin/dashboard/stats');
    final data = response.data['data'] as Map<String, dynamic>;
    return AdminStatsModel.fromJson(data);
  }

  /// Lấy badge counts cho thông báo
  Future<AdminBadgesModel> getBadgeCounts() async {
    final response = await _client.dio.get('/api/v1/admin/dashboard/badge-counts');
    final data = response.data['data'] as Map<String, dynamic>;
    return AdminBadgesModel.fromJson(data);
  }
}
