import 'package:bitaqwa/jadwal_sholat/sholat_helper.dart';
import 'package:bitaqwa/jadwal_sholat/waktu_sholat_model.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const times = PrayerTimeModel(
    fajr: '04:30',
    dhuhr: '12:00',
    asr: '15:15',
    maghrib: '18:00',
    isha: '19:15',
    sunrise: '05:45',
  );

  group('PrayerHelper', () {
    test('memilih sholat berikutnya pada hari yang sama', () {
      final next = PrayerHelper.nextPrayer(
        times,
        now: DateTime(2026, 11, 17, 11, 30),
      );

      expect(next, isNotNull);
      expect(next!.name, PrayerName.dzuhur);
      expect(next.time, '12:00');
      expect(next.dateTime, DateTime(2026, 11, 17, 12, 0));
    });

    test('setelah isya memilih subuh besok', () {
      final next = PrayerHelper.nextPrayer(
        times,
        now: DateTime(2026, 11, 17, 20, 0),
      );

      expect(next, isNotNull);
      expect(next!.name, PrayerName.subuh);
      expect(next.time, '04:30');
      expect(next.dateTime, DateTime(2026, 11, 18, 4, 30));
    });

    test('lima waktu sholat valid terbaca', () {
      final schedule = PrayerHelper.todaySchedule(
        times,
        now: DateTime(2026, 11, 17, 8, 0),
      );

      expect(schedule.length, 5);
      expect(
        schedule.map((moment) => moment.name).toList(),
        PrayerName.values,
      );
    });

    test('jam tidak valid dilewati', () {
      const broken = PrayerTimeModel(
        fajr: '--:--',
        dhuhr: '12:00',
        asr: '99:99',
        maghrib: '18:00',
        isha: '19:15',
        sunrise: '05:45',
      );

      final schedule = PrayerHelper.todaySchedule(broken);
      expect(schedule.map((moment) => moment.name), [
        PrayerName.dzuhur,
        PrayerName.maghrib,
        PrayerName.isya,
      ]);
    });
  });

  group('PrayerTimeModel', () {
    test('membersihkan suffix zona waktu dari API', () {
      final model = PrayerTimeModel.fromJson(const {
        'Fajr': '04:30 (WIB)',
        'Dhuhr': '12:05',
        'Asr': '15:15',
        'Maghrib': '18:00',
        'Isha': '19:15',
        'Sunrise': '05:45',
      });

      expect(model.fajr, '04:30');
      expect(model.dayTime(PrayerName.dzuhur), '12:05');
    });

    test('nilai kosong menjadi placeholder aman', () {
      final model = PrayerTimeModel.fromJson(const {});
      expect(model.fajr, '--:--');
      expect(model.isha, '--:--');
    });
  });
}

extension on PrayerTimeModel {
  String dayTime(PrayerName name) => timeOf(name);
}
