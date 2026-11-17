import 'package:bitaqwa/core/theme/app_theme.dart';
import 'package:bitaqwa/core/widgets/prayer_countdown.dart';
import 'package:bitaqwa/jadwal_sholat/lokasi_model.dart';
import 'package:bitaqwa/jadwal_sholat/waktu_sholat_model.dart';
import 'package:bitaqwa/jadwal_sholat/widgets/prayer_hero_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('kartu sholat menampilkan lima waktu dan hitung mundur', (
    tester,
  ) async {
    const times = PrayerTimeModel(
      fajr: '04:30',
      dhuhr: '12:05',
      asr: '15:20',
      maghrib: '18:10',
      isha: '19:20',
      sunrise: '05:40',
    );
    const location = LocationModel(
      latitude: -6.2,
      longitude: 106.8,
      city: 'Jakarta',
      district: 'Gambir',
    );

    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.light,
        home: const Scaffold(
          body: Center(
            child: SizedBox(
              width: 420,
              child: PrayerHeroCard(
                times: times,
                location: location,
              ),
            ),
          ),
        ),
      ),
    );
    await tester.pump();

    expect(find.text('SHOLAT BERIKUTNYA'), findsOneWidget);
    expect(find.text('Gambir, Jakarta'), findsOneWidget);
    expect(find.byType(PrayerCountdown), findsOneWidget);
    expect(find.text('04:30'), findsWidgets);
    expect(find.text('12:05'), findsWidgets);
    expect(find.text('15:20'), findsWidgets);
    expect(find.text('18:10'), findsWidgets);
    expect(find.text('19:20'), findsWidgets);

    // Lepas widget agar timer hitung mundur dibatalkan sebelum test selesai.
    await tester.pumpWidget(const SizedBox.shrink());
  });

  testWidgets('kartu sholat menampilkan state loading dengan pesan jelas', (
    tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.light,
        home: const Scaffold(
          body: PrayerHeroCard(times: null, isLoading: true),
        ),
      ),
    );
    await tester.pump();

    expect(find.text('Menyiapkan jadwal sholat…'), findsOneWidget);
    expect(find.byType(CircularProgressIndicator), findsOneWidget);

    await tester.pumpWidget(const SizedBox.shrink());
  });
}
