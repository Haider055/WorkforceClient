import 'package:get/get.dart';

class PasswordUpdatedController extends GetxController {
  RxBool hasEnable = true.obs;
  @override
  void dispose() {
    super.dispose();
  }

  @override
  void onInit() {
    hasEnable.value = true;
    super.onInit();
  }
}
