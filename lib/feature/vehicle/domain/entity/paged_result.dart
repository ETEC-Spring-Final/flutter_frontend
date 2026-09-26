/// A single page of results, shaped like the Spring Data `Page` the backend
/// will return once `/vehicles` and `/brands` support paging.
///
/// Pages are zero based, so `page: 0` is the first page and `hasMore` is
/// false once the last page has been handed out.
class PagedResult<T> {
  final List<T> items;

  /// Zero based index of this page.
  final int page;

  /// Maximum number of items a page holds.
  final int size;

  /// Total number of items available across every page, after filtering.
  final int totalItems;

  const PagedResult({
    required this.items,
    required this.page,
    required this.size,
    required this.totalItems,
  });

  /// Splits [source] into the requested page.
  ///
  /// [filter] narrows the source before it is sliced, which is how the brand
  /// filter behaves: the backend would filter and paginate in one query, so
  /// the local simulation does the same in one step.
  factory PagedResult.fromAll(
    List<T> source, {
    required int page,
    required int size,
    bool Function(T item)? filter,
  }) {
    final filtered = filter == null ? source : source.where(filter).toList();

    final start = (page * size).clamp(0, filtered.length);
    final end = (start + size).clamp(0, filtered.length);

    return PagedResult(
      items: filtered.sublist(start, end),
      page: page,
      size: size,
      totalItems: filtered.length,
    );
  }

  bool get hasMore => (page + 1) * size < totalItems;

  int get totalPages {
    if (size <= 0) return 0;

    return ((totalItems + size - 1) ~/ size);
  }

  /// Appends [next] to this page, keeping the totals of the later page.
  PagedResult<T> append(PagedResult<T> next) {
    return PagedResult(
      items: [...items, ...next.items],
      page: next.page,
      size: next.size,
      totalItems: next.totalItems,
    );
  }

  @override
  bool operator ==(Object other) {
    return other is PagedResult<T> &&
        other.page == page &&
        other.size == size &&
        other.totalItems == totalItems &&
        other.items.length == items.length;
  }

  @override
  int get hashCode => Object.hash(items.length, page, size, totalItems);
}
