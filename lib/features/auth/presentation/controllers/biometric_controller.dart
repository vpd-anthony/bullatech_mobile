import 'package:bullatech/core/notifiers/auth_status_notifier.dart';
import 'package:bullatech/core/notifiers/idle_timer_notifier.dart';
import 'package:bullatech/features/auth/presentation/providers/biometric_providers.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'biometric_controller.g.dart';

@riverpod
class BiometricController extends _$BiometricController {
  @override
  FutureOr<bool?> build() => null;

  Future<bool> authenticate() async {
    final service = ref.read(biometricServiceProvider);
    final enabled = await service.isBiometricEnabled();
    if (!enabled) return false;

    // authenticate first
    final result = await service.authenticate(
      localizedReason: 'Authenticate to access Bullatech',
    );

    if (result) {
      await ref.read(authStatusNotifierProvider.notifier).authenticated();
      ref.read(idleTimerNotifierProvider.notifier).start();
    }

    // update state for UI, but return the result directly
    state = AsyncValue.data(result);
    return result;
  }

  Future<void> enableBiometric() async {
    final service = ref.read(biometricServiceProvider);
    await service.setBiometricEnabled(true);
  }

  Future<void> disableBiometric() async {
    final service = ref.read(biometricServiceProvider);
    await service.setBiometricEnabled(false);
  }
}
