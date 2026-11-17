import 'package:bitaqwa/data/bookmark_store.dart';
import 'package:bitaqwa/doa_harian/doa_data.dart';
import 'package:bitaqwa/doa_harian/doa_screen.dart';
import 'package:bitaqwa/doa_harian/widgets/doa_tile.dart';
import 'package:bitaqwa/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() async {
    SharedPreferences.setMockInitialValues(<String, Object>{});
    await BookmarkStore.instance.load();
  });

  testWidgets('navigasi lima tab utama berjalan tanpa layar kosong', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(900, 2000);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(const BitaqwaApp());
    // Beri waktu untuk post-frame callback dan animasi awal.
    await tester.pump(const Duration(milliseconds: 50));
    await tester.pump(const Duration(milliseconds: 700));

    expect(find.text('Sahabat Bitaqwa'), findsOneWidget);
    expect(find.text('Akses Cepat'), findsOneWidget);

    await tester.tap(find.text('Sholat').first);
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 900));
    expect(find.text('Jadwal Sholat'), findsWidgets);
    expect(find.text('Waktu Sholat Hari Ini'), findsOneWidget);

    await tester.tap(find.text('Doa').first);
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 900));
    expect(find.text('Doa Harian'), findsOneWidget);

    await tester.tap(find.text('Kajian').first);
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 900));
    expect(find.text('Kajian Online'), findsOneWidget);

    await tester.tap(find.text('Zakat').first);
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 900));
    expect(find.text('Zakat Mal'), findsOneWidget);
  });

  testWidgets('detail doa dapat dibuka dan disimpan sebagai favorit', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(900, 2000);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(const BitaqwaApp());
    await tester.pump(const Duration(milliseconds: 50));
    await tester.pump(const Duration(milliseconds: 700));

    await tester.tap(find.text('Doa').first);
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 900));

    final searchField = find
        .descendant(of: find.byType(DoaScreen), matching: find.byType(TextField))
        .first;
    await tester.enterText(searchField, 'makan');
    await tester.pump();
    expect(find.text('Hasil Pencarian'), findsOneWidget);
    expect(find.text('Doa Sebelum Makan'), findsWidgets);

    await tester.tap(find.byTooltip('Hapus pencarian'));
    await tester.pump();
    expect(find.text('Hasil Pencarian'), findsNothing);

    final firstEntry = allDoaEntries.first;
    final tile = find
        .descendant(
          of: find.byType(DoaScreen),
          matching: find.byType(DoaTile),
        )
        .first;
    await tester.ensureVisible(tile);
    await tester.pump();
    await tester.tap(tile);
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 500));

    expect(find.text(firstEntry.doa.title), findsWidgets);
    expect(find.text('TEKS ARAB'), findsOneWidget);
    expect(find.text('LATIN'), findsOneWidget);
    expect(find.text('ARTINYA'), findsOneWidget);
    expect(find.text('SUMBER'), findsOneWidget);

    await tester.tap(find.text('Simpan Doa'));
    await tester.pump();
    expect(find.text('Tersimpan'), findsOneWidget);

    await tester.tap(find.byTooltip('Kembali'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 500));

    expect(find.text('Doa Harian'), findsWidgets);
    expect(find.text('Disimpan · 1'), findsOneWidget);
  });

  testWidgets('kalkulator zakat menghitung, menampilkan hasil, dan reset', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(900, 2000);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(const BitaqwaApp());
    await tester.pump(const Duration(milliseconds: 50));
    await tester.pump(const Duration(milliseconds: 700));

    await tester.tap(find.text('Zakat').first);
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 900));

    final fields = find.byType(TextFormField);
    expect(fields, findsNWidgets(2));

    await tester.enterText(fields.at(0), '200000000');
    await tester.pump();

    await tester.ensureVisible(find.text('Hitung Zakat'));
    await tester.pump();
    await tester.tap(find.text('Hitung Zakat'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));

    expect(find.text('Wajib Membayar Zakat'), findsOneWidget);
    expect(find.textContaining('5.000.000'), findsWidgets);

    await tester.ensureVisible(find.byIcon(Icons.refresh_rounded));
    await tester.pump();
    await tester.tap(find.byIcon(Icons.refresh_rounded));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));

    expect(find.text('Wajib Membayar Zakat'), findsNothing);
    expect(find.text('Hasil perhitungan'), findsOneWidget);
    expect(
      tester
          .widget<TextFormField>(find.byType(TextFormField).first)
          .controller
          ?.text,
      isEmpty,
    );
  });

  testWidgets('tampilan sempit dapat membuka seluruh tab tanpa overflow', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(360, 780);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(const BitaqwaApp());
    await tester.pump(const Duration(milliseconds: 50));
    await tester.pump(const Duration(milliseconds: 700));

    const destinations = <String, String>{
      'Sholat': 'Jadwal Sholat',
      'Doa': 'Doa Harian',
      'Kajian': 'Kajian Online',
      'Zakat': 'Zakat Mal',
    };

    for (final entry in destinations.entries) {
      await tester.tap(find.text(entry.key).first);
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 900));
      expect(find.text(entry.value), findsWidgets);
    }
  });
}
