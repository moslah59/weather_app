import 'dart:convert';

import 'package:http/http.dart' as http;

class LocationService {
  // ==================================================
  // GET LOCATION SUGGESTIONS
  // ==================================================

  Future<List<dynamic>> getSuggestions(
      String query,
      ) async {
    final text = query.trim();

    if (text.isEmpty) {
      return [];
    }

    final url = Uri.https(
      'photon.komoot.io',
      '/api/',
      {
        'q': text,
        'limit': '5',
        'lang': 'en',
      },
    );

    // First request
    final result = await _request(url);

    if (result != null) {
      return result['features'] ?? [];
    }

    // Retry once if first request fails
    await Future.delayed(
      const Duration(milliseconds: 700),
    );

    final retryResult = await _request(url);

    if (retryResult != null) {
      return retryResult['features'] ?? [];
    }

    return [];
  }

  // ==================================================
  // SEARCH LOCATION
  // ==================================================

  Future<Map<String, dynamic>?> searchLocation(
      String query,
      ) async {
    final text = query.trim();

    if (text.isEmpty) {
      return null;
    }

    final url = Uri.https(
      'photon.komoot.io',
      '/api/',
      {
        'q': text,
        'limit': '5',
        'lang': 'en',
      },
    );

    // First request
    var data = await _request(url);

    // Retry once if first request fails
    if (data == null) {
      await Future.delayed(
        const Duration(milliseconds: 700),
      );

      data = await _request(url);
    }

    if (data == null) {
      return null;
    }

    final features = data['features'] as List? ?? [];

    if (features.isEmpty) {
      return null;
    }

    // ==================================================
    // FIND BEST MATCH
    // ==================================================

    final searchWords = text
        .toLowerCase()
        .split(RegExp(r'\s+'))
        .where(
          (word) => word.isNotEmpty,
    )
        .toList();

    dynamic bestResult;

    for (final feature in features) {
      final properties = feature['properties'];

      final name =
          properties['name']
              ?.toString()
              .toLowerCase() ??
              '';

      final city =
          properties['city']
              ?.toString()
              .toLowerCase() ??
              '';

      final state =
          properties['state']
              ?.toString()
              .toLowerCase() ??
              '';

      final country =
          properties['country']
              ?.toString()
              .toLowerCase() ??
              '';

      final searchableText =
          '$name $city $state $country';

      final allWordsMatch =
      searchWords.every(
            (word) =>
            searchableText.contains(word),
      );

      if (allWordsMatch) {
        bestResult = feature;
        break;
      }
    }

    if (bestResult == null) {
      return null;
    }

    // ==================================================
    // GET LOCATION DATA
    // ==================================================

    final properties =
    bestResult['properties'];

    final coordinates =
    bestResult['geometry']['coordinates'];

    final longitude =
    (coordinates[0] as num).toDouble();

    final latitude =
    (coordinates[1] as num).toDouble();

    final name =
        properties['name'] ??
            properties['city'] ??
            properties['state'] ??
            text;

    return {
      'name': name.toString(),
      'latitude': latitude,
      'longitude': longitude,
    };
  }

  // ==================================================
  // HTTP REQUEST
  // ==================================================

  Future<Map<String, dynamic>?> _request(
      Uri url,
      ) async {
    try {
      final response = await http.get(
        url,
        headers: {
          'User-Agent': 'WeatherApp/1.0 (Flutter)',
          'Accept': 'application/json',
        },
      );

      print('Location URL: $url');

      print(
        'Location Status Code: ${response.statusCode}',
      );

      if (response.statusCode != 200) {
        print(
          'Location Response: ${response.body}',
        );

        return null;
      }

      return jsonDecode(response.body)
      as Map<String, dynamic>;
    } catch (e) {
      print(
        'Location Request Error: $e',
      );

      return null;
    }
  }
}