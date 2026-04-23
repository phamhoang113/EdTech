/// Centralized app configuration — tránh hardcode URL rải rác.
///
/// Sử dụng `--dart-define` khi build:
/// ```
/// flutter run --dart-define=API_BASE_URL=https://api.giasutinhhoa.com
/// flutter run --dart-define=WEB_BASE_URL=https://giasutinhhoa.com
/// ```
///
/// Dev trên thiết bị thật: dùng IP LAN thay vì localhost
/// flutter run --dart-define=API_BASE_URL=http://10.173.18.33:8080
class AppConfig {
  AppConfig._();

  static const String apiBaseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: 'http://10.101.45.65:8080', // IP Wi-Fi hotspot từ điện thoại
  );

  static const String webBaseUrl = String.fromEnvironment(
    'WEB_BASE_URL',
    defaultValue: 'http://10.101.45.65:5173', // IP Wi-Fi hotspot từ điện thoại
  );
}
