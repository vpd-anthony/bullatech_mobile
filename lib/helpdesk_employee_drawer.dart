import 'package:bullatech/common/widget/drawer/drawer_item.dart';
import 'package:bullatech/common/widget/drawer/dynamic_drawer_items.dart';
import 'package:bullatech/core/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class HelpdeskEmployeeDrawer extends ConsumerStatefulWidget {
  const HelpdeskEmployeeDrawer({super.key});

  @override
  ConsumerState<HelpdeskEmployeeDrawer> createState() =>
      _HelpdeskEmployeeDrawerState();
}

class _HelpdeskEmployeeDrawerState
    extends ConsumerState<HelpdeskEmployeeDrawer> {
  late final ValueNotifier<String> activeRoute;

  @override
  void initState() {
    super.initState();

    final routeInfo = GoRouter.of(context).routeInformationProvider;

    // Initialize with the current path
    activeRoute = ValueNotifier(routeInfo.value.uri.path);

    // Listen for updates
    routeInfo.addListener(() {
      final currentPath = routeInfo.value.uri.path;
      if (activeRoute.value != currentPath) {
        activeRoute.value = currentPath;
      }
    });
  }

  @override
  void dispose() {
    activeRoute.dispose();
    super.dispose();
  }

  @override
  Widget build(final BuildContext context) {
    // Drawer items
    final mainDrawerItems = <DrawerItem>[
      DrawerItem(
        title: 'Ticket List',
        inactiveIcon: Icons.dashboard_outlined,
        activeIcon: Icons.dashboard,
        route: '/helpdesk/employee/ticket-list',
      ),
    ];

    return Drawer(
      backgroundColor: AppColors.backgroundWhite,
      surfaceTintColor: AppColors.backgroundWhite,
      child: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 20),
            Image.asset(
              'assets/images/bullacrave.png',
              height: 80,
            ),
            const SizedBox(height: 20),

            /// 🔼 Main menu (scrollable)
            Expanded(
              child: ValueListenableBuilder<String>(
                valueListenable: activeRoute,
                builder: (final context, final currentRoute, final _) {
                  return SingleChildScrollView(
                    child: DynamicDrawerItems(
                      items: mainDrawerItems,
                      activeRoute: currentRoute,
                      onRouteChanged: (final route) {
                        activeRoute.value = route;
                        context.go(route);
                      },
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
