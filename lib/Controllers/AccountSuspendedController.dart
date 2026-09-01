import 'package:get/get.dart';
import 'package:workforceclientapp/Others/routes.dart';

class AccountSuspendedController extends GetxController {
  Future<void> goToLogin() async {
    Get.offAllNamed(AppLinks.login_screen);
  }

  Future<void> goToSupport() async {
    Get.toNamed(AppLinks.support_centre);
  }
}
