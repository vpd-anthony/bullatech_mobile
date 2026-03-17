import 'package:flutter/material.dart';

class DrawerItem {
  final String title;
  final IconData inactiveIcon;
  final IconData activeIcon;
  final String route;
  final List<DrawerItem>? children;

  DrawerItem({
    required this.title,
    required this.inactiveIcon,
    required this.activeIcon,
    required this.route,
    this.children,
  });
}
