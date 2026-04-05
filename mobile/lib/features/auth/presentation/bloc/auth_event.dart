import 'package:equatable/equatable.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object> get props => [];
}

class AuthStarted extends AuthEvent {}

class AuthLoginRequested extends AuthEvent {
  final String phone;
  final String password;

  const AuthLoginRequested(this.phone, this.password);

  @override
  List<Object> get props => [phone, password];
}

/// Register via Firebase auth (mock for test env)
/// No separate OTP step — goes directly to /api/v1/auth/firebase
class AuthRegisterRequested extends AuthEvent {
  final String phone;
  final String password;
  final String fullName;
  final String role;

  const AuthRegisterRequested(this.phone, this.password, this.fullName, this.role);

  @override
  List<Object> get props => [phone, password, fullName, role];
}

/// Forgot password step 1: init → get maskedPhone
class AuthForgotPasswordInitRequested extends AuthEvent {
  final String identifier;

  const AuthForgotPasswordInitRequested(this.identifier);

  @override
  List<Object> get props => [identifier];
}

/// Forgot password step 2: reset with mock/Firebase idToken
class AuthForgotPasswordResetRequested extends AuthEvent {
  final String identifier;
  final String idToken;

  const AuthForgotPasswordResetRequested(this.identifier, this.idToken);

  @override
  List<Object> get props => [identifier, idToken];
}

class AuthLogoutRequested extends AuthEvent {}
