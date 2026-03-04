import 'package:get/get.dart';

class NotificationPreference {
  int? id;
  String? type;
  RxBool emailEnabled;
  RxBool pushEnabled;
  String? title;
  String? description;

  NotificationPreference({
    this.id,
    this.type,
    bool emailEnabled = false,
    bool pushEnabled = false,
    this.title,
    this.description,
  })  : emailEnabled = emailEnabled.obs,
        pushEnabled = pushEnabled.obs;

  factory NotificationPreference.fromJson(Map<String, dynamic> json) {
    return NotificationPreference(
      id: json['id'],
      type: json['type'],
      emailEnabled: json['email_enabled'] ?? false,
      pushEnabled: json['push_enabled'] ?? false,
      title: json['title'],
      description: json['description'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'type': type,
      'email_enabled': emailEnabled.value,
      'push_enabled': pushEnabled.value,
      'title': title,
      'description': description,
    };
  }
}
