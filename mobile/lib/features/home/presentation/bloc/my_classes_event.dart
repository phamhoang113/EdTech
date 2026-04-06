import 'package:equatable/equatable.dart';

abstract class MyClassesEvent extends Equatable {
  const MyClassesEvent();

  @override
  List<Object?> get props => [];
}

/// Load classes cho phụ huynh hoặc học sinh.
class LoadMyClassesRequested extends MyClassesEvent {
  final String role;

  const LoadMyClassesRequested(this.role);

  @override
  List<Object?> get props => [role];
}
