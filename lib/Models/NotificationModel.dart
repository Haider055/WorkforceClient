import 'package:get/get.dart';

class NotificationModel {
  String? id;
  String? type;
  String? title;
  String? body;
  String? jobPostingId;
  String? serviceName;
  String? location;
  String? dataCreatedAt;
  String? actionUrl;
  String? actionText;
  String? readAt;
  String? createdAt;
  String? humanReadableCreatedAt;
  RxBool isRead = false.obs;

  NotificationModel({
    this.id,
    this.type,
    this.title,
    this.body,
    this.jobPostingId,
    this.serviceName,
    this.location,
    this.dataCreatedAt,
    this.actionUrl,
    this.actionText,
    this.readAt,
    this.createdAt,
    this.humanReadableCreatedAt,
    bool isRead = false, // ✅ normal bool here
  }) {
    this.isRead.value = isRead;
  }

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    final data = json['data'] ?? {};
    return NotificationModel(
      id: json['id'],
      type: json['type'],
      title: json['title'],
      body: json['body'],
      jobPostingId: data['job_posting_id'],
      serviceName: data['service_name'],
      location: data['location'],
      dataCreatedAt: data['created_at'],
      actionUrl: json['action_url'],
      actionText: json['action_text'],
      readAt: json['read_at'],
      createdAt: json['created_at'],
      humanReadableCreatedAt: json['human_readable_created_at'],
      isRead: json['is_read'],
    );
  }
}
