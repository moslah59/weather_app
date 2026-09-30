import 'dart:convert';

import 'package:http/http.dart' as http;

class WeatherService {
  Future<Map<String, dynamic>> getWeather(
      double latitude,
      double longitude,
      ) async {
    final url = Uri.parse(
      'https://api.open-meteo.com/v1/forecast'
          '?latitude=$latitude'
          '&longitude=$longitude'
          '&timezone=auto'
          '&current='
          'temperature_2m,'
          'relative_humidity_2m,'
          'wind_speed_10m,'
          'weather_code,'
          'is_day'
          '&hourly='
          'temperature_2m,'
          'weather_code,'
          'precipitation_probability'
          '&daily='
          'temperature_2m_max,'
          'temperature_2m_min,'
          'weather_code,'
          'precipitation_probability_max,'
          'sunrise,'
          'sunset'
          '&forecast_days=10',
    );

    final response = await http.get(url);

    if (response.statusCode != 200) {
      throw Exception(
        'Weather data could not be loaded',
      );
    }

    final data = jsonDecode(response.body);

    return data;
  }
}