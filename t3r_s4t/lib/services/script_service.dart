import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../models/script_model.dart';
import 'api_service.dart';

class ScriptService {
  /// Obtener todos los scripts
  static Future<List<ScriptModel>> getScripts({String? type}) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token') ?? '';

    final url = type != null
        ? '${ApiService.baseUrl}/scripts?type=$type'
        : '${ApiService.baseUrl}/scripts';

    final response = await http.get(
      Uri.parse(url),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((e) => ScriptModel.fromJson(e)).toList();
    } else {
      throw Exception('Error al obtener scripts.');
    }
  }

  /// Obtener enlace de descarga de un script (protegido)
  static Future<String> getScriptDownloadUrl(String scriptId) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token') ?? '';

    final response = await http.get(
      Uri.parse('${ApiService.baseUrl}/scripts/$scriptId/download'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return data['url'] ?? '';
    } else {
      throw Exception('No se pudo obtener el enlace de descarga.');
    }
  }
}
