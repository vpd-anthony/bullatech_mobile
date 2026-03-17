import 'package:bullatech/common/dialogs/error_dialog.dart';
import 'package:bullatech/common/dialogs/loading_dialog.dart';
import 'package:bullatech/common/dialogs/success_dialog.dart';
import 'package:bullatech/core/exceptions/server_exception.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Generic listener for any AsyncValue provider
/// Handles loading, errors, and backend "status": "error" responses
void watchApiWithDialogs<T>({
  required final WidgetRef ref,
  required final ProviderBase<AsyncValue<T>> provider,
  required final BuildContext context,
  final String? loadingMessage,
  final VoidCallback? onRetry,
  final bool showSuccessMessage =
      false, // optional: show success message if status == "success"
}) {
  ref.listen<AsyncValue<T>>(provider, (final previous, final next) {
    // Show loading
    if (next.isLoading) {
      LoadingDialog.show(context, message: loadingMessage ?? 'Loading...');
      return;
    }

    // Hide loading when done
    if (previous?.isLoading == true && !next.isLoading) {
      LoadingDialog.hide(context);
    }

    // Handle actual errors
    next.whenOrNull(
      error: (final error, final _) {
        final message =
            error is ServerException ? error.message : error.toString();
        ErrorDialog.show(
          context,
          message: message,
          onPressed: () {
            Navigator.of(context, rootNavigator: true).pop();
            onRetry?.call();
          },
        );
      },
      data: (final data) {
        // Handle backend status error if the response is TicketSubmissionResponse
        // if (data is TicketSubmissionResponse) {
        //   if (data.status == 'error') {
        //     ErrorDialog.show(
        //       context,
        //       message: data.message,
        //       onPressed: () {
        //         Navigator.of(context, rootNavigator: true).pop();
        //         onRetry?.call();
        //       },
        //     );
        //   } else if (showSuccessMessage && data.status == 'success') {
        //     SuccessDialog.show(context, message: data.message);
        //   }
        // }
      },
    );
  });
}
