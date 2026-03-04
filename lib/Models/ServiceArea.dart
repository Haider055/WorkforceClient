class ServiceArea {
  int? id;
  int? userId;
  String? country;
  String? city;
  String? postcode;
  double? latitude;
  double? longitude;
  int? radius;

  ServiceArea(
      {this.id,
      this.userId,
      this.country,
      this.city,
      this.postcode,
      this.latitude,
      this.longitude,
      this.radius});

  factory ServiceArea.fromJson(Map<String, dynamic> json) {
    return ServiceArea(
      id: json['id'],
      userId: json['user_id'],
      country: json['country'],
      city: json['city'],
      postcode: json['postcode'],
      latitude: (json['latitude'] as num?)?.toDouble(),
      longitude: (json['longitude'] as num?)?.toDouble(),
      radius: json['radius'],
    );
  }
}
