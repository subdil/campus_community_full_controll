import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class Api {
  static const String baseUrl =
      'https://campusmate-demo-app-szj4.vercel.app/api';

  static Future<Map<String, String>> _headers() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    return {
      'Content-Type': 'application/json',
      if (token != null && token.isNotEmpty) 'Authorization': 'Bearer $token',
    };
  }

  static Future<dynamic> _send(http.Response response) async {
    dynamic data;
    if (response.body.isNotEmpty) {
      try {
        data = jsonDecode(response.body);
      } catch (_) {
        data = {'message': response.body};
      }
    }

    if (response.statusCode >= 200 && response.statusCode < 300) {
      return data ?? <String, dynamic>{'success': true};
    }

    String message = 'Request failed (${response.statusCode})';
    if (data is Map && data['message'] != null) {
      message = data['message'].toString();
    } else if (data is Map && data['error'] != null) {
      message = data['error'].toString();
    }
    throw Exception(message);
  }

  static Future<dynamic> get(String path) async {
    return _send(await http.get(Uri.parse('$baseUrl$path'), headers: await _headers()));
  }

  static Future<dynamic> post(
    String path, [
    Map<String, dynamic>? body,
  ]) async {
    return _send(
      await http.post(
        Uri.parse('$baseUrl$path'),
        headers: await _headers(),
        body: body == null ? null : jsonEncode(body),
      ),
    );
  }

  static Future<dynamic> put(
    String path, [
    Map<String, dynamic>? body,
  ]) async {
    return _send(
      await http.put(
        Uri.parse('$baseUrl$path'),
        headers: await _headers(),
        body: body == null ? null : jsonEncode(body),
      ),
    );
  }

  static Future<dynamic> patch(
    String path, [
    Map<String, dynamic>? body,
  ]) async {
    return _send(
      await http.patch(
        Uri.parse('$baseUrl$path'),
        headers: await _headers(),
        body: body == null ? null : jsonEncode(body),
      ),
    );
  }

  static Future<dynamic> del(String path) async {
    return _send(
      await http.delete(Uri.parse('$baseUrl$path'), headers: await _headers()),
    );
  }

  static Future<void> save(Map<String, dynamic> response) async {
    final prefs = await SharedPreferences.getInstance();
    final token = response['token'];
    final user = response['user'];
    if (token != null) {
      await prefs.setString('token', token.toString());
    }
    if (user is Map) {
      await prefs.setString('user', jsonEncode(user));
    }
  }

  static Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('token');
    await prefs.remove('user');
  }
}
