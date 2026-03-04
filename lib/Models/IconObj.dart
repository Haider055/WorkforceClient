class IconObj {
  int? id;
  String? name;
  String? url;

  IconObj({required this.id, required this.name, required this.url});

  factory IconObj.fromJson(Map<String, dynamic> json) {
    return IconObj(
      id: json['id'],
      name: json['name'],
      url: json['url'],
    );
  }
}
