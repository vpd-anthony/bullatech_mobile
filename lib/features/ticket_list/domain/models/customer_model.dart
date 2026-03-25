import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter/foundation.dart';

part 'customer_model.freezed.dart';
part 'customer_model.g.dart';

@freezed
class Customer with _$Customer {
  const factory Customer({
    required final int id,
    final String? mobileNo,
    required final String name,
    final String? email,
  }) = _Customer;
  factory Customer.fromJson(final Map<String, dynamic> json) =>
      _$CustomerFromJson(json);
}
