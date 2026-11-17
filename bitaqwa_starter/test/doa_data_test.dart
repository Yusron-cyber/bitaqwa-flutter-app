import 'package:bitaqwa/doa_harian/doa_data.dart';
import 'package:bitaqwa/doa_harian/kategori_doa_enum.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Data doa', () {
    test('seluruh kategori memiliki doa', () {
      for (final category in DoaCategory.values) {
        expect(
          doaCountFor(category),
          greaterThan(0),
          reason: 'Kategori ${category.name} tidak boleh kosong',
        );
      }
    });

    test('jumlah doa dan judul unik', () {
      final entries = allDoaEntries;
      expect(entries.length, 25);

      final titles = entries.map((entry) => entry.doa.title).toList();
      expect(titles.toSet().length, titles.length);
    });

    test('setiap doa memiliki arab, latin, arti, dan sumber', () {
      final arabicPattern = RegExp(r'[\u0600-\u06FF]');

      for (final entry in allDoaEntries) {
        final doa = entry.doa;
        expect(doa.title.trim(), isNotEmpty);
        expect(doa.arabicText.trim(), isNotEmpty);
        expect(
          arabicPattern.hasMatch(doa.arabicText),
          isTrue,
          reason: 'Teks Arab rusak pada ${doa.title}',
        );
        expect(doa.latin.trim(), isNotEmpty);
        expect(doa.translation.trim(), isNotEmpty);
        expect(doa.reference.trim(), isNotEmpty);

        // Pastikan tidak ada sisa mojibake dari encoding lama.
        expect(doa.title.contains('Ã'), isFalse);
        expect(doa.arabicText.contains('Ã'), isFalse);
        expect(doa.translation.contains('Ã'), isFalse);
        expect(doa.title.contains('Do’a'), isFalse);
      }
    });

    test('pencarian doa berdasarkan judul stabil', () {
      final entry = findDoaByTitle('Doa Sebelum Makan');
      expect(entry, isNotNull);
      expect(entry!.doa.latin.toLowerCase(), contains('bismill'));
      expect(findDoaByTitle('Doa yang tidak ada'), isNull);
    });
  });
}
