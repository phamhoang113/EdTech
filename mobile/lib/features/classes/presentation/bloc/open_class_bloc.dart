import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../domain/entities/class_filter_entity.dart';
import '../../domain/entities/ward_entity.dart';
import '../../domain/repositories/class_repository.dart';
import 'open_class_event.dart';
import 'open_class_state.dart';

@injectable
class OpenClassBloc extends Bloc<OpenClassEvent, OpenClassState> {
  final ClassRepository repository;

  /// Cached wards for the currently selected province
  List<WardEntity> currentWards = [];

  /// Cached filters for reuse by RequestClassScreen
  ClassFilterEntity cachedFilters = ClassFilterEntity.empty;

  OpenClassBloc(this.repository) : super(OpenClassInitial()) {
    on<FetchOpenClassesRequested>(_onFetch);
    on<LoadWardsRequested>(_onLoadWards);
    on<CreateClassRequested>(_onCreateClass);
  }

  Future<void> _onFetch(FetchOpenClassesRequested event, Emitter<OpenClassState> emit) async {
    emit(OpenClassLoading());

    final classesResult = await repository.getOpenClasses();
    final filtersResult = await repository.getClassFilters();
    final provincesResult = await repository.getProvinces();

    if (classesResult.isLeft()) {
      final failure = classesResult.fold((l) => l, (r) => null);
      emit(OpenClassError(failure?.message ?? 'Lỗi tải lớp học'));
      return;
    }

    final classes = classesResult.getOrElse(() => []);
    final filters = filtersResult.getOrElse(() => ClassFilterEntity.empty);
    final provinces = provincesResult.getOrElse(() => []);

    cachedFilters = filters;
    emit(OpenClassLoaded(classes, filters, provinces));
  }

  Future<void> _onLoadWards(LoadWardsRequested event, Emitter<OpenClassState> emit) async {
    final result = await repository.getWardsByProvince(event.provinceCode);
    currentWards = result.getOrElse(() => []);
  }

  Future<void> _onCreateClass(CreateClassRequested event, Emitter<OpenClassState> emit) async {
    emit(ClassCreating());

    final result = await repository.createClass(event.data);
    result.fold(
      (failure) => emit(OpenClassError(failure.message)),
      (_) => emit(ClassCreated()),
    );
  }
}
