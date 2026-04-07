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

    final classesResult = await _repository.getMyClasses(event.role);

    await classesResult.fold(
      (failure) async => emit(MyClassesError(failure.message)),
      (classes) async {
        // Load sessions & billings song song (non-blocking)
        final sessionsFuture = _repository.getUpcomingSessions(event.role);
        final billingsFuture = event.role == 'PARENT'
            ? _repository.getUnpaidBillings()
            : Future.value(<dynamic>[]);

        final results = await Future.wait([sessionsFuture, billingsFuture]);

        final sessions = results[0];
        final billings = results[1];

        final totalPending = classes
            .where((c) => c.pendingApplicationCount > 0)
            .fold<int>(0, (sum, c) => sum + c.pendingApplicationCount);

        emit(MyClassesLoaded(
          classes: classes,
          upcomingSessions: List.from(sessions),
          unpaidBillings: List.from(billings),
          totalPendingApplicants: totalPending,
        ));
      },
    );
  }
}
