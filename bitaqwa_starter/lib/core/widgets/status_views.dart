import 'package:bitaqwa/core/theme/app_colors.dart';
import 'package:bitaqwa/core/theme/app_theme.dart';
import 'package:bitaqwa/core/widgets/app_card.dart';
import 'package:flutter/material.dart';

/// Tampilan status kosong yang konsisten.
class EmptyState extends StatelessWidget {
  const EmptyState({
    super.key,
    required this.icon,
    required this.title,
    required this.message,
    this.actionLabel,
    this.onAction,
  });

  final IconData icon;
  final String title;
  final String message;
  final String? actionLabel;
  final VoidCallback? onAction;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 30),
      elevated: false,
      child: Column(
        children: [
          IconBadge(
            icon: icon,
            size: 52,
            iconSize: 24,
            background: AppColors.sage50,
            foreground: AppColors.sage600,
          ),
          const SizedBox(height: 14),
          Text(title, style: AppText.h3, textAlign: TextAlign.center),
          const SizedBox(height: 6),
          Text(message, style: AppText.body, textAlign: TextAlign.center),
          if (actionLabel != null && onAction != null) ...[
            const SizedBox(height: 18),
            FilledButton(
              onPressed: onAction,
              style: FilledButton.styleFrom(
                minimumSize: const Size(0, 44),
                padding: const EdgeInsets.symmetric(horizontal: 20),
              ),
              child: Text(actionLabel!),
            ),
          ],
        ],
      ),
    );
  }
}

/// Tampilan error dengan aksi coba lagi dan (opsional) buka pengaturan.
class ErrorStateCard extends StatelessWidget {
  const ErrorStateCard({
    super.key,
    required this.title,
    required this.message,
    this.onRetry,
    this.onOpenSettings,
    this.compact = false,
  });

  final String title;
  final String message;
  final VoidCallback? onRetry;
  final VoidCallback? onOpenSettings;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      color: AppColors.errorSoft,
      borderColor: AppColors.error.withValues(alpha: 0.16),
      elevated: false,
      padding: EdgeInsets.all(compact ? 16 : 20),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const IconBadge(
            icon: Icons.location_off_rounded,
            background: Color(0xFFFFE3DF),
            foreground: AppColors.error,
            size: 42,
            iconSize: 20,
          ),
          const SizedBox(width: 13),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppText.h3.copyWith(fontSize: 15, color: AppColors.error),
                ),
                const SizedBox(height: 4),
                Text(
                  message,
                  style: AppText.body.copyWith(fontSize: 13, height: 1.5),
                ),
                if (onRetry != null || onOpenSettings != null) ...[
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      if (onRetry != null)
                        FilledButton(
                          onPressed: onRetry,
                          style: FilledButton.styleFrom(
                            minimumSize: const Size(0, 40),
                            backgroundColor: AppColors.error,
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                          ),
                          child: const Text('Coba Lagi', style: TextStyle(fontSize: 13)),
                        ),
                      if (onOpenSettings != null)
                        OutlinedButton(
                          onPressed: onOpenSettings,
                          style: OutlinedButton.styleFrom(
                            minimumSize: const Size(0, 40),
                            foregroundColor: AppColors.error,
                            side: BorderSide(
                              color: AppColors.error.withValues(alpha: 0.35),
                            ),
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                          ),
                          child: const Text(
                            'Buka Pengaturan',
                            style: TextStyle(fontSize: 13),
                          ),
                        ),
                    ],
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Indikator loading sederhana dengan pesan.
class LoadingState extends StatelessWidget {
  const LoadingState({super.key, this.message = 'Memuat data…'});

  final String message;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      elevated: false,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 26),
      child: Column(
        children: [
          const SizedBox(
            height: 26,
            width: 26,
            child: CircularProgressIndicator(
              strokeWidth: 2.4,
              color: AppColors.sage600,
            ),
          ),
          const SizedBox(height: 14),
          Text(message, style: AppText.body, textAlign: TextAlign.center),
        ],
      ),
    );
  }
}
