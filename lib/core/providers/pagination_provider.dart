import 'package:bullatech/common/constants/pagination_constant.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'pagination_provider.g.dart';

@Riverpod(keepAlive: true)
class Paginationv2CurrentPage extends _$Paginationv2CurrentPage {
  @override
  int build(final String key) => PaginationConstant.defaultPaginationPage;

  void setPage(final int page) => state = page;
}

@Riverpod(keepAlive: true)
class Paginationv2ItemsPerPage extends _$Paginationv2ItemsPerPage {
  @override
  int build(final String key) => PaginationConstant.paginationDefaultItems;

  void setItemsPerPage(final int itemsPerPage) => state = itemsPerPage;
}
