import 'package:bitaqwa/core/theme/app_colors.dart';
import 'package:bitaqwa/core/theme/app_theme.dart';
import 'package:bitaqwa/core/widgets/app_card.dart';
import 'package:bitaqwa/doa_harian/doa_data.dart';
import 'package:bitaqwa/doa_harian/doa_list_screen.dart';
import 'package:bitaqwa/doa_harian/kategori_doa_ext.dart';
import 'package:bitaqwa/doa_harian/kategori_doa_model.dart';
import 'package:flutter/material.dart';

/// Kartu kategori doa pada halaman Doa Harian.
class CardDoa extends StatelessWidget {
  const CardDoa({super.key, required this.doa});

  final KategoriDoaModel doa;

  @override
  Widget build(BuildContext context) {
    final category = doa.category;
    final count = doaCountFor(category);

    return AppCard(
      padding: const EdgeInsets.all(16),
      elevated: false,
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute<void>(
            builder: (_) => DoaListScreen(category: category),
          ),
        );
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              IconBadge(
                icon: category.icon,
                size: 42,
                iconSize: 20,
                background: AppColors.sage50,
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 8,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: AppColors.sage50,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  '$count doa',
                  style: AppText.caption.copyWith(
                    color: AppColors.sage700,
                    fontSize: 10,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
          const Spacer(),
          Text(
            category.title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppText.h3.copyWith(fontSize: 15.5),
          ),
          const SizedBox(height: 3),
          Text(
            category.description,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppText.caption.copyWith(fontSize: 11),
          ),
        ],
      ),
    );
  }
}
