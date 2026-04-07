import 'package:equatable/equatable.dart';

/// Hóa đơn chưa thanh toán — domain entity cho Home screen.
class BillingSummaryEntity extends Equatable {
  final String id;
  final String classTitle;
  final String classCode;
  final int month;
  final int year;
  final double amount;
  final String status;
  final String transactionCode;

  const BillingSummaryEntity({
    required this.id,
    required this.classTitle,
    required this.classCode,
    required this.month,
    required this.year,
    required this.amount,
    required this.status,
    required this.transactionCode,
  });

  factory BillingSummaryEntity.fromJson(Map<String, dynamic> json) {
    return BillingSummaryEntity(
      id: json['id']?.toString() ?? '',
      classTitle: json['classTitle']?.toString() ?? '',
      classCode: json['classCode']?.toString() ?? '',
      month: json['month'] as int? ?? 0,
      year: json['year'] as int? ?? 0,
      amount: (json['parentFeeAmount'] ?? json['amount'] ?? 0).toDouble(),
      status: json['status']?.toString() ?? '',
      transactionCode: json['transactionCode']?.toString() ?? '',
    );
  }

  bool get isUnpaid => status == 'UNPAID' || status == 'DRAFT';

  @override
  List<Object?> get props => [id, classTitle, month, year, status];
}
