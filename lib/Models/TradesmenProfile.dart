class TradesmenProfile {
  int? id;
  String? companyName;
  String? bio;
  String? website;
  String? phone;
  String? companySize;
  String? companyYears;
  String? companyAddress;
  String? postalCode;
  String? companyType;
  bool? isVerified;

  TradesmenProfile(
      {this.id,
      this.companyName,
      this.bio,
      this.website,
      this.phone,
      this.companySize,
      this.companyYears,
      this.companyAddress,
      this.postalCode,
      this.companyType,
      this.isVerified});

  factory TradesmenProfile.fromJson(Map<String, dynamic> json) {
    return TradesmenProfile(
      id: json['id'],
      companyName: json['company_name'],
      bio: json['bio'],
      website: json['website'],
      phone: json['phone'],
      companySize: json['company_size'],
      companyYears: json['company_years'],
      companyAddress: json['company_address'],
      postalCode: json['postal_code'],
      companyType: json['company_type'],
      isVerified: json['is_verified'],
    );
  }
}
