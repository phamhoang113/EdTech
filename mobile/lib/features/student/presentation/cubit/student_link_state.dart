import 'package:equatable/equatable.dart';

import '../../data/models/parent_link_model.dart';

/// Trạng thái danh sách liên kết PH của HS
abstract class StudentLinkState extends Equatable {
  const StudentLinkState();

  @override
  List<Object?> get props => [];
}

class StudentLinkInitial extends StudentLinkState {}

class StudentLinkLoading extends StudentLinkState {}

class StudentLinkLoaded extends StudentLinkState {
  final List<ParentLinkModel> links;

  const StudentLinkLoaded(this.links);

  /// Danh sách PH đã liên kết (ACCEPTED)
  List<ParentLinkModel> get acceptedLinks =>
      links.where((l) => l.isAccepted).toList();

  /// Danh sách PH đang chờ duyệt (PENDING từ PH gửi)
  List<ParentLinkModel> get pendingFromParent =>
      links.where((l) => l.isPending && l.initiatedBy == 'PARENT').toList();

  /// Danh sách HS đã gửi yêu cầu (PENDING từ HS gửi)
  List<ParentLinkModel> get pendingSentByStudent =>
      links.where((l) => l.isPending && l.initiatedBy == 'STUDENT').toList();

  bool get hasParent => acceptedLinks.isNotEmpty;
  bool get hasPendingRequests => pendingFromParent.isNotEmpty;

  @override
  List<Object?> get props => [links];
}

class StudentLinkError extends StudentLinkState {
  final String message;

  const StudentLinkError(this.message);

  @override
  List<Object?> get props => [message];
}

/// Trạng thái sau khi gửi/chấp nhận/từ chối liên kết
class StudentLinkActionSuccess extends StudentLinkState {
  final String message;

  const StudentLinkActionSuccess(this.message);

  @override
  List<Object?> get props => [message];
}
