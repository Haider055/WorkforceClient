import 'package:get/get.dart';
import 'package:workforceclientapp/Others/Constants.dart';
import 'package:workforceclientapp/Others/routes.dart';
import 'package:workforceclientapp/views/screens/Chat/ConversationScreen.dart';

class NotificationNavigationService {
  static void handleNotificationTap(Map<String, dynamic> data) {
    final String? type = data['type'];
    print(type);

    switch (type) {
      case "View Job Details":
      case "View Job Posting":
      case "View Request Details":
      case "Jobdetails anzeigen":
      case "Anfragedetails anzeigen":
      case "job_posted":
        int jobPostingId = data['job_posting_id'] == null
            ? -1
            : int.parse(data['job_posting_id']);
        Get.toNamed(AppLinks.orders_details_screen,
            arguments: {'jobId': jobPostingId});
        break;
      case "View Job Application":
      case "Bewerbung anzeigen":
      case "request_approved":
      case "anfrage_genehmigt":
      case "job_application_received":
        int jobPostingId = data['job_posting_id'] == null
            ? -1
            : int.parse(data['job_posting_id']);
        Get.toNamed(AppLinks.orders_details_screen,
            arguments: {'jobId': jobPostingId, 'section': "tradesmen"});
        break;

      // New chat message
      case 'chat':
      case 'message_received':
        Constants.fromNotifications.value = true;
        int chatId = data['chat_id'] == null ? -1 : int.parse(data['chat_id']);
        Get.to(
          const ConversationScreen(),
          arguments: {
            'chat': null,
            'chatId': chatId,
            'fromWhere': 'notification'
          },
          transition: Transition.rightToLeft,
          duration: const Duration(milliseconds: 500),
        );
        break;

      default:
        Get.toNamed(AppLinks.all_chats); // fallback
    }
  }
}
