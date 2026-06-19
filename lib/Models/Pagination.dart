class Pagination {
  int? currentPage;
  int? lastPage;
  int? perPage;
  int? total;
  bool? hasMore;

  Pagination({
    this.currentPage,
    this.lastPage,
    this.perPage,
    this.total,
    this.hasMore,
  });

  factory Pagination.fromJson(Map<String, dynamic> json) {
    return Pagination(
      currentPage: json['current_page'],
      lastPage: json['last_page'],
      perPage: json['per_page'],
      total: json['total'],
      hasMore: json['has_more'] ?? false,
    );
  }
}
