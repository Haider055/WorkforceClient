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
      imageList: List<String>.from(json['images']),
    );
  }
}
