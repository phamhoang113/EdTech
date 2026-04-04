import 'package:equatable/equatable.dart';

import '../../domain/entities/user_entity.dart';

abstract class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object?> get props => [];
}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}

/// Đăng ký thành công → OTP đã gửi, backend trả otpToken UUID
class AuthOtpSent extends AuthState {
  final String phone;     // Chỉ để hiển thị UX
  final String otpToken;  // UUID để verify — không cần phone nữa

  const AuthOtpSent({required this.phone, required this.otpToken});

  @override
  List<Object> get props => [phone, otpToken];
}

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
