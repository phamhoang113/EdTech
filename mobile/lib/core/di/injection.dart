import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';
import 'injection.config.dart';
import 'tutor_verification_notifier.dart';

final getIt = GetIt.instance;

@InjectableInit(
  initializerName: 'init',
  preferRelativeImports: true,
  asExtension: true,
)
void configureDependencies() {
  getIt.init();
  // Manual singleton — not injectable-generated
  if (!getIt.isRegistered<TutorVerificationNotifier>()) {
    getIt.registerLazySingleton<TutorVerificationNotifier>(() => TutorVerificationNotifier());
  }
}
