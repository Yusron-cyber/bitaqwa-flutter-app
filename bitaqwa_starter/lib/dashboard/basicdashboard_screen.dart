import 'package:bitaqwa/core/theme/app_colors.dart';
import 'package:bitaqwa/core/theme/app_theme.dart';
import 'package:bitaqwa/core/utils/indonesian_date.dart';
import 'package:bitaqwa/core/widgets/app_card.dart';
import 'package:bitaqwa/core/widgets/content_width.dart';
import 'package:bitaqwa/core/widgets/section_header.dart';
import 'package:bitaqwa/core/widgets/status_views.dart';
import 'package:bitaqwa/dashboard/menu_data.dart';
import 'package:bitaqwa/dashboard/menu_model.dart';
import 'package:bitaqwa/data/prayer_times_controller.dart';
import 'package:bitaqwa/doa_harian/doa_data.dart';
import 'package:bitaqwa/doa_harian/detail_doa_screen.dart';
import 'package:bitaqwa/doa_harian/widgets/doa_tile.dart';
import 'package:bitaqwa/jadwal_sholat/widgets/prayer_hero_card.dart';
import 'package:flutter/material.dart';

/// Beranda Bitaqwa.
///
/// Menyapa pengguna, menampilkan sholat berikutnya, akses cepat ke seluruh
/// fitur, inspirasi harian, dan doa pilihan. Data jadwal sholat dibagi dengan
/// tab Jadwal Sholat melalui [PrayerTimesController].
class BasicDashboardScreen extends StatefulWidget {
  const BasicDashboardScreen({super.key, required this.onSelectTab});

  /// Berpindah tab pada [MainShell] tanpa membuat halaman baru.
  final ValueChanged<int> onSelectTab;

  @override
  State<BasicDashboardScreen> createState() => _BasicDashboardScreenState();
}

class _BasicDashboardScreenState extends State<BasicDashboardScreen> {
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

  void _openTab(int index) => widget.onSelectTab(index);

  void _openDoa(DoaEntry entry) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => DetailDoaScreen(
          doa: entry.doa,
          category: entry.category,
        ),
      ),
    );
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
          child: RefreshIndicator(
            onRefresh: _refresh,
            color: AppColors.sage700,
            backgroundColor: AppColors.surface,
            child: AnimatedBuilder(
              animation: _prayer,
              builder: (context, _) {
                final heroLoading =
                    _prayer.isLoading && _prayer.times == null;

                return ListView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  padding: const EdgeInsets.fromLTRB(20, 14, 20, 130),
                  children: [
                    _DashboardHeader(now: now),
                    const SizedBox(height: 22),
                    PrayerHeroCard(
                      times: _prayer.times,
                      location: _prayer.location,
                      isLoading: heroLoading,
                      compact: true,
                      onTap: () => _openTab(1),
                      onCountdownFinished: () {
                        if (mounted) setState(() {});
                      },
                    ),
                    if (_prayer.hasError) ...[
                      const SizedBox(height: 12),
                      ErrorStateCard(
                        title: 'Jadwal sholat belum tersedia',
                        message:
                            _prayer.errorMessage ??
                            'Periksa koneksi dan izin lokasi, lalu coba lagi.',
                        onRetry: _prayer.isLoading ? null : _refresh,
                        onOpenSettings: _prayer.canOpenLocationSettings
                            ? () => _prayer.openSettings()
                            : null,
                        compact: true,
                      ),
                    ],
                    const SizedBox(height: 26),
                    const SectionHeader(
                      title: 'Akses Cepat',
                      subtitle: 'Seluruh fitur Bitaqwa dalam satu genggaman',
                    ),
                    const SizedBox(height: 12),
                    _QuickAccessGrid(
                      onSelected: (menu) => _openTab(menu.tabIndex),
                    ),
                    const SizedBox(height: 26),
                    SectionHeader(
                      title: 'Inspirasi Hari Ini',
                      subtitle: IndonesianDate.fullDate(now),
                    ),
                    const SizedBox(height: 12),
                    _InspirationCard(
                      inspiration: _inspirationFor(now),
                    ),
                    const SizedBox(height: 26),
                    SectionHeader(
                      title: 'Doa Pilihan',
                      subtitle: 'Bacaan singkat untuk menemani harimu',
                      actionLabel: 'Lihat semua',
                      onAction: () => _openTab(2),
                    ),
                    const SizedBox(height: 12),
                    ..._featuredDoas(now, 3).map(
                      (entry) => Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: DoaTile(
                          doa: entry.doa,
                          category: entry.category,
                          onTap: () => _openDoa(entry),
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}

/// Daftar ayat pilihan yang berganti setiap hari.
const List<_Inspiration> _inspirations = [
  _Inspiration(
    arabic: 'فَإِنَّ مَعَ الْعُسْرِ يُسْرًا',
    translation:
        'Maka sesungguhnya bersama kesulitan ada kemudahan.',
    source: 'QS. Asy-Syarh: 5',
  ),
  _Inspiration(
    arabic: 'إِنَّ اللَّهَ مَعَ الصَّابِرِينَ',
    translation:
        'Sesungguhnya Allah bersama orang-orang yang sabar.',
    source: 'QS. Al-Baqarah: 153',
  ),
  _Inspiration(
    arabic: 'وَمَن يَتَّقِ اللَّهَ يَجْعَل لَّهُ مَخْرَجًا',
    translation:
        'Barangsiapa bertakwa kepada Allah, niscaya Dia akan '
        'menjadikan jalan keluar baginya.',
    source: 'QS. At-Talaq: 2',
  ),
  _Inspiration(
    arabic: 'فَاذْكُرُونِي أَذْكُرْكُمْ',
    translation:
        'Maka ingatlah kepada-Ku, Aku pun akan ingat kepadamu.',
    source: 'QS. Al-Baqarah: 152',
  ),
  _Inspiration(
    arabic: 'وَقُل رَّبِّ زِدْنِي عِلْمًا',
    translation:
        'Dan katakanlah, "Ya Tuhanku, tambahkanlah ilmu kepadaku."',
    source: 'QS. Thaha: 114',
  ),
  _Inspiration(
    arabic: 'إِنَّ الصَّلَاةَ كَانَتْ عَلَى الْمُؤْمِنِينَ كِتَابًا مَّوْقُوتًا',
    translation:
        'Sesungguhnya sholat itu adalah kewajiban yang ditetapkan '
        'waktunya bagi orang-orang mukmin.',
    source: 'QS. An-Nisa: 103',
  ),
  _Inspiration(
    arabic: 'وَاذْكُر رَّبَّكَ إِذَا نَسِيتَ',
    translation: 'Dan ingatlah kepada Tuhanmu ketika kamu lupa.',
    source: 'QS. Al-Kahf: 24',
  ),
];

class _Inspiration {
  const _Inspiration({
    required this.arabic,
    required this.translation,
    required this.source,
  });

  final String arabic;
  final String translation;
  final String source;
}

_Inspiration _inspirationFor(DateTime date) {
  final dayOfYear = date
      .difference(DateTime(date.year, 1, 1))
      .inDays;
  return _inspirations[dayOfYear % _inspirations.length];
}

/// Tiga doa pilihan yang berganti setiap hari tanpa mengubah urutan data.
List<DoaEntry> _featuredDoas(DateTime date, int count) {
  final entries = allDoaEntries;
  if (entries.isEmpty) return const [];
  final dayOfYear = date.difference(DateTime(date.year, 1, 1)).inDays;
  final start = dayOfYear % entries.length;
  final total = count < 1
      ? 1
      : (count > entries.length ? entries.length : count);
  return List<DoaEntry>.generate(
    total,
    (index) => entries[(start + index) % entries.length],
  );
}

class _DashboardHeader extends StatelessWidget {
  const _DashboardHeader({required this.now});

  final DateTime now;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'ASSALAMU\'ALAIKUM',
                style: AppText.overline.copyWith(
                  color: AppColors.sage600,
                ),
              ),
              const SizedBox(height: 7),
              Text(
                '${IndonesianDate.greeting(now)},',
                style: AppText.h2.copyWith(color: AppColors.textSecondary),
              ),
              Text(
                'Sahabat Bitaqwa',
                style: AppText.h1.copyWith(fontSize: 25),
              ),
              const SizedBox(height: 7),
              Row(
                children: [
                  const Icon(
                    Icons.calendar_today_rounded,
                    size: 13,
                    color: AppColors.textTertiary,
                  ),
                  const SizedBox(width: 6),
                  Flexible(
                    child: Text(
                      IndonesianDate.fullDate(now),
                      style: AppText.caption,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(width: 12),
        Container(
          height: 62,
          width: 56,
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: AppColors.border),
            boxShadow: [
              BoxShadow(
                color: AppColors.sage900.withValues(alpha: 0.05),
                blurRadius: 18,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                IndonesianDate.dayNumber(now),
                style: AppText.h2.copyWith(
                  fontSize: 22,
                  color: AppColors.sage800,
                ),
              ),
              Text(
                IndonesianDate.monthShort(now).toUpperCase(),
                style: AppText.overline.copyWith(
                  fontSize: 8.5,
                  color: AppColors.textTertiary,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _QuickAccessGrid extends StatelessWidget {
  const _QuickAccessGrid({required this.onSelected});

  final ValueChanged<MenuModel> onSelected;

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: menus.length,
      gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
        maxCrossAxisExtent: 260,
        mainAxisExtent: 118,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
      ),
      itemBuilder: (context, index) {
        final menu = menus[index];
        return AppCard(
          padding: const EdgeInsets.all(15),
          elevated: false,
          onTap: () => onSelected(menu),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  IconBadge(
                    icon: menu.icon,
                    size: 40,
                    iconSize: 20,
                    background: menu.tint,
                    foreground: menu.foreground,
                  ),
                  const Spacer(),
                  const Icon(
                    Icons.arrow_outward_rounded,
                    size: 15,
                    color: AppColors.textTertiary,
                  ),
                ],
              ),
              const Spacer(),
              Text(
                menu.title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AppText.bodyStrong.copyWith(fontSize: 14),
              ),
              const SizedBox(height: 1),
              Text(
                menu.subtitle,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AppText.caption.copyWith(fontSize: 10.5),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _InspirationCard extends StatelessWidget {
  const _InspirationCard({required this.inspiration});

  final _Inspiration inspiration;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      elevated: false,
      color: AppColors.surface,
      padding: const EdgeInsets.fromLTRB(20, 18, 20, 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const IconBadge(
                icon: Icons.auto_awesome_rounded,
                size: 38,
                iconSize: 18,
                background: AppColors.goldSoft,
                foreground: AppColors.gold,
              ),
              const SizedBox(width: 10),
              Text(
                'AYAT PILIHAN',
                style: AppText.overline.copyWith(
                  color: AppColors.gold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),
          Directionality(
            textDirection: TextDirection.rtl,
            child: Text(
              inspiration.arabic,
              textAlign: TextAlign.right,
              style: AppText.arabic.copyWith(
                fontSize: 23,
                height: 2,
              ),
            ),
          ),
          const SizedBox(height: 14),
          Text(
            inspiration.translation,
            style: AppText.body.copyWith(
              color: AppColors.textPrimary,
              height: 1.7,
            ),
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              Container(
                width: 20,
                height: 1.5,
                color: AppColors.gold.withValues(alpha: 0.55),
              ),
              const SizedBox(width: 8),
              Text(
                inspiration.source,
                style: AppText.caption.copyWith(
                  color: AppColors.gold,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
