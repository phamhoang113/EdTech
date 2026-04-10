import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/di/injection.dart';
import '../../../../core/di/tutor_verification_notifier.dart';
import '../../../../core/services/push_notification_service.dart';
import '../../domain/repositories/auth_repository.dart';
import 'auth_event.dart';
import 'auth_state.dart';

@injectable
class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository _authRepository;

  AuthBloc(this._authRepository) : super(AuthInitial()) {
    on<AuthStarted>(_onAuthStarted);
    on<AuthLoginRequested>(_onAuthLoginRequested);
    on<AuthRegisterRequested>(_onAuthRegisterRequested);
    on<AuthForgotPasswordInitRequested>(_onForgotPasswordInit);
    on<AuthForgotPasswordResetRequested>(_onForgotPasswordReset);
    on<AuthLogoutRequested>(_onAuthLogoutRequested);
  }

  Future<void> _onAuthStarted(AuthStarted event, Emitter<AuthState> emit) async {
    final user = await _authRepository.getAuthenticatedUser();
    if (user != null) {
      emit(AuthAuthenticated(user));
      // Re-register FCM token for returning users
      PushNotificationService.instance.requestPermissionAndRegisterToken();
    } else {
      emit(AuthUnauthenticated());
    }
  }

  Future<void> _onAuthLoginRequested(AuthLoginRequested event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    final result = await _authRepository.login(event.phone, event.password);
    result.fold(
      (failure) => emit(AuthError(failure.message)),
      (user) {
        emit(AuthAuthenticated(user));
        PushNotificationService.instance.requestPermissionAndRegisterToken();
      },
    );
  }

  /// Register → directly calls /api/v1/auth/firebase with MOCK_TOKEN
  /// No separate OTP step on test env
  Future<void> _onAuthRegisterRequested(
    AuthRegisterRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    final result = await _authRepository.registerWithFirebase(
      phone: event.phone,
      fullName: event.fullName,
      password: event.password,
      role: event.role,
    );
    result.fold(
      (failure) => emit(AuthError(failure.message)),
      (user) {
        emit(AuthAuthenticated(user));
        PushNotificationService.instance.requestPermissionAndRegisterToken();
      },
    );
  }

  /// Step 1: BE check identifier → return maskedPhone + fullPhone
  Future<void> _onForgotPasswordInit(
    AuthForgotPasswordInitRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    final result = await _authRepository.initForgotPassword(event.identifier);
    result.fold(
      (failure) => emit(AuthError(failure.message)),
      (data) => emit(AuthForgotPasswordInitSuccess(
        identifier: event.identifier,
        maskedPhone: data['maskedPhone'] ?? '',
        fullPhone: data['fullPhone'] ?? '',
      )),
    );
  }

  /// Step 2: verify OTP → BE reset password → return new random password
  Future<void> _onForgotPasswordReset(
    AuthForgotPasswordResetRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    final result = await _authRepository.resetForgotPassword(event.identifier, event.idToken);
    result.fold(
      (failure) => emit(AuthError(failure.message)),
      (newPassword) => emit(AuthForgotPasswordResetSuccess(newPassword)),
    );
  }

  Future<void> _onAuthLogoutRequested(AuthLogoutRequested event, Emitter<AuthState> emit) async {
    await PushNotificationService.instance.unregisterToken();
    await _authRepository.logout();
    getIt<TutorVerificationNotifier>().clear();
    emit(AuthUnauthenticated());
  }
}
