import 'package:equatable/equatable.dart';
import '../../domain/entities/open_class_entity.dart';

abstract class OpenClassState extends Equatable {
  const OpenClassState();

  @override
  List<Object> get props => [];
}

class OpenClassInitial extends OpenClassState {}

class OpenClassLoading extends OpenClassState {}

class OpenClassLoaded extends OpenClassState {
  final List<OpenClassEntity> classes;

  const OpenClassLoaded(this.classes);

  @override
  List<Object> get props => [classes];
}

class OpenClassError extends OpenClassState {
  final String message;

  const OpenClassError(this.message);

  @override
  List<Object> get props => [message];
}
