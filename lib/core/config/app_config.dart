/// Build-time configuration, read from `--dart-define-from-file=env/<env>.json`.
///
/// This is the only place `fromEnvironment` is read. [AppConfig.fromEnvironment]
/// fails fast with a [ConfigException] naming the first missing or invalid key.
final class AppConfig {
  const AppConfig({required this.apiBaseUrl, required this.useMockApi});

  /// Base URL of the Punchy backend.
  final Uri apiBaseUrl;

  /// When true, services are bound to in-memory mocks instead of HTTP.
  final bool useMockApi;

  static const apiBaseUrlKey = 'API_BASE_URL';
  static const useMockApiKey = 'USE_MOCK_API';

  factory AppConfig.fromEnvironment() => AppConfig.parse(const {
    apiBaseUrlKey: String.fromEnvironment(apiBaseUrlKey),
    useMockApiKey: String.fromEnvironment(useMockApiKey),
  });

  /// Validates raw values; exposed separately so it can be tested.
  factory AppConfig.parse(Map<String, String> raw) {
    final baseUrl = Uri.tryParse(raw[apiBaseUrlKey] ?? '');
    if (baseUrl == null || !baseUrl.hasScheme || baseUrl.host.isEmpty) {
      throw const ConfigException(apiBaseUrlKey);
    }
    final useMock = switch (raw[useMockApiKey]) {
      'true' => true,
      'false' => false,
      _ => throw const ConfigException(useMockApiKey),
    };
    return AppConfig(apiBaseUrl: baseUrl, useMockApi: useMock);
  }
}

final class ConfigException implements Exception {
  const ConfigException(this.key);

  /// The dart-define key that is missing or invalid.
  final String key;

  @override
  String toString() => 'ConfigException: missing or invalid "$key"';
}
