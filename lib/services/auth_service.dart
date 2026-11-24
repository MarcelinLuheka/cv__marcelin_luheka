
import 'dart:convert';
import 'package:http/http.dart' as http;

class AuthService {
  static const String baseUrl =
      'http://127.0.0.1:8081/api-test/public';

  Future<Map<String, dynamic>> register(
    String email,
    String password,
  ) async {
    final response = await http.post(
      Uri.parse('$baseUrl/accounts/register'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'email': email,
        'password': password,
      }),
    );

    return _handleResponse(response);
  }

  Future<Map<String, dynamic>> login(
    String email,
    String password,
  ) async {
    final response = await http.post(
      Uri.parse('$baseUrl/accounts/login'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'email': email,
        'password': password,
      }),
    );

    return _handleResponse(response);
  }

  Map<String, dynamic> _handleResponse(
    http.Response response,
  ) {
    final dynamic data = jsonDecode(response.body);

    if (data is Map<String, dynamic>) {
      if (response.statusCode >= 200 &&
          response.statusCode < 300) {
        return data;
      }

      throw Exception(
        data['message'] ?? 'Une erreur est survenue',
      );
    }

    throw Exception('Réponse invalide du serveur');
  }
}
