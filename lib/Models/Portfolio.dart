class Portfolio {
  int? id;
  String? title;
  String? desc;
  List<String>? imageList = [];

  Portfolio({
    this.id,
    this.title,
    this.desc,
    this.imageList,
  });

  factory Portfolio.fromJson(Map<String, dynamic> json) {
    return Portfolio(
      id: json['id'],
      title: json['title'],
      desc: json['description'],
      // API returns images as objects: [{"id": 4, "url": "https://..."}].
      // Also accept plain URL strings in case the shape changes back.
      imageList: (json['images'] as List? ?? [])
          .map((img) => img is Map ? img['url']?.toString() : img?.toString())
          .whereType<String>()
          .toList(),
    );
  }
}
