import 'package:freezed_annotation/freezed_annotation.dart';

part 'pagination_data.freezed.dart';
part 'pagination_data.g.dart';

@freezed
class PaginationData with _$PaginationData {
  const factory PaginationData({
    required final int total,
    required final int perPage,
    required final int currentPage,
    required final int lastPage,
  }) = _PaginationData;
  factory PaginationData.fromJson(final Map<String, dynamic> json) =>
      _$PaginationDataFromJson(json);
}
