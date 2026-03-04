import 'package:workforceclientapp/Models/IconObj.dart';

class Services {
  int? id;
  String? name;
  String? slug;
  IconObj? icon;

  Services({
    this.id,
    this.name,
    this.slug,
    this.icon,
  });

  factory Services.fromJson(Map<String, dynamic> json) {
    return Services(
        id: json['id'],
        name: json['name'],
        slug: json['slug'],
        icon: json['icon'] != null ? IconObj.fromJson(json['icon']) : null);
  }
}
