import 'dart:convert';
import 'package:http/http.dart' as http;

class WeatherService {
  static const String _apiKey = 'a7e0977dc452c261c9a7ac90dbb73161';
  static const String _baseUrl = 'https://api.openweathermap.org/data/2.5/weather';

  static Future<Map<String, dynamic>?> getWeather(double lat, double lng) async {
    try {
      final url = Uri.parse('$_baseUrl?lat=$lat&lon=$lng&units=metric&appid=$_apiKey');
      final response = await http.get(url);

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        print('❌ Weather fetch failed: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      print('❌ Weather error: $e');
      return null;
    }
  }
}
