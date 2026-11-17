import 'package:bitaqwa/core/theme/app_colors.dart';
import 'package:bitaqwa/core/theme/app_theme.dart';
import 'package:bitaqwa/core/widgets/app_card.dart';
import 'package:bitaqwa/data/bookmark_store.dart';
import 'package:bitaqwa/doa_harian/doa_model.dart';
import 'package:bitaqwa/doa_harian/kategori_doa_enum.dart';
import 'package:bitaqwa/doa_harian/kategori_doa_ext.dart';
import 'package:flutter/material.dart';

/// Baris doa yang dipakai pada daftar kategori, hasil pencarian, dan favorit.
class DoaTile extends StatelessWidget {
  const DoaTile({
    super.key,
    required this.doa,
    required this.category,
    this.number,
    this.showCategory = true,
    this.onTap,
  });

  final Doa doa;
  final DoaCategory category;
  final int? number;
  final bool showCategory;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      padding: const EdgeInsets.fromLTRB(14, 14, 8, 14),
      onTap: onTap,
      elevated: false,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          if (number != null)
            Container(
              height: 34,
              width: 34,
              alignment: Alignment.center,
              decoration: const BoxDecoration(
                color: AppColors.sage50,
                shape: BoxShape.circle,
              ),
              child: Text(
                '$number',
                style: AppText.label.copyWith(
                  color: AppColors.sage700,
                  fontWeight: FontWeight.w600,
                ),
              ),
            )
          else
            IconBadge(
              icon: category.icon,
              size: 42,
              iconSize: 20,
              background: AppColors.sage50,
            ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (showCategory) ...[
                  Text(
                    category.title.toUpperCase(),
                    style: AppText.overline.copyWith(
                      color: AppColors.sage600,
                      fontSize: 9,
                    ),
                  ),
                  const SizedBox(height: 3),
                ],
                Text(
                  doa.title,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: AppText.bodyStrong,
                ),
                const SizedBox(height: 2),
                Text(
                  doa.latin,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppText.caption.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 4),
          AnimatedBuilder(
            animation: BookmarkStore.instance,
            builder: (context, _) {
              final saved = BookmarkStore.instance.contains(doa.title);
              return IconButton(
                tooltip: saved ? 'Hapus dari simpanan' : 'Simpan doa',
                onPressed: () => BookmarkStore.instance.toggle(doa.title),
                icon: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 220),
                  child: Icon(
                    saved
                        ? Icons.bookmark_rounded
                        : Icons.bookmark_border_rounded,
                    key: ValueKey(saved),
                    size: 21,
                    color: saved ? AppColors.sage700 : AppColors.textTertiary,
                  ),
                ),
              );
            },
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
