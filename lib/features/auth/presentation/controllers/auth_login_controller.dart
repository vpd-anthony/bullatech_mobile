import 'package:bullatech/core/notifiers/auth_status_notifier.dart';
import 'package:bullatech/core/notifiers/idle_timer_notifier.dart';
import 'package:bullatech/core/services/notification_service.dart';
import 'package:bullatech/features/auth/data/dtos/login_request_dto.dart';
import 'package:bullatech/features/auth/data/dtos/password_only_login_request_dto.dart';
import 'package:bullatech/features/auth/domain/models/login_response.dart';
import 'package:bullatech/features/auth/presentation/providers/auth_providers.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'auth_login_controller.g.dart';

@riverpod
class AuthLoginController extends _$AuthLoginController {
  @override
  FutureOr<LoginResponse?> build() => null;

  Future<void> login(final LoginRequestDto dto) async {
    state = const AsyncValue.loading();

    state = await AsyncValue.guard(() async {
      final service = ref.read(authServiceProvider);
      final response = await service.login(dto);

      await ref.read(authStatusNotifierProvider.notifier).authenticated();
      // ref.read(idleTimerNotifierProvider.notifier).start();

      await NotificationService.init();
      await NotificationService.requestPermissionWithoutContext();

      return response;
    });
  }

  Future<void> passwordOnlylogin(final PasswordOnlyLoginRequestDto dto) async {
    state = const AsyncValue.loading();

    state = await AsyncValue.guard(() async {
      final service = ref.read(authServiceProvider);
      final response = await service.passwordOnlylogin(dto);

      await ref.read(authStatusNotifierProvider.notifier).authenticated();
      // ref.read(idleTimerNotifierProvider.notifier).start();

      return response;
    });
  }

  void reset() {
    state = const AsyncValue.data(null);
  }
}
