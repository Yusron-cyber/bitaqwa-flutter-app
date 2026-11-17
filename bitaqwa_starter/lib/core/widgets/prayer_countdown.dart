import 'dart:async';

import 'package:bitaqwa/core/theme/app_theme.dart';
import 'package:flutter/material.dart';

/// Angka hitung mundur menuju waktu sholat berikutnya.
///
/// Widget memiliki ticker sendiri agar halaman induk tidak perlu di-rebuild
/// setiap detik. [onFinished] dipanggil sekali ketika hitungan mencapai nol,
/// sehingga halaman dapat menghitung ulang sholat berikutnya.
class PrayerCountdown extends StatefulWidget {
  const PrayerCountdown({
    super.key,
    required this.target,
    this.style,
    this.builder,
    this.onFinished,
    this.showLabels = false,
  });

  final DateTime target;
  final TextStyle? style;
  final Widget Function(BuildContext context, Duration remaining)? builder;
  final VoidCallback? onFinished;
  final bool showLabels;

  @override
  State<PrayerCountdown> createState() => _PrayerCountdownState();
}

class _PrayerCountdownState extends State<PrayerCountdown> {
  Timer? _timer;
  Duration _remaining = Duration.zero;
  bool _notified = false;

  @override
  void initState() {
    super.initState();
    _update();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) => _update());
  }

  @override
  void didUpdateWidget(covariant PrayerCountdown oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.target != widget.target) {
      _notified = false;
      _update();
    }
  }

  void _update() {
    final diff = widget.target.difference(DateTime.now());
    final next = diff.isNegative ? Duration.zero : diff;
    if (!mounted) return;

    final shouldNotify = next == Duration.zero && !_notified;
    if (next != _remaining) {
      setState(() => _remaining = next);
    }
    if (shouldNotify) {
      _notified = true;
      widget.onFinished?.call();
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  String _two(int value) => value.toString().padLeft(2, '0');

  @override
  Widget build(BuildContext context) {
    if (widget.builder != null) {
      return widget.builder!(context, _remaining);
    }

    final hours = _remaining.inHours;
    final minutes = _remaining.inMinutes.remainder(60);
    final seconds = _remaining.inSeconds.remainder(60);

    final style = (widget.style ?? AppText.bodyStrong).copyWith(
      fontFeatures: const [FontFeature.tabularFigures()],
    );

    if (!widget.showLabels) {
      return Text(
        '${_two(hours)}:${_two(minutes)}:${_two(seconds)}',
        style: style,
      );
    }

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        _CountdownUnit(value: _two(hours), label: 'Jam', style: style),
        _CountdownUnit(value: _two(minutes), label: 'Menit', style: style),
        _CountdownUnit(value: _two(seconds), label: 'Detik', style: style),
      ],
    );
  }
}

class _CountdownUnit extends StatelessWidget {
  const _CountdownUnit({
    required this.value,
    required this.label,
    required this.style,
  });

  final String value;
  final String label;
  final TextStyle style;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 14),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(value, style: style),
          const SizedBox(height: 2),
          Text(label, style: AppText.caption.copyWith(fontSize: 10)),
        ],
      ),
    );
  }
}
