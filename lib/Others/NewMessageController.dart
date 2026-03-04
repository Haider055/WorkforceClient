import 'package:get/get.dart';
import 'package:workforceclientapp/Models/Message.dart';

class NewMessageController extends GetxController {
  RxList<Message> messages = <Message>[].obs;

  void addMessage(Message message) {
    messages.add(message); // Triggers UI update in Obx
  }
}
