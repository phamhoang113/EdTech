import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../domain/repositories/class_repository.dart';
import 'open_class_event.dart';
import 'open_class_state.dart';

@injectable
class OpenClassBloc extends Bloc<OpenClassEvent, OpenClassState> {
  final ClassRepository repository;

  OpenClassBloc(this.repository) : super(OpenClassInitial()) {
    on<FetchOpenClassesRequested>((event, emit) async {
      emit(OpenClassLoading());
      final result = await repository.getOpenClasses();
      result.fold(
        (failure) => emit(OpenClassError(failure.message)),
        (classes) => emit(OpenClassLoaded(classes)),
      );
    });
  }
}
