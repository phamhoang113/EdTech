import '../../features/tutor_profile/domain/entities/tutor_public_entity.dart';

/// In-memory cache cho danh sách Gia Sư Tiêu Biểu.
/// Cache sẽ tồn tại trong suốt session và hết hạn sau 7 ngày.
class FeaturedTutorCache {
  static final FeaturedTutorCache _instance = FeaturedTutorCache._();
  factory FeaturedTutorCache() => _instance;
  FeaturedTutorCache._();

  static const Duration cacheExpiration = Duration(days: 7);

  List<TutorPublicEntity>? _cachedTutors;
  DateTime? _cachedAt;

  bool get isValid =>
      _cachedTutors != null &&
      _cachedAt != null &&
      DateTime.now().difference(_cachedAt!) < cacheExpiration;

  List<TutorPublicEntity>? get tutors => isValid ? _cachedTutors : null;

  void save(List<TutorPublicEntity> tutors) {
    _cachedTutors = tutors;
    _cachedAt = DateTime.now();
  }

  void clear() {
    _cachedTutors = null;
    _cachedAt = null;
  }
}
