import 'package:get/get.dart';
import 'package:workforceclientapp/Others/Constants.dart';

class SelectLanguageController extends GetxController {
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  void onInit() {
    super.onInit();
    Constants.selectedLang = 'de';
  }
}
