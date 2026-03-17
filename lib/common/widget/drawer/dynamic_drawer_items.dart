import 'package:bullatech/core/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'drawer_item.dart';

class DynamicDrawerItems extends StatelessWidget {
  final List<DrawerItem> items;
  final String activeRoute;
  final void Function(String route) onRouteChanged;

  const DynamicDrawerItems({
    super.key,
    required this.items,
    required this.activeRoute,
    required this.onRouteChanged,
  });

  bool _isActive(final String route) => route == activeRoute;

  Widget _buildItem(final BuildContext context, final DrawerItem item) {
    final isActive = _isActive(item.route);

    return ListTile(
      leading: Icon(
        isActive ? item.activeIcon : item.inactiveIcon,
        color: AppColors.textPrimary,
      ),
      title: Text(
        item.title,
        style: TextStyle(
          fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
        ),
      ),
      onTap: () {
        if (item.route.isNotEmpty) {
          context.go(item.route);
          onRouteChanged(item.route);
        }
        Navigator.pop(context);
      },
    );
  }

  @override
  Widget build(final BuildContext context) {
    return Column(
      children: items.map((final item) {
        final hasChildren = item.children != null && item.children!.isNotEmpty;

        if (hasChildren) {
          final expanded =
              item.children!.any((final child) => _isActive(child.route));

          return ExpansionTile(
            initiallyExpanded: expanded,
            leading: Icon(item.inactiveIcon, color: AppColors.primaryDark),
            title: Text(
              item.title,
              style: TextStyle(
                fontWeight: expanded ? FontWeight.bold : FontWeight.normal,
                color: expanded ? AppColors.primaryDark : AppColors.textPrimary,
              ),
            ),
            childrenPadding: const EdgeInsets.only(left: 24),
            trailing: Icon(
              expanded ? Icons.expand_less : Icons.expand_more,
              color: AppColors.primaryDark,
            ),
            children: item.children!
                .map((final child) => _buildItem(context, child))
                .toList(),
          );
        }

        return _buildItem(context, item);
      }).toList(),
    );
  }
}
