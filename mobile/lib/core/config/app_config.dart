/// Centralized app configuration — tránh hardcode URL rải rác.
///
/// Sử dụng `--dart-define` khi build:
/// ```
/// flutter run --dart-define=API_BASE_URL=https://api.giasutinhhoa.com
/// flutter run --dart-define=WEB_BASE_URL=https://giasutinhhoa.com
/// ```
class AppConfig {
  AppConfig._();

  static const String apiBaseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: 'http://localhost:8080',
  );

  static const String webBaseUrl = String.fromEnvironment(
    'WEB_BASE_URL',
    defaultValue: 'http://localhost:5173',
  );
}
