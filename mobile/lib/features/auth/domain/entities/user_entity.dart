import 'package:equatable/equatable.dart';

class UserEntity extends Equatable {
  final String id;
  final String phoneNumber;
  final String role; // TUTOR | PARENT | STUDENT | ADMIN
  final String? name;
  final bool mustChangePassword;

  const UserEntity({
    required this.id,
    required this.phoneNumber,
    required this.role,
    this.name,
    this.mustChangePassword = false,
  });

  @override
  List<Object?> get props => [id, phoneNumber, role, name, mustChangePassword];
}
