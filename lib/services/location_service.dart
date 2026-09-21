import 'dart:convert';

import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';

/// Result returned by `LocationService.detectCity()`.
class DetectedLocation {
  final double latitude;
  final double longitude;
  final String city;         // e.g. "Dar es Salaam"
  final String region;       // e.g. "Dar es Salaam"
  final String country;      // e.g. "Tanzania"
  final String displayName;  // e.g. "Dar es Salaam, Tanzania"

  const DetectedLocation({
    required this.latitude,
    required this.longitude,
    required this.city,
    required this.region,
    required this.country,
    required this.displayName,
  });
}

class LocationService {
  LocationService._();
  static final LocationService instance = LocationService._();

  /// Ask permission, get GPS, reverse-geocode to city.
  /// Returns null if permission denied or lookup failed.
  Future<DetectedLocation?> detectCity() async {
    try {
      // 1. Is location service enabled?
      final serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        debugPrint('📍 Location service disabled');
        return null;
      }

      // 2. Check + request permission
      var permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }
      if (permission == LocationPermission.denied ||
          permission == LocationPermission.deniedForever) {
        debugPrint('📍 Permission denied: $permission');
        return null;
      }

      // 3. Get position (medium accuracy is fine for city-level)
      final pos = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.medium,
        timeLimit: const Duration(seconds: 15),
      );
      debugPrint('📍 GPS: ${pos.latitude}, ${pos.longitude}');

      // 4. Reverse geocode via OpenStreetMap Nominatim (free, no key)
      final uri = Uri.parse(
        'https://nominatim.openstreetmap.org/reverse'
        '?format=json'
        '&lat=${pos.latitude}'
        '&lon=${pos.longitude}'
        '&zoom=10'
        '&addressdetails=1',
      );
      final res = await http.get(uri, headers: {
        'User-Agent': 'ZanNext/1.0 (contact: support@zannext.app)',
        'Accept': 'application/json',
      });

      if (res.statusCode != 200) {
        debugPrint('📍 Nominatim HTTP ${res.statusCode}');
        return null;
      }

      final json = jsonDecode(res.body) as Map<String, dynamic>;
      final addr = (json['address'] as Map<String, dynamic>?) ?? const {};

      final city = (addr['city'] ??
              addr['town'] ??
              addr['village'] ??
              addr['municipality'] ??
              addr['county'] ??
              'Unknown')
          .toString();
      final region =
          (addr['state'] ?? addr['region'] ?? addr['county'] ?? '').toString();
      final country = (addr['country'] ?? '').toString();

      final parts = [city, region, country]
          .where((s) => s.isNotEmpty)
          .toSet()
          .toList();
      final displayName = parts.join(', ');

      debugPrint('📍 Resolved: $displayName');

      return DetectedLocation(
        latitude: pos.latitude,
        longitude: pos.longitude,
        city: city,
        region: region,
        country: country,
        displayName: displayName,
      );
    } catch (e) {
      debugPrint('📍 LocationService error: $e');
      return null;
    }
  }
}
