import 'dart:async';

import 'package:bitaqwa/core/theme/app_colors.dart';
import 'package:bitaqwa/core/theme/app_theme.dart';
import 'package:bitaqwa/core/widgets/app_card.dart';
import 'package:bitaqwa/core/widgets/content_width.dart';
import 'package:bitaqwa/kajian_online/kajian_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

/// Halaman pemutar video kajian.
///
/// Tautan video divalidasi terlebih dahulu. Jika tidak valid, halaman tetap
/// tampil dengan pesan yang jelas, bukan melempar error atau layar kosong.
class DetailVideoKajianScreen extends StatefulWidget {
  const DetailVideoKajianScreen({super.key, required this.video});

  final KajianVideo video;

  @override
  State<DetailVideoKajianScreen> createState() =>
      _DetailVideoKajianScreenState();
}

class _DetailVideoKajianScreenState extends State<DetailVideoKajianScreen> {
  YoutubePlayerController? _controller;
  StreamSubscription<YoutubePlayerValue>? _subscription;
  String? _videoId;
  bool _isPlayerReady = false;
  bool _hasError = false;

  @override
  void initState() {
    super.initState();

    final videoId = YoutubePlayerController.convertUrlToId(
      widget.video.videoId,
    );
    if (videoId == null || videoId.isEmpty) return;

    _videoId = videoId;
    final controller = YoutubePlayerController.fromVideoId(
      videoId: videoId,
      autoPlay: true,
      params: const YoutubePlayerParams(
        showControls: true,
        enableJavaScript: true,
        strictRelatedVideos: true,
        playsInline: true,
      ),
    );

    _controller = controller;
    _subscription = controller.stream.listen(_onPlayerValue);
  }

  void _onPlayerValue(YoutubePlayerValue value) {
    if (!mounted) return;

    final ready = value.playerState != PlayerState.unknown;
    final hasError = value.hasError;

    if (ready != _isPlayerReady || hasError != _hasError) {
      setState(() {
        _isPlayerReady = ready;
        _hasError = hasError;
      });
    }
  }

  @override
  void dispose() {
    _subscription?.cancel();
    _controller?.close();
    super.dispose();
  }

  Future<void> _copyLink() async {
    final videoId = _videoId;
    if (videoId == null) return;

    await Clipboard.setData(
      ClipboardData(text: 'https://youtu.be/$videoId'),
    );
    if (!mounted) return;

    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        const SnackBar(content: Text('Tautan video berhasil disalin.')),
      );
  }

  void _retry() {
    final controller = _controller;
    final videoId = _videoId;
    if (controller == null || videoId == null) return;

    setState(() {
      _hasError = false;
      _isPlayerReady = false;
    });
    controller.loadVideoById(videoId: videoId);
  }

  @override
  Widget build(BuildContext context) {
    final video = widget.video;
    final controller = _controller;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        leading: IconButton(
          tooltip: 'Kembali',
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 19),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text('Kajian Online'),
      ),
      body: SafeArea(
        top: false,
        child: ContentWidth(
          maxWidth: 720,
          child: ListView(
            padding: const EdgeInsets.fromLTRB(20, 6, 20, 28),
            children: [
              if (controller == null || _videoId == null)
                const _InvalidVideoCard()
              else
                _PlayerCard(
                  controller: controller,
                  isReady: _isPlayerReady,
                  hasError: _hasError,
                  onRetry: _retry,
                ),
              const SizedBox(height: 20),
              Text(
                video.account.toUpperCase(),
                style: AppText.overline.copyWith(color: AppColors.sage600),
              ),
              const SizedBox(height: 7),
              Text(video.title, style: AppText.h1),
              const SizedBox(height: 12),
              Row(
                children: [
                  const IconBadge(
                    icon: Icons.person_outline_rounded,
                    size: 36,
                    iconSize: 18,
                    background: AppColors.sage50,
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          video.ustadz,
                          style: AppText.bodyStrong.copyWith(fontSize: 13.5),
                        ),
                        const SizedBox(height: 1),
                        Text(
                          video.account,
                          style: AppText.caption.copyWith(fontSize: 10.5),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              const Divider(),
              const SizedBox(height: 18),
              Text(
                'TENTANG KAJIAN',
                style: AppText.overline.copyWith(fontSize: 9.5),
              ),
              const SizedBox(height: 8),
              Text(
                video.description,
                style: AppText.body.copyWith(height: 1.75),
              ),
              const SizedBox(height: 22),
              OutlinedButton.icon(
                onPressed: controller == null ? null : _copyLink,
                icon: const Icon(Icons.link_rounded, size: 18),
                label: const Text('Salin Tautan Video'),
              ),
              const SizedBox(height: 16),
              const _PlaybackNote(),
            ],
          ),
        ),
      ),
    );
  }
}

class _PlayerCard extends StatelessWidget {
  const _PlayerCard({
    required this.controller,
    required this.isReady,
    required this.hasError,
    required this.onRetry,
  });

  final YoutubePlayerController controller;
  final bool isReady;
  final bool hasError;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(22),
      child: DecoratedBox(
        decoration: const BoxDecoration(color: Colors.black),
        child: AspectRatio(
          aspectRatio: 16 / 9,
          child: Stack(
            fit: StackFit.expand,
            children: [
              YoutubePlayer(
                controller: controller,
                aspectRatio: 16 / 9,
                backgroundColor: Colors.black,
              ),
              if (!isReady && !hasError)
                Positioned.fill(
                  child: ColoredBox(
                    color: Colors.black.withValues(alpha: 0.55),
                    child: const Center(
                      child: SizedBox(
                        height: 26,
                        width: 26,
                        child: CircularProgressIndicator(
                          strokeWidth: 2.4,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
              if (hasError)
                Positioned.fill(
                  child: ColoredBox(
                    color: Colors.black.withValues(alpha: 0.82),
                    child: Center(
                      child: Padding(
                        padding: const EdgeInsets.all(22),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(
                              Icons.wifi_off_rounded,
                              size: 30,
                              color: Colors.white70,
                            ),
                            const SizedBox(height: 10),
                            Text(
                              'Video tidak dapat diputar',
                              textAlign: TextAlign.center,
                              style: AppText.bodyStrong.copyWith(
                                color: Colors.white,
                                fontSize: 14,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Periksa koneksi internet, lalu coba lagi.',
                              textAlign: TextAlign.center,
                              style: AppText.caption.copyWith(
                                color: Colors.white70,
                              ),
                            ),
                            const SizedBox(height: 14),
                            FilledButton(
                              onPressed: onRetry,
                              style: FilledButton.styleFrom(
                                backgroundColor: Colors.white,
                                foregroundColor: AppColors.sage900,
                                minimumSize: const Size(0, 40),
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 18,
                                ),
                              ),
                              child: const Text(
                                'Coba Lagi',
                                style: TextStyle(fontSize: 12.5),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _InvalidVideoCard extends StatelessWidget {
  const _InvalidVideoCard();

  @override
  Widget build(BuildContext context) {
    return AppCard(
      color: AppColors.errorSoft,
      borderColor: AppColors.error.withValues(alpha: 0.16),
      elevated: false,
      padding: const EdgeInsets.all(18),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const IconBadge(
            icon: Icons.link_off_rounded,
            size: 42,
            iconSize: 20,
            background: Color(0xFFFFE3DF),
            foreground: AppColors.error,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Tautan video tidak valid',
                  style: AppText.h3.copyWith(
                    fontSize: 15,
                    color: AppColors.error,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Video ini belum dapat diputar karena tautannya tidak '
                  'dikenali. Silakan kembali dan pilih kajian lain.',
                  style: AppText.body.copyWith(fontSize: 12.5),
                ),
                const SizedBox(height: 10),
                OutlinedButton(
                  onPressed: () => Navigator.of(context).pop(),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.error,
                    side: BorderSide(
                      color: AppColors.error.withValues(alpha: 0.35),
                    ),
                    minimumSize: const Size(0, 40),
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                  ),
                  child: const Text(
                    'Kembali ke Daftar',
                    style: TextStyle(fontSize: 12.5),
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

class _PlaybackNote extends StatelessWidget {
  const _PlaybackNote();

  @override
  Widget build(BuildContext context) {
    return AppCard(
      color: AppColors.sage50,
      borderColor: AppColors.sage100,
      elevated: false,
      padding: const EdgeInsets.all(14),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.info_outline_rounded,
            size: 16,
            color: AppColors.sage600,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              'Pemutaran video memerlukan koneksi internet. Gunakan tombol '
              'layar penuh pada pemutar untuk pengalaman menonton yang lebih '
              'leluasa.',
              style: AppText.caption.copyWith(
                fontSize: 10.5,
                height: 1.5,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
