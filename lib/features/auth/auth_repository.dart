import 'dart:convert';
import 'package:ghaselny/features/auth/login/data/login_model.dart';
import 'package:ghaselny/features/auth/register/data/register_model.dart';
import 'package:http/http.dart' as http;

class AuthRepository {
  final String baseUrl = "https://ghaslni-api.vercel.app/auth";

  // --- Registration ---
  Future<void> registerUser(RegisterRequest request) async {
    try {
      final uri = Uri.parse("$baseUrl/register");
      final response = await http.post(
        uri,
        headers: {
          "Content-Type": "application/json",
          "Accept": "application/json",
        },
        body: jsonEncode(request.toJson()),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return;
      } else {
        throw Exception("Failed to register: ${response.body}");
      }
    } catch (e) {
      throw Exception("Network error: $e");
    }
  }

  // --- Login ---
  Future<void> login(LoginRequest request) async {
    try {
      final uri = Uri.parse("$baseUrl/login");
      final response = await http.post(
        uri,
        headers: {
          "Content-Type": "application/json",
          "Accept": "application/json",
        },
        body: jsonEncode(request.toJson()),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return;
      } else {
        String errorMsg = "Failed to login";
        try {
          final body = jsonDecode(response.body);
          if(body['message'] != null) errorMsg = body['message'];
        } catch(_) {}
        throw Exception(errorMsg);
      }
    } catch (e) {
      throw Exception("Network error: $e");
    }
  }

  // --- Forgot Password ---
  /// Returns a user ID or token if the API provides one, otherwise returns null.
  Future<String?> forgotPassword(String identifier, bool isPhone) async {
    try {
      final uri = Uri.parse("$baseUrl/forgot-password");

      final Map<String, dynamic> body = isPhone
          ? {"phoneNumber": identifier}
          : {"email": identifier};

      final response = await http.post(
        uri,
        headers: {
          "Content-Type": "application/json",
          "Accept": "application/json",
        },
        body: jsonEncode(body),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        // Check if API returns the ID needed for the next step
        try {
          final data = jsonDecode(response.body);
          // Adjust key based on actual API response (e.g., 'id', 'userId', 'token')
          return data['id']?.toString() ?? data['userId']?.toString();
        } catch (_) {
          return null;
        }
      } else {
        String errorMsg = "Failed to send reset request";
        try {
          final body = jsonDecode(response.body);
          if(body['message'] != null) errorMsg = body['message'];
        } catch(_) {}
        throw Exception(errorMsg);
      }
    } catch (e) {
      throw Exception("Network error: $e");
    }
  }

  // --- Reset Password ---
  Future<void> resetPassword(String id, String newPassword) async {
    try {
      final uri = Uri.parse("$baseUrl/reset-password/$id");

      final response = await http.post(
        uri,
        headers: {
          "Content-Type": "application/json",
          "Accept": "application/json",
        },
        body: jsonEncode({"password": newPassword}),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return;
      } else {
        String errorMsg = "Failed to reset password";
        try {
          final body = jsonDecode(response.body);
          if(body['message'] != null) errorMsg = body['message'];
        } catch(_) {}
        throw Exception(errorMsg);
      }
    } catch (e) {
      throw Exception("Network error: $e");
    }
  }
}