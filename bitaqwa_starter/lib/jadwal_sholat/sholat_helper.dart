import 'package:bitaqwa/jadwal_sholat/waktu_sholat_model.dart';

/// Satu waktu sholat lengkap dengan tanggal & jam sebenarnya.
class PrayerMoment {
  const PrayerMoment({
    required this.name,
    required this.time,
    required this.dateTime,
  });

  final PrayerName name;
  final String time;
  final DateTime dateTime;

  String get label => name.label;
}

/// Alat bantu menghitung sholat berikutnya tanpa mengubah logika perhitungan
/// waktu sholat dari API.
class PrayerHelper {
  static final RegExp _timePattern = RegExp(r'^(\d{1,2}):(\d{2})$');

  static DateTime? _dateTimeFor(String time, DateTime day) {
    final match = _timePattern.firstMatch(time.trim());
    if (match == null) return null;
    final hour = int.tryParse(match.group(1) ?? '');
    final minute = int.tryParse(match.group(2) ?? '');
    if (hour == null || minute == null) return null;
    if (hour < 0 || hour > 23 || minute < 0 || minute > 59) return null;
    return DateTime(day.year, day.month, day.day, hour, minute);
  }

  /// Lima waktu sholat pada hari ini (hanya jam yang valid).
  static List<PrayerMoment> todaySchedule(
    PrayerTimeModel prayer, {
    DateTime? now,
  }) {
    final day = now ?? DateTime.now();
    final moments = <PrayerMoment>[];
    for (final name in PrayerName.values) {
      final time = prayer.timeOf(name);
      final dateTime = _dateTimeFor(time, day);
      if (dateTime != null) {
        moments.add(PrayerMoment(name: name, time: time, dateTime: dateTime));
      }
    }
    return moments;
  }

  /// Sholat berikutnya. Setelah Isya, hasilnya adalah Subuh besok.
  static PrayerMoment? nextPrayer(
    PrayerTimeModel prayer, {
    DateTime? now,
  }) {
    final current = now ?? DateTime.now();
    final today = todaySchedule(prayer, now: current);

    for (final moment in today) {
      if (moment.dateTime.isAfter(current)) return moment;
    }

    final tomorrow = current.add(const Duration(days: 1));
    final fajrTime = _dateTimeFor(prayer.fajr, tomorrow);
    if (fajrTime == null) return null;
    return PrayerMoment(
      name: PrayerName.subuh,
      time: prayer.fajr,
      dateTime: fajrTime,
    );
  }

  /// Versi Map dipertahankan untuk kompatibilitas kode lama.
  static Map<String, String> getNextPrayer(PrayerTimeModel prayer) {
    final next = nextPrayer(prayer);
    if (next == null) return {'name': 'Subuh', 'time': prayer.fajr};
    return {'name': next.label, 'time': next.time};
  }

  static bool isNext(
    PrayerName name,
    PrayerTimeModel prayer, {
    DateTime? now,
  }) {
    return nextPrayer(prayer, now: now)?.name == name;
  }
}
