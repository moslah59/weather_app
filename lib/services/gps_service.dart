import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';

class GpsService {
  Future<Position> getCurrentLocation() async {
    bool serviceEnabled =
    await Geolocator.isLocationServiceEnabled();

    if (!serviceEnabled) {
      throw Exception(
        'Location service is disabled.',
      );
    }

    LocationPermission permission =
    await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      permission =
      await Geolocator.requestPermission();
    }

    if (permission == LocationPermission.denied) {
      throw Exception(
        'Location permission denied.',
      );
    }

    if (permission ==
        LocationPermission.deniedForever) {
      throw Exception(
        'Location permission permanently denied.',
      );
    }

    return await Geolocator.getCurrentPosition(
      locationSettings:
      const LocationSettings(
        accuracy: LocationAccuracy.high,
      ),
    );
  }

  Future<String> getLocationName(
      double latitude,
      double longitude,
      ) async {
    try {
      final Geocoding geocoding = Geocoding();

      final placemarks =
      await geocoding.placemarkFromCoordinates(
        latitude,
        longitude,
      );

      if (placemarks.isEmpty) {
        return 'My Location';
      }

      final place = placemarks.first;

      if (place.locality != null &&
          place.locality!.trim().isNotEmpty) {
        return place.locality!;
      }

      if (place.subAdministrativeArea != null &&
          place.subAdministrativeArea!.trim().isNotEmpty) {
        return place.subAdministrativeArea!;
      }

      if (place.administrativeArea != null &&
          place.administrativeArea!.trim().isNotEmpty) {
        return place.administrativeArea!;
      }

      if (place.subLocality != null &&
          place.subLocality!.trim().isNotEmpty) {
        return place.subLocality!;
      }

      if (place.name != null &&
          place.name!.trim().isNotEmpty) {
        return place.name!;
      }

      return 'My Location';
    } catch (e) {
      print('Reverse Geocoding Error: $e');
      return 'My Location';
    }
  }
}