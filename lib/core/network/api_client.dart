import 'dart:convert';

import 'package:http/http.dart' as http;

/// The one shared client for the Punchy backend. Adds the bearer token of
/// the current session and decodes JSON bodies.
class ApiClient {
  ApiClient({
    required this._baseUrl,
    required this._tokenProvider,
    http.Client? httpClient,
  }) : _http = httpClient ?? http.Client();

  final Uri _baseUrl;
  final String? Function() _tokenProvider;
  final http.Client _http;

  static const _timeout = Duration(seconds: 15);

  Future<Object?> get(String path) =>
      _send(() => _http.get(_resolve(path), headers: _headers()));

  Future<Object?> post(String path, Map<String, Object?> body) => _send(
    () =>
        _http.post(_resolve(path), headers: _headers(), body: jsonEncode(body)),
  );

  Uri _resolve(String path) => _baseUrl.resolve(path);

  Map<String, String> _headers() {
    final token = _tokenProvider();
    return {
      'Accept': 'application/json',
      'Content-Type': 'application/json',
      if (token != null) 'Authorization': 'Bearer $token',
    };
  }

  Future<Object?> _send(Future<http.Response> Function() request) async {
    final http.Response response;
    try {
      response = await request().timeout(_timeout);
    } on Exception catch (e) {
      throw NetworkException(e);
    }
    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw ApiException(response.statusCode);
    }
    if (response.body.isEmpty) return null;
    return jsonDecode(response.body);
  }
}

/// The server answered with a non-2xx status.
final class ApiException implements Exception {
  const ApiException(this.statusCode);

  final int statusCode;

  bool get isUnauthorized => statusCode == 401 || statusCode == 403;

  @override
  String toString() => 'ApiException($statusCode)';
}

/// The request never reached the server, or timed out.
final class NetworkException implements Exception {
  const NetworkException(this.cause);

  final Object cause;

  @override
  String toString() => 'NetworkException($cause)';
}
