import 'package:get/get.dart';
import 'package:workforceclientapp/Models/Message.dart';

class Chat {
  int? id;
  int? jobApplicationId;
  int? jobPostingId;
  RxInt unreadCount;
  String? jobTitle;
  String? serviceName;
  String? jobDesc;
  int? tradesmenId;
  String? tradesmenName;
  String? jobStatus;
  String? applicationStatus;
  bool? isVerified = true;
  String? profileImg;
  String? memberSince;
  Message? lastMessage;

  Chat(
      {required this.id,
      required this.jobApplicationId,
      required this.jobPostingId,
      required this.unreadCount,
      required this.jobTitle,
      required this.jobDesc,
      required this.jobStatus,
      required this.applicationStatus,
      required this.isVerified,
      required this.lastMessage,
      required this.serviceName,
      required this.tradesmenId,
      required this.tradesmenName,
      required this.profileImg,
      required this.memberSince});

  factory Chat.fromJson(Map<String, dynamic> json) {
    return Chat(
      id: json['id'],
      unreadCount: ((json['unread_count'] ?? 0) as int).obs,
      jobApplicationId: json['job_application_id'],
      jobPostingId: json['job_application']['job_posting_id'],
      jobTitle: json['title'],
      jobDesc: json['job_application']['job_posting']['description'],
      isVerified: true,
      serviceName: "Master Painter (Interior)",
      lastMessage: json['latest_message'] == null
          ? null
          : Message.fromJson(json['latest_message']),
      jobStatus: json['job_application']['job_posting']['status'],
      applicationStatus: json['job_application']['status'],
      tradesmenId: json['job_application']['user_id'],
      tradesmenName: json['job_application']['user']['name'],
      profileImg: json['job_application']['user']['profile_img'],
      memberSince: json['job_application']['user']['member_since'],
    );
  }
}
