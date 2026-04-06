import 'package:equatable/equatable.dart';

/// Quận/huyện — domain entity (không chứa fromJson).
class WardEntity extends Equatable {
  final String code;
  final String name;
  final String provinceCode;

  const WardEntity({
    required this.code,
    required this.name,
    required this.provinceCode,
  });

  @override
  List<Object?> get props => [code, name, provinceCode];
}
