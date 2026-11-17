import 'package:bitaqwa/core/navigation/app_routes.dart';
import 'package:bitaqwa/core/theme/app_colors.dart';
import 'package:bitaqwa/dashboard/menu_model.dart';
import 'package:flutter/material.dart';

/// Empat fitur utama Bitaqwa. Rute tetap tersedia sebagai named route,
/// sementara dashboard memakai tabIndex untuk perpindahan tab yang mulus.
const List<MenuModel> menus = [
  MenuModel(
    title: 'Jadwal Sholat',
    subtitle: 'Akurat sesuai lokasi',
    image: 'assets/images/ic_menu_jadwal_sholat.png',
    route: AppRoutes.prayer,
    tabIndex: 1,
    icon: Icons.schedule_rounded,
  ),
  MenuModel(
    title: 'Doa Harian',
    subtitle: 'Kumpulan doa pilihan',
    image: 'assets/images/ic_menu_doa.png',
    route: AppRoutes.doa,
    tabIndex: 2,
    icon: Icons.menu_book_rounded,
  ),
  MenuModel(
    title: 'Kajian Online',
    subtitle: 'Video ceramah pilihan',
    image: 'assets/images/ic_menu_video_kajian.png',
    route: AppRoutes.kajian,
    tabIndex: 3,
    icon: Icons.play_circle_rounded,
  ),
  MenuModel(
    title: 'Zakat Mal',
    subtitle: 'Hitung dengan mudah',
    image: 'assets/images/ic_menu_zakat.png',
    route: AppRoutes.zakat,
    tabIndex: 4,
    icon: Icons.volunteer_activism_rounded,
    tint: AppColors.goldSoft,
    foreground: AppColors.gold,
  ),
];
