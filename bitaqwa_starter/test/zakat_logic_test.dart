import 'package:bitaqwa/zakat/zakat_logic.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('ZakatLogic', () {
    test('nisab adalah 85 gram emas', () {
      expect(ZakatLogic.nisabEmasGram, 85);
      expect(ZakatLogic.kadarZakat, 0.025);
      expect(ZakatLogic.hitungNisabRupiah(1000000), 85000000);
      expect(ZakatLogic.hitungNisabRupiah(1400000), 119000000);
    });

    test('wajib zakat ketika harta sama dengan atau di atas nisab', () {
      expect(
        ZakatLogic.apakahWajibZakat(
          totalHarta: 119000000,
          hargaEmasPerGram: 1400000,
        ),
        isTrue,
      );
      expect(
        ZakatLogic.apakahWajibZakat(
          totalHarta: 200000000,
          hargaEmasPerGram: 1400000,
        ),
        isTrue,
      );
      expect(
        ZakatLogic.apakahWajibZakat(
          totalHarta: 118999999,
          hargaEmasPerGram: 1400000,
        ),
        isFalse,
      );
    });

    test('nominal zakat adalah 2,5 persen dari harta', () {
      expect(ZakatLogic.hitungZakat(100000000), 2500000);
      expect(ZakatLogic.hitungZakat(200000000), 5000000);
      expect(ZakatLogic.hitungZakat(0), 0);
    });

    test('format rupiah memakai pemisah ribuan', () {
      final formatted = ZakatLogic.formatRupiah(2500000);
      expect(formatted, contains('2.500.000'));
    });
  });
}
