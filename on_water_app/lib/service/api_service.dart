import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

class ApiService {
  static Future<bool> fetchWaterData(double latitude, double longitude) async {
    final String apiKey = dotenv.env['API_KEY'] ?? '';
    final String apiHost = dotenv.env['API_HOST'] ?? '';

    final url = Uri.parse("https://isitwater-com.p.rapidapi.com/?latitude=$latitude&longitude=$longitude");

    try {
      final response = await http.get(
        url,
        headers: {
          'X-Rapidapi-Key': apiKey,
          'X-Rapidapi-Host': apiHost,
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['water'] ?? false;
      } else {
        throw Exception('Erro ao buscar dados: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Erro ao buscar dados: $e');
    }
  }
}
