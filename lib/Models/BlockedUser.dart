import 'package:workforceclientapp/Models/Pagination.dart';

class BlockedUser {
  int? id;
  String? name;
  String? profileImg;
  String? memberSince;

  BlockedUser({this.id, this.name, this.profileImg, this.memberSince});

  factory BlockedUser.fromJson(Map<String, dynamic> json) {
    return BlockedUser(
      id: json['id'],
      name: json['name'],
      profileImg: json['profile_img'],
      memberSince: json['member_since'],
    );
  }
}

class BlockedChat {
  int? id;
  int? userId;
  String? reason;
  String? blockedAt;
  BlockedUser? user;

  BlockedChat({
    this.id,
    this.userId,
    this.reason,
    this.blockedAt,
    this.user,
  });

  factory BlockedChat.fromJson(Map<String, dynamic> json) {
    return BlockedChat(
      id: json['id'],
      userId: json['user_id'],
      reason: json['reason'],
      blockedAt: json['blocked_at'],
      user: json['user'] != null ? BlockedUser.fromJson(json['user']) : null,
    );
  }
}

class BlockedChatsList {
  List<BlockedChat> list;
  Pagination? pagination;

  BlockedChatsList({required this.list, this.pagination});
}
