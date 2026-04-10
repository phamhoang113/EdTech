import 'package:equatable/equatable.dart';

import '../../domain/entities/my_class_entity.dart';
import '../../domain/entities/upcoming_session_entity.dart';
import '../../domain/entities/billing_summary_entity.dart';
import '../../domain/entities/student_entity.dart';

abstract class MyClassesState extends Equatable {
  const MyClassesState();

  @override
  List<Object?> get props => [];
}

class MyClassesInitial extends MyClassesState {}

class MyClassesLoading extends MyClassesState {}

class MyClassesLoaded extends MyClassesState {
  final List<MyClassEntity> classes;
  final List<UpcomingSessionEntity> upcomingSessions;
  final List<BillingSummaryEntity> unpaidBillings;
  final List<StudentEntity> children;
  final int totalPendingApplicants;

  const MyClassesLoaded({
    required this.classes,
    this.upcomingSessions = const [],
    this.unpaidBillings = const [],
    this.children = const [],
    this.totalPendingApplicants = 0,
  });

  @override
  List<Object> get props => [classes, upcomingSessions, unpaidBillings, children, totalPendingApplicants];
}

class MyClassesError extends MyClassesState {
  final String message;

  const MyClassesError(this.message);

  @override
  List<Object> get props => [message];
}
