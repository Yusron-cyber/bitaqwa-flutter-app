import 'package:bitaqwa/core/theme/app_colors.dart';
import 'package:bitaqwa/core/theme/app_theme.dart';
import 'package:bitaqwa/core/widgets/content_width.dart';
import 'package:bitaqwa/core/widgets/screen_header.dart';
import 'package:bitaqwa/core/widgets/section_header.dart';
import 'package:bitaqwa/core/widgets/status_views.dart';
import 'package:bitaqwa/data/bookmark_store.dart';
import 'package:bitaqwa/doa_harian/card_doa.dart';
import 'package:bitaqwa/doa_harian/doa_data.dart';
import 'package:bitaqwa/doa_harian/detail_doa_screen.dart';
import 'package:bitaqwa/doa_harian/kategori_doa_data.dart';
import 'package:bitaqwa/doa_harian/kategori_doa_ext.dart';
import 'package:bitaqwa/doa_harian/widgets/doa_tile.dart';
import 'package:flutter/material.dart';

/// Halaman Doa Harian: kategori, pencarian, dan doa yang disimpan.
class DoaScreen extends StatefulWidget {
  const DoaScreen({super.key});

  @override
  State<DoaScreen> createState() => _DoaScreenState();
}

class _DoaScreenState extends State<DoaScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _query = '';
  bool _savedOnly = false;
  bool _showAll = false;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<DoaEntry> _matchingEntries() {
    final normalized = _query.trim().toLowerCase();
    var entries = allDoaEntries;

    if (_savedOnly) {
      entries = entries
          .where((entry) => BookmarkStore.instance.contains(entry.doa.title))
          .toList();
    }

    if (normalized.isNotEmpty) {
      entries = entries.where((entry) {
        final doa = entry.doa;
        return doa.title.toLowerCase().contains(normalized) ||
            doa.latin.toLowerCase().contains(normalized) ||
            doa.translation.toLowerCase().contains(normalized) ||
            entry.category.title.toLowerCase().contains(normalized);
      }).toList();
    }

    return entries;
  }

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
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        bottom: false,
        child: ContentWidth(
          maxWidth: 760,
          child: AnimatedBuilder(
            animation: BookmarkStore.instance,
            builder: (context, _) {
              final showResults = _query.trim().isNotEmpty || _savedOnly;
              final results = _matchingEntries();

              return ListView(
                padding: const EdgeInsets.fromLTRB(20, 12, 20, 130),
                keyboardDismissBehavior:
                    ScrollViewKeyboardDismissBehavior.onDrag,
                children: [
                  ScreenHeader(
                    title: 'Doa Harian',
                    subtitle:
                        '${allDoaEntries.length} doa · ${doaCategoryData.length} kategori',
                    trailing: _SavedButton(
                      count: BookmarkStore.instance.count,
                      active: _savedOnly,
                      onTap: () {
                        setState(() => _savedOnly = !_savedOnly);
                      },
                    ),
                  ),
                  const SizedBox(height: 20),
                  _SearchField(
                    controller: _searchController,
                    onChanged: (value) => setState(() => _query = value),
                    onClear: () {
                      _searchController.clear();
                      setState(() => _query = '');
                    },
                  ),
                  const SizedBox(height: 12),
                  _SegmentedFilter(
                    savedOnly: _savedOnly,
                    savedCount: BookmarkStore.instance.count,
                    onChanged: (saved) {
                      setState(() => _savedOnly = saved);
                    },
                  ),
                  const SizedBox(height: 22),
                  if (showResults) ...[
                    SectionHeader(
                      title: _savedOnly ? 'Doa Disimpan' : 'Hasil Pencarian',
                      subtitle: _savedOnly
                          ? '${results.length} doa tersimpan di perangkat ini'
                          : '${results.length} doa cocok dengan pencarian',
                    ),
                    const SizedBox(height: 12),
                    if (results.isEmpty)
                      _savedOnly
                          ? EmptyState(
                              icon: Icons.bookmark_border_rounded,
                              title: 'Belum ada doa tersimpan',
                              message:
                                  'Simpan doa yang sering dibaca dengan menekan '
                                  'ikon bookmark pada daftar doa.',
                              actionLabel: 'Jelajahi Kategori',
                              onAction: () {
                                setState(() => _savedOnly = false);
                              },
                            )
                          : EmptyState(
                              icon: Icons.search_off_rounded,
                              title: 'Doa tidak ditemukan',
                              message:
                                  'Coba kata kunci lain, misalnya "makan", '
                                  '"perjalanan", atau "tidur".',
                              actionLabel: 'Hapus Pencarian',
                              onAction: () {
                                _searchController.clear();
                                setState(() => _query = '');
                              },
                            )
                    else
                      ...results.map(
                        (entry) => Padding(
                          padding: const EdgeInsets.only(bottom: 10),
                          child: DoaTile(
                            doa: entry.doa,
                            category: entry.category,
                            onTap: () => _openDoa(entry),
                          ),
                        ),
                      ),
                  ] else ...[
                    const SectionHeader(
                      title: 'Kategori Doa',
                      subtitle: 'Pilih kategori untuk melihat kumpulan doa',
                    ),
                    const SizedBox(height: 12),
                    GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: doaCategoryData.length,
                      gridDelegate:
                          const SliverGridDelegateWithMaxCrossAxisExtent(
                            maxCrossAxisExtent: 270,
                            mainAxisExtent: 150,
                            crossAxisSpacing: 12,
                            mainAxisSpacing: 12,
                          ),
                      itemBuilder: (context, index) {
                        return CardDoa(doa: doaCategoryData[index]);
                      },
                    ),
                    const SizedBox(height: 26),
                    SectionHeader(
                      title: 'Semua Doa',
                      subtitle: '${allDoaEntries.length} doa dalam Al-Qur\'an '
                          'dan Sunnah',
                      actionLabel: _showAll ? 'Ringkas' : 'Lihat semua',
                      onAction: () {
                        setState(() => _showAll = !_showAll);
                      },
                    ),
                    const SizedBox(height: 12),
                    ...(allDoaEntries.take(_showAll ? allDoaEntries.length : 4))
                        .map(
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
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}

class _SearchField extends StatelessWidget {
  const _SearchField({
    required this.controller,
    required this.onChanged,
    required this.onClear,
  });

  final TextEditingController controller;
  final ValueChanged<String> onChanged;
  final VoidCallback onClear;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      onChanged: onChanged,
      textInputAction: TextInputAction.search,
      decoration: InputDecoration(
        hintText: 'Cari doa, latin, atau arti…',
        prefixIcon: const Icon(Icons.search_rounded, size: 21),
        suffixIcon: ValueListenableBuilder<TextEditingValue>(
          valueListenable: controller,
          builder: (context, value, _) {
            if (value.text.isEmpty) return const SizedBox.shrink();
            return IconButton(
              tooltip: 'Hapus pencarian',
              onPressed: onClear,
              icon: const Icon(Icons.close_rounded, size: 19),
            );
          },
        ),
      ),
    );
  }
}

class _SegmentedFilter extends StatelessWidget {
  const _SegmentedFilter({
    required this.savedOnly,
    required this.savedCount,
    required this.onChanged,
  });

  final bool savedOnly;
  final int savedCount;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: AppColors.sage50,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          _Segment(
            label: 'Kategori',
            selected: !savedOnly,
            onTap: () => onChanged(false),
          ),
          _Segment(
            label: savedCount > 0 ? 'Disimpan · $savedCount' : 'Disimpan',
            selected: savedOnly,
            onTap: () => onChanged(true),
          ),
        ],
      ),
    );
  }
}

class _Segment extends StatelessWidget {
  const _Segment({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Semantics(
        button: true,
        selected: selected,
        child: GestureDetector(
          onTap: onTap,
          behavior: HitTestBehavior.opaque,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 220),
            curve: Curves.easeOutCubic,
            height: 40,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: selected ? AppColors.surface : Colors.transparent,
              borderRadius: BorderRadius.circular(11),
              boxShadow: selected
                  ? [
                      BoxShadow(
                        color: AppColors.sage900.withValues(alpha: 0.06),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ]
                  : null,
            ),
            child: Text(
              label,
              style: AppText.label.copyWith(
                fontSize: 12.5,
                fontWeight: selected ? FontWeight.w600 : FontWeight.w400,
                color: selected ? AppColors.sage800 : AppColors.textSecondary,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _SavedButton extends StatelessWidget {
  const _SavedButton({
    required this.count,
    required this.active,
    required this.onTap,
  });

  final int count;
  final bool active;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: 'Doa yang disimpan',
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(18),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 220),
          height: 48,
          width: 48,
          decoration: BoxDecoration(
            color: active ? AppColors.sage100 : AppColors.surface,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColors.border),
          ),
          child: Stack(
            alignment: Alignment.center,
            children: [
              Icon(
                Icons.bookmark_rounded,
                size: 21,
                color: active ? AppColors.sage800 : AppColors.sage600,
              ),
              if (count > 0)
                Positioned(
                  top: 8,
                  right: 8,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 4,
                      vertical: 1,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.sage700,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      '$count',
                      style: AppText.caption.copyWith(
                        color: Colors.white,
                        fontSize: 8,
                        fontWeight: FontWeight.w600,
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
