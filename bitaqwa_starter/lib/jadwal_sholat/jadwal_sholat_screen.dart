import 'package:bitaqwa/core/theme/app_colors.dart';
import 'package:bitaqwa/core/theme/app_theme.dart';
import 'package:bitaqwa/core/utils/indonesian_date.dart';
import 'package:bitaqwa/core/widgets/app_card.dart';
import 'package:bitaqwa/core/widgets/content_width.dart';
import 'package:bitaqwa/core/widgets/screen_header.dart';
import 'package:bitaqwa/core/widgets/section_header.dart';
import 'package:bitaqwa/core/widgets/status_views.dart';
import 'package:bitaqwa/data/prayer_times_controller.dart';
import 'package:bitaqwa/jadwal_sholat/sholat_helper.dart';
import 'package:bitaqwa/jadwal_sholat/waktu_sholat_model.dart';
import 'package:bitaqwa/jadwal_sholat/widgets/prayer_hero_card.dart';
import 'package:flutter/material.dart';

/// Halaman Jadwal Sholat.
///
/// Memakai data bersama [PrayerTimesController] sehingga jadwal yang tampil
/// di beranda dan di sini selalu sama. Menampilkan lokasi, lima waktu sholat,
/// penanda sholat berikutnya, serta status loading/error yang jelas.
class JadwalSholatScreen extends StatefulWidget {
  const JadwalSholatScreen({super.key});

  @override
  State<JadwalSholatScreen> createState() => _JadwalSholatScreenState();
}

class _JadwalSholatScreenState extends State<JadwalSholatScreen> {
  PrayerTimesController get _prayer => PrayerTimesController.instance;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) _prayer.ensureLoaded();
    });
  }

  Future<void> _refresh() async {
    await _prayer.refresh();
    if (mounted) setState(() {});
  }

  String _errorTitle(PrayerErrorType type) {
    switch (type) {
      case PrayerErrorType.location:
        return 'Layanan lokasi belum aktif';
      case PrayerErrorType.permission:
        return 'Izin lokasi diperlukan';
      case PrayerErrorType.network:
        return 'Gagal memuat jadwal sholat';
      case PrayerErrorType.unknown:
        return 'Jadwal sholat belum tersedia';
    }
  }

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        bottom: false,
        child: ContentWidth(
          maxWidth: 760,
          child: AnimatedBuilder(
            animation: _prayer,
            builder: (context, _) {
              final times = _prayer.times;
              final waiting = times == null &&
                  (_prayer.isLoading ||
                      _prayer.status == PrayerLoadStatus.idle);
              final next = times == null
                  ? null
                  : PrayerHelper.nextPrayer(times, now: now);

              return RefreshIndicator(
                onRefresh: _refresh,
                color: AppColors.sage700,
                backgroundColor: AppColors.surface,
                child: ListView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  padding: const EdgeInsets.fromLTRB(20, 14, 20, 130),
                  children: [
                    ScreenHeader(
                      title: 'Jadwal Sholat',
                      subtitle: IndonesianDate.prayerDay(now),
                      trailing: _RefreshButton(
                        loading: _prayer.isLoading,
                        onTap: _prayer.isLoading ? null : _refresh,
                      ),
                    ),
                    const SizedBox(height: 20),
                    PrayerHeroCard(
                      times: times,
                      location: _prayer.location,
                      isLoading: waiting,
                      onCountdownFinished: () {
                        if (mounted) setState(() {});
                      },
                    ),
                    if (_prayer.hasError) ...[
                      const SizedBox(height: 12),
                      ErrorStateCard(
                        title: _errorTitle(_prayer.errorType),
                        message:
                            _prayer.errorMessage ??
                            'Periksa koneksi internet dan izin lokasi, '
                                'lalu coba lagi.',
                        onRetry: _prayer.isLoading ? null : _refresh,
                        onOpenSettings: _prayer.canOpenLocationSettings
                            ? () async {
                                await _prayer.openSettings();
                                if (mounted) setState(() {});
                              }
                            : null,
                      ),
                    ],
                    const SizedBox(height: 16),
                    _LocationCard(
                      locationName: _prayer.location?.displayName,
                      latitude: _prayer.location?.latitude,
                      longitude: _prayer.location?.longitude,
                      lastUpdated: _prayer.lastUpdated,
                      refreshing: _prayer.isLoading,
                      onRefresh: _prayer.isLoading ? null : _refresh,
                    ),
                    const SizedBox(height: 24),
                    SectionHeader(
                      title: 'Waktu Sholat Hari Ini',
                      subtitle: next == null
                          ? 'Lima waktu sholat fardhu'
                          : 'Berikutnya ${next.label} pukul ${next.time}',
                    ),
                    const SizedBox(height: 12),
                    if (times == null && waiting)
                      const LoadingState(
                        message: 'Menghitung jadwal sholat untuk lokasimu…',
                      )
                    else if (times == null)
                      const EmptyState(
                        icon: Icons.schedule_rounded,
                        title: 'Jadwal belum tersedia',
                        message:
                            'Nyalakan lokasi dan koneksi internet, lalu '
                            'tarik halaman ke bawah untuk memuat ulang.',
                      )
                    else
                      _PrayerList(times: times, next: next),
                    const SizedBox(height: 18),
                    const _MethodNote(),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

class _RefreshButton extends StatelessWidget {
  const _RefreshButton({required this.loading, required this.onTap});

  final bool loading;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: 'Perbarui jadwal sholat',
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          height: 48,
          width: 48,
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColors.border),
          ),
          child: Center(
            child: loading
                ? const SizedBox(
                    height: 19,
                    width: 19,
                    child: CircularProgressIndicator(
                      strokeWidth: 2.2,
                      color: AppColors.sage600,
                    ),
                  )
                : const Icon(
                    Icons.refresh_rounded,
                    size: 21,
                    color: AppColors.sage700,
                  ),
          ),
        ),
      ),
    );
  }
}

class _LocationCard extends StatelessWidget {
  const _LocationCard({
    required this.locationName,
    required this.latitude,
    required this.longitude,
    required this.lastUpdated,
    required this.refreshing,
    required this.onRefresh,
  });

  final String? locationName;
  final double? latitude;
  final double? longitude;
  final DateTime? lastUpdated;
  final bool refreshing;
  final VoidCallback? onRefresh;

  String _updatedLabel() {
    if (lastUpdated == null) return 'Belum diperbarui';
    final hour = lastUpdated!.hour.toString().padLeft(2, '0');
    final minute = lastUpdated!.minute.toString().padLeft(2, '0');
    return 'Diperbarui hari ini, $hour:$minute';
  }

  @override
  Widget build(BuildContext context) {
    final coordinate = latitude == null || longitude == null
        ? 'Menunggu koordinat lokasi'
        : '${latitude!.toStringAsFixed(4)}, '
            '${longitude!.toStringAsFixed(4)}';

    return AppCard(
      elevated: false,
      padding: const EdgeInsets.fromLTRB(16, 15, 10, 15),
      child: Row(
        children: [
          const IconBadge(
            icon: Icons.my_location_rounded,
            size: 44,
            iconSize: 21,
            background: AppColors.sage50,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  locationName ?? 'Lokasi belum tersedia',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppText.bodyStrong.copyWith(fontSize: 14),
                ),
                const SizedBox(height: 2),
                Text(
                  coordinate,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppText.caption.copyWith(fontSize: 10.5),
                ),
                const SizedBox(height: 1),
                Text(
                  _updatedLabel(),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppText.caption.copyWith(fontSize: 10),
                ),
              ],
            ),
          ),
          TextButton(
            onPressed: onRefresh,
            style: TextButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              minimumSize: const Size(0, 40),
            ),
            child: Text(refreshing ? 'Memuat…' : 'Perbarui'),
          ),
        ],
      ),
    );
  }
}

class _PrayerList extends StatelessWidget {
  const _PrayerList({required this.times, required this.next});

  final PrayerTimeModel times;
  final PrayerMoment? next;

  IconData _icon(PrayerName name) {
    switch (name) {
      case PrayerName.subuh:
        return Icons.dark_mode_rounded;
      case PrayerName.dzuhur:
        return Icons.light_mode_rounded;
      case PrayerName.ashar:
        return Icons.wb_twilight_rounded;
      case PrayerName.maghrib:
        return Icons.nights_stay_rounded;
      case PrayerName.isya:
        return Icons.bedtime_rounded;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        for (final name in PrayerName.values)
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: _PrayerRow(
              name: name,
              time: times.timeOf(name),
              icon: _icon(name),
              isNext: next?.name == name,
            ),
          ),
      ],
    );
  }
}

class _PrayerRow extends StatelessWidget {
  const _PrayerRow({
    required this.name,
    required this.time,
    required this.icon,
    required this.isNext,
  });

  final PrayerName name;
  final String time;
  final IconData icon;
  final bool isNext;

  @override
  Widget build(BuildContext context) {
    final foreground = isNext ? Colors.white : AppColors.textPrimary;
    final secondary = isNext
        ? Colors.white.withValues(alpha: 0.66)
        : AppColors.textTertiary;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 260),
      curve: Curves.easeOutCubic,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 13),
      decoration: BoxDecoration(
        color: isNext ? AppColors.sage800 : AppColors.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isNext ? AppColors.sage800 : AppColors.border,
        ),
        boxShadow: isNext
            ? [
                BoxShadow(
                  color: AppColors.sage900.withValues(alpha: 0.16),
                  blurRadius: 20,
                  offset: const Offset(0, 8),
                ),
              ]
            : null,
      ),
      child: Row(
        children: [
          IconBadge(
            icon: icon,
            size: 42,
            iconSize: 20,
            background: isNext
                ? Colors.white.withValues(alpha: 0.10)
                : AppColors.sage50,
            foreground: isNext ? Colors.white : AppColors.sage700,
          ),
          const SizedBox(width: 13),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      name.label,
                      style: AppText.bodyStrong.copyWith(
                        fontSize: 14.5,
                        color: foreground,
                      ),
                    ),
                    if (isNext) ...[
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 7,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.gold.withValues(alpha: 0.9),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          'BERIKUTNYA',
                          style: AppText.overline.copyWith(
                            color: Colors.white,
                            fontSize: 7.5,
                            letterSpacing: 0.7,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
                const SizedBox(height: 2),
                Text(
                  isNext ? 'Bersiap untuk sholat' : 'Waktu sholat fardhu',
                  style: AppText.caption.copyWith(
                    color: secondary,
                    fontSize: 10.5,
                  ),
                ),
              ],
            ),
          ),
          Text(
            time,
            style: AppText.h2.copyWith(
              fontSize: 20,
              color: foreground,
              letterSpacing: -0.4,
            ),
          ),
        ],
      ),
    );
  }
}

class _MethodNote extends StatelessWidget {
  const _MethodNote();

  @override
  Widget build(BuildContext context) {
    return AppCard(
      color: AppColors.sage50,
      borderColor: AppColors.sage100,
      elevated: false,
      padding: const EdgeInsets.all(15),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.verified_user_rounded,
            size: 17,
            color: AppColors.sage600,
          ),
          const SizedBox(width: 9),
          Expanded(
            child: Text(
              'Jadwal dihitung dari koordinat lokasi Anda memakai metode '
              'Kemenag RI melalui layanan Aladhan. Selisih beberapa menit '
              'dapat terjadi tergantung kondisi lapangan.',
              style: AppText.caption.copyWith(
                fontSize: 11,
                height: 1.55,
                color: AppColors.textSecondary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
