import 'package:json_annotation/json_annotation.dart';

part 'auth_response_model.g.dart';

/// Match với TokenResponse từ backend:
/// { accessToken, refreshToken, role, fullName, isActive }
@JsonSerializable()
class AuthResponseModel {
  final String accessToken;
  final String refreshToken;
  final String role;
  final String fullName;
  final bool? isActive;
  final bool? mustChangePassword;

  const AuthResponseModel({
    required this.accessToken,
    required this.refreshToken,
    required this.role,
    required this.fullName,
    this.isActive,
    this.mustChangePassword,
  });

  factory AuthResponseModel.fromJson(Map<String, dynamic> json) =>
      _$AuthResponseModelFromJson(json);

  Map<String, dynamic> toJson() => _$AuthResponseModelToJson(this);
}
