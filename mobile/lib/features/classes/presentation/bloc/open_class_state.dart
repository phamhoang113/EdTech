import 'package:equatable/equatable.dart';
import '../../data/datasources/class_remote_data_source.dart';
import '../../domain/entities/class_filter_entity.dart';
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
  final ClassFilterEntity filters;
  final List<ProvinceDto> provinces;

  const OpenClassLoaded(this.classes, this.filters, this.provinces);

  @override
  List<Object> get props => [classes, filters, provinces];
}

class OpenClassError extends OpenClassState {
  final String message;

  const OpenClassError(this.message);

  @override
  List<Object> get props => [message];
}
