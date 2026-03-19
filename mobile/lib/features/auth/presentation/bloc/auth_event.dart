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

class AuthRegisterRequested extends AuthEvent {
  final String phone;
  final String password;
  final String fullName;
  final String role;

  const AuthRegisterRequested(this.phone, this.password, this.fullName, this.role);

  @override
  List<Object> get props => [phone, password, fullName, role];
}

class AuthVerifyOtpRequested extends AuthEvent {
  final String otpToken; // UUID từ backend sau register
  final String code;

  const AuthVerifyOtpRequested(this.otpToken, this.code);

  @override
  List<Object> get props => [otpToken, code];
}

class AuthLogoutRequested extends AuthEvent {}
