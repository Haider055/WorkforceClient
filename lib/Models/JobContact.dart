import 'package:get/get.dart';

class JobContact {
  int? id;
  String? status;
  int? chatId;
  String? createdAt;
  String? humanReadableCreatedAt;
  String? updatedAt;
  String? humanReadableUpdatedAt;
  JobContactTradesman? tradesman;
  List<JobContactReview> reviews;

  JobContact({
    this.id,
    this.status,
    this.chatId,
    this.createdAt,
    this.humanReadableCreatedAt,
    this.updatedAt,
    this.humanReadableUpdatedAt,
    this.tradesman,
    this.reviews = const [],
  });

  factory JobContact.fromJson(Map<String, dynamic> json) {
    return JobContact(
      id: json['id'],
      status: json['status'],
      chatId: json['chat_id'],
      createdAt: json['created_at'],
      humanReadableCreatedAt: json['human_readable_created_at'],
      updatedAt: json['updated_at'],
      humanReadableUpdatedAt: json['human_readable_updated_at'],
      tradesman: json['tradesman'] == null
          ? null
          : JobContactTradesman.fromJson(json['tradesman']),
      reviews: json['reviews'] == null
          ? []
          : (json['reviews'] as List)
              .map((e) => JobContactReview.fromJson(e))
              .toList(),
    );
  }

  /// The review given to this contact's tradesman, if any.
  JobContactReview? get tradesmanReview {
    if (reviews.isEmpty) return null;
    for (var review in reviews) {
      if (review.revieweeId == tradesman?.id) return review;
    }
    return reviews.first;
  }
}

class JobContactTradesman {
  int? id;
  String? name;
  String? profileImg;
  String? memberSince;
  bool? isVerified;
  String? companyName;
  String? phone;

  JobContactTradesman({
    this.id,
    this.name,
    this.profileImg,
    this.memberSince,
    this.isVerified,
    this.companyName,
    this.phone,
  });

  factory JobContactTradesman.fromJson(Map<String, dynamic> json) {
    Map<String, dynamic>? profile = json['trade_person_profile'];
    return JobContactTradesman(
      id: json['id'],
      name: json['name'],
      profileImg: json['profile_img'],
      memberSince: json['member_since']?.toString(),
      isVerified: profile?['is_verified'],
      companyName: profile?['company_name'],
      phone: profile?['phone'],
    );
  }
}

class JobContactReview {
  int? id;
  int? userId;
  int? revieweeId;
  RxnInt rating;
  RxnString comment;
  RxnString createdAt;
  String? userName;
  String? userProfileImg;

  JobContactReview({
    this.id,
    this.userId,
    this.revieweeId,
    int? rating,
    String? comment,
    String? createdAt,
    this.userName,
    this.userProfileImg,
  })  : rating = RxnInt(rating),
        comment = RxnString(comment),
        createdAt = RxnString(createdAt);

  factory JobContactReview.fromJson(Map<String, dynamic> json) {
    return JobContactReview(
      id: json['id'],
      userId: json['user_id'],
      revieweeId: json['reviewee_id'],
      rating: json['rating'],
      comment: json['comment'],
      createdAt: json['created_at'],
      userName: json['user'] == null ? null : json['user']['name'],
      userProfileImg: json['user'] == null ? null : json['user']['profile_img'],
    );
  }
}
