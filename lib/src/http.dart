import 'package:http/http.dart' as http;
import 'decoder.dart';

typedef OnRefreshError = void Function(dynamic error);
typedef OnRefreshSuccess = void Function();
typedef OnRefreshStart = void Function();

class Http {
  static String _baseUrl = "";
  static String refreshTokenURL = "";
  static Map<String, String> requestHeaders = {};
  static Map<String, dynamic> requestBody = {};
  static OnRefreshError? _onRefreshError;
  static OnRefreshSuccess? _onRefreshSuccess;
  static OnRefreshStart? _onRefreshStart;

  /// This function initializes the Http class with the base URL, refresh token URL and Tokens.
  ///
  /// [baseUrl] The base URL of the API.
  /// Example: "https://myapp.com"
  ///
  /// [refreshTokenURL] The refresh token URL of the API.
  /// Example: "/api/auth/refresh-token"
  ///
  /// [accessToken] The access token [String]
  /// Example: "access_token"
  ///
  /// [refreshToken] The refresh token [String]
  /// Example: "refresh_token"
  ///
  /// [requestHeaders] You can adjust all request headers.
  /// Example: {"Content-Type": "application/json", "x-client-type": "flutter"}
  ///
  /// [requestBody] You can adjust all request body.
  /// Example: {"device_id": "device_id"}
  ///
  /// [onRefreshError] Called when a request fails due to an error.
  /// Provides the error information.
  /// Parameters:
  /// - [error]: The error message or object describing why the request failed.
  /// This callback does **not** return anything. Use it to:
  /// - Display error messages to the user
  /// - Log the error
  /// - Trigger retries or fallback actions if needed
  static void init({
    required String baseUrl,
    required String refreshTokenURL,
    required String accessToken,
    required String refreshToken,
    Map<String, String>? requestHeaders,
    Map<String, dynamic>? requestBody,
    OnRefreshError? onRefreshError,
    OnRefreshSuccess? onRefreshSuccess,
    OnRefreshStart? onRefreshStart,
  }) {
    _baseUrl = baseUrl;
    refreshTokenURL = refreshTokenURL;
    write(accessToken, refreshToken);
    _onRefreshError = onRefreshError;
    _onRefreshSuccess = onRefreshSuccess;
    _onRefreshStart = onRefreshStart;
  }

  /// This function returns the base URL of the API.
  static String? get baseUrl => _baseUrl;

  /// This function sends a POST request to the specified URL with the provided body and headers.
  ///
  /// [url] Type the route only.
  /// Example: /api/auth/login or http://myapp.com/api/auth/login
  ///
  /// [body] The body
  /// Example: {"email": "email", "password": "password"}
  ///
  /// [headers] The headers automatic add Content-Type: application/json, x-client-type: flutter and Authorization: 'Bearer $accessToken'
  /// Example: {"Content-Type": "application/json", "x-client-type": "flutter"}
  static Future post(
    String url, {
    required Map body,
    Map<String, String>? headers,
  }) async {
    headers?['Authorization'] = 'Bearer ${await getValue('access_token')}';
    headers?.addAll(requestHeaders);
    body.addAll(requestBody);

    final response = await http.post(
      // To check if the url starts with http or route.
      Uri.parse(url.startsWith("http") ? url : "$_baseUrl$url"),
      headers: headers,
      body: body,
    );

    if (response.statusCode == 200) {
      return response;
    } else if (response.statusCode == 401) {
      _onRefreshStart!.call();
      final bool refreshResponse = await refreshAccessToken(
        await getValue('refresh_token'),
      );
      if (refreshResponse) {
        _onRefreshSuccess!.call();
        return await post(url, body: body, headers: headers);
      } else {
        _onRefreshError!.call({"message": "Refresh token failed or expired"});
      }
    } else {
      return response;
    }
  }

  /// This function sends a GET request to the specified URL with the provided headers.
  ///
  /// [url] Type the route only.
  /// Example: /api/data or http://myapp.com/api/data
  ///
  /// [headers] The headers automatic add Content-Type: application/json, x-client-type: flutter and Authorization: 'Bearer $accessToken'
  /// Example: {"Content-Type": "application/json", "x-client-type": "flutter"}
  static Future get(String url, {Map<String, String>? headers}) async {
    headers?['Authorization'] = 'Bearer ${await getValue('access_token')}';
    headers?.addAll(requestHeaders);

    final response = await http.get(
      Uri.parse(url.startsWith("http") ? url : "$_baseUrl$url"),
      headers: headers,
    );

    if (response.statusCode == 200) {
      return response;
    } else if (response.statusCode == 401) {
      _onRefreshStart!.call();
      final refreshResponse = await refreshAccessToken(
        await getValue('refresh_token'),
      );
      if (refreshResponse) {
        _onRefreshSuccess!.call();
        return await get(url, headers: headers);
      } else {
        _onRefreshError!.call({"message": "Refresh token failed or expired"});
      }
    } else {
      return response;
    }
  }

  /// This function sends a PUT request to the specified URL with the provided body and headers.
  ///
  /// [url] Type the route only.
  /// Example: /api/data or http://myapp.com/api/data
  ///
  /// [body] The body
  /// Example: {"username": "Yousef", "email": "yousef@example.com", "password": "password"}
  ///
  /// [headers] The headers automatic add Content-Type: application/json, x-client-type: flutter and Authorization: 'Bearer $accessToken'
  /// Example: {"Content-Type": "application/json", "x-client-type": "flutter"}
  static Future put(
    String url, {
    required Map body,
    Map<String, String>? headers,
  }) async {
    headers?['Authorization'] = 'Bearer ${await getValue('access_token')}';
    headers?.addAll(requestHeaders);
    body.addAll(requestBody);

    final response = await http.put(
      Uri.parse(url.startsWith("http") ? url : "$_baseUrl$url"),
      headers: headers,
      body: body,
    );

    if (response.statusCode == 200) {
      return response;
    } else if (response.statusCode == 401) {
      _onRefreshStart!.call();
      final refreshResponse = await refreshAccessToken(
        await getValue('refresh_token'),
      );
      if (refreshResponse) {
        _onRefreshSuccess!.call();
        return await put(url, body: body, headers: headers);
      } else {
        _onRefreshError!.call({"message": "Refresh token failed or expired"});
      }
    } else {
      return response;
    }
  }

  /// This function sends a DELETE request to the specified URL with the provided body and headers.
  ///
  /// [url] Type the route only.
  /// Example: /api/data or https://myapp.com/api/data
  ///
  /// [headers] The headers automatic add Content-Type: application/json, x-client-type: flutter and Authorization: 'Bearer $accessToken'
  /// Example: {"Content-Type": "application/json", "x-client-type": "flutter"}
  ///
  /// [body] The body (Not best practice) | Optional
  /// Example: {"id": "123"}
  static Future delete(
    String url, {
    Map<String, String>? headers,
    Map? body,
  }) async {
    headers?['Authorization'] = 'Bearer ${await getValue('access_token')}';
    headers?.addAll(requestHeaders);
    body?.addAll(requestBody);

    final response = await http.delete(
      Uri.parse(url.startsWith("http") ? url : "$_baseUrl$url"),
      headers: headers,
      body: body,
    );

    if (response.statusCode == 200) {
      return response;
    } else if (response.statusCode == 401) {
      _onRefreshStart!.call();
      final refreshResponse = await refreshAccessToken(
        await getValue('refresh_token'),
      );
      if (refreshResponse) {
        _onRefreshSuccess!.call();
        return await delete(url, headers: headers, body: body);
      } else {
        _onRefreshError!.call({"message": "Refresh token failed or expired"});
      }
    } else {
      return response;
    }
  }
}
