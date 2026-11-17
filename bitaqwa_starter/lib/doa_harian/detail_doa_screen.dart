import 'package:bitaqwa/core/theme/app_colors.dart';
import 'package:bitaqwa/core/theme/app_theme.dart';
import 'package:bitaqwa/core/widgets/app_card.dart';
import 'package:bitaqwa/core/widgets/content_width.dart';
import 'package:bitaqwa/data/bookmark_store.dart';
import 'package:bitaqwa/doa_harian/doa_model.dart';
import 'package:bitaqwa/doa_harian/kategori_doa_enum.dart';
import 'package:bitaqwa/doa_harian/kategori_doa_ext.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Halaman baca satu doa lengkap: Arab, Latin, arti, dan sumber.
class DetailDoaScreen extends StatelessWidget {
  const DetailDoaScreen({super.key, required this.doa, this.category});

  final Doa doa;
  final DoaCategory? category;

  String _shareText() {
    return '${doa.title}\n\n'
        '${doa.arabicText}\n\n'
        'Latin: ${doa.latin}\n\n'
        'Artinya: ${doa.translation}\n\n'
        'Sumber: ${doa.reference}\n'
        '— Bitaqwa';
  }

  Future<void> _copy(BuildContext context) async {
    await Clipboard.setData(ClipboardData(text: _shareText()));
    if (!context.mounted) return;
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        const SnackBar(content: Text('Doa berhasil disalin.')),
      );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        leading: IconButton(
          tooltip: 'Kembali',
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 19),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text('Doa Harian'),
      ),
      body: SafeArea(
        top: false,
        child: ContentWidth(
          maxWidth: 720,
          child: ListView(
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 28),
            children: [
              if (category != null) ...[
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 5,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.sage100,
                    borderRadius: BorderRadius.circular(9),
                  ),
                  child: Text(
                    category!.title.toUpperCase(),
                    style: AppText.overline.copyWith(
                      color: AppColors.sage700,
                      fontSize: 9,
                    ),
                  ),
                ),
                const SizedBox(height: 12),
              ],
              Text(doa.title, style: AppText.h1),
              const SizedBox(height: 20),
              _SectionCard(
                label: 'Teks Arab',
                icon: Icons.auto_stories_rounded,
                color: AppColors.sage50,
                borderColor: AppColors.sage100,
                child: Directionality(
                  textDirection: TextDirection.rtl,
                  child: SelectableText(
                    doa.arabicText,
                    textAlign: TextAlign.right,
                    style: AppText.arabic,
                  ),
                ),
              ),
              const SizedBox(height: 12),
              _SectionCard(
                label: 'Latin',
                icon: Icons.record_voice_over_rounded,
                child: SelectableText(
                  doa.latin,
                  style: AppText.body.copyWith(
                    color: AppColors.textPrimary,
                    fontStyle: FontStyle.italic,
                    height: 1.7,
                  ),
                ),
              ),
              const SizedBox(height: 12),
              _SectionCard(
                label: 'Artinya',
                icon: Icons.translate_rounded,
                child: SelectableText(
                  doa.translation,
                  style: AppText.body.copyWith(
                    color: AppColors.textPrimary,
                    height: 1.7,
                  ),
                ),
              ),
              const SizedBox(height: 12),
              _SectionCard(
                label: 'Sumber',
                icon: Icons.verified_rounded,
                color: AppColors.goldSoft,
                borderColor: AppColors.gold.withValues(alpha: 0.18),
                child: Text(
                  doa.reference,
                  style: AppText.body.copyWith(
                    color: AppColors.textSecondary,
                    fontSize: 13,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: _DetailActions(
        doaTitle: doa.title,
        onCopy: () => _copy(context),
      ),
    );
  }
}

class _SectionCard extends StatelessWidget {
  const _SectionCard({
    required this.label,
    required this.icon,
    required this.child,
    this.color,
    this.borderColor,
  });

  final String label;
  final IconData icon;
  final Widget child;
  final Color? color;
  final Color? borderColor;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      color: color,
      borderColor: borderColor,
      elevated: false,
      padding: const EdgeInsets.all(18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 16, color: AppColors.sage600),
              const SizedBox(width: 7),
              Text(
                label.toUpperCase(),
                style: AppText.overline.copyWith(
                  color: AppColors.sage600,
                  fontSize: 9.5,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          child,
        ],
      ),
    );
  }
}

class _DetailActions extends StatelessWidget {
  const _DetailActions({required this.doaTitle, required this.onCopy});

  final String doaTitle;
  final VoidCallback onCopy;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 10, 20, 12),
        child: Center(
          heightFactor: 1,
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 720),
            child: AnimatedBuilder(
              animation: BookmarkStore.instance,
              builder: (context, _) {
                final saved = BookmarkStore.instance.contains(doaTitle);
                return Row(
                  children: [
                    Expanded(
                      child: FilledButton.icon(
                        onPressed: () =>
                            BookmarkStore.instance.toggle(doaTitle),
                        style: FilledButton.styleFrom(
                          backgroundColor: saved
                              ? AppColors.sage100
                              : AppColors.sage800,
                          foregroundColor: saved
                              ? AppColors.sage800
                              : Colors.white,
                          side: saved
                              ? const BorderSide(color: AppColors.sage200)
                              : BorderSide.none,
                        ),
                        icon: Icon(
                          saved
                              ? Icons.bookmark_rounded
                              : Icons.bookmark_add_outlined,
                          size: 19,
                        ),
                        label: Text(saved ? 'Tersimpan' : 'Simpan Doa'),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: onCopy,
                        icon: const Icon(Icons.copy_rounded, size: 18),
                        label: const Text('Salin'),
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
