/// Nama sholat fardhu yang ditampilkan di aplikasi.
enum PrayerName { subuh, dzuhur, ashar, maghrib, isya }

extension PrayerNameLabel on PrayerName {
  String get label {
    switch (this) {
      case PrayerName.subuh:
        return 'Subuh';
      case PrayerName.dzuhur:
        return 'Dzuhur';
      case PrayerName.ashar:
        return 'Ashar';
      case PrayerName.maghrib:
        return 'Maghrib';
      case PrayerName.isya:
        return 'Isya';
    }
  }
}

/// Model jadwal sholat harian.
class PrayerTimeModel {
  final String fajr;
  final String dhuhr;
  final String asr;
  final String maghrib;
  final String isha;
  final String sunrise;

  const PrayerTimeModel({
    required this.fajr,
    required this.dhuhr,
    required this.asr,
    required this.maghrib,
    required this.isha,
    required this.sunrise,
  });

  factory PrayerTimeModel.fromJson(Map<String, dynamic> json) {
    return PrayerTimeModel(
      fajr: _sanitize(json['Fajr']),
      dhuhr: _sanitize(json['Dhuhr']),
      asr: _sanitize(json['Asr']),
      maghrib: _sanitize(json['Maghrib']),
      isha: _sanitize(json['Isha']),
      sunrise: _sanitize(json['Sunrise']),
    );
  }

  String timeOf(PrayerName name) {
    switch (name) {
      case PrayerName.subuh:
        return fajr;
      case PrayerName.dzuhur:
        return dhuhr;
      case PrayerName.ashar:
        return asr;
      case PrayerName.maghrib:
        return maghrib;
      case PrayerName.isya:
        return isha;
    }
  }

  /// API terkadang mengirim "04:30 (WIB)". Ambil bagian jam:menit saja.
  static String _sanitize(dynamic value) {
    if (value == null) return '--:--';
    final raw = value.toString().trim();
    final match = RegExp(r'(\d{1,2}):(\d{2})').firstMatch(raw);
    if (match == null) return '--:--';
    final hour = int.tryParse(match.group(1) ?? '');
    final minute = int.tryParse(match.group(2) ?? '');
    if (hour == null || minute == null) return '--:--';
    return '${hour.toString().padLeft(2, '0')}:'
        '${minute.toString().padLeft(2, '0')}';
  }
}
