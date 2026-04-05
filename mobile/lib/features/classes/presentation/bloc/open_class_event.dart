import 'package:equatable/equatable.dart';

abstract class OpenClassEvent extends Equatable {
  const OpenClassEvent();

  @override
  List<Object?> get props => [];
}

class FetchOpenClassesRequested extends OpenClassEvent {}

/// Load wards when user selects a province
class LoadWardsRequested extends OpenClassEvent {
  final String provinceCode;

  const LoadWardsRequested(this.provinceCode);

  @override
  List<Object?> get props => [provinceCode];
}
