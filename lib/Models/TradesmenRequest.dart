import 'package:get/get.dart';
import 'package:workforceclientapp/Models/ServiceArea.dart';

class TradesmenRequest {
  int? id;
  int? jobPostingId;
  int? userId;
  String? userName;
  String? userProfileImg;
  String? coverLetter;
  String? status;
  String? humanReadableCreatedAt;
  ServiceArea? serviceArea;
  int? reviewsCount;
  String? rating;
  RxString loadingValue = "".obs;
  int? chatId;

  TradesmenRequest({
    this.id,
    this.jobPostingId,
    this.userId,
    this.chatId,
    this.userName,
    this.userProfileImg,
    this.coverLetter,
    this.status,
    this.serviceArea,
    this.humanReadableCreatedAt,
    this.reviewsCount,
    this.rating,
  });

  factory TradesmenRequest.fromJson(Map<String, dynamic> json) {
    return TradesmenRequest(
      id: json['id'],
      jobPostingId: json['job_posting_id'],
      userId: json['user_id'],
      userName: json['user']['name'],
      userProfileImg: json['user']['profile_img'],
      coverLetter: json['cover_letter'],
      chatId: json['chat'] != null ? json['chat']['id'] : null,
      status: json['status'],
      serviceArea: json['user']['service_area'] != null
          ? ServiceArea.fromJson(json['user']['service_area'])
          : null,
      humanReadableCreatedAt: json['human_readable_created_at'],
      reviewsCount: json['user']['reviews_count'] ?? "0",
      rating: json['user']['rating'] ?? "0",
    );
  }
}
