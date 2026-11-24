
import 'dart:convert';
import 'package:http/http.dart' as http;

class FamilyService {
  static const String baseUrl =
      'http://127.0.0.1:8081/api-test/public';

  // RECUPERER TOUS LES MEMBRES
  Future<List<dynamic>> getMembers() async {
    final response = await http.get(
      Uri.parse('$baseUrl/famille-membres'),
    );

    final data = _handleResponse(response);
    return data['data'] as List<dynamic>;
  }

  // AJOUTER UN MEMBRE SANS PHOTO
  Future<Map<String, dynamic>> addMember(
    Map<String, dynamic> member,
  ) async {
    final response = await http.post(
      Uri.parse('$baseUrl/famille-membres'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(member),
    );

    return _handleResponse(response);
  }

  // AJOUTER UN MEMBRE AVEC PHOTO
  Future<Map<String, dynamic>> addMemberWithImage(
    Map<String, dynamic> member,
    String imagePath,
  ) async {
    final request = http.MultipartRequest(
      'POST',
      Uri.parse('$baseUrl/famille-membres'),
    );

    member.forEach((key, value) {
      request.fields[key] = value.toString();
    });

    request.files.add(
      await http.MultipartFile.fromPath('image', imagePath),
    );

    final streamedResponse = await request.send();
    final response = await http.Response.fromStream(streamedResponse);

    return _handleResponse(response);
  }

  // MODIFIER UN MEMBRE SANS CHANGER SA PHOTO
  Future<Map<String, dynamic>> updateMember(
    int id,
    Map<String, dynamic> member,
  ) async {
    final response = await http.put(
      Uri.parse('$baseUrl/famille-membres/$id'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(member),
    );

    return _handleResponse(response);
  }

  // MODIFIER UN MEMBRE AVEC UNE NOUVELLE PHOTO
  Future<Map<String, dynamic>> updateMemberWithImage(
    int id,
    Map<String, dynamic> member,
    String imagePath,
  ) async {
    final request = http.MultipartRequest(
      'POST',
      Uri.parse('$baseUrl/famille-membres/$id'),
    );

    member.forEach((key, value) {
      request.fields[key] = value.toString();
    });

    request.files.add(
      await http.MultipartFile.fromPath('image', imagePath),
    );

    final streamedResponse = await request.send();
    final response = await http.Response.fromStream(streamedResponse);

    return _handleResponse(response);
  }

  // SUPPRIMER UN MEMBRE
  Future<Map<String, dynamic>> deleteMember(int id) async {
    final response = await http.delete(
      Uri.parse('$baseUrl/famille-membres/$id'),
    );

    return _handleResponse(response);
  }

  // TRAITER LES REPONSES DE L'API
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
