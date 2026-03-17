import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class PincodeLocalDataSource {
  final FlutterSecureStorage _secureStorage;

  PincodeLocalDataSource(this._secureStorage);

  static const _keyPincode = 'customer_pincode';

  /// Save pincode
  Future<void> savePincode(final String pincode) async {
    await _secureStorage.write(key: _keyPincode, value: pincode);
  }

  /// Get saved pincode
  Future<String?> getPincode() async {
    return await _secureStorage.read(key: _keyPincode);
  }

  /// Check if pincode exists
  Future<bool> hasPincode() async {
    final pincode = await getPincode();
    return pincode != null && pincode.isNotEmpty;
  }

  /// Verify pincode
  Future<bool> verifyPincode(final String inputPincode) async {
    final savedPincode = await getPincode();
    return savedPincode == inputPincode;
  }

  /// Delete pincode
  Future<void> deletePincode() async {
    await _secureStorage.delete(key: _keyPincode);
  }
}
