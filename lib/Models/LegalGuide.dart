class LegalGuide {
  String? slug;
  String? title;
  String? url;

  LegalGuide({this.slug, this.title, this.url});

  factory LegalGuide.fromJson(Map<String, dynamic> json) {
    return LegalGuide(
      slug: json['slug'],
      title: json['title'],
      url: json['url'],
    );
  }
}
