import 'package:bullatech/features/auth/data/datasources/local/pincode_local_datasource.dart';
import 'package:bullatech/features/auth/data/repositories/pincode_repository.dart';

class PincodeRepositoryImpl implements PincodeRepository {
  final PincodeLocalDataSource localDataSource;

  PincodeRepositoryImpl(this.localDataSource);

  @override
  Future<void> savePincode(final String pincode) =>
      localDataSource.savePincode(pincode);

  @override
  Future<String?> getPincode() => localDataSource.getPincode();

  @override
  Future<bool> hasPincode() => localDataSource.hasPincode();

  @override
  Future<bool> verifyPincode(final String inputPincode) =>
      localDataSource.verifyPincode(inputPincode);

  @override
  Future<void> deletePincode() => localDataSource.deletePincode();
}
