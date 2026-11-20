import 'package:get/get.dart';
import 'package:workforceclientapp/Models/ServiceArea.dart';
import 'package:workforceclientapp/Models/TradesmenProfile.dart';

class TradesmenRequest {
  int? id;
  int? jobPostingId;
  TradesmenRequestJobPosting? jobPosting;
  String? jobTitle;
  String? jobStatus;
  TradesmenRequestChat? chat;
  int? chatId;
  int? userId;
  String? userName;
  String? userProfileImg;
  String? userProfileImgThumbnail;
  String? memberSince;
  TradesmenProfile? tradesmenProfile;
  ServiceArea? serviceArea;
  int? reviewsCount;
  String? rating;
  String? coverLetter;
  String? status;
  bool fromRequest;
  String? createdAt;
  String? humanReadableCreatedAt;
  String? updatedAt;
  String? humanReadableUpdatedAt;
  RxString loadingValue = "".obs;

  TradesmenRequest({
    this.id,
    this.jobPostingId,
    this.jobPosting,
    this.jobTitle,
    this.jobStatus,
    this.chat,
    this.chatId,
    this.userId,
    this.userName,
    this.userProfileImg,
    this.userProfileImgThumbnail,
    this.memberSince,
    this.tradesmenProfile,
    this.serviceArea,
    this.reviewsCount,
    this.rating,
    this.coverLetter,
    this.status,
    this.fromRequest = false,
    this.createdAt,
    this.humanReadableCreatedAt,
    this.updatedAt,
    this.humanReadableUpdatedAt,
  });

  factory TradesmenRequest.fromJson(Map<String, dynamic> json) {
    final Map<String, dynamic>? user = json['user'];
    final Map<String, dynamic>? jobPostingJson = json['job_posting'];
    final Map<String, dynamic>? chatJson = json['chat'];

    return TradesmenRequest(
      id: json['id'],
      jobPostingId: json['job_posting_id'] ?? jobPostingJson?['id'],
      jobPosting: jobPostingJson != null
          ? TradesmenRequestJobPosting.fromJson(jobPostingJson)
          : null,
      jobTitle: jobPostingJson?['title'],
      jobStatus: jobPostingJson?['status'],
      chat: chatJson != null ? TradesmenRequestChat.fromJson(chatJson) : null,
      chatId: chatJson?['id'],
      userId: json['user_id'] ?? user?['id'],
      userName: user?['name'],
      userProfileImg: user?['profile_img'],
      userProfileImgThumbnail: user?['profile_img_thumbnail'],
      memberSince: user?['member_since']?.toString(),
      tradesmenProfile: user?['trade_person_profile'] != null
          ? TradesmenProfile.fromJson(user!['trade_person_profile'])
          : null,
      serviceArea: user?['service_area'] != null
          ? ServiceArea.fromJson(user!['service_area'])
          : null,
      reviewsCount: _toInt(user?['reviews_count']) ?? 0,
      rating: user?['rating']?.toString() ?? "0",
      coverLetter: json['cover_letter'],
      status: json['status'],
      fromRequest: _toBool(json['from_request']),
      createdAt: json['created_at'],
      humanReadableCreatedAt: json['human_readable_created_at'],
      updatedAt: json['updated_at'],
      humanReadableUpdatedAt: json['human_readable_updated_at'],
    );
  }
}

class TradesmenRequestJobPosting {
  int? id;
  String? title;
  String? description;
  String? location;
  double? lat;
  double? lng;
  String? city;
  String? state;
  String? country;
  String? postcode;
  String? status;
  bool boosted;
  int? userId;
  bool isSaved;
  List<String> attachments;
  bool showAttachments;
  double? distance;
  String? createdAt;
  String? humanReadableCreatedAt;

  TradesmenRequestJobPosting({
    this.id,
    this.title,
    this.description,
    this.location,
    this.lat,
    this.lng,
    this.city,
    this.state,
    this.country,
    this.postcode,
    this.status,
    this.boosted = false,
    this.userId,
    this.isSaved = false,
    this.attachments = const [],
    this.showAttachments = false,
    this.distance,
    this.createdAt,
    this.humanReadableCreatedAt,
  });

  factory TradesmenRequestJobPosting.fromJson(Map<String, dynamic> json) {
    final dynamic rawAttachments = json['attachments'];
    return TradesmenRequestJobPosting(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      location: json['location'],
      lat: _toDouble(json['lat']),
      lng: _toDouble(json['lng']),
      city: json['city'],
      state: json['state'],
      country: json['country'],
      postcode: json['postcode']?.toString(),
      status: json['status'],
      boosted: _toBool(json['boosted']),
      userId: _toInt(json['user_id']),
      isSaved: _toBool(json['is_saved']),
      attachments: rawAttachments is List
          ? rawAttachments.whereType<String>().toList()
          : [],
      showAttachments: _toBool(json['show_attachments']),
      distance: _toDouble(json['distance']),
      createdAt: json['created_at'],
      humanReadableCreatedAt: json['human_readable_created_at'],
    );
  }
}

class TradesmenRequestChat {
  int? id;
  int? jobApplicationId;
  String? title;
  DateTime? createdAt;
  DateTime? updatedAt;
  DateTime? latestActivityAt;

  TradesmenRequestChat({
    this.id,
    this.jobApplicationId,
    this.title,
    this.createdAt,
    this.updatedAt,
    this.latestActivityAt,
  });

  factory TradesmenRequestChat.fromJson(Map<String, dynamic> json) {
    return TradesmenRequestChat(
      id: json['id'],
      jobApplicationId: _toInt(json['job_application_id']),
      title: json['title'],
      createdAt: _toDateTime(json['created_at']),
      updatedAt: _toDateTime(json['updated_at']),
      latestActivityAt: _toDateTime(json['latest_activity_at']),
    );
  }
}

int? _toInt(dynamic value) {
  if (value == null) return null;
  if (value is int) return value;
  if (value is num) return value.toInt();
  return int.tryParse(value.toString());
}

double? _toDouble(dynamic value) {
  if (value == null) return null;
  if (value is num) return value.toDouble();
  return double.tryParse(value.toString());
}

bool _toBool(dynamic value) {
  if (value is bool) return value;
  if (value is num) return value == 1;
  if (value is String) return value == "1" || value.toLowerCase() == "true";
  return false;
}

DateTime? _toDateTime(dynamic value) {
  if (value == null) return null;
  return DateTime.tryParse(value.toString())?.toLocal();
}
