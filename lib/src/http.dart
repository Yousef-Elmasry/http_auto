import 'package:http/http.dart' as http;
import 'decoder.dart';

class Http {
  static String _baseUrl = "";
  static String refreshTokenURL = "";

  /// This function initializes the Http class with the base URL, refresh token URL and Tokens.
  static void init({
    /// The base URL of the API.
    /// Example: "http://myapp.com/api"
    required String baseUrl,

    /// The refresh token URL of the API.
    /// Example: "/api/auth/refresh-token"
    required String refreshTokenURL,

    /// The access token [String]
    required String accessToken,

    /// The refresh token [String]
    required String refreshToken,
  }) {
    _baseUrl = baseUrl;
    refreshTokenURL = refreshTokenURL;
    write(accessToken, refreshToken);
  }

  static String? get baseUrl => _baseUrl;

  /// This function sends a POST request to the specified URL with the provided body and headers.
  static Future post({
    /// Type the route only.
    /// Example: /api/auth/login or http://myapp.com/api/auth/login
    required String url,

    /// The body
    /// Example: {"email": "email", "password": "password"}
    required Map body,

    /// The headers automatic add Content-Type: application/json, x-client-type: flutter and Authorization: 'Bearer $accessToken'
    Map<String, String>? headers,
  }) async {
    headers ??= {};
    headers['Content-Type'] = 'application/json';
    headers['x-client-type'] = 'flutter';
    headers['Authorization'] = 'Bearer ${await getValue('access_token')}';

    final response = await http.post(
      // To check if the url starts with http or route.
      Uri.parse(url.startsWith("http") ? url : "$_baseUrl$url"),
      headers: headers,
      body: body,
    );

    if (response.statusCode == 200) {
      return response;
    } else if (response.statusCode == 401) {
      final refreshResponse = await refreshAccessToken(
        await getValue('refresh_token'),
      );
      if (refreshResponse) {
        return await post(url: url, body: body, headers: headers);
      } else {
        return "Refresh token failed or expired";
      }
    } else {
      return response;
    }
  }

  /// This function sends a GET request to the specified URL with the provided headers.
  static Future get({
    /// Type the route only.
    /// Example: /api/data
    required String url,

    /// The headers automatic add Content-Type: application/json, x-client-type: flutter and Authorization: 'Bearer $accessToken'
    Map<String, String>? headers,
  }) async {
    headers ??= {};
    headers['Content-Type'] = 'application/json';
    headers['x-client-type'] = 'flutter';
    headers['Authorization'] = 'Bearer ${await getValue('access_token')}';

    final response = await http.get(
      Uri.parse(url.startsWith("http") ? url : "$_baseUrl$url"),
      headers: headers,
    );

    if (response.statusCode == 200) {
      return response;
    } else if (response.statusCode == 401) {
      final refreshResponse = await refreshAccessToken(
        await getValue('refresh_token'),
      );
      if (refreshResponse) {
        return await get(url: url, headers: headers);
      } else {
        return "Refresh token failed or expired";
      }
    } else {
      return response;
    }
  }

  /// This function sends a PUT request to the specified URL with the provided body and headers.
  static Future put({
    /// Type the route only.
    /// Example: /api/users
    required String url,

    /// The body
    /// Example: {"username": "Yousef", "email": "yousef@example.com", "password": "password"}
    required Map body,

    /// The headers automatic add Content-Type: application/json, x-client-type: flutter and Authorization: 'Bearer $accessToken'
    Map<String, String>? headers,
  }) async {
    headers ??= {};
    headers['Content-Type'] = 'application/json';
    headers['x-client-type'] = 'flutter';
    headers['Authorization'] = 'Bearer ${await getValue('access_token')}';

    final response = await http.put(
      Uri.parse(url.startsWith("http") ? url : "$_baseUrl$url"),
      headers: headers,
      body: body,
    );

    if (response.statusCode == 200) {
      return response;
    } else if (response.statusCode == 401) {
      final refreshResponse = await refreshAccessToken(
        await getValue('refresh_token'),
      );
      if (refreshResponse) {
        return await put(url: url, body: body, headers: headers);
      } else {
        return "Refresh token failed or expired";
      }
    } else {
      return response;
    }
  }

  /// This function sends a DELETE request to the specified URL with the provided body and headers.
  static Future delete({
    /// Type the route only.
    /// Example: /api/auth/login
    required String url,

    /// The headers automatic add Content-Type: application/json, x-client-type: flutter and Authorization: 'Bearer $accessToken'
    Map<String, String>? headers,

    /// The body (Not best practice) | Optional
    /// Example: {"id": "123"}
    Map? body,
  }) async {
    headers ??= {};
    headers['Content-Type'] = 'application/json';
    headers['x-client-type'] = 'flutter';
    headers['Authorization'] = 'Bearer ${await getValue('access_token')}';

    final response = await http.delete(
      Uri.parse(url.startsWith("http") ? url : "$_baseUrl$url"),
      headers: headers,
      body: body,
    );

    if (response.statusCode == 200) {
      return response;
    } else if (response.statusCode == 401) {
      final refreshResponse = await refreshAccessToken(
        await getValue('refresh_token'),
      );
      if (refreshResponse) {
        return await delete(url: url, headers: headers, body: body);
      } else {
        return "Refresh token failed or expired";
      }
    } else {
      return response;
    }
  }
}
