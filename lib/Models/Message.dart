class Message {
  int? id;
  int? chatId;
  int? senderId;
  int? receiverId;
  String? humanReadableCreatedAt;
  // String? read;
  String? message;
  bool sent = true;
  final DateTime? createdAt;

  Message(
      {required this.id,
      required this.chatId,
      required this.senderId,
      required this.receiverId,
      required this.humanReadableCreatedAt,
      // required this.read,
      required this.message,
      this.createdAt});

  factory Message.fromJson(Map<String, dynamic> json) {
    final createdAtStr = json['created_at'] as String?;
    return Message(
      id: json['id'],
      chatId: json['chat_id'],
      senderId: json['sender_id'],
      receiverId: json['receiver_id'],
      humanReadableCreatedAt: json['human_readable_created_at'],
      // read: json['read'],
      message: json['message'],
      createdAt: createdAtStr != null
          ? DateTime.tryParse(createdAtStr)?.toLocal()
          : null,
    );
  }
}
