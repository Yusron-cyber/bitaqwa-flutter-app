import 'package:intl/intl.dart';

/// Format tanggal dan sapaan berbahasa Indonesia.
///
/// Memakai intl bila data locale sudah dimuat, dengan fallback manual agar
/// dashboard tetap tampil benar pada kondisi awal aplikasi.
abstract final class IndonesianDate {
  static const List<String> _weekdays = [
    'Senin',
    'Selasa',
    'Rabu',
    'Kamis',
    'Jumat',
    'Sabtu',
    'Minggu',
  ];

  static const List<String> _months = [
    'Januari',
    'Februari',
    'Maret',
    'April',
    'Mei',
    'Juni',
    'Juli',
    'Agustus',
    'September',
    'Oktober',
    'November',
    'Desember',
  ];

  static const List<String> _monthsShort = [
    'Jan',
    'Feb',
    'Mar',
    'Apr',
    'Mei',
    'Jun',
    'Jul',
    'Agu',
    'Sep',
    'Okt',
    'Nov',
    'Des',
  ];

  static String fullDate(DateTime date) {
    try {
      return DateFormat('EEEE, d MMMM yyyy', 'id_ID').format(date);
    } catch (_) {
      return '${_weekdays[date.weekday - 1]}, ${date.day} '
          '${_months[date.month - 1]} ${date.year}';
    }
  }

  static String shortDate(DateTime date) {
    try {
      return DateFormat('EEE, d MMM', 'id_ID').format(date);
    } catch (_) {
      return '${_weekdays[date.weekday - 1].substring(0, 3)}, '
          '${date.day} ${_monthsShort[date.month - 1]}';
    }
  }

  static String dayNumber(DateTime date) => '${date.day}';

  static String monthShort(DateTime date) {
    try {
      return DateFormat('MMM', 'id_ID').format(date);
    } catch (_) {
      return _monthsShort[date.month - 1];
    }
  }

  static String greeting(DateTime time) {
    final hour = time.hour;
    if (hour >= 4 && hour < 11) return 'Selamat pagi';
    if (hour >= 11 && hour < 15) return 'Selamat siang';
    if (hour >= 15 && hour < 18) return 'Selamat sore';
    return 'Selamat malam';
  }

  static String prayerDay(DateTime date) {
    try {
      return DateFormat('EEEE, d MMMM', 'id_ID').format(date);
    } catch (_) {
      return '${_weekdays[date.weekday - 1]}, ${date.day} '
          '${_months[date.month - 1]}';
    }
  }
}
