import 'package:equatable/equatable.dart';

import '../../domain/entities/user_entity.dart';

abstract class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object?> get props => [];
}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}

/// Đã xác thực — lưu thông tin user
class AuthAuthenticated extends AuthState {
  final UserEntity user;

  const AuthAuthenticated(this.user);

  bool get mustChangePassword => user.mustChangePassword;

  @override
  List<Object> get props => [user];
}

class AuthUnauthenticated extends AuthState {}

class AuthError extends AuthState {
  final String message;

  const AuthError(this.message);

  @override
  List<Object> get props => [message];
}

/// Forgot password step 1 done — OTP needed
class AuthForgotPasswordInitSuccess extends AuthState {
  final String identifier;
  final String maskedPhone;
  final String fullPhone;

  const AuthForgotPasswordInitSuccess({
    required this.identifier,
    required this.maskedPhone,
    required this.fullPhone,
  });

  @override
  List<Object> get props => [identifier, maskedPhone, fullPhone];
}

/// Forgot password step 2 done — new password generated
class AuthForgotPasswordResetSuccess extends AuthState {
  final String newPassword;

  const AuthForgotPasswordResetSuccess(this.newPassword);

  @override
  List<Object> get props => [newPassword];
}
