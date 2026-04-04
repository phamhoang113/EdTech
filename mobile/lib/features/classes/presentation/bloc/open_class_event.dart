import 'package:equatable/equatable.dart';

abstract class OpenClassEvent extends Equatable {
  const OpenClassEvent();

  @override
  List<Object?> get props => [];
}

class FetchOpenClassesRequested extends OpenClassEvent {}
