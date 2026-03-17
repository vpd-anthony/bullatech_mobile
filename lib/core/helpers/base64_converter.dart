import 'dart:convert';
import 'dart:typed_data';
import 'package:freezed_annotation/freezed_annotation.dart';

class Base64Converter implements JsonConverter<Uint8List?, String?> {
  const Base64Converter();

  @override
  Uint8List? fromJson(final String? json) {
    if (json == null) return null;
    try {
      // If it's a data URI (e.g. "data:image/png;base64,..."), strip the prefix
      final base64Str = json.contains(',') ? json.split(',').last : json;
      return base64Decode(base64Str);
    } catch (e) {
      return null;
    }
  }

  @override
  String? toJson(final Uint8List? object) =>
      object != null ? base64Encode(object) : null;
}
