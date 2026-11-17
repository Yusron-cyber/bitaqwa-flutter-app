import 'dart:async';
import 'dart:convert';

import 'package:bitaqwa/jadwal_sholat/waktu_sholat_model.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

/// Menghubungi API Aladhan untuk mengambil jadwal sholat.
///
/// Logika perhitungan tetap memakai method=20 (Kemenag RI) seperti sebelumnya.
class PrayerService {
  Future<PrayerTimeModel?> getPrayerTimes({
    required double latitude,
    required double longitude,
  }) async {
    try {
      final url = Uri.https('api.aladhan.com', '/v1/timings', {
        'latitude': latitude.toString(),
        'longitude': longitude.toString(),
        'method': '20',
      });

      final response = await http
          .get(url)
          .timeout(const Duration(seconds: 12));

      if (response.statusCode != 200) {
        debugPrint('PrayerService: HTTP ${response.statusCode}');
        return null;
      }

      final decoded = jsonDecode(response.body);
      if (decoded is! Map<String, dynamic>) return null;

      final data = decoded['data'];
      if (data is! Map<String, dynamic>) return null;

      final timings = data['timings'];
      if (timings is! Map<String, dynamic>) return null;

      return PrayerTimeModel.fromJson(timings);
    } catch (error) {
      debugPrint('PrayerService: $error');
      return null;
    }
  }
}
