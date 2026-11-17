import 'package:flutter/material.dart';

/// Model menu akses cepat pada dashboard.
class MenuModel {
  final String title;
  final String subtitle;
  final String image;
  final String route;
  final int tabIndex;
  final IconData icon;
  final Color tint;
  final Color foreground;

  const MenuModel({
    required this.title,
    required this.subtitle,
    required this.image,
    required this.route,
    required this.tabIndex,
    required this.icon,
    this.tint = const Color(0xFFE7EFE3),
    this.foreground = const Color(0xFF47634F),
  });
}
