import 'package:dio/dio.dart';

import '../../../../core/network/dio_client.dart';

/// Model cho 1 payout record từ API
class TutorPayoutModel {
  final String id;
  final String? classTitle;
  final int? month;
  final int? year;
  final double amount;
  final String status; // LOCKED, PENDING, PAID_OUT
  final String? adminNote;
  final String? paidAt;
  final String? confirmedByTutorAt;
  final String? transactionCode;

  const TutorPayoutModel({
    required this.id,
    this.classTitle,
    this.month,
    this.year,
    required this.amount,
    required this.status,
    this.adminNote,
    this.paidAt,
    this.confirmedByTutorAt,
    this.transactionCode,
  });

  factory TutorPayoutModel.fromJson(Map<String, dynamic> json) {
    return TutorPayoutModel(
      id: json['id'] as String,
      classTitle: json['classTitle'] as String?,
      month: json['month'] as int?,
      year: json['year'] as int?,
      amount: (json['amount'] as num?)?.toDouble() ?? 0,
      status: json['status'] as String? ?? 'PENDING',
      adminNote: json['adminNote'] as String?,
      paidAt: json['paidAt'] as String?,
      confirmedByTutorAt: json['confirmedByTutorAt'] as String?,
      transactionCode: json['transactionCode'] as String?,
    );
  }

  /// Payout đã chuyển nhưng GS chưa xác nhận
  bool get needsConfirmation => status == 'PAID_OUT' && confirmedByTutorAt == null;

  /// Đã hoàn tất (GS đã xác nhận nhận tiền)
  bool get isConfirmed => confirmedByTutorAt != null;

  String get periodLabel => (month != null && year != null) ? 'T$month/$year' : '—';
}

/// Datasource gọi API tutor payouts
class TutorPayoutDataSource {
  final DioClient _client;

  TutorPayoutDataSource(this._client);

  /// Lấy danh sách payouts của GS
  Future<List<TutorPayoutModel>> getPayouts() async {
    final response = await _client.dio.get('/api/v1/tutors/payouts');
    final data = response.data['data'] as List<dynamic>? ?? [];
    return data.map((e) => TutorPayoutModel.fromJson(e as Map<String, dynamic>)).toList();
  }

  /// GS xác nhận đã nhận lương
  Future<void> confirmPayout(String payoutId) async {
    await _client.dio.post('/api/v1/tutors/payouts/$payoutId/confirm');
  }
}
