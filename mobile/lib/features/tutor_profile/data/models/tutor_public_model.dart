import '../../domain/entities/tutor_public_entity.dart';

class TutorPublicModel extends TutorPublicEntity {
  const TutorPublicModel({
    required super.userId,
    required super.fullName,
    super.bio,
    super.subjects = const [],
    super.location,
    super.teachingMode,
    super.hourlyRate,
    super.rating = 0.0,
    super.ratingCount = 0,
    super.teachingLevels = const [],
    super.achievements,
    super.experienceYears,
    super.avatarBase64,
    super.tutorType,
  });

  factory TutorPublicModel.fromJson(Map<String, dynamic> json) {
    return TutorPublicModel(
      userId: json['userId'] as String,
      fullName: json['fullName'] as String? ?? 'Gia sư',
      bio: json['bio'] as String?,
      subjects: _parseStringList(json['subjects']),
      location: json['location'] as String?,
      teachingMode: json['teachingMode'] as String?,
      hourlyRate: json['hourlyRate'] != null
          ? (json['hourlyRate'] as num).toDouble()
          : null,
      rating: json['rating'] != null
          ? (json['rating'] as num).toDouble()
          : 0.0,
      ratingCount: json['ratingCount'] as int? ?? 0,
      teachingLevels: _parseStringList(json['teachingLevels']),
      achievements: json['achievements'] as String?,
      experienceYears: json['experienceYears'] as int?,
      avatarBase64: json['avatarBase64'] as String?,
      tutorType: json['tutorType'] as String?,
    );
  }

  /// Parse dynamic list (could be `List<String>` or null)
  static List<String> _parseStringList(dynamic value) {
    if (value == null) return [];
    if (value is List) return value.map((e) => e.toString()).toList();
    return [];
  }
}
