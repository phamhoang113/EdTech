// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format width=80

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:flutter_secure_storage/flutter_secure_storage.dart' as _i558;
import 'package:get_it/get_it.dart' as _i174;
import 'package:injectable/injectable.dart' as _i526;

import '../../features/auth/data/datasources/auth_local_datasource.dart'
    as _i992;
import '../../features/auth/data/datasources/auth_remote_datasource.dart'
    as _i161;
import '../../features/auth/data/repositories/auth_repository_impl.dart'
    as _i153;
import '../../features/auth/domain/repositories/auth_repository.dart' as _i787;
import '../../features/auth/presentation/bloc/auth_bloc.dart' as _i797;
import '../../features/classes/data/datasources/class_remote_data_source.dart'
    as _i702;
import '../../features/classes/data/repositories/class_repository_impl.dart'
    as _i972;
import '../../features/classes/domain/repositories/class_repository.dart'
    as _i367;
import '../../features/classes/presentation/bloc/open_class_bloc.dart' as _i169;
import '../../features/home/data/datasources/home_remote_datasource.dart'
    as _i278;
import '../../features/home/data/repositories/home_repository_impl.dart'
    as _i76;
import '../../features/home/domain/repositories/home_repository.dart' as _i0;
import '../../features/home/presentation/bloc/my_classes_bloc.dart' as _i712;
import '../../features/tutor_profile/data/datasources/tutor_profile_remote_datasource.dart'
    as _i734;
import '../../features/tutor_profile/data/repositories/tutor_profile_repository_impl.dart'
    as _i618;
import '../../features/tutor_profile/domain/repositories/tutor_profile_repository.dart'
    as _i255;
import '../../features/tutor_profile/presentation/bloc/public_tutor_bloc.dart'
    as _i412;
import '../../features/tutor_profile/presentation/bloc/tutor_profile_bloc.dart'
    as _i958;
import '../network/auth_interceptor.dart' as _i908;
import '../network/dio_client.dart' as _i667;
import '../services/web_launcher_service.dart' as _i316;
import '../storage/platform_storage.dart' as _i438;
import 'register_module.dart' as _i291;

extension GetItInjectableX on _i174.GetIt {
  // initializes the registration of main-scope dependencies inside of GetIt
  _i174.GetIt init({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) {
    final gh = _i526.GetItHelper(this, environment, environmentFilter);
    final registerModule = _$RegisterModule();
    gh.lazySingleton<_i558.FlutterSecureStorage>(
      () => registerModule.secureStorage,
    );
    gh.lazySingleton<_i438.PlatformStorage>(
      () => registerModule.platformStorage(gh<_i558.FlutterSecureStorage>()),
    );
    gh.lazySingleton<_i316.WebLauncherService>(
      () => _i316.WebLauncherService(gh<_i438.PlatformStorage>()),
    );
    gh.factory<_i992.AuthLocalDataSource>(
      () => _i992.AuthLocalDataSourceImpl(gh<_i438.PlatformStorage>()),
    );
    gh.factory<_i908.AuthInterceptor>(
      () => _i908.AuthInterceptor(gh<_i438.PlatformStorage>()),
    );
    gh.singleton<_i667.DioClient>(
      () => _i667.DioClient(gh<_i908.AuthInterceptor>()),
    );
    gh.factory<_i161.AuthRemoteDataSource>(
      () => _i161.AuthRemoteDataSourceImpl(gh<_i667.DioClient>()),
    );
    gh.lazySingleton<_i278.HomeRemoteDataSource>(
      () => _i278.HomeRemoteDataSourceImpl(gh<_i667.DioClient>()),
    );
    gh.lazySingleton<_i702.ClassRemoteDataSource>(
      () => _i702.ClassRemoteDataSourceImpl(gh<_i667.DioClient>()),
    );
    gh.lazySingleton<_i367.ClassRepository>(
      () => _i972.ClassRepositoryImpl(gh<_i702.ClassRemoteDataSource>()),
    );
    gh.factory<_i734.TutorProfileRemoteDataSource>(
      () => _i734.TutorProfileRemoteDataSourceImpl(gh<_i667.DioClient>()),
    );
    gh.factory<_i169.OpenClassBloc>(
      () => _i169.OpenClassBloc(gh<_i367.ClassRepository>()),
    );
    gh.factory<_i255.TutorProfileRepository>(
      () => _i618.TutorProfileRepositoryImpl(
        gh<_i734.TutorProfileRemoteDataSource>(),
      ),
    );
    gh.factory<_i787.AuthRepository>(
      () => _i153.AuthRepositoryImpl(
        gh<_i161.AuthRemoteDataSource>(),
        gh<_i992.AuthLocalDataSource>(),
        gh<_i438.PlatformStorage>(),
      ),
    );
    gh.lazySingleton<_i0.HomeRepository>(
      () => _i76.HomeRepositoryImpl(gh<_i278.HomeRemoteDataSource>()),
    );
    gh.factory<_i797.AuthBloc>(
      () => _i797.AuthBloc(gh<_i787.AuthRepository>()),
    );
    gh.factory<_i412.PublicTutorBloc>(
      () => _i412.PublicTutorBloc(gh<_i255.TutorProfileRepository>()),
    );
    gh.factory<_i958.TutorProfileBloc>(
      () => _i958.TutorProfileBloc(gh<_i255.TutorProfileRepository>()),
    );
    gh.factory<_i712.MyClassesBloc>(
      () => _i712.MyClassesBloc(gh<_i0.HomeRepository>()),
    );
    return this;
  }
}

class _$RegisterModule extends _i291.RegisterModule {}
