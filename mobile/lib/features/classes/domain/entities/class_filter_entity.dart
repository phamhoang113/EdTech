import 'package:equatable/equatable.dart';

/// Filter options from backend API /api/v1/classes/filters
class ClassFilterEntity extends Equatable {
  final List<String> subjects;
  final List<String> levels;
  final List<String> genders;
  final List<String> tutorLevels;

  const ClassFilterEntity({
    required this.subjects,
    required this.levels,
    required this.genders,
    required this.tutorLevels,
  });

  static const empty = ClassFilterEntity(
    subjects: [],
    levels: [],
    genders: [],
    tutorLevels: [],
  );

  @override
  List<Object?> get props => [subjects, levels, genders, tutorLevels];
}
