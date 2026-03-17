import 'package:bullatech/common/constants/auth_keys.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:uuid/uuid.dart';

class AuthLocalDataSource {
  final FlutterSecureStorage _secureStorage;

  AuthLocalDataSource(this._secureStorage);

  FlutterSecureStorage get storage => _secureStorage;

  /// Save the auth token and its type (user/customer)
  Future<void> saveAuthToken({
    required final String type,
    required final String token,
  }) async {
    await _secureStorage.write(key: AuthKeys.authType, value: type);
    await _secureStorage.write(key: AuthKeys.authToken, value: token);
  }

  /// Read the stored auth token
  Future<String?> getAuthToken() async {
    return await _secureStorage.read(key: AuthKeys.authToken);
  }

  /// Read the stored token type (user/customer)
  Future<String?> getTokenType() async {
    return await _secureStorage.read(key: AuthKeys.authType);
  }

  /// Delete all stored data including tokens and user/customer info
  Future<void> clearAllData() async {
    await _secureStorage.deleteAll();
  }

  /// Check if the user/customer is logged in
  Future<bool> isLoggedIn() async {
    final token = await getAuthToken();
    return token != null && token.isNotEmpty;
  }

  Future<void> saveDeviceId(final String deviceId) async {
    await _secureStorage.write(key: 'device_id', value: deviceId);
  }

  Future<String> getDeviceId() async {
    var deviceId = await _secureStorage.read(key: 'device_id');

    if (deviceId == null) {
      deviceId = const Uuid().v4();
      await saveDeviceId(deviceId);
    }

    return deviceId;
  }
}
