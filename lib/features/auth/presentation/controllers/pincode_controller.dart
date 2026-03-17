import 'package:bullatech/core/notifiers/auth_status_notifier.dart';
import 'package:bullatech/core/notifiers/idle_timer_notifier.dart';
import 'package:bullatech/features/auth/presentation/providers/pincode_providers.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'pincode_controller.g.dart';

@riverpod
class PincodeController extends _$PincodeController {
  @override
  FutureOr<bool?> build() => null;

  /// Setup new pincode
  Future<bool> setupPincode(final String pincode) async {
    try {
      // Save the pincode
      final isValid =
          await ref.read(pincodeServiceProvider).setupPincode(pincode);

      // Authenticate if successful
      if (isValid) {
        await ref.read(authStatusNotifierProvider.notifier).authenticated();
        ref.read(idleTimerNotifierProvider.notifier).start();
      }

      // Set the state to success
      state = AsyncValue.data(isValid);

      return isValid;
    } catch (e, st) {
      state = AsyncValue.error(e, st);
      return false;
    }
  }

  /// Verify pincode
  Future<bool> verifyPincode(final String pincode) async {
    try {
      // Check pincode
      final isValid = await ref.read(pincodeServiceProvider).login(pincode);

      // Only authenticate if valid
      if (isValid) {
        await ref.read(authStatusNotifierProvider.notifier).authenticated();
        ref.read(idleTimerNotifierProvider.notifier).start();
      }

      // Update state once
      state = AsyncValue.data(isValid);

      return isValid;
    } catch (e, st) {
      state = AsyncValue.error(e, st);
      return false;
    }
  }

  /// Delete pincode
  Future<void> deletePincode() async {
    state = const AsyncValue.loading();

    try {
      await ref.read(pincodeServiceProvider).deletePincode();
      state = const AsyncValue.data(true);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }
}
