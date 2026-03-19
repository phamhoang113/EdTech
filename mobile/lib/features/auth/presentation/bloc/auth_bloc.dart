import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../data/repositories/auth_repository_impl.dart';
import 'auth_event.dart';
import 'auth_state.dart';

@injectable
class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepositoryImpl _authRepository;

  AuthBloc(this._authRepository) : super(AuthInitial()) {
    on<AuthStarted>(_onAuthStarted);
    on<AuthLoginRequested>(_onAuthLoginRequested);
    on<AuthRegisterRequested>(_onAuthRegisterRequested);
    on<AuthVerifyOtpRequested>(_onAuthVerifyOtpRequested);
    on<AuthLogoutRequested>(_onAuthLogoutRequested);
  }

  Future<void> _onAuthStarted(AuthStarted event, Emitter<AuthState> emit) async {
    final user = await _authRepository.getAuthenticatedUser();
    if (user != null) {
      emit(user);
    } else {
      emit(AuthUnauthenticated());
    }
  }

  Future<void> _onAuthLoginRequested(AuthLoginRequested event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    final result = await _authRepository.login(event.phone, event.password);
    result.fold(
      (failure) => emit(AuthError(failure.message)),
      (authState) => emit(authState),
    );
  }

  Future<void> _onAuthRegisterRequested(
    AuthRegisterRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    final result = await _authRepository.register(
      event.phone,
      event.password,
      event.role,
      fullName: event.fullName,
    );
    result.fold(
      (failure) => emit(AuthError(failure.message)),
      (otpToken) => emit(AuthOtpSent(phone: event.phone, otpToken: otpToken)),
    );
  }

  Future<void> _onAuthVerifyOtpRequested(
    AuthVerifyOtpRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    final result = await _authRepository.verifyOtp(event.otpToken, event.code);
    result.fold(
      (failure) => emit(AuthError(failure.message)),
      (authState) => emit(authState),
    );
  }

  Future<void> _onAuthLogoutRequested(AuthLogoutRequested event, Emitter<AuthState> emit) async {
    await _authRepository.logout();
    emit(AuthUnauthenticated());
  }
}
