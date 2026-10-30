import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:workforceclientapp/Controllers/SelectLanguageController.dart';
import 'package:workforceclientapp/Others/MyColors.dart';
import 'package:workforceclientapp/Others/Strings.dart';
import 'package:workforceclientapp/Others/routes.dart';
import 'package:workforceclientapp/views/widgets/FullWidthButtonPrimary.dart';
import 'package:workforceclientapp/views/widgets/FullWidthOutlineButton.dart';

class SelectLanguage extends GetView<SelectLanguageController> {
  SelectLanguage({super.key});
  late SharedPreferences _prefs;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(MyColors.appbackgroundColor),
      body: Stack(
        children: [
          Padding(
            padding: EdgeInsets.only(top: 50.0.h),
            child: Align(
                alignment: Alignment.topCenter,
                child: SvgPicture.asset(
                  "lib/assets/icons/auftragnowRedBalck.svg",
                  fit: BoxFit.contain,
                )),
          ),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: EdgeInsets.all(16.0.r),
                  child: Image.asset(
                    'lib/assets/images/select_language_image.png',
                    height: 300.0.h,
                    width: 200.0.w,
                    fit: BoxFit.contain,
                  ),
                ),
                Text(Strings.selectLanguageText(context),
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 29.0.sp,
                        fontWeight: FontWeight.w700,
                        fontFamily: 'Poppins')),
                Padding(
                  padding: EdgeInsets.all(8.0.r),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Padding(
                        padding: EdgeInsets.all(12.0.r),
                        child: FullWidthButtonPrimary(
                            text: Strings.germanText(context),
                            fontsize: 17.0,
                            color: MyColors.themeRedColor,
                            onPressed: () async {
                              _prefs = await SharedPreferences.getInstance();
                              await _prefs.setString("language", "de");
                              Get.updateLocale(const Locale('de'));
                              Get.offAllNamed(AppLinks.onboard_screen);
                            }),
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 12.0.w, right: 12.0.w),
                        child: FullWidthOutlineButton(
                            text: Strings.englishText(context),
                            fontsize: 17.0,
                            color: MyColors.themeRedColor,
                            onPressed: () async {
                              _prefs = await SharedPreferences.getInstance();
                              await _prefs.setString("language", "en");
                              Get.updateLocale(const Locale('en'));
                              Get.offAllNamed(AppLinks.onboard_screen);
                            }),
                      ),
                      SizedBox(height: 12.0.h),
                      Padding(
                        padding: EdgeInsets.only(left: 12.0.w, right: 12.0.w),
                        child: FullWidthOutlineButton(
                            text: Strings.portugueseText(context),
                            fontsize: 17.0,
                            color: MyColors.themeRedColor,
                            onPressed: () async {
                              _prefs = await SharedPreferences.getInstance();
                              await _prefs.setString("language", "pt");
                              Get.updateLocale(const Locale('pt'));
                              Get.offAllNamed(AppLinks.onboard_screen);
                            }),
                      ),
                      SizedBox(height: 12.0.h),
                      Padding(
                        padding: EdgeInsets.only(left: 12.0.w, right: 12.0.w),
                        child: FullWidthOutlineButton(
                            text: Strings.turkishText(context),
                            fontsize: 17.0,
                            color: MyColors.themeRedColor,
                            onPressed: () async {
                              _prefs = await SharedPreferences.getInstance();
                              await _prefs.setString("language", "tr");
                              Get.updateLocale(const Locale('tr'));
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
    );
  }
}
