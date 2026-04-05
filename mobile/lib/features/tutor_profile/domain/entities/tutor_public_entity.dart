import 'package:equatable/equatable.dart';

class TutorPublicEntity extends Equatable {
  final String userId;
  final String fullName;
  final String? bio;
  final List<String> subjects;
  final String? location;
  final String? teachingMode;
  final double? hourlyRate;
  final double rating;
  final int ratingCount;
  final List<String> teachingLevels;
  final String? achievements;
  final int? experienceYears;
  final String? avatarBase64;
  final String? tutorType;

  const TutorPublicEntity({
    required this.userId,
    required this.fullName,
    this.bio,
    this.subjects = const [],
    this.location,
    this.teachingMode,
    this.hourlyRate,
    this.rating = 0.0,
    this.ratingCount = 0,
    this.teachingLevels = const [],
    this.achievements,
    this.experienceYears,
    this.avatarBase64,
    this.tutorType,
  });

  @override
  List<Object?> get props => [
        userId, fullName, bio, subjects, location, teachingMode,
        hourlyRate, rating, ratingCount, teachingLevels,
        achievements, experienceYears, avatarBase64, tutorType,
      ];
}
