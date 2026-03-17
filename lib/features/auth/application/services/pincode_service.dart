import 'package:bullatech/features/auth/data/repositories/pincode_repository.dart';

class PincodeService {
  final PincodeRepository repository;

  PincodeService(this.repository);

  Future<bool> setupPincode(final String newPincode) async {
    await repository.savePincode(newPincode);

    return true;
  }

  Future<String?> getPincode() => repository.getPincode();

  Future<bool> login(final String inputPincode) async {
    final savedPincode = await repository.getPincode();

    final isCorrect = (savedPincode?.trim() ?? '') == inputPincode.trim();

    return isCorrect;
  }

  /// Check if pincode exists
  Future<bool> hasPincode() => repository.hasPincode();

  /// Delete the current pincode
  Future<void> deletePincode() => repository.deletePincode();
}
