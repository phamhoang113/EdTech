import 'package:equatable/equatable.dart';

/// Tỉnh/thành phố — domain entity (không chứa fromJson).
class ProvinceEntity extends Equatable {
  final String code;
  final String name;

  const ProvinceEntity({required this.code, required this.name});

  @override
  List<Object?> get props => [code, name];
}
