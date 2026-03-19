import 'package:equatable/equatable.dart';

class TutorProfileEntity extends Equatable {
  final String? bio;
  final List<String> subjects;
  final String? level;
  final String? location;
  final String? teachingMode;
  final double? hourlyRate;
  final double rating;
  final int ratingCount;
  final String? idCardUrl;
  final String? idCardBackUrl;
  final List<String> certUrls;
  final String verificationStatus; // UNVERIFIED | PENDING | APPROVED | REJECTED
  final String? tutorType; // STUDENT | TEACHER | GRADUATED

  const TutorProfileEntity({
    this.bio,
    this.subjects = const [],
    this.level,
    this.location,
    this.teachingMode,
    this.hourlyRate,
    this.rating = 0.0,
    this.ratingCount = 0,
    this.idCardUrl,
    this.idCardBackUrl,
    this.certUrls = const [],
    this.verificationStatus = 'UNVERIFIED',
    this.tutorType,
  });

  @override
  List<Object?> get props => [
        bio,
        subjects,
        level,
        location,
        teachingMode,
        hourlyRate,
        rating,
        ratingCount,
        idCardUrl,
        idCardBackUrl,
        certUrls,
        verificationStatus,
        tutorType,
      ];
}
