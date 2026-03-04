class Message {
  int? id;
  int? chatId;
  int? senderId;
  int? receiverId;
  String? humanReadableCreatedAt;
  // String? read;
  String? message;

  Message(
      {required this.id,
      required this.chatId,
      required this.senderId,
      required this.receiverId,
      required this.humanReadableCreatedAt,
      // required this.read,
      required this.message});

  factory Message.fromJson(Map<String, dynamic> json) {
    return Message(
      id: json['id'],
      chatId: json['chat_id'],
      senderId: json['sender_id'],
      receiverId: json['receiver_id'],
      humanReadableCreatedAt: json['human_readable_created_at'],
      // read: json['read'],
      message: json['message'],
    );
  }
}
