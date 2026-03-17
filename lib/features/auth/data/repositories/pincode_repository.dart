abstract class PincodeRepository {
  Future<void> savePincode(final String pincode);
  Future<String?> getPincode();
  Future<bool> hasPincode();
  Future<bool> verifyPincode(final String inputPincode);
  Future<void> deletePincode();
}
