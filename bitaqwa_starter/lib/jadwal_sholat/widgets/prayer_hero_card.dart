import 'package:bitaqwa/core/theme/app_colors.dart';
import 'package:bitaqwa/core/theme/app_theme.dart';
import 'package:bitaqwa/core/widgets/prayer_countdown.dart';
import 'package:bitaqwa/jadwal_sholat/lokasi_model.dart';
import 'package:bitaqwa/jadwal_sholat/sholat_helper.dart';
import 'package:bitaqwa/jadwal_sholat/waktu_sholat_model.dart';
import 'package:flutter/material.dart';

/// Kartu utama sholat berikutnya. Dipakai di dashboard dan halaman jadwal.
class PrayerHeroCard extends StatelessWidget {
  const PrayerHeroCard({
    super.key,
    required this.times,
    this.location,
    this.isLoading = false,
    this.compact = false,
    this.onTap,
    this.onCountdownFinished,
  });

  final PrayerTimeModel? times;
  final LocationModel? location;
  final bool isLoading;
  final bool compact;
  final VoidCallback? onTap;
  final VoidCallback? onCountdownFinished;

  @override
  Widget build(BuildContext context) {
    final borderRadius = BorderRadius.circular(compact ? 26 : 30);

    return Container(
      decoration: BoxDecoration(
        borderRadius: borderRadius,
        boxShadow: [
          BoxShadow(
            color: AppColors.sage900.withValues(alpha: 0.16),
            blurRadius: 30,
            offset: const Offset(0, 14),
          ),
        ],
      ),
      child: Material(
        color: AppColors.sage900,
        borderRadius: borderRadius,
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onTap,
          child: Stack(
            children: [
              Positioned(
                right: -70,
                top: -90,
                child: Container(
                  height: 230,
                  width: 230,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white.withValues(alpha: 0.035),
                  ),
                ),
              ),
              Positioned(
                left: -60,
                bottom: -100,
                child: Container(
                  height: 200,
                  width: 200,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColors.gold.withValues(alpha: 0.10),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(compact ? 20 : 24),
                child: isLoading
                    ? const _LoadingHero()
                    : _ReadyHero(
                        times: times,
                        location: location,
                        compact: compact,
                        onCountdownFinished: onCountdownFinished,
                        onTap: onTap,
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _LoadingHero extends StatelessWidget {
  const _LoadingHero();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 160,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(
            height: 26,
            width: 26,
            child: CircularProgressIndicator(
              strokeWidth: 2.4,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'Menyiapkan jadwal sholat…',
            style: AppText.body.copyWith(color: Colors.white70),
          ),
        ],
      ),
    );
  }
}

class _ReadyHero extends StatelessWidget {
  const _ReadyHero({
    required this.times,
    required this.location,
    required this.compact,
    required this.onCountdownFinished,
    required this.onTap,
  });

  final PrayerTimeModel? times;
  final LocationModel? location;
  final bool compact;
  final VoidCallback? onCountdownFinished;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final next = times == null ? null : PrayerHelper.nextPrayer(times!);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 5),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.09),
                borderRadius: BorderRadius.circular(9),
              ),
              child: Text(
                'SHOLAT BERIKUTNYA',
                style: AppText.overline.copyWith(
                  color: Colors.white70,
                  fontSize: 9,
                  letterSpacing: 0.9,
                ),
              ),
            ),
            const Spacer(),
            if (onTap != null)
              Icon(
                Icons.arrow_outward_rounded,
                size: 18,
                color: Colors.white.withValues(alpha: 0.7),
              ),
          ],
        ),
        const SizedBox(height: 16),
        if (next == null)
          Text(
            'Jadwal belum tersedia',
            style: AppText.h3.copyWith(color: Colors.white),
          )
        else
          LayoutBuilder(
            builder: (context, constraints) {
              final isNarrow = constraints.maxWidth < 320;
              return Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          next.label,
                          style: AppText.body.copyWith(
                            color: Colors.white70,
                            fontSize: 13,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          next.time,
                          style: AppText.display.copyWith(
                            color: Colors.white,
                            fontSize: compact ? 42 : 46,
                            fontWeight: FontWeight.w600,
                            letterSpacing: -1.5,
                            fontFeatures: const [
                              FontFeature.tabularFigures(),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        isNarrow ? 'Menuju' : 'Menuju ${next.label}',
                        style: AppText.caption.copyWith(
                          color: Colors.white54,
                          fontSize: 11,
                        ),
                      ),
                      const SizedBox(height: 4),
                      PrayerCountdown(
                        target: next.dateTime,
                        onFinished: onCountdownFinished,
                        style: AppText.h3.copyWith(
                          color: Colors.white,
                          fontSize: compact ? 17 : 19,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 0.2,
                        ),
                      ),
                    ],
                  ),
                ],
              );
            },
          ),
        const SizedBox(height: 16),
        Container(
          height: 1,
          color: Colors.white.withValues(alpha: 0.10),
        ),
        const SizedBox(height: 14),
        _PrayerSummaryRow(times: times, next: next, compact: compact),
        const SizedBox(height: 14),
        Row(
          children: [
            const Icon(
              Icons.location_on_rounded,
              size: 14,
              color: Color(0xFFB9CDB1),
            ),
            const SizedBox(width: 5),
            Expanded(
              child: Text(
                location?.displayName ?? 'Menunggu lokasi…',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AppText.caption.copyWith(
                  color: Colors.white.withValues(alpha: 0.72),
                  fontSize: 11,
                ),
              ),
            ),
            Text(
              'Kemenag RI',
              style: AppText.caption.copyWith(
                color: Colors.white.withValues(alpha: 0.45),
                fontSize: 10,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _PrayerSummaryRow extends StatelessWidget {
  const _PrayerSummaryRow({
    required this.times,
    required this.next,
    required this.compact,
  });

  final PrayerTimeModel? times;
  final PrayerMoment? next;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        for (final name in PrayerName.values)
          Expanded(
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 250),
              margin: EdgeInsets.symmetric(horizontal: compact ? 1.5 : 2.5),
              padding: const EdgeInsets.symmetric(vertical: 7),
              decoration: BoxDecoration(
                color: next?.name == name
                    ? Colors.white.withValues(alpha: 0.12)
                    : Colors.transparent,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                children: [
                  Text(
                    name.label,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppText.caption.copyWith(
                      color: next?.name == name
                          ? Colors.white
                          : Colors.white.withValues(alpha: 0.52),
                      fontSize: compact ? 9.5 : 10.5,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    times?.timeOf(name) ?? '--:--',
                    maxLines: 1,
                    style: AppText.caption.copyWith(
                      color: next?.name == name
                          ? Colors.white
                          : Colors.white.withValues(alpha: 0.8),
                      fontSize: compact ? 11 : 12,
                      fontWeight: next?.name == name
                          ? FontWeight.w600
                          : FontWeight.w400,
                      fontFeatures: const [FontFeature.tabularFigures()],
                    ),
                  ),
                ],
              ),
            ),
          ),
      ],
    );
  }
}
