import 'dart:convert';
import 'package:http/http.dart' as http;

/// Kết quả geocode từ Mapbox Search API v6.
class PlaceResult {
  final String displayName;
  final double lat;
  final double lon;
  final String? placeId;

  const PlaceResult({
    required this.displayName,
    required this.lat,
    required this.lon,
    this.placeId,
  });
}

/// Service gọi Mapbox Search API v6 (geocode).
/// Dùng chung API key với web frontend.
class MapboxService {
  /// Mapbox token — truyền qua: --dart-define=MAPBOX_ACCESS_TOKEN=pk.xxx
  static const _accessToken = String.fromEnvironment(
    'MAPBOX_ACCESS_TOKEN',
    defaultValue: '',
  );

  static const _baseUrl = 'https://api.mapbox.com/search/geocode/v6';

  /// Forward geocode: tìm địa chỉ từ query text.
  static Future<List<PlaceResult>> searchAddress(String query) async {
    if (query.trim().length < 2) return [];

    final url = Uri.parse(
      '$_baseUrl/forward'
      '?q=${Uri.encodeComponent(query)}'
      '&country=vn'
      '&language=vi'
      '&access_token=$_accessToken',
    );

    try {
      final response = await http.get(url).timeout(const Duration(seconds: 8));
      if (response.statusCode != 200) return [];

      final data = json.decode(response.body);
      final features = data['features'] as List<dynamic>? ?? [];

      return features.map((f) {
        final props = f['properties'] as Map<String, dynamic>;
        final coords = f['geometry']['coordinates'] as List<dynamic>;
        return PlaceResult(
          displayName: props['full_address'] as String? ??
              props['name'] as String? ??
              props['place_formatted'] as String? ??
              '',
          lon: (coords[0] as num).toDouble(),
          lat: (coords[1] as num).toDouble(),
          placeId: f['id'] as String?,
        );
      }).toList();
    } catch (_) {
      return [];
    }
  }

  /// Reverse geocode: lấy địa chỉ từ tọa độ.
  static Future<String> reverseGeocode(double lat, double lon) async {
    final url = Uri.parse(
      '$_baseUrl/reverse'
      '?longitude=$lon'
      '&latitude=$lat'
      '&language=vi'
      '&access_token=$_accessToken',
    );

    try {
      final response = await http.get(url).timeout(const Duration(seconds: 8));
      if (response.statusCode != 200) return _formatCoords(lat, lon);

      final data = json.decode(response.body);
      final features = data['features'] as List<dynamic>? ?? [];
      if (features.isEmpty) return _formatCoords(lat, lon);

      final props = features[0]['properties'] as Map<String, dynamic>;
      return props['full_address'] as String? ??
          props['name'] as String? ??
          props['place_formatted'] as String? ??
          _formatCoords(lat, lon);
    } catch (_) {
      return _formatCoords(lat, lon);
    }
  }

  /// Mapbox tile URL cho flutter_map (streets style).
  static String get tileUrl =>
      'https://api.mapbox.com/styles/v1/mapbox/streets-v12/tiles/{z}/{x}/{y}@2x'
      '?access_token=$_accessToken';

  static String _formatCoords(double lat, double lon) =>
      '${lat.toStringAsFixed(6)}, ${lon.toStringAsFixed(6)}';
}
