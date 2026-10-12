import 'package:get/get.dart';
import 'package:workforceclientapp/Models/Message.dart';

class NewMessageController extends GetxController {
  RxList<Message> messages = <Message>[].obs;
  final Set<int> _processedMessageIds = {};

  void addMessage(Message message) {
    // Guards against the same server message being delivered more than
    // once (e.g. overlapping reverb sockets during a reconnect), which
    // would otherwise double-count per-chat unread badges.
    if (message.id != null && !_processedMessageIds.add(message.id!)) {
      return;
    }
    messages.add(message); // Triggers UI update in Obx
  }
}
