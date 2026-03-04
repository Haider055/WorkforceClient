class User {
  String? id;
  String? name;
  String? email;
  String username = "";
  String? phone;
  bool? emailVerified;
  bool? phoneVerified;
  String profileImg = "";
  bool? isActive;
  String lastLoginAt = "";
  String lastLoginIp = "";
  String timezone = "";
  String? role;
  String? connectsBalance;
  String? token;

  User.fromJson(Map<String, dynamic> json,String Usertoken) {
    id = json['id'];
    name = json['name'];
    email = json['email'];
    phone = json['phone'];
    emailVerified = json['email_verified'];
    phoneVerified = json['phone_verified'];
    profileImg = json['profile_img'];
    username = json['username'];
    isActive = json['is_active'];
    lastLoginAt = json['last_login_at'];
    lastLoginIp = json['last_login_ip'];
    role = json['role'];
    timezone = json['timezone'];
    connectsBalance = json['connects_balance'];
  }
}
