import 'package:bullatech/core/theme/app_colors.dart';
import 'package:bullatech/core/utils/exit_handler.dart';
import 'package:bullatech/core/utils/idle_timer_utils.dart';
import 'package:bullatech/helpdesk_employee_drawer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HelpdeskEmployeeScaffold extends ConsumerStatefulWidget {
  final Widget child;

  const HelpdeskEmployeeScaffold({super.key, required this.child});

  @override
  ConsumerState<HelpdeskEmployeeScaffold> createState() =>
      _HelpdeskEmployeeScaffoldState();
}

class _HelpdeskEmployeeScaffoldState
    extends ConsumerState<HelpdeskEmployeeScaffold> {
  final ValueNotifier<String> activeRoute =
      ValueNotifier<String>('/helpdesk/employee/ticket-list');

  @override
  Widget build(final BuildContext context) {
    return WillPopScope(
      onWillPop: () => ExitHandler.showExitDialog(context),
      child: Listener(
        behavior: HitTestBehavior.translucent,
        onPointerDown: (final _) => IdleTimerUtils.resetIdleTimer(ref),
        onPointerMove: (final _) => IdleTimerUtils.resetIdleTimer(ref),
        child: Scaffold(
          appBar: PreferredSize(
            preferredSize: const Size.fromHeight(80),
            child: Container(
              decoration: const BoxDecoration(
                color: AppColors.backgroundWhite,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(15),
                  bottomRight: Radius.circular(15),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Color.fromRGBO(0, 0, 0, 0.15),
                    offset: Offset(0, 3),
                    blurRadius: 2,
                  ),
                ],
              ),
              child: SafeArea(
                child: Builder(
                  builder: (final context) => Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.menu,
                            color: AppColors.textPrimary),
                        onPressed: () {
                          Scaffold.of(context).openDrawer();
                        },
                      ),
                      Expanded(
                        child: Center(
                          child: Image.asset(
                            'assets/images/bullacrave.png',
                            width: 80,
                            height: 80,
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),
                      const SizedBox(width: 48),
                    ],
                  ),
                ),
              ),
            ),
          ),
          drawer: ValueListenableBuilder<String>(
            valueListenable: activeRoute,
            builder: (final context, final currentRoute, final _) {
              return const HelpdeskEmployeeDrawer();
            },
          ),
          body: widget.child,
        ),
      ),
    );
  }
}
