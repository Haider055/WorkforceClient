class Pagination2 {
  final String? nextCursor;
  final String? nextPage;
  final String? previousCursor;
  final bool? hasMore;

  Pagination2({
    this.nextCursor,
    this.nextPage,
    this.previousCursor,
    this.hasMore,
  });

  factory Pagination2.fromJson(Map<String, dynamic> json) {
    return Pagination2(
      nextCursor: json['next_cursor'],
      nextPage: json['next_page'],
      previousCursor: json['previous_cursor'],
      hasMore: json['has_more'],
    );
  }
}
