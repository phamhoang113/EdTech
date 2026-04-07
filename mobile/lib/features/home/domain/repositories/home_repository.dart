import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../entities/my_class_entity.dart';
import '../entities/upcoming_session_entity.dart';
import '../entities/billing_summary_entity.dart';

abstract class HomeRepository {
  /// Load classes cho phụ huynh hoặc học sinh dựa trên role.
  Future<Either<Failure, List<MyClassEntity>>> getMyClasses(String role);

  /// Load lịch học sắp tới (7 ngày tới).
  Future<List<UpcomingSessionEntity>> getUpcomingSessions(String role);

  /// Load hóa đơn chưa thanh toán (chỉ PH).
  Future<List<BillingSummaryEntity>> getUnpaidBillings();
}
