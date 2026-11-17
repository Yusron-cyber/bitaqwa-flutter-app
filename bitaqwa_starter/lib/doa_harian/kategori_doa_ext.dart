import 'package:bitaqwa/doa_harian/kategori_doa_enum.dart';
import 'package:flutter/material.dart';

/// Data presentasi untuk setiap kategori doa.
extension DoaCategoryExtension on DoaCategory {
  String get title {
    switch (this) {
      case DoaCategory.makananMinuman:
        return 'Makanan & Minuman';
      case DoaCategory.pagiMalam:
        return 'Pagi & Malam';
      case DoaCategory.rumah:
        return 'Rumah';
      case DoaCategory.perjalanan:
        return 'Perjalanan';
      case DoaCategory.sholat:
        return 'Sholat';
      case DoaCategory.etikaBaik:
        return 'Etika Baik';
    }
  }

  String get description {
    switch (this) {
      case DoaCategory.makananMinuman:
        return 'Sebelum dan sesudah makan';
      case DoaCategory.pagiMalam:
        return 'Dzikir pagi dan petang';
      case DoaCategory.rumah:
        return 'Aktivitas di rumah';
      case DoaCategory.perjalanan:
        return 'Safar dan bepergian';
      case DoaCategory.sholat:
        return 'Wudhu dan masjid';
      case DoaCategory.etikaBaik:
        return 'Adab dan akhlak';
    }
  }

  String get image {
    switch (this) {
      case DoaCategory.makananMinuman:
        return 'assets/images/ic_doa_makanan_minuman.png';
      case DoaCategory.pagiMalam:
        return 'assets/images/ic_doa_pagi_malam.png';
      case DoaCategory.rumah:
        return 'assets/images/ic_doa_rumah.png';
      case DoaCategory.perjalanan:
        return 'assets/images/ic_doa_perjalanan.png';
      case DoaCategory.sholat:
        return 'assets/images/ic_doa_sholat.png';
      case DoaCategory.etikaBaik:
        return 'assets/images/ic_doa_etika_baik.png';
    }
  }

  IconData get icon {
    switch (this) {
      case DoaCategory.makananMinuman:
        return Icons.restaurant_rounded;
      case DoaCategory.pagiMalam:
        return Icons.dark_mode_rounded;
      case DoaCategory.rumah:
        return Icons.home_rounded;
      case DoaCategory.perjalanan:
        return Icons.explore_rounded;
      case DoaCategory.sholat:
        return Icons.mosque_rounded;
      case DoaCategory.etikaBaik:
        return Icons.handshake_rounded;
    }
  }
}
