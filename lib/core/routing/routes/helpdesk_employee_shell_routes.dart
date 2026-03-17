import 'package:bullatech/common/layouts/helpdesk_employee_scaffold.dart';
import 'package:bullatech/features/ticket_list/presentation/screens/ticket_list_screen.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class HelpdeskEmployeeShellRoutes {
  static ShellRoute get route {
    return ShellRoute(
      builder: (final context, final state, final child) {
        return HelpdeskEmployeeScaffold(child: child);
      },
      routes: [
        GoRoute(
          path: '/helpdesk/employee/ticket-list',
          pageBuilder: (final context, final state) => MaterialPage(
            key: state.pageKey,
            child: const TicketListScreen(),
          ),
        ),
      ],
    );
  }
}
