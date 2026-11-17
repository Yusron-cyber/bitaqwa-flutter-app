import 'package:bitaqwa/core/theme/app_colors.dart';
import 'package:bitaqwa/core/theme/app_theme.dart';
import 'package:bitaqwa/core/widgets/app_card.dart';
import 'package:bitaqwa/core/widgets/content_width.dart';
import 'package:bitaqwa/core/widgets/screen_header.dart';
import 'package:bitaqwa/zakat/zakat_logic.dart';
import 'package:bitaqwa/zakat/zakat_result_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Kalkulator Zakat Mal.
///
/// Logika perhitungan tetap memakai [ZakatLogic] (nisab 85 gram emas dan kadar
/// 2,5%). Halaman ini hanya menambah validasi, rincian hasil, dan penjelasan
/// agar pengguna memahami angka yang ditampilkan.
class ZakatScreen extends StatefulWidget {
  const ZakatScreen({super.key});

  @override
  State<ZakatScreen> createState() => _ZakatScreenState();
}

class _ZakatScreenState extends State<ZakatScreen> {
  static const double _defaultHargaEmas = 1400000;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final TextEditingController _totalHartaController = TextEditingController();
  final TextEditingController _hargaEmasController = TextEditingController(
    text: _formatRupiah(_defaultHargaEmas),
  );

  bool _sudahDihitung = false;
  bool _wajibZakat = false;
  double _totalHarta = 0;
  double _hargaEmas = 0;
  double _batasNisab = 0;
  double _nominalZakat = 0;

  static String _formatRupiah(num value) {
    final digits = value.round().toString();
    final buffer = StringBuffer();
    for (var index = 0; index < digits.length; index++) {
      if (index > 0 && (digits.length - index) % 3 == 0) {
        buffer.write('.');
      }
      buffer.write(digits[index]);
    }
    return buffer.toString();
  }

  static double _parseRupiah(String text) {
    final digits = text.replaceAll(RegExp(r'[^0-9]'), '');
    if (digits.isEmpty) return 0;
    return double.tryParse(digits) ?? 0;
  }

  @override
  void dispose() {
    _totalHartaController.dispose();
    _hargaEmasController.dispose();
    super.dispose();
  }

  void _onInputChanged(String _) {
    setState(() {
      _sudahDihitung = false;
      _wajibZakat = false;
      _totalHarta = 0;
      _hargaEmas = 0;
      _batasNisab = 0;
      _nominalZakat = 0;
    });
  }

  void _hitungZakat() {
    FocusScope.of(context).unfocus();

    if (!(_formKey.currentState?.validate() ?? false)) return;

    final totalHarta = _parseRupiah(_totalHartaController.text);
    final hargaEmas = _parseRupiah(_hargaEmasController.text);
    final batasNisab = ZakatLogic.hitungNisabRupiah(hargaEmas);
    final wajib = ZakatLogic.apakahWajibZakat(
      totalHarta: totalHarta,
      hargaEmasPerGram: hargaEmas,
    );

    setState(() {
      _sudahDihitung = true;
      _wajibZakat = wajib;
      _totalHarta = totalHarta;
      _hargaEmas = hargaEmas;
      _batasNisab = batasNisab;
      _nominalZakat = wajib ? ZakatLogic.hitungZakat(totalHarta) : 0.0;
    });
  }

  void _reset() {
    FocusScope.of(context).unfocus();
    _formKey.currentState?.reset();
    _totalHartaController.clear();
    _hargaEmasController.text = _formatRupiah(_defaultHargaEmas);

    setState(() {
      _sudahDihitung = false;
      _wajibZakat = false;
      _totalHarta = 0;
      _hargaEmas = 0;
      _batasNisab = 0;
      _nominalZakat = 0;
    });
  }

  String? _validateHarta(String? _) {
    if (_parseRupiah(_totalHartaController.text) <= 0) {
      return 'Masukkan total harta lebih dari Rp 0.';
    }
    return null;
  }

  String? _validateHargaEmas(String? _) {
    if (_parseRupiah(_hargaEmasController.text) <= 0) {
      return 'Masukkan harga emas per gram lebih dari Rp 0.';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final previewNisab = _parseRupiah(_hargaEmasController.text);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        bottom: false,
        child: ContentWidth(
          maxWidth: 760,
          child: ListView(
            padding: const EdgeInsets.fromLTRB(20, 14, 20, 130),
            keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
            children: [
              const ScreenHeader(
                title: 'Zakat Mal',
                subtitle: 'Hitung kewajiban zakat harta dengan jelas',
              ),
              const SizedBox(height: 20),
              const _ZakatSummaryBanner(),
              const SizedBox(height: 18),
              AppCard(
                padding: const EdgeInsets.all(20),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Data Harta', style: AppText.h3),
                      const SizedBox(height: 4),
                      Text(
                        'Gabungkan tabungan, emas, dan aset lain yang '
                        'dimiliki. Gunakan nilai wajar saat ini.',
                        style: AppText.caption.copyWith(height: 1.5),
                      ),
                      const SizedBox(height: 18),
                      _FieldLabel(
                        label: 'Total Harta',
                        hint: 'Tabungan, emas, dan aset',
                      ),
                      const SizedBox(height: 7),
                      TextFormField(
                        controller: _totalHartaController,
                        keyboardType: TextInputType.number,
                        textInputAction: TextInputAction.next,
                        inputFormatters: const [_RupiahInputFormatter()],
                        validator: _validateHarta,
                        onChanged: _onInputChanged,
                        style: AppText.bodyStrong.copyWith(fontSize: 16),
                        decoration: const InputDecoration(
                          prefixText: 'Rp ',
                          hintText: '0',
                        ),
                      ),
                      const SizedBox(height: 18),
                      _FieldLabel(
                        label: 'Harga Emas per Gram',
                        hint: 'Sesuaikan harga pasar hari ini',
                      ),
                      const SizedBox(height: 7),
                      TextFormField(
                        controller: _hargaEmasController,
                        keyboardType: TextInputType.number,
                        textInputAction: TextInputAction.done,
                        inputFormatters: const [_RupiahInputFormatter()],
                        validator: _validateHargaEmas,
                        onChanged: _onInputChanged,
                        onFieldSubmitted: (_) => _hitungZakat(),
                        style: AppText.bodyStrong.copyWith(fontSize: 16),
                        decoration: const InputDecoration(
                          prefixText: 'Rp ',
                          hintText: '0',
                        ),
                      ),
                      const SizedBox(height: 14),
                      _NisabPreview(hargaEmas: previewNisab),
                      const SizedBox(height: 18),
                      Row(
                        children: [
                          Expanded(
                            child: FilledButton.icon(
                              onPressed: _hitungZakat,
                              icon: const Icon(
                                Icons.calculate_rounded,
                                size: 19,
                              ),
                              label: const Text('Hitung Zakat'),
                            ),
                          ),
                          const SizedBox(width: 10),
                          OutlinedButton(
                            onPressed: _reset,
                            style: OutlinedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                              ),
                              minimumSize: const Size(0, 52),
                            ),
                            child: const Icon(
                              Icons.refresh_rounded,
                              size: 20,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 18),
              ZakatResultCard(
                sudahDihitung: _sudahDihitung,
                wajibZakat: _wajibZakat,
                totalHarta: _totalHarta,
                hargaEmasPerGram: _hargaEmas,
                batasNisab: _batasNisab,
                nominalZakat: _nominalZakat,
              ),
              const SizedBox(height: 16),
              const _ZakatNote(),
            ],
          ),
        ),
      ),
    );
  }
}

class _FieldLabel extends StatelessWidget {
  const _FieldLabel({required this.label, required this.hint});

  final String label;
  final String hint;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Expanded(
          child: Text(
            label,
            style: AppText.label.copyWith(
              color: AppColors.textPrimary,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        const SizedBox(width: 10),
        Flexible(
          child: Text(
            hint,
            textAlign: TextAlign.right,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppText.caption.copyWith(fontSize: 10),
          ),
        ),
      ],
    );
  }
}

class _NisabPreview extends StatelessWidget {
  const _NisabPreview({required this.hargaEmas});

  final double hargaEmas;

  @override
  Widget build(BuildContext context) {
    final nisab = hargaEmas > 0
        ? ZakatLogic.hitungNisabRupiah(hargaEmas)
        : 0.0;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 10),
      decoration: BoxDecoration(
        color: AppColors.sage50,
        borderRadius: BorderRadius.circular(13),
        border: Border.all(color: AppColors.sage100),
      ),
      child: Row(
        children: [
          const Icon(
            Icons.straighten_rounded,
            size: 15,
            color: AppColors.sage600,
          ),
          const SizedBox(width: 7),
          Expanded(
            child: Text(
              'Batas nisab saat ini',
              style: AppText.caption.copyWith(
                fontSize: 11,
                color: AppColors.textSecondary,
              ),
            ),
          ),
          Text(
            nisab > 0 ? ZakatLogic.formatRupiah(nisab) : '—',
            style: AppText.bodyStrong.copyWith(
              fontSize: 12.5,
              color: AppColors.sage800,
            ),
          ),
        ],
      ),
    );
  }
}

class _ZakatSummaryBanner extends StatelessWidget {
  const _ZakatSummaryBanner();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
      decoration: BoxDecoration(
        color: AppColors.sage800,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: AppColors.sage900.withValues(alpha: 0.14),
            blurRadius: 24,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'NISAB ZAKAT MAL',
                  style: AppText.overline.copyWith(
                    color: Colors.white54,
                    fontSize: 9,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '85 gram emas',
                  style: AppText.h3.copyWith(
                    color: Colors.white,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ),
          Container(
            width: 1,
            height: 38,
            color: Colors.white.withValues(alpha: 0.12),
          ),
          const SizedBox(width: 18),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'KADAR ZAKAT',
                style: AppText.overline.copyWith(
                  color: Colors.white54,
                  fontSize: 9,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                '2,5%',
                style: AppText.h3.copyWith(
                  color: AppColors.gold,
                  fontSize: 16,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ZakatNote extends StatelessWidget {
  const _ZakatNote();

  @override
  Widget build(BuildContext context) {
    return AppCard(
      color: AppColors.surface,
      elevated: false,
      padding: const EdgeInsets.all(15),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.menu_book_rounded,
            size: 17,
            color: AppColors.sage600,
          ),
          const SizedBox(width: 9),
          Expanded(
            child: Text(
              'Zakat mal dihitung dari harta yang telah mencapai nisab dan '
              'dimiliki selama satu tahun (haul). Hasil kalkulator ini '
              'bersifat bantuan hitung, bukan pengganti nasihat amil zakat.',
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

/// Memformat ketikan angka menjadi rupiah dengan pemisah ribuan.
///
/// Dibuat sendiri agar input tetap aman saat dikosongkan pengguna.
class _RupiahInputFormatter extends TextInputFormatter {
  const _RupiahInputFormatter();

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final digits = newValue.text.replaceAll(RegExp(r'[^0-9]'), '');
    if (digits.isEmpty) {
      return const TextEditingValue(
        text: '',
        selection: TextSelection.collapsed(offset: 0),
      );
    }

    final withoutLeadingZeros = digits.replaceFirst(RegExp(r'^0+'), '');
    final normalized =
        withoutLeadingZeros.isEmpty ? '0' : withoutLeadingZeros;
    final buffer = StringBuffer();
    for (var index = 0; index < normalized.length; index++) {
      if (index > 0 && (normalized.length - index) % 3 == 0) {
        buffer.write('.');
      }
      buffer.write(normalized[index]);
    }

    final text = buffer.toString();
    return TextEditingValue(
      text: text,
      selection: TextSelection.collapsed(offset: text.length),
    );
  }
}
