import 'package:flutter/material.dart';

class DailyForecast extends StatelessWidget {
  final List<dynamic> dates;
  final List<dynamic> maxTemperatures;
  final List<dynamic> minTemperatures;
  final List<dynamic> weatherCodes;
  final List<dynamic> precipitationProbabilities;

  const DailyForecast({
    super.key,
    required this.dates,
    required this.maxTemperatures,
    required this.minTemperatures,
    required this.weatherCodes,
    required this.precipitationProbabilities,
  });

  // ==================================================
  // WEATHER ICON
  // ==================================================

  IconData getWeatherIcon(int code) {
    if (code == 0) {
      return Icons.wb_sunny;
    }

    if (code == 1 || code == 2 || code == 3) {
      return Icons.cloud;
    }

    if (code == 45 || code == 48) {
      return Icons.foggy;
    }

    if (code >= 51 && code <= 57) {
      return Icons.grain;
    }

    if (code >= 61 && code <= 67) {
      return Icons.water_drop;
    }

    if (code >= 71 && code <= 77) {
      return Icons.ac_unit;
    }

    if (code >= 80 && code <= 82) {
      return Icons.grain;
    }

    if (code == 85 || code == 86) {
      return Icons.ac_unit;
    }

    if (code >= 95 && code <= 99) {
      return Icons.thunderstorm;
    }

    return Icons.cloud;
  }

  // ==================================================
  // DAY NAME
  // ==================================================

  String formatDay(String date) {
    final dateTime = DateTime.parse(date);

    final now = DateTime.now();

    final today = DateTime(
      now.year,
      now.month,
      now.day,
    );

    final forecastDate = DateTime(
      dateTime.year,
      dateTime.month,
      dateTime.day,
    );

    final difference =
        forecastDate.difference(today).inDays;

    if (difference == 0) {
      return 'Today';
    }

    if (difference == 1) {
      return 'Tomorrow';
    }

    const days = [
      'Mon',
      'Tue',
      'Wed',
      'Thu',
      'Fri',
      'Sat',
      'Sun',
    ];

    return days[dateTime.weekday - 1];
  }

  // ==================================================
  // DATE
  // ==================================================

  String formatDate(String date) {
    final dateTime = DateTime.parse(date);

    return '${dateTime.day}/${dateTime.month}';
  }

  // ==================================================
  // BUILD
  // ==================================================

  @override
  Widget build(BuildContext context) {
    if (dates.isEmpty) {
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
          padding: EdgeInsets.symmetric(
            horizontal: 16,
          ),
          child: Text(
            '10-Day Forecast',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),

        const SizedBox(
          height: 12,
        ),

        // ==================================================
        // HORIZONTAL LIST
        // ==================================================

        SizedBox(
          height: 190,

          child: ListView.builder(
            scrollDirection: Axis.horizontal,

            physics:
            const BouncingScrollPhysics(),

            padding:
            const EdgeInsets.symmetric(
              horizontal: 10,
            ),

            itemCount: dates.length,

            itemBuilder: (
                context,
                index,
                ) {
              final maxTemperature =
              (maxTemperatures[index]
              as num)
                  .toDouble();

              final minTemperature =
              (minTemperatures[index]
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
                width: 110,

                margin:
                const EdgeInsets.only(
                  right: 10,
                ),

                padding:
                const EdgeInsets.all(12),

                decoration: BoxDecoration(
                  color: Colors.blue
                      .withOpacity(0.08),

                  borderRadius:
                  BorderRadius.circular(
                    18,
                  ),

                  border: Border.all(
                    color: Colors.blue
                        .withOpacity(0.15),
                  ),
                ),

                child: Column(
                  mainAxisAlignment:
                  MainAxisAlignment
                      .spaceBetween,

                  children: [

                    // Day
                    Text(
                      formatDay(
                        dates[index]
                            .toString(),
                      ),

                      style:
                      const TextStyle(
                        fontSize: 14,
                        fontWeight:
                        FontWeight.bold,
                      ),
                    ),

                    // Date
                    Text(
                      formatDate(
                        dates[index]
                            .toString(),
                      ),

                      style:
                      const TextStyle(
                        fontSize: 12,
                        color:
                        Colors.grey,
                      ),
                    ),

                    // Weather icon
                    Icon(
                      getWeatherIcon(
                        weatherCode,
                      ),

                      size: 32,

                      color:
                      Colors.orange,
                    ),

                    // Temperature
                    Row(
                      mainAxisAlignment:
                      MainAxisAlignment
                          .center,

                      children: [

                        Text(
                          '${maxTemperature.toStringAsFixed(0)}°',

                          style:
                          const TextStyle(
                            fontSize: 18,
                            fontWeight:
                            FontWeight.bold,
                          ),
                        ),

                        const SizedBox(
                          width: 5,
                        ),

                        Text(
                          '${minTemperature.toStringAsFixed(0)}°',

                          style:
                          const TextStyle(
                            fontSize: 15,
                            color:
                            Colors.grey,
                          ),
                        ),
                      ],
                    ),

                    // Rain probability
                    Row(
                      mainAxisAlignment:
                      MainAxisAlignment
                          .center,

                      children: [

                        const Icon(
                          Icons.water_drop,
                          size: 14,
                          color:
                          Colors.blue,
                        ),

                        const SizedBox(
                          width: 3,
                        ),

                        Text(
                          '$rainProbability%',

                          style:
                          const TextStyle(
                            fontSize: 12,
                            color:
                            Colors.grey,
                          ),
                        ),
                      ],
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