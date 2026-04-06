import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../domain/repositories/home_repository.dart';
import 'my_classes_event.dart';
import 'my_classes_state.dart';

@injectable
class MyClassesBloc extends Bloc<MyClassesEvent, MyClassesState> {
  final HomeRepository _repository;

  MyClassesBloc(this._repository) : super(MyClassesInitial()) {
    on<LoadMyClassesRequested>(_onLoad);
  }

  Future<void> _onLoad(
    LoadMyClassesRequested event,
    Emitter<MyClassesState> emit,
  ) async {
    emit(MyClassesLoading());

    final result = await _repository.getMyClasses(event.role);
    result.fold(
      (failure) => emit(MyClassesError(failure.message)),
      (classes) => emit(MyClassesLoaded(classes)),
    );
  }
}
