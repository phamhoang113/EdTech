import 'package:equatable/equatable.dart';

abstract class PublicTutorEvent extends Equatable {
  const PublicTutorEvent();

  @override
  List<Object?> get props => [];
}

class FetchPublicTutorsRequested extends PublicTutorEvent {}
