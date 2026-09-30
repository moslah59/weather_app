import 'package:flutter/material.dart';

class HourlyForecast extends StatelessWidget {
  final List<dynamic> times;
  final List<dynamic> temperatures;
  final List<dynamic> weatherCodes;
  final List<dynamic> precipitationProbabilities;

  const HourlyForecast({
    super.key,
    required this.times,
    required this.temperatures,
    required this.weatherCodes,
    required this.precipitationProbabilities,
  });

  // ==================================================
  // WEATHER ICON
  // ==================================================

  IconData getWeatherIcon(
      int code,
      ) {
    if (code == 0) {
      return Icons.wb_sunny;
    }

    if (code == 1 ||
        code == 2 ||
        code == 3) {
      return Icons.cloud;
    }

    if (code == 45 ||
        code == 48) {
      return Icons.foggy;
    }

    if (code >= 51 &&
        code <= 57) {
      return Icons.grain;
    }

    if (code >= 61 &&
        code <= 67) {
      return Icons.water_drop;
    }

    if (code >= 71 &&
        code <= 77) {
      return Icons.ac_unit;
    }

    if (code >= 80 &&
        code <= 82) {
      return Icons.grain;
    }

    if (code == 85 ||
        code == 86) {
      return Icons.ac_unit;
    }

    if (code >= 95 &&
        code <= 99) {
      return Icons.thunderstorm;
    }

    return Icons.cloud;
  }

  // ==================================================
  // FORMAT TIME
  // ==================================================

  String formatTime(
      String time,
      ) {
    final dateTime =
    DateTime.parse(time);

    final hour =
        dateTime.hour;

    if (hour == 0) {
      return '12 AM';
    }

    if (hour == 12) {
      return '12 PM';
    }

    if (hour > 12) {
      return '${hour - 12} PM';
    }

    return '$hour AM';
  }

  @override
  Widget build(
      BuildContext context,
      ) {
    if (times.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment:
      CrossAxisAlignment.start,
      children: [

        // ==================================================
        // TITLE
        // ==================================================

        const Padding(
          padding:
          EdgeInsets.symmetric(
            horizontal: 16,
          ),

          child: Text(
            'Hourly Forecast',

            style: TextStyle(
              fontSize: 20,
              fontWeight:
              FontWeight.bold,
            ),
          ),
        ),

        const SizedBox(
          height: 12,
        ),

        // ==================================================
        // HOURLY LIST
        // ==================================================

        SizedBox(
          height: 165,

          child: ListView.builder(
            scrollDirection:
            Axis.horizontal,

            physics:
            const BouncingScrollPhysics(),

            padding:
            const EdgeInsets.symmetric(
              horizontal: 10,
            ),

            itemCount:
            times.length,

            itemBuilder: (
                context,
                index,
                ) {
              final temperature =
              (temperatures[index]
              as num)
                  .toDouble();

              final weatherCode =
              (weatherCodes[index]
              as num)
                  .toInt();

              final rainProbability =
              (precipitationProbabilities[
              index]
              as num)
                  .toInt();

              return Container(
                width: 90,

                margin:
                const EdgeInsets.only(
                  right: 10,
                ),

                padding:
                const EdgeInsets.all(
                  12,
                ),

                decoration:
                BoxDecoration(
                  color: Colors.blue
                      .withOpacity(
                    0.08,
                  ),

                  borderRadius:
                  BorderRadius.circular(
                    15,
                  ),

                  border: Border.all(
                    color: Colors.blue
                        .withOpacity(
                      0.15,
                    ),
                  ),
                ),

                child: Column(
                  mainAxisAlignment:
                  MainAxisAlignment
                      .spaceBetween,

                  children: [

                    // ==================================
                    // TIME
                    // ==================================

                    Text(
                      formatTime(
                        times[index]
                            .toString(),
                      ),

                      style:
                      const TextStyle(
                        fontSize: 13,
                        fontWeight:
                        FontWeight.w600,
                      ),
                    ),

                    // ==================================
                    // WEATHER ICON
                    // ==================================

                    Icon(
                      getWeatherIcon(
                        weatherCode,
                      ),

                      size: 30,

                      color:
                      Colors.orange,
                    ),

                    // ==================================
                    // TEMPERATURE
                    // ==================================

                    Text(
                      '${temperature.toStringAsFixed(0)}°',

                      style:
                      const TextStyle(
                        fontSize: 18,
                        fontWeight:
                        FontWeight.bold,
                      ),
                    ),

                    // ==================================
                    // RAIN PROBABILITY
                    // ==================================

                    Text(
                      '$rainProbability% rain',

                      style:
                      const TextStyle(
                        fontSize: 11,
                        color:
                        Colors.grey,
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}