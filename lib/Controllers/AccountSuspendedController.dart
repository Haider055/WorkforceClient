import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:workforceclientapp/Others/routes.dart';

class AccountSuspendedController extends GetxController {
  Future<void> goToLogin() async {
    Get.offAllNamed(AppLinks.login_screen);
  }
}
