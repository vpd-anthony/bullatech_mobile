import 'package:freezed_annotation/freezed_annotation.dart';

part 'customer_account_model.freezed.dart';
part 'customer_account_model.g.dart';

@freezed
class CustomerAccountModel with _$CustomerAccountModel {
  const factory CustomerAccountModel({
    required final int id,
    required final int customerId,
    required final bool isPasswordExpired,
    final String? createdAt,
    final String? updatedAt,
  }) = _CustomerAccountModel;
  factory CustomerAccountModel.fromJson(final Map<String, dynamic> json) =>
      _$CustomerAccountModelFromJson(json);
}
