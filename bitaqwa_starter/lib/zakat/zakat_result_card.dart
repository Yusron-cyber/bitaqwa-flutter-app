import 'package:bitaqwa/core/theme/app_colors.dart';
import 'package:bitaqwa/core/theme/app_theme.dart';
import 'package:bitaqwa/core/widgets/app_card.dart';
import 'package:bitaqwa/zakat/zakat_logic.dart';
import 'package:flutter/material.dart';

/// Kartu hasil perhitungan zakat mal.
///
/// Menampilkan status kewajiban, nominal zakat, dan rincian perhitungan agar
/// pengguna dapat memeriksa asal angka yang muncul.
class ZakatResultCard extends StatelessWidget {
  const ZakatResultCard({
    super.key,
    required this.sudahDihitung,
    required this.wajibZakat,
    required this.totalHarta,
    required this.hargaEmasPerGram,
    required this.batasNisab,
    required this.nominalZakat,
  });

  final bool sudahDihitung;
  final bool wajibZakat;
  final double totalHarta;
  final double hargaEmasPerGram;
  final double batasNisab;
  final double nominalZakat;

  @override
  Widget build(BuildContext context) {
    if (!sudahDihitung) {
      return AppCard(
        color: AppColors.sage50,
        borderColor: AppColors.sage100,
        elevated: false,
        padding: const EdgeInsets.all(17),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const IconBadge(
              icon: Icons.info_outline_rounded,
              size: 42,
              iconSize: 20,
              background: AppColors.surface,
              foreground: AppColors.sage600,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Hasil perhitungan', style: AppText.h3),
                  const SizedBox(height: 3),
                  Text(
                    'Isi total harta dan harga emas per gram, lalu tekan '
                    '"Hitung Zakat" untuk melihat hasilnya.',
                    style: AppText.body.copyWith(fontSize: 12.5),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    }

    return AppCard(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              IconBadge(
                icon: wajibZakat
                    ? Icons.check_circle_rounded
                    : Icons.hourglass_bottom_rounded,
                size: 44,
                iconSize: 22,
                background: wajibZakat
                    ? AppColors.successSoft
                    : AppColors.goldSoft,
                foreground: wajibZakat
                    ? AppColors.success
                    : AppColors.gold,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      wajibZakat
                          ? 'Wajib Membayar Zakat'
                          : 'Belum Mencapai Nisab',
                      style: AppText.h3,
                    ),
                    const SizedBox(height: 2),
                    Text(
                      wajibZakat
                          ? 'Harta Anda telah mencapai batas nisab.'
                          : 'Harta Anda masih di bawah batas nisab.',
                      style: AppText.caption.copyWith(fontSize: 11.5),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          if (wajibZakat)
            _ZakatAmount(nominalZakat: nominalZakat)
          else
            _ShortfallPanel(
              batasNisab: batasNisab,
              totalHarta: totalHarta,
            ),
          const SizedBox(height: 18),
          Text(
            'RINCIAN PERHITUNGAN',
            style: AppText.overline.copyWith(
              color: AppColors.textTertiary,
              fontSize: 9.5,
            ),
          ),
          const SizedBox(height: 10),
          _DetailRow(
            label: 'Total harta',
            value: ZakatLogic.formatRupiah(totalHarta),
          ),
          _DetailRow(
            label: 'Harga emas per gram',
            value: ZakatLogic.formatRupiah(hargaEmasPerGram),
          ),
          _DetailRow(
            label: 'Nisab (85 gram emas)',
            value: ZakatLogic.formatRupiah(batasNisab),
          ),
          _DetailRow(
            label: 'Kadar zakat',
            value: '${(ZakatLogic.kadarZakat * 100).toStringAsFixed(1)}%',
          ),
          if (!wajibZakat)
            _DetailRow(
              label: 'Kekurangan menuju nisab',
              value: ZakatLogic.formatRupiah(batasNisab - totalHarta),
              highlight: true,
            ),
          const SizedBox(height: 14),
          Container(
            padding: const EdgeInsets.all(13),
            decoration: BoxDecoration(
              color: AppColors.surfaceMuted,
              borderRadius: BorderRadius.circular(14),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(
                  Icons.lightbulb_outline_rounded,
                  size: 16,
                  color: AppColors.sage600,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Kalkulator ini hanya membantu menghitung batas nisab '
                    'dan kadar 2,5%. Kewajiban zakat tetap memperhatikan '
                    'haul (kepemilikan satu tahun) serta ketentuan lain. '
                    'Konsultasikan dengan amil atau ustaz bila ragu.',
                    style: AppText.caption.copyWith(
                      fontSize: 10.5,
                      height: 1.5,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ZakatAmount extends StatelessWidget {
  const _ZakatAmount({required this.nominalZakat});

  final double nominalZakat;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(18, 16, 18, 17),
      decoration: BoxDecoration(
        color: AppColors.sage800,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'ZAKAT YANG DIKELUARKAN',
            style: AppText.overline.copyWith(
              color: Colors.white54,
              fontSize: 9,
            ),
          ),
          const SizedBox(height: 5),
          Text(
            ZakatLogic.formatRupiah(nominalZakat),
            style: AppText.h1.copyWith(
              color: Colors.white,
              fontSize: 27,
              letterSpacing: -0.8,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            '2,5% dari total harta',
            style: AppText.caption.copyWith(
              color: Colors.white70,
              fontSize: 10.5,
            ),
          ),
        ],
      ),
    );
  }
}

class _ShortfallPanel extends StatelessWidget {
  const _ShortfallPanel({
    required this.batasNisab,
    required this.totalHarta,
  });

  final double batasNisab;
  final double totalHarta;

  @override
  Widget build(BuildContext context) {
    final progress = batasNisab <= 0
        ? 0.0
        : (totalHarta / batasNisab).clamp(0.0, 1.0).toDouble();

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.goldSoft,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: AppColors.gold.withValues(alpha: 0.18),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Harta Anda belum wajib dizakati karena belum mencapai nisab '
            '85 gram emas.',
            style: AppText.body.copyWith(
              fontSize: 12.5,
              color: AppColors.textPrimary,
              height: 1.55,
            ),
          ),
          const SizedBox(height: 13),
          ClipRRect(
            borderRadius: BorderRadius.circular(6),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 7,
              backgroundColor: AppColors.surface,
              valueColor: const AlwaysStoppedAnimation<Color>(
                AppColors.gold,
              ),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '${(progress * 100).toStringAsFixed(0)}% dari batas nisab',
            style: AppText.caption.copyWith(
              fontSize: 10,
              color: AppColors.gold,
            ),
          ),
        ],
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  const _DetailRow({
    required this.label,
    required this.value,
    this.highlight = false,
  });

  final String label;
  final String value;
  final bool highlight;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Text(
              label,
              style: AppText.body.copyWith(
                fontSize: 12.5,
                color: AppColors.textSecondary,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Text(
            value,
            textAlign: TextAlign.right,
            style: AppText.bodyStrong.copyWith(
              fontSize: 12.5,
              color: highlight ? AppColors.gold : AppColors.textPrimary,
            ),
          ),
        ],
      ),
    );
  }
}
