import 'package:freezed_annotation/freezed_annotation.dart';

part 'company_model.freezed.dart';
part 'company_model.g.dart';

@freezed
class CompanyModel with _$CompanyModel {
  const factory CompanyModel({
    required final int id,
    required final String name,
    required final String email,
    final String? website,
    final String? apiUrl,
    final String? logo,
    final String? logoUrl,
    @JsonKey(name: 'address_1') final String? address1,
    @JsonKey(name: 'address_2') final String? address2,
    final String? city,
    final String? state,
    final String? zip,
    final String? country,
    final String? phone,
    final String? description,
    final DateTime? deletedAt,
    required final DateTime createdAt,
    required final DateTime updatedAt,
  }) = _CompanyModel;
  factory CompanyModel.fromJson(final Map<String, dynamic> json) =>
      _$CompanyModelFromJson(json);
}
