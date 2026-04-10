import 'package:equatable/equatable.dart';

/// Hóa đơn chi tiết — domain entity cho BillingsScreen.
class BillingDetailEntity extends Equatable {
  final String id;
  final String classId;
  final String classCode;
  final String classTitle;
  final String? parentName;
  final String? studentNames;
  final int month;
  final int year;
  final int? totalSessions;
  final double amount;
  final String transactionCode;
  final String status;
  final String? qrDataStr;
  final String? beneficiaryBank;
  final String? beneficiaryAccount;
  final String? beneficiaryName;
  final String? verifiedAt;
  final String? createdAt;

  const BillingDetailEntity({
    required this.id,
    required this.classId,
    required this.classCode,
    required this.classTitle,
    this.parentName,
    this.studentNames,
    required this.month,
    required this.year,
    this.totalSessions,
    required this.amount,
    required this.transactionCode,
    required this.status,
    this.qrDataStr,
    this.beneficiaryBank,
    this.beneficiaryAccount,
    this.beneficiaryName,
    this.verifiedAt,
    this.createdAt,
  });

  factory BillingDetailEntity.fromJson(Map<String, dynamic> json) {
    return BillingDetailEntity(
      id: json['id']?.toString() ?? '',
      classId: json['classId']?.toString() ?? '',
      classCode: json['classCode']?.toString() ?? '',
      classTitle: json['classTitle']?.toString() ?? '',
      parentName: json['parentName']?.toString(),
      studentNames: json['studentNames']?.toString(),
      month: json['month'] as int? ?? 0,
      year: json['year'] as int? ?? 0,
      totalSessions: json['totalSessions'] as int?,
      amount: (json['parentFeeAmount'] ?? json['amount'] ?? 0).toDouble(),
      transactionCode: json['transactionCode']?.toString() ?? '',
      status: json['status']?.toString() ?? '',
      qrDataStr: json['qrDataStr']?.toString(),
      beneficiaryBank: json['beneficiaryBank']?.toString(),
      beneficiaryAccount: json['beneficiaryAccount']?.toString(),
      beneficiaryName: json['beneficiaryName']?.toString(),
      verifiedAt: json['verifiedAt']?.toString(),
      createdAt: json['createdAt']?.toString(),
    );
  }

  bool get isUnpaid => status == 'UNPAID' || status == 'DRAFT';
  bool get isPaid => status == 'PAID';
  bool get isPending => status == 'PENDING_VERIFICATION';

  String get statusLabel {
    const labels = {
      'DRAFT': 'Nháp',
      'UNPAID': 'Chưa thanh toán',
      'PENDING_VERIFICATION': 'Chờ đối soát',
      'PAID': 'Đã thanh toán',
    };
    return labels[status] ?? status;
  }

  @override
  List<Object?> get props => [id, classId, month, year, status];
}
