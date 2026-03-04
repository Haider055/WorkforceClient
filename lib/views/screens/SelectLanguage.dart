import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:workforceclientapp/Controllers/SelectLanguageController.dart';
import 'package:workforceclientapp/Others/MyColors.dart';
import 'package:workforceclientapp/Others/Strings.dart';
import 'package:workforceclientapp/Others/routes.dart';
import 'package:workforceclientapp/views/widgets/FullWidthButtonPrimary.dart';
import 'package:workforceclientapp/views/widgets/FullWidthOutlineButton.dart';
import 'package:workforceclientapp/views/widgets/SplashScreenimage.dart';

class SelectLanguage extends GetView<SelectLanguageController> {
  SelectLanguage({super.key});
  late SharedPreferences _prefs;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(MyColors.appbackgroundColor),
      body: SafeArea(
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 50.0),
              child: Align(
                  alignment: Alignment.topCenter,
                  child: Image.asset(
                    "lib/assets/icons/Logo_black_red.png",
                    fit: BoxFit.fill,
                    height: 27.27,
                    width: 114.0,
                  )),
            ),
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Padding(
                    padding: EdgeInsets.all(16.0),
                    child: SplashScreenimage(
                        path: "lib/assets/images/select_language_image.png"),
                  ),
                  Text(Strings.selectLanguageText(context),
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                          color: Colors.black,
                          fontSize: 29.0,
                          fontWeight: FontWeight.w700,
                          fontFamily: 'Poppins')),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: FullWidthButtonPrimary(
                              text: Strings.englishText(context),
                              fontsize: 17.0,
                              color: MyColors.themeRedColor,
                              onPressed: () async {
                                _prefs = await SharedPreferences.getInstance();
                                await _prefs.setString("language", "en");
                                // await Provider.of<LocaleProvider>(context,
                                //         listen: false)
                                //     .setLocale(const Locale('en'));
                                Get.updateLocale(const Locale('en'));
                                Get.offAllNamed(AppLinks.onboard_screen);
                              }),
                        ),
                        Padding(
                          padding:
                              const EdgeInsets.only(left: 12.0, right: 12.0),
                          child: FullWidthOutlineButton(
                              text: Strings.germanText(context),
                              fontsize: 17.0,
                              color: MyColors.themeRedColor,
                              onPressed: () async {
                                _prefs = await SharedPreferences.getInstance();
                                await _prefs.setString("language", "de");
                                // await Provider.of<LocaleProvider>(context,
                                //         listen: false)
                                //     .setLocale(const Locale('de'));
                                Get.updateLocale(const Locale('de'));
                                // notifyListeners();
                                Get.offAllNamed(AppLinks.onboard_screen);
                              }),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
