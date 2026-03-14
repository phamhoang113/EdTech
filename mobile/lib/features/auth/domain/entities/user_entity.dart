import 'package:equatable/equatable.dart';

class UserEntity extends Equatable {
  final String id;
  final String phoneNumber;
  final String role; // TUTOR | PARENT | STUDENT | ADMIN
  final String? name;

  const UserEntity({
    required this.id,
    required this.phoneNumber,
    required this.role,
    this.name,
  });

  @override
  List<Object?> get props => [id, phoneNumber, role, name];
}
