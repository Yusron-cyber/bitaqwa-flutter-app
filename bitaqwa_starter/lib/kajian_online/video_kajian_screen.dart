import 'package:bitaqwa/core/theme/app_colors.dart';
import 'package:bitaqwa/core/theme/app_theme.dart';
import 'package:bitaqwa/core/widgets/app_card.dart';
import 'package:bitaqwa/core/widgets/content_width.dart';
import 'package:bitaqwa/core/widgets/screen_header.dart';
import 'package:bitaqwa/core/widgets/section_header.dart';
import 'package:bitaqwa/kajian_online/detail_video_kajian_screen.dart';
import 'package:bitaqwa/kajian_online/kajian_model.dart';
import 'package:bitaqwa/kajian_online/video_data.dart';
import 'package:flutter/material.dart';

/// Halaman Kajian Online: daftar video ceramah pilihan.
class VideoKajianScreen extends StatelessWidget {
  const VideoKajianScreen({super.key});

  void _open(BuildContext context, KajianVideo video) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => DetailVideoKajianScreen(video: video),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final featured = videos.isNotEmpty ? videos.first : null;
    final rest = videos.length > 1 ? videos.sublist(1) : const <KajianVideo>[];

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        bottom: false,
        child: ContentWidth(
          maxWidth: 760,
          child: ListView(
            padding: const EdgeInsets.fromLTRB(20, 14, 20, 130),
            children: [
              ScreenHeader(
                title: 'Kajian Online',
                subtitle:
                    '${videos.length} video ceramah pilihan untuk menemani '
                    'belajarmu',
              ),
              if (featured != null) ...[
                const SizedBox(height: 20),
                _FeaturedVideo(
                  video: featured,
                  onTap: () => _open(context, featured),
                ),
              ],
              const SizedBox(height: 26),
              const SectionHeader(
                title: 'Semua Kajian',
                subtitle: 'Pilih ceramah sesuai kebutuhanmu',
              ),
              const SizedBox(height: 12),
              if (rest.isEmpty && featured == null)
                const Text('Belum ada video kajian.')
              else
                for (final video in rest)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: _VideoTile(
                      video: video,
                      onTap: () => _open(context, video),
                    ),
                  ),
              const SizedBox(height: 8),
              const _KajianNote(),
            ],
          ),
        ),
      ),
    );
  }
}

class _FeaturedVideo extends StatelessWidget {
  const _FeaturedVideo({required this.video, required this.onTap});

  final KajianVideo video;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(26),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Container(
          decoration: BoxDecoration(
            color: AppColors.sage900,
            borderRadius: BorderRadius.circular(26),
            boxShadow: [
              BoxShadow(
                color: AppColors.sage900.withValues(alpha: 0.16),
                blurRadius: 28,
                offset: const Offset(0, 12),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AspectRatio(
                aspectRatio: 16 / 9,
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    VideoThumbnail(image: video.thumbnail),
                    DecoratedBox(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.black.withValues(alpha: 0.02),
                            Colors.black.withValues(alpha: 0.42),
                          ],
                        ),
                      ),
                    ),
                    const Center(child: _PlayBadge(size: 62)),
                    Positioned(
                      left: 16,
                      bottom: 14,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 9,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.black.withValues(alpha: 0.38),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          'KAJIAN PILIHAN',
                          style: AppText.overline.copyWith(
                            color: Colors.white,
                            fontSize: 8.5,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(18, 15, 18, 18),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      video.account.toUpperCase(),
                      style: AppText.overline.copyWith(
                        color: AppColors.sage300,
                        fontSize: 8.5,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      video.title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: AppText.h3.copyWith(
                        color: Colors.white,
                        fontSize: 18,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Row(
                      children: [
                        const Icon(
                          Icons.person_outline_rounded,
                          size: 13,
                          color: Colors.white54,
                        ),
                        const SizedBox(width: 5),
                        Expanded(
                          child: Text(
                            video.ustadz,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: AppText.caption.copyWith(
                              color: Colors.white70,
                              fontSize: 11,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _VideoTile extends StatelessWidget {
  const _VideoTile({required this.video, required this.onTap});

  final KajianVideo video;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      elevated: false,
      padding: const EdgeInsets.all(10),
      onTap: onTap,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(14),
            child: SizedBox(
              height: 78,
              width: 112,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  VideoThumbnail(image: video.thumbnail),
                  Center(child: _PlayBadge(size: 34)),
                ],
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  video.account.toUpperCase(),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppText.overline.copyWith(
                    color: AppColors.sage600,
                    fontSize: 8,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  video.title,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: AppText.bodyStrong.copyWith(fontSize: 13.5),
                ),
                const SizedBox(height: 3),
                Text(
                  video.ustadz,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppText.caption.copyWith(fontSize: 10.5),
                ),
              ],
            ),
          ),
          const Icon(
            Icons.chevron_right_rounded,
            size: 19,
            color: AppColors.textTertiary,
          ),
          const SizedBox(width: 2),
        ],
      ),
    );
  }
}

class _PlayBadge extends StatelessWidget {
  const _PlayBadge({required this.size});

  final double size;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: size,
      width: size,
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.94),
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.18),
            blurRadius: 14,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Icon(
        Icons.play_arrow_rounded,
        size: size * 0.52,
        color: AppColors.sage800,
      ),
    );
  }
}

/// Thumbnail dengan fallback bila aset gambar tidak tersedia.
class VideoThumbnail extends StatelessWidget {
  const VideoThumbnail({super.key, required this.image});

  final String image;

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      image,
      fit: BoxFit.cover,
      errorBuilder: (context, error, stackTrace) {
        return Container(
          color: AppColors.sage100,
          alignment: Alignment.center,
          child: const Icon(
            Icons.video_library_rounded,
            size: 30,
            color: AppColors.sage500,
          ),
        );
      },
    );
  }
}

class _KajianNote extends StatelessWidget {
  const _KajianNote();

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
            Icons.wifi_rounded,
            size: 17,
            color: AppColors.sage600,
          ),
          const SizedBox(width: 9),
          Expanded(
            child: Text(
              'Video diputar langsung di dalam aplikasi melalui YouTube. '
              'Pastikan koneksi internet stabil agar pemutaran lancar.',
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
