import 'dart:async';

import 'package:flutter/material.dart';

import '../services/location_service.dart';
import '../services/weather_service.dart';
import '../services/gps_service.dart';

import '../widgets/search_box.dart';
import '../widgets/suggestion_list.dart';
import '../widgets/weather_card.dart';
import '../widgets/hourly_forecast.dart';
import '../widgets/daily_forecast.dart';
import '../widgets/sun_info.dart';

class WeatherHomePage extends StatefulWidget {
  const WeatherHomePage({super.key});

  @override
  State<WeatherHomePage> createState() =>
      _WeatherHomePageState();
}

class _WeatherHomePageState
    extends State<WeatherHomePage> {
  // ==================================================
  // SERVICES
  // ==================================================

  final WeatherService weatherService =
  WeatherService();

  final LocationService locationService =
  LocationService();

  final GpsService gpsService =
  GpsService();

  // ==================================================
  // CURRENT WEATHER
  // ==================================================

  double? temperature;
  double? humidity;
  double? windSpeed;

  int? weatherCode;
  int? isDay;

  // ==================================================
  // HOURLY FORECAST
  // ==================================================

  List<dynamic> hourlyTimes = [];
  List<dynamic> hourlyTemperatures = [];
  List<dynamic> hourlyWeatherCodes = [];
  List<dynamic> hourlyRainProbabilities = [];

  // ==================================================
  // DAILY FORECAST
  // ==================================================

  List<dynamic> dailyDates = [];
  List<dynamic> dailyMaxTemperatures = [];
  List<dynamic> dailyMinTemperatures = [];
  List<dynamic> dailyWeatherCodes = [];
  List<dynamic> dailyRainProbabilities = [];

  // ==================================================
  // SUNRISE & SUNSET
  // ==================================================

  String? sunrise;
  String? sunset;

  // ==================================================
  // CURRENT LOCATION
  // ==================================================

  String cityName = 'Dhaka';

  // Default Dhaka coordinates
  double currentLatitude = 23.8103;
  double currentLongitude = 90.4125;

  // ==================================================
  // LOADING & ERROR
  // ==================================================

  bool isLoading = false;
  String? errorMessage;

  // ==================================================
  // SEARCH
  // ==================================================

  final TextEditingController cityController =
  TextEditingController();

  List<dynamic> suggestions = [];

  Timer? _debounce;

  // ==================================================
  // REQUEST CONTROL
  // ==================================================

  // Prevent old suggestion responses
  int _suggestionRequestId = 0;

  // Prevent old weather responses
  int _weatherRequestId = 0;

  // ==================================================
  // GET CURRENT LOCATION
  // ==================================================

  Future<void> getCurrentLocation() async {
    setState(() {
      isLoading = true;
      errorMessage = null;
    });

    try {
      final position =
      await gpsService.getCurrentLocation();

      currentLatitude = position.latitude;
      currentLongitude = position.longitude;

      final locationName =
      await gpsService.getLocationName(
        position.latitude,
        position.longitude,
      );

      setState(() {
        cityName = locationName;
        cityController.text = locationName;
      });

      await getWeather(
        currentLatitude,
        currentLongitude,
      );
    } catch (e) {
      setState(() {
        errorMessage = e.toString();
      });
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  // ==================================================
  // GET WEATHER
  // ==================================================

  Future<void> getWeather(
      double latitude,
      double longitude, {
        bool showLoading = true,
      }) async {
    final requestId =
    ++_weatherRequestId;

    if (showLoading && mounted) {
      setState(() {
        isLoading = true;
        errorMessage = null;
      });
    }

    try {
      final data =
      await weatherService.getWeather(
        latitude,
        longitude,
      );

      if (!mounted ||
          requestId != _weatherRequestId) {
        return;
      }

      // ==================================================
      // CURRENT WEATHER
      // ==================================================

      final current =
      data['current'];

      // ==================================================
      // HOURLY WEATHER
      // ==================================================

      final hourly =
      data['hourly'];

      final allTimes =
      List<dynamic>.from(
        hourly['time'] ?? [],
      );

      final allTemperatures =
      List<dynamic>.from(
        hourly['temperature_2m'] ?? [],
      );

      final allWeatherCodes =
      List<dynamic>.from(
        hourly['weather_code'] ?? [],
      );

      final allRainProbabilities =
      List<dynamic>.from(
        hourly[
        'precipitation_probability'
        ] ??
            [],
      );

      // ==================================================
      // DAILY WEATHER
      // ==================================================

      final daily =
      data['daily'];

      final allDailyDates =
      List<dynamic>.from(
        daily['time'] ?? [],
      );

      final allDailyMaxTemperatures =
      List<dynamic>.from(
        daily['temperature_2m_max'] ?? [],
      );

      final allDailyMinTemperatures =
      List<dynamic>.from(
        daily['temperature_2m_min'] ?? [],
      );

      final allDailyWeatherCodes =
      List<dynamic>.from(
        daily['weather_code'] ?? [],
      );

      final allDailyRainProbabilities =
      List<dynamic>.from(
        daily[
        'precipitation_probability_max'
        ] ??
            [],
      );

      // ==================================================
      // SUNRISE & SUNSET
      // ==================================================

      final allSunrises =
      List<dynamic>.from(
        daily['sunrise'] ?? [],
      );

      final allSunsets =
      List<dynamic>.from(
        daily['sunset'] ?? [],
      );

      // ==================================================
      // FIND CURRENT HOUR
      // ==================================================

      final currentTime =
      current['time'].toString();

      int currentIndex =
      allTimes.indexOf(
        currentTime,
      );

      if (currentIndex == -1) {
        currentIndex =
            allTimes.indexWhere(
                  (time) =>
              time
                  .toString()
                  .compareTo(
                currentTime,
              ) >=
                  0,
            );

        if (currentIndex == -1) {
          currentIndex = 0;
        }
      }

      // ==================================================
      // KEEP HOURLY ARRAY LENGTHS ALIGNED
      // ==================================================

      final availableLength = [
        allTimes.length,
        allTemperatures.length,
        allWeatherCodes.length,
        allRainProbabilities.length,
      ].reduce(
            (a, b) => a < b ? a : b,
      );

      if (availableLength == 0) {
        throw Exception(
          'Hourly forecast is empty',
        );
      }

      if (currentIndex >=
          availableLength) {
        currentIndex =
            availableLength - 1;
      }

      // ==================================================
      // NEXT 24 HOURS
      // ==================================================

      final endIndex =
      (currentIndex + 24).clamp(
        0,
        availableLength,
      );

      // ==================================================
      // KEEP DAILY ARRAY LENGTHS ALIGNED
      // ==================================================

      final dailyAvailableLength = [
        allDailyDates.length,
        allDailyMaxTemperatures.length,
        allDailyMinTemperatures.length,
        allDailyWeatherCodes.length,
        allDailyRainProbabilities.length,
      ].reduce(
            (a, b) => a < b ? a : b,
      );

      if (dailyAvailableLength == 0) {
        throw Exception(
          'Daily forecast is empty',
        );
      }

      // ==================================================
      // UPDATE UI
      // ==================================================

      setState(() {
        // ------------------------------------------------
        // CURRENT WEATHER
        // ------------------------------------------------

        temperature =
            (current[
            'temperature_2m']
            as num?)
                ?.toDouble();

        humidity =
            (current[
            'relative_humidity_2m']
            as num?)
                ?.toDouble();

        windSpeed =
            (current[
            'wind_speed_10m']
            as num?)
                ?.toDouble();

        weatherCode =
            (current[
            'weather_code']
            as num?)
                ?.toInt();

        isDay =
            (current['is_day']
            as num?)
                ?.toInt();

        // ------------------------------------------------
        // HOURLY FORECAST
        // ------------------------------------------------

        hourlyTimes =
            allTimes.sublist(
              currentIndex,
              endIndex,
            );

        hourlyTemperatures =
            allTemperatures.sublist(
              currentIndex,
              endIndex,
            );

        hourlyWeatherCodes =
            allWeatherCodes.sublist(
              currentIndex,
              endIndex,
            );

        hourlyRainProbabilities =
            allRainProbabilities.sublist(
              currentIndex,
              endIndex,
            );

        // ------------------------------------------------
        // DAILY FORECAST
        // ------------------------------------------------

        dailyDates =
            allDailyDates.sublist(
              0,
              dailyAvailableLength,
            );

        dailyMaxTemperatures =
            allDailyMaxTemperatures.sublist(
              0,
              dailyAvailableLength,
            );

        dailyMinTemperatures =
            allDailyMinTemperatures.sublist(
              0,
              dailyAvailableLength,
            );

        dailyWeatherCodes =
            allDailyWeatherCodes.sublist(
              0,
              dailyAvailableLength,
            );

        dailyRainProbabilities =
            allDailyRainProbabilities.sublist(
              0,
              dailyAvailableLength,
            );

        // ------------------------------------------------
        // SUNRISE
        // ------------------------------------------------

        sunrise =
        allSunrises.isNotEmpty
            ? allSunrises.first.toString()
            : null;

        // ------------------------------------------------
        // SUNSET
        // ------------------------------------------------

        sunset =
        allSunsets.isNotEmpty
            ? allSunsets.first.toString()
            : null;

        // ------------------------------------------------
        // LOADING / ERROR
        // ------------------------------------------------

        isLoading = false;
        errorMessage = null;
      });

      debugPrint(
        'Weather updated for $cityName',
      );
    } catch (e) {
      if (!mounted ||
          requestId != _weatherRequestId) {
        return;
      }

      setState(() {
        isLoading = false;
        errorMessage =
        'Unable to load weather data';
      });

      debugPrint(
        'Weather Error: $e',
      );
    }
  }

  // ==================================================
  // PULL TO REFRESH
  // ==================================================

  Future<void> refreshWeather() async {
    await getWeather(
      currentLatitude,
      currentLongitude,
      showLoading: false,
    );
  }

  // ==================================================
  // GET SEARCH SUGGESTIONS
  // ==================================================

  Future<void> getSuggestions(
      String query,
      ) async {
    final text =
    query.trim();

    if (text.isEmpty) {
      if (!mounted) return;

      setState(() {
        suggestions = [];
      });

      return;
    }

    final requestId =
    ++_suggestionRequestId;

    final result =
    await locationService
        .getSuggestions(
      text,
    );

    if (!mounted ||
        requestId !=
            _suggestionRequestId) {
      return;
    }

    // User changed the text
    if (cityController.text
        .trim() !=
        text) {
      return;
    }

    setState(() {
      suggestions = result;
    });
  }

  // ==================================================
  // HANDLE SEARCH TEXT
  // ==================================================

  void onSearchTextChanged(
      String value,
      ) {
    _debounce?.cancel();

    // Invalidate old requests
    _suggestionRequestId++;

    if (!mounted) return;

    setState(() {
      suggestions = [];
    });

    if (value.trim().isEmpty) {
      return;
    }

    _debounce = Timer(
      const Duration(
        milliseconds: 500,
      ),
          () {
        getSuggestions(value);
      },
    );
  }

  // ==================================================
  // SEARCH LOCATION
  // ==================================================

  Future<void> searchLocation(
      String query,
      ) async {
    final text =
    query.trim();

    if (text.isEmpty) {
      return;
    }

    _debounce?.cancel();

    // Cancel old suggestion requests
    _suggestionRequestId++;

    if (!mounted) return;

    setState(() {
      isLoading = true;
      errorMessage = null;
      suggestions = [];
    });

    try {
      final result =
      await locationService
          .searchLocation(
        text,
      );

      if (!mounted) return;

      if (result == null) {
        setState(() {
          isLoading = false;
          errorMessage =
          'Location not found';
          suggestions = [];
        });

        return;
      }

      final name =
      result['name'].toString();

      final latitude =
      (result['latitude']
      as num)
          .toDouble();

      final longitude =
      (result['longitude']
      as num)
          .toDouble();

      setState(() {
        cityName = name;

        cityController.text =
            name;

        // Save selected location
        currentLatitude =
            latitude;

        currentLongitude =
            longitude;

        suggestions = [];
      });

      await getWeather(
        latitude,
        longitude,
      );

      if (!mounted) return;

      setState(() {
        suggestions = [];
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        isLoading = false;
        errorMessage =
        'Location search failed';
        suggestions = [];
      });

      debugPrint(
        'Search Error: $e',
      );
    }
  }

  // ==================================================
  // SELECT SUGGESTION
  // ==================================================

  void selectSuggestion(
      double latitude,
      double longitude,
      String name,
      ) {
    _debounce?.cancel();

    // Cancel old suggestions
    _suggestionRequestId++;

    setState(() {
      cityName = name;

      cityController.text =
          name;

      currentLatitude =
          latitude;

      currentLongitude =
          longitude;

      suggestions = [];
    });

    getWeather(
      latitude,
      longitude,
    );
  }

  // ==================================================
  // INITIAL LOAD
  // ==================================================

  @override
  void initState() {
    super.initState();

    // Initial search box text
    cityController.text =
    'Dhaka';

    // Initial weather
    getWeather(
      currentLatitude,
      currentLongitude,
    );
  }

  // ==================================================
  // DISPOSE
  // ==================================================

  @override
  void dispose() {
    _debounce?.cancel();

    cityController.dispose();

    super.dispose();
  }

  // ==================================================
  // BUILD
  // ==================================================

  @override
  Widget build(
      BuildContext context,
      ) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFFEAF6FF),
        title:
        Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.blue.withOpacity(0.10),
                borderRadius: BorderRadius.circular(14),
              ),
              child: const Icon(
                Icons.wb_sunny_rounded,
                size: 32,
                color: Colors.orange,
              ),
            ),

            const SizedBox(width: 12),

            const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Weather App',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    letterSpacing: -0.5,
                  ),
                ),

                SizedBox(height: 2),

                Text(
                  'Your weather, anytime',
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          ],
        ),
        centerTitle: false,
      ),

      body: Column(
        children: [

          // ==================================================
          // SEARCH SECTION
          // ==================================================

          Padding(
            padding:
            const EdgeInsets.all(
              16,
            ),

            child: Column(
              children: [

                // SEARCH BOX
                SearchBox(
                  controller:
                  cityController,

                  onChanged:
                  onSearchTextChanged,

                  onSubmitted:
                  searchLocation,

                  onSearch: () {
                    searchLocation(
                      cityController
                          .text,
                    );
                  },
                ),

                // SUGGESTIONS
                SuggestionList(
                  suggestions:
                  suggestions,

                  onSelected: (
                      latitude,
                      longitude,
                      name,
                      ) {
                    selectSuggestion(
                      latitude,
                      longitude,
                      name,
                    );
                  },
                ),

                const SizedBox(
                  height: 10,
                ),

                // ==================================================
                // CURRENT LOCATION BUTTON
                // ==================================================

                SizedBox(
                  width:
                  double.infinity,

                  child:
                  OutlinedButton.icon(
                    onPressed:
                    isLoading
                        ? null
                        : getCurrentLocation,

                    icon:
                    const Icon(
                      Icons.my_location,
                    ),

                    label:
                    const Text(
                      'Use My Location',
                    ),
                  ),
                ),
              ],
            ),
          ),

          // ==================================================
          // WEATHER SECTION
          // ==================================================

          Expanded(
            child:
            RefreshIndicator(
              onRefresh:
              refreshWeather,

              child:
              SingleChildScrollView(
                physics:
                const AlwaysScrollableScrollPhysics(),

                child:
                Column(
                  children: [

                    // ==================================================
                    // CURRENT WEATHER
                    // ==================================================

                    Center(
                      child: isLoading
                          ? const Padding(
                        padding:
                        EdgeInsets.all(
                          40,
                        ),

                        child:
                        CircularProgressIndicator(),
                      )
                          : errorMessage !=
                          null
                          ? Padding(
                        padding:
                        const EdgeInsets.all(
                          24,
                        ),

                        child:
                        Column(
                          children: [

                            const Icon(
                              Icons
                                  .error_outline,
                              size: 60,
                              color:
                              Colors.red,
                            ),

                            const SizedBox(
                              height:
                              10,
                            ),

                            Text(
                              errorMessage!,
                              textAlign:
                              TextAlign.center,
                              style:
                              const TextStyle(
                                fontSize:
                                18,
                                color:
                                Colors.red,
                              ),
                            ),
                          ],
                        ),
                      )
                          : WeatherCard(
                        cityName:
                        cityName,

                        temperature:
                        temperature,

                        humidity:
                        humidity,

                        windSpeed:
                        windSpeed,

                        weatherCode:
                        weatherCode,

                        isDay:
                        isDay,
                      ),
                    ),

                    const SizedBox(
                      height: 10,
                    ),

                    // ==================================================
                    // HOURLY FORECAST
                    // ==================================================

                    if (!isLoading &&
                        errorMessage ==
                            null &&
                        hourlyTimes
                            .isNotEmpty)
                      HourlyForecast(
                        times:
                        hourlyTimes,

                        temperatures:
                        hourlyTemperatures,

                        weatherCodes:
                        hourlyWeatherCodes,

                        precipitationProbabilities:
                        hourlyRainProbabilities,
                      ),

                    const SizedBox(
                      height: 25,
                    ),

                    // ==================================================
                    // SUNRISE & SUNSET
                    // ==================================================

                    if (!isLoading &&
                        errorMessage ==
                            null &&
                        sunrise != null &&
                        sunset != null)
                      SunInfo(
                        sunrise:
                        sunrise!,
                        sunset:
                        sunset!,
                      ),

                    const SizedBox(
                      height: 25,
                    ),

                    // ==================================================
                    // 10-DAY FORECAST
                    // ==================================================

                    if (!isLoading &&
                        errorMessage ==
                            null &&
                        dailyDates
                            .isNotEmpty)
                      DailyForecast(
                        dates:
                        dailyDates,

                        maxTemperatures:
                        dailyMaxTemperatures,

                        minTemperatures:
                        dailyMinTemperatures,

                        weatherCodes:
                        dailyWeatherCodes,

                        precipitationProbabilities:
                        dailyRainProbabilities,
                      ),

                    const SizedBox(
                      height: 25,
                    ),
                  ],
                ),
              ),
            ),
          ),

          // ==================================================
          // ATTRIBUTION
          // ==================================================

          const Padding(
            padding:
            EdgeInsets.only(
              bottom: 10,
            ),

            child: Text(
              'Location data © OpenStreetMap contributors',

              style: TextStyle(
                fontSize: 11,
                color: Colors.grey,
              ),
            ),
          ),
        ],
      ),
    );
  }
}