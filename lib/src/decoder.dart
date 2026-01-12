import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'http.dart';
import 'dart:convert';

final storage = FlutterSecureStorage();

// Save tokens
/// This function saves the access and refresh tokens to secure storage.
Future<void> write(String accessToken, String refreshToken) async {
  await storage.write(key: 'access_token', value: accessToken);
  await storage.write(key: 'refresh_token', value: refreshToken);
}

// Read tokens
/// This function gets the access and refresh tokens from secure storage.
Future<Map<String, String?>> getAll() async {
  final access = await storage.read(key: 'access_token');
  final refresh = await storage.read(key: 'refresh_token');
  return {'access_token': access, 'refresh_token': refresh};
}

// Get specific value
/// This function gets a specific value from secure storage.
Future<dynamic> getValue(String key) async {
  return await storage.read(key: key);
}

// Clear tokens
/// This function deletes all tokens from secure storage.
Future<void> clearAll() async {
  await storage.deleteAll();
}

// Delete value
/// This function deletes a specific value from secure storage.
Future<void> deleteValue(String key) async {
  await storage.delete(key: key);
}

// Refresh access token
/// This function refreshes the access token using the refresh token.
Future<bool> refreshAccessToken(String? refreshToken) async {
  if (refreshToken == null) return false;

  final response = await http.post(
    Uri.parse(
      Http.refreshTokenURL.startsWith("http:")
          ? Http.refreshTokenURL
          : "${Http.baseUrl}${Http.refreshTokenURL}",
    ),
    headers: {'Content-Type': 'application/json', 'x-client-type': 'flutter'},
    body: jsonEncode({'refresh_token': refreshToken}),
  );

  if (response.statusCode == 200) {
    final data = jsonDecode(response.body);
    final newAccessToken = data['access_token'];
    if (newAccessToken != null) {
      await storage.write(key: 'access_token', value: newAccessToken);
      return true;
    }
  }
  return false;
}