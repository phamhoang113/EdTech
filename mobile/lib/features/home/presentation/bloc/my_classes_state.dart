import 'package:equatable/equatable.dart';

import '../../domain/entities/my_class_entity.dart';

abstract class MyClassesState extends Equatable {
  const MyClassesState();

  @override
  List<Object?> get props => [];
}

class MyClassesInitial extends MyClassesState {}

class MyClassesLoading extends MyClassesState {}

class MyClassesLoaded extends MyClassesState {
  final List<MyClassEntity> classes;

  const MyClassesLoaded(this.classes);

  @override
  List<Object> get props => [classes];
}

class MyClassesError extends MyClassesState {
  final String message;

  const MyClassesError(this.message);

  @override
  List<Object> get props => [message];
}
