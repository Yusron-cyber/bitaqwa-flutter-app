import 'dart:async';
import 'dart:convert';

import 'package:bitaqwa/jadwal_sholat/lokasi_model.dart';
import 'package:flutter/foundation.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;

enum LocationErrorKind {
  serviceDisabled,
  permissionDenied,
  permissionDeniedForever,
  timeout,
  unknown,
}

class LocationException implements Exception {
  const LocationException(this.kind, this.message);

  final LocationErrorKind kind;
  final String message;

  @override
  String toString() => message;
}

/// Mengambil koordinat GPS dan nama kota pengguna.
class LocationService {
  Future<LocationModel> getCurrentLocation() async {
    final serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      throw const LocationException(
        LocationErrorKind.serviceDisabled,
        'GPS belum aktif. Nyalakan layanan lokasi agar jadwal sholat dapat '
        'disesuaikan dengan tempat Anda.',
      );
    }

    var permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }

    if (permission == LocationPermission.denied) {
      throw const LocationException(
        LocationErrorKind.permissionDenied,
        'Izin lokasi ditolak. Bitaqwa memerlukan lokasi untuk menghitung '
        'jadwal sholat sesuai wilayah Anda.',
      );
    }

    if (permission == LocationPermission.deniedForever) {
      throw const LocationException(
        LocationErrorKind.permissionDeniedForever,
        'Izin lokasi diblokir permanen. Aktifkan izin lokasi melalui '
        'pengaturan aplikasi.',
      );
    }

    Position? position;
    try {
      position = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.medium,
          timeLimit: Duration(seconds: 15),
        ),
      );
    } on TimeoutException {
      position = await Geolocator.getLastKnownPosition();
      if (position == null) {
        throw const LocationException(
          LocationErrorKind.timeout,
          'Lokasi belum ditemukan. Pastikan GPS aktif dan berada di area '
          'terbuka, lalu coba lagi.',
        );
      }
    } on PermissionDeniedException {
      throw const LocationException(
        LocationErrorKind.permissionDenied,
        'Izin lokasi ditolak. Aktifkan izin lokasi untuk melanjutkan.',
      );
    } on LocationServiceDisabledException {
      throw const LocationException(
        LocationErrorKind.serviceDisabled,
        'GPS belum aktif. Nyalakan layanan lokasi lalu coba lagi.',
      );
    }

    final names = await _getLocationName(
      position.latitude,
      position.longitude,
    );

    return LocationModel(
      latitude: position.latitude,
      longitude: position.longitude,
      city: names['city'] ?? 'Lokasi Anda',
      district: names['district'] ?? '',
    );
  }

  Future<Map<String, String>> _getLocationName(
    double latitude,
    double longitude,
  ) async {
    try {
      final url = Uri.parse(
        'https://nominatim.openstreetmap.org/reverse'
        '?format=jsonv2&lat=$latitude&lon=$longitude',
      );
      final response = await http
          .get(url, headers: {'User-Agent': 'Bitaqwa/1.0'})
          .timeout(const Duration(seconds: 8));

      if (response.statusCode != 200) {
        return {'city': 'Lokasi Anda', 'district': ''};
      }

      final json = jsonDecode(response.body) as Map<String, dynamic>;
      final address = (json['address'] as Map<String, dynamic>?) ?? {};

      final city =
          address['city'] ??
          address['municipality'] ??
          address['town'] ??
          address['county'] ??
          address['state'] ??
          'Lokasi Anda';

      final district =
          address['suburb'] ??
          address['village'] ??
          address['hamlet'] ??
          address['city_district'] ??
          '';

      return {'city': city.toString(), 'district': district.toString()};
    } catch (error) {
      debugPrint('LocationService reverse geocoding: $error');
      return {'city': 'Lokasi Anda', 'district': ''};
    }
  }

  Future<bool> openAppSettings() => Geolocator.openAppSettings();

  Future<bool> openLocationSettings() => Geolocator.openLocationSettings();
}
