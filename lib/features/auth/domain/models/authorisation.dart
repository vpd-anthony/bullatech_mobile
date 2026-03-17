import 'package:freezed_annotation/freezed_annotation.dart';

part 'authorisation.freezed.dart';
part 'authorisation.g.dart';

@freezed
class Authorisation with _$Authorisation {
  const factory Authorisation({
    required final String token,
    required final String type,
  }) = _Authorisation;
  factory Authorisation.fromJson(final Map<String, dynamic> json) =>
      _$AuthorisationFromJson(json);
}
