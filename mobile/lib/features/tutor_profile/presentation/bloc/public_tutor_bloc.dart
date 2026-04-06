import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/cache/featured_tutor_cache.dart';
import '../../domain/repositories/tutor_profile_repository.dart';
import 'public_tutor_event.dart';
import 'public_tutor_state.dart';

@injectable
class PublicTutorBloc extends Bloc<PublicTutorEvent, PublicTutorState> {
  final TutorProfileRepository repository;
  final FeaturedTutorCache _cache = FeaturedTutorCache();

  PublicTutorBloc(this.repository) : super(PublicTutorInitial()) {
    on<FetchPublicTutorsRequested>(_onFetchRequested);
  }

  Future<void> _onFetchRequested(
    FetchPublicTutorsRequested event,
    Emitter<PublicTutorState> emit,
  ) async {
    // Trả về cache nếu còn hạn (7 ngày)
    final cached = _cache.tutors;
    if (cached != null) {
      emit(PublicTutorLoaded(cached));
      return;
    }

    emit(PublicTutorLoading());
    final result = await repository.getPublicTutors(size: 9);
    result.fold(
      (failure) => emit(PublicTutorError(failure.message)),
      (tutors) {
        _cache.save(tutors);
        emit(PublicTutorLoaded(tutors));
      },
    );
  }
}
