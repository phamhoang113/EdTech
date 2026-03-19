import '../../domain/entities/tutor_profile_entity.dart';

class TutorProfileModel extends TutorProfileEntity {
  const TutorProfileModel({
    super.bio,
    super.subjects = const [],
    super.level,
    super.location,
    super.teachingMode,
    super.hourlyRate,
    super.rating = 0.0,
    super.ratingCount = 0,
    super.idCardUrl,
    super.idCardBackUrl,
    super.certUrls = const [],
    super.verificationStatus = 'UNVERIFIED',
    super.tutorType,
  });

  factory TutorProfileModel.fromJson(Map<String, dynamic> json) {
    return TutorProfileModel(
      bio: json['bio'] as String?,
      subjects: (json['subjects'] as List<dynamic>?)?.map((e) => e as String).toList() ?? [],
      level: json['level'] as String?,
      location: json['location'] as String?,
      teachingMode: json['teachingMode'] as String?,
      hourlyRate: json['hourlyRate'] != null ? (json['hourlyRate'] as num).toDouble() : null,
      rating: json['rating'] != null ? (json['rating'] as num).toDouble() : 0.0,
      ratingCount: json['ratingCount'] as int? ?? 0,
      idCardUrl: json['idCardUrl'] as String?,
      idCardBackUrl: json['idCardBackUrl'] as String?,
      certUrls: (json['certUrls'] as List<dynamic>?)?.map((e) => e as String).toList() ?? [],
      verificationStatus: json['verificationStatus'] as String? ?? 'UNVERIFIED',
      tutorType: json['tutorType'] as String?,
    );
  }
}
