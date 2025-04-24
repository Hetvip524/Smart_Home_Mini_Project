import 'dart:convert';
import 'package:http/http.dart' as http;

class WeatherService {
  static const String _apiKey = 'dce43babe23d8de59f0bbd92a70c368e'; // Replace with your OpenWeatherMap API key
  static const String _baseUrl = 'https://api.openweathermap.org/data/2.5/weather';

  Future<Map<String, dynamic>> getWeather(double lat, double lon) async {
    try {
      final url = '$_baseUrl?lat=$lat&lon=$lon&units=metric&appid=$_apiKey';
      print('Fetching weather from: $url'); // Debug log

      final response = await http.get(Uri.parse(url));
      print('Response status code: ${response.statusCode}'); // Debug log
      print('Response body: ${response.body}'); // Debug log

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception('Failed to load weather data: ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      print('Error fetching weather data: $e'); // Debug log
      throw Exception('Error fetching weather data: $e');
    }
  }
} 