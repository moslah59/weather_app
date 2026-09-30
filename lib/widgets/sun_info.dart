import 'package:flutter/material.dart';

class SunInfo extends StatelessWidget {
  final String sunrise;
  final String sunset;

  const SunInfo({
    super.key,
    required this.sunrise,
    required this.sunset,
  });

  // ==================================================
  // FORMAT TIME
  // ==================================================

  String formatTime(String time) {
    try {
      final dateTime = DateTime.parse(time);

      final hour = dateTime.hour;
      final minute =
      dateTime.minute.toString().padLeft(2, '0');

      if (hour == 0) {
        return '12:$minute AM';
      }

      if (hour == 12) {
        return '12:$minute PM';
      }

      if (hour > 12) {
        return '${hour - 12}:$minute PM';
      }

      return '$hour:$minute AM';
    } catch (e) {
      return time;
    }
  }

  // ==================================================
  // BUILD
  // ==================================================

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(
        horizontal: 20,
      ),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.orange.withOpacity(0.08),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: Colors.orange.withOpacity(0.20),
        ),
      ),
      child: Column(
        children: [

          // ==================================================
          // TITLE
          // ==================================================

          const Row(
            mainAxisAlignment:
            MainAxisAlignment.center,
            children: [
              Icon(
                Icons.wb_sunny,
                color: Colors.orange,
              ),
              SizedBox(width: 8),
              Text(
                'Sunrise & Sunset',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),

          const SizedBox(
            height: 20,
          ),

          // ==================================================
          // SUNRISE + SUNSET
          // ==================================================

          Row(
            mainAxisAlignment:
            MainAxisAlignment.spaceAround,
            children: [

              // Sunrise
              Column(
                children: [
                  const Icon(
                    Icons.wb_twilight,
                    size: 38,
                    color: Colors.orange,
                  ),

                  const SizedBox(
                    height: 8,
                  ),

                  const Text(
                    'Sunrise',
                    style: TextStyle(
                      fontSize: 15,
                      color: Colors.grey,
                    ),
                  ),

                  const SizedBox(
                    height: 4,
                  ),

                  Text(
                    formatTime(sunrise),
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),

              // Divider
              Container(
                height: 65,
                width: 1,
                color: Colors.grey.withOpacity(0.3),
              ),

              // Sunset
              Column(
                children: [
                  const Icon(
                    Icons.nights_stay,
                    size: 38,
                    color: Colors.deepOrange,
                  ),

                  const SizedBox(
                    height: 8,
                  ),

                  const Text(
                    'Sunset',
                    style: TextStyle(
                      fontSize: 15,
                      color: Colors.grey,
                    ),
                  ),

                  const SizedBox(
                    height: 4,
                  ),

                  Text(
                    formatTime(sunset),
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}