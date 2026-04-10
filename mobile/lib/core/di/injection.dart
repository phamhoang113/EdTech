import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';

import '../../features/admin/data/datasources/admin_dashboard_datasource.dart';
import '../../features/applicants/data/datasources/applicant_remote_datasource.dart';
import '../../features/billing/data/datasources/billing_remote_datasource.dart';
import '../../features/classes/data/datasources/class_remote_data_source.dart';
import '../../features/student/data/datasources/student_remote_datasource.dart';
import '../../features/tutor_profile/data/datasources/tutor_profile_remote_datasource.dart';
import '../../features/tutor_profile/data/datasources/tutor_payout_datasource.dart';
import '../network/dio_client.dart';
import 'injection.config.dart';
import 'tutor_verification_notifier.dart';

final getIt = GetIt.instance;

@InjectableInit(
  initializerName: 'init',
  preferRelativeImports: true,
  asExtension: true,
)
void configureDependencies() {
  getIt.allowReassignment = true;
  getIt.init();

  // ── Manual registrations (not injectable-generated) ──

  if (!getIt.isRegistered<ApplicantDataSource>()) {
    getIt.registerLazySingleton<ApplicantDataSource>(
      () => ApplicantRemoteDataSource(getIt<DioClient>()),
    );
  }
  if (!getIt.isRegistered<BillingDataSource>()) {
    getIt.registerLazySingleton<BillingDataSource>(
      () => BillingRemoteDataSource(getIt<DioClient>()),
    );
  }

  if (!getIt.isRegistered<TutorVerificationNotifier>()) {
    getIt.registerLazySingleton<TutorVerificationNotifier>(
      () => TutorVerificationNotifier(),
    );
  }

  if (!getIt.isRegistered<StudentRemoteDataSource>()) {
    getIt.registerLazySingleton<StudentRemoteDataSource>(
      () => StudentRemoteDataSource(getIt<DioClient>()),
    );
  }

  if (!getIt.isRegistered<TutorPayoutDataSource>()) {
    getIt.registerLazySingleton<TutorPayoutDataSource>(
      () => TutorPayoutDataSource(getIt<DioClient>()),
    );
  }

  if (!getIt.isRegistered<AdminDashboardDataSource>()) {
    getIt.registerLazySingleton<AdminDashboardDataSource>(
      () => AdminDashboardDataSource(getIt<DioClient>()),
    );
  }
}
