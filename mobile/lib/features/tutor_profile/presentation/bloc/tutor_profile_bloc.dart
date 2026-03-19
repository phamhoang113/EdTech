import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../domain/repositories/tutor_profile_repository.dart';
import 'tutor_profile_event.dart';
import 'tutor_profile_state.dart';

@injectable
class TutorProfileBloc extends Bloc<TutorProfileEvent, TutorProfileState> {
  final TutorProfileRepository repository;

  TutorProfileBloc(this.repository) : super(TutorProfileInitial()) {
    on<LoadTutorProfile>(_onLoadTutorProfile);
    on<VerifyTutorProfile>(_onVerifyTutorProfile);
  }

  Future<void> _onLoadTutorProfile(
    LoadTutorProfile event,
    Emitter<TutorProfileState> emit,
  ) async {
    emit(TutorProfileLoading());
    final result = await repository.getMyProfile();
    result.fold(
      (failure) => emit(TutorProfileError(failure.message)),
      (profile) => emit(TutorProfileLoaded(profile)),
    );
  }

  Future<void> _onVerifyTutorProfile(
    VerifyTutorProfile event,
    Emitter<TutorProfileState> emit,
  ) async {
    emit(TutorProfileLoading());
    final result = await repository.verifyProfile(
      tutorType: event.tutorType,
      idCardFront: event.idCardFront,
      idCardBack: event.idCardBack,
      degree: event.degree,
    );
    result.fold(
      (failure) => emit(TutorProfileError(failure.message)),
      (profile) => emit(TutorProfileVerificationSuccess(profile)),
    );
  }
}
