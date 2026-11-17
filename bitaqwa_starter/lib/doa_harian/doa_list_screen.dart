import 'package:bitaqwa/core/theme/app_colors.dart';
import 'package:bitaqwa/core/theme/app_theme.dart';
import 'package:bitaqwa/core/widgets/app_card.dart';
import 'package:bitaqwa/core/widgets/content_width.dart';
import 'package:bitaqwa/core/widgets/status_views.dart';
import 'package:bitaqwa/doa_harian/doa_data.dart';
import 'package:bitaqwa/doa_harian/detail_doa_screen.dart';
import 'package:bitaqwa/doa_harian/kategori_doa_enum.dart';
import 'package:bitaqwa/doa_harian/kategori_doa_ext.dart';
import 'package:bitaqwa/doa_harian/widgets/doa_tile.dart';
import 'package:flutter/material.dart';

/// Daftar doa di dalam satu kategori.
class DoaListScreen extends StatelessWidget {
  const DoaListScreen({super.key, required this.category});

  final DoaCategory category;

  @override
  Widget build(BuildContext context) {
    final doas = doaData[category] ?? const [];

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        leading: IconButton(
          tooltip: 'Kembali',
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 19),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(category.title),
      ),
      body: SafeArea(
        top: false,
        child: ContentWidth(
          maxWidth: 720,
          child: ListView(
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 28),
            children: [
              AppCard(
                color: AppColors.sage50,
                borderColor: AppColors.sage100,
                elevated: false,
                padding: const EdgeInsets.all(18),
                child: Row(
                  children: [
                    IconBadge(
                      icon: category.icon,
                      size: 50,
                      iconSize: 24,
                      background: AppColors.surface,
                      foreground: AppColors.sage700,
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(category.title, style: AppText.h3),
                          const SizedBox(height: 3),
                          Text(
                            '${doas.length} doa · ${category.description}',
                            style: AppText.caption,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 18),
              if (doas.isEmpty)
                const EmptyState(
                  icon: Icons.menu_book_rounded,
                  title: 'Belum ada doa',
                  message: 'Kategori ini belum memiliki doa.',
                )
              else
                for (var index = 0; index < doas.length; index++)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: DoaTile(
                      doa: doas[index],
                      category: category,
                      number: index + 1,
                      showCategory: false,
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute<void>(
                            builder: (_) => DetailDoaScreen(
                              doa: doas[index],
                              category: category,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
            ],
          ),
        ),
      ),
    );
  }
}
