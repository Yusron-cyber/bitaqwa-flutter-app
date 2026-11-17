import 'package:bitaqwa/core/theme/app_theme.dart';
import 'package:flutter/material.dart';

/// Header untuk halaman utama di dalam tab (tanpa tombol kembali).
class ScreenHeader extends StatelessWidget {
  const ScreenHeader({
    super.key,
    required this.title,
    this.subtitle,
    this.eyebrow,
    this.trailing,
  });

  final String title;
  final String? subtitle;
  final String? eyebrow;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (eyebrow != null) ...[
                Text(eyebrow!.toUpperCase(), style: AppText.overline),
                const SizedBox(height: 6),
              ],
              Text(title, style: AppText.h1),
              if (subtitle != null) ...[
                const SizedBox(height: 5),
                Text(subtitle!, style: AppText.body),
              ],
            ],
          ),
        ),
        if (trailing != null) ...[const SizedBox(width: 14), trailing!],
      ],
    );
  }
}
