/// Model cho thông tin liên kết phụ huynh — học sinh
class ParentLinkModel {
  final String id;
  final String parentId;
  final String parentName;
  final String? parentPhone;
  final String linkStatus; // PENDING | ACCEPTED
  final String initiatedBy; // PARENT | STUDENT
  final DateTime? createdAt;

  const ParentLinkModel({
    required this.id,
    required this.parentId,
    required this.parentName,
    this.parentPhone,
    required this.linkStatus,
    required this.initiatedBy,
    this.createdAt,
  });

  factory ParentLinkModel.fromJson(Map<String, dynamic> json) {
    return ParentLinkModel(
      id: json['id']?.toString() ?? '',
      parentId: json['parentId']?.toString() ?? '',
      parentName: json['parentName']?.toString() ?? '',
      parentPhone: json['parentPhone']?.toString(),
      linkStatus: json['linkStatus']?.toString() ?? 'PENDING',
      initiatedBy: json['initiatedBy']?.toString() ?? 'PARENT',
      createdAt: json['createdAt'] != null
          ? DateTime.tryParse(json['createdAt'].toString())
          : null,
    );
  }

  bool get isAccepted => linkStatus == 'ACCEPTED';
  bool get isPending => linkStatus == 'PENDING';
}
