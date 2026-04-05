import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../domain/repositories/tutor_profile_repository.dart';
import 'public_tutor_event.dart';
import 'public_tutor_state.dart';

@injectable
class PublicTutorBloc extends Bloc<PublicTutorEvent, PublicTutorState> {
  final TutorProfileRepository repository;

  PublicTutorBloc(this.repository) : super(PublicTutorInitial()) {
    on<FetchPublicTutorsRequested>(_onFetchRequested);
  }

  Future<void> _onFetchRequested(
    FetchPublicTutorsRequested event,
    Emitter<PublicTutorState> emit,
  ) async {
    emit(PublicTutorLoading());
    final result = await repository.getPublicTutors(size: 9);
    result.fold(
      (failure) => emit(PublicTutorError(failure.message)),
      (tutors) => emit(PublicTutorLoaded(tutors)),
    );
  }
}
