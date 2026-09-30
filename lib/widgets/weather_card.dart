import 'package:flutter/material.dart';

class WeatherCard extends StatelessWidget {
  final String cityName;
  final double? temperature;
  final double? humidity;
  final double? windSpeed;
  final int? weatherCode;
  final int? isDay;

  const WeatherCard({
    super.key,
    required this.cityName,
    required this.temperature,
    required this.humidity,
    required this.windSpeed,
    required this.weatherCode,
    required this.isDay,
  });

  // ==================================================
  // WEATHER ICON
  // ==================================================

  IconData getWeatherIcon() {
    final code = weatherCode;

    if (code == null) {
      return Icons.wb_sunny;
    }

    // Clear sky
    if (code == 0) {
      if (isDay == 1) {
        return Icons.wb_sunny;
      } else {
        return Icons.nightlight_round;
      }
    }

    // Mainly clear
    if (code == 1) {
      return Icons.cloud;
    }

    // Partly cloudy
    if (code == 2) {
      return Icons.cloud;
    }

    // Overcast
    if (code == 3) {
      return Icons.cloud;
    }

    // Fog
    if (code == 45 || code == 48) {
      return Icons.foggy;
    }

    // Drizzle
    if (code >= 51 && code <= 57) {
      return Icons.grain;
    }

    // Rain
    if (code >= 61 && code <= 67) {
      return Icons.water_drop;
    }

    // Snow
    if (code >= 71 && code <= 77) {
      return Icons.ac_unit;
    }

    // Rain showers
    if (code >= 80 && code <= 82) {
      return Icons.grain;
    }

    // Snow showers
    if (code == 85 || code == 86) {
      return Icons.ac_unit;
    }

    // Thunderstorm
    if (code >= 95 && code <= 99) {
      return Icons.thunderstorm;
    }

    return Icons.cloud;
  }

  // ==================================================
  // WEATHER DESCRIPTION
  // ==================================================

  String getWeatherDescription() {
    final code = weatherCode;

    if (code == null) {
      return 'Weather';
    }

    // Clear sky
    if (code == 0) {
      return isDay == 1
          ? 'Clear Sky'
          : 'Clear Night';
    }

    // Mainly clear
    if (code == 1) {
      return 'Mainly Clear';
    }

    // Partly cloudy
    if (code == 2) {
      return 'Partly Cloudy';
    }

    // Overcast
    if (code == 3) {
      return 'Overcast';
    }

    // Fog
    if (code == 45 || code == 48) {
      return 'Fog';
    }

    // Drizzle
    if (code >= 51 && code <= 57) {
      return 'Drizzle';
    }

    // Rain
    if (code >= 61 && code <= 67) {
      return 'Rain';
    }

    // Snow
    if (code >= 71 && code <= 77) {
      return 'Snow';
    }

    // Rain showers
    if (code >= 80 && code <= 82) {
      return 'Rain Showers';
    }

    // Snow showers
    if (code == 85 || code == 86) {
      return 'Snow Showers';
    }

    // Thunderstorm
    if (code >= 95 && code <= 99) {
      return 'Thunderstorm';
    }

    return 'Weather';
  }

  // ==================================================
  // WEATHER BACKGROUND
  // ==================================================

  Color getWeatherBackground() {
    final code = weatherCode;

    if (code == null) {
      return Colors.blue;
    }

    // Night
    if (isDay == 0) {
      return const Color(0xFF172554);
    }

    // Clear sky
    if (code == 0) {
      return const Color(0xFF38BDF8);
    }

    // Cloudy
    if (code >= 1 && code <= 3) {
      return const Color(0xFF64748B);
    }

    // Fog
    if (code == 45 || code == 48) {
      return const Color(0xFF94A3B8);
    }

    // Drizzle + Rain
    if (code >= 51 && code <= 67) {
      return const Color(0xFF3B82F6);
    }

    // Snow
    if (code >= 71 && code <= 86) {
      return const Color(0xFF93C5FD);
    }

    // Thunderstorm
    if (code >= 95 && code <= 99) {
      return const Color(0xFF334155);
    }

    return Colors.blue;
  }

  // ==================================================
  // TEXT COLOR
  // ==================================================

  Color getTextColor() {
    final code = weatherCode;

    // Night
    if (isDay == 0) {
      return Colors.white;
    }

    // Cloudy
    if (code != null &&
        code >= 1 &&
        code <= 3) {
      return Colors.white;
    }

    // Drizzle + Rain
    if (code != null &&
        code >= 51 &&
        code <= 67) {
      return Colors.white;
    }

    // Thunderstorm
    if (code != null &&
        code >= 95 &&
        code <= 99) {
      return Colors.white;
    }

    // Light backgrounds
    return Colors.black87;
  }

  // ==================================================
  // ICON COLOR
  // ==================================================

  Color getIconColor() {
    final code = weatherCode;

    // Clear daytime
    if (code == 0 && isDay == 1) {
      return Colors.amber;
    }

    // Clear night
    if (code == 0 && isDay == 0) {
      return Colors.yellowAccent;
    }

    // Rain
    if (code != null &&
        code >= 51 &&
        code <= 67) {
      return Colors.white;
    }

    // Snow
    if (code != null &&
        code >= 71 &&
        code <= 86) {
      return Colors.white;
    }

    // Thunderstorm
    if (code != null &&
        code >= 95 &&
        code <= 99) {
      return Colors.yellowAccent;
    }

    // Cloud / fog
    return Colors.white;
  }

  // ==================================================
  // BUILD
  // ==================================================

  @override
  Widget build(BuildContext context) {
    return Card(
      color: getWeatherBackground(),
      elevation: 8,
      margin: const EdgeInsets.all(20),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24),
      ),
      child: Padding(
        padding: const EdgeInsets.all(30),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [

            // ==================================================
            // WEATHER ICON
            // ==================================================

            Icon(
              getWeatherIcon(),
              size: 80,
              color: getIconColor(),
            ),

            const SizedBox(
              height: 20,
            ),

            // ==================================================
            // CITY NAME
            // ==================================================

            Text(
              cityName,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
                color: getTextColor(),
              ),
            ),

            const SizedBox(
              height: 10,
            ),

            // ==================================================
            // WEATHER DESCRIPTION
            // ==================================================

            Text(
              getWeatherDescription(),
              style: TextStyle(
                fontSize: 18,
                color: getTextColor().withOpacity(0.9),
              ),
            ),

            const SizedBox(
              height: 10,
            ),

            // ==================================================
            // TEMPERATURE
            // ==================================================

            Text(
              temperature != null
                  ? '${temperature!.toStringAsFixed(1)}°C'
                  : '--°C',
              style: TextStyle(
                fontSize: 60,
                fontWeight: FontWeight.bold,
                color: getTextColor(),
              ),
            ),

            const SizedBox(
              height: 20,
            ),

            // ==================================================
            // HUMIDITY + WIND
            // ==================================================

            Row(
              mainAxisAlignment:
              MainAxisAlignment.center,
              children: [

                // Humidity
                Text(
                  humidity != null
                      ? 'Humidity: ${humidity!.toStringAsFixed(0)}%'
                      : 'Humidity: --%',
                  style: TextStyle(
                    fontSize: 18,
                    color: getTextColor(),
                  ),
                ),

                const SizedBox(
                  width: 25,
                ),

                // Wind
                Text(
                  windSpeed != null
                      ? 'Wind: ${windSpeed!.toStringAsFixed(1)} km/h'
                      : 'Wind: -- km/h',
                  style: TextStyle(
                    fontSize: 18,
                    color: getTextColor(),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}