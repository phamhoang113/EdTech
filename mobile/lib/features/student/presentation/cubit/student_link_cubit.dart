import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/datasources/student_remote_datasource.dart';
import 'student_link_state.dart';

/// Cubit quản lý liên kết PH — HS
class StudentLinkCubit extends Cubit<StudentLinkState> {
  final StudentRemoteDataSource _dataSource;

  StudentLinkCubit(this._dataSource) : super(StudentLinkInitial());

  /// Tải danh sách liên kết PH
  Future<void> loadParentLinks() async {
    emit(StudentLinkLoading());
    try {
      final links = await _dataSource.getParentLinks();
      emit(StudentLinkLoaded(links));
    } catch (e) {
      emit(StudentLinkError(e.toString()));
    }
  }

  /// HS gửi yêu cầu liên kết PH bằng SĐT
  Future<void> requestParentLink(String parentPhone) async {
    try {
      await _dataSource.requestParentLink(parentPhone);
      emit(const StudentLinkActionSuccess('Gửi yêu cầu liên kết thành công!'));
      await loadParentLinks();
    } catch (e) {
      emit(StudentLinkError(e.toString()));
    }
  }

  /// HS chấp nhận yêu cầu liên kết từ PH
  Future<void> acceptLink(String linkId) async {
    try {
      await _dataSource.acceptParentLink(linkId);
      emit(const StudentLinkActionSuccess('Đã chấp nhận liên kết!'));
      await loadParentLinks();
    } catch (e) {
      emit(StudentLinkError(e.toString()));
    }
  }

  /// HS từ chối yêu cầu liên kết từ PH
  Future<void> rejectLink(String linkId) async {
    try {
      await _dataSource.rejectParentLink(linkId);
      emit(const StudentLinkActionSuccess('Đã từ chối yêu cầu liên kết.'));
      await loadParentLinks();
    } catch (e) {
      emit(StudentLinkError(e.toString()));
    }
  }
}
