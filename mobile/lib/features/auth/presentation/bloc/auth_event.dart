import 'package:equatable/equatable.dart';

import '../../domain/entities/user_entity.dart';

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
  final String role;

  const AuthRegisterRequested(this.phone, this.password, this.role);

  @override
  List<Object> get props => [phone, password, role];
}

class AuthLogoutRequested extends AuthEvent {}
