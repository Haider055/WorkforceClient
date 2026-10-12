import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:workforceclientapp/Controllers/ChangeLanguageController.dart';
import 'package:workforceclientapp/Others/MyColors.dart';
import 'package:workforceclientapp/Others/Strings.dart';
import 'package:workforceclientapp/views/widgets/HeadingTextW500.dart';
import 'package:workforceclientapp/views/widgets/HeadingTextW600.dart';
import 'package:workforceclientapp/views/widgets/Headingdescription.dart';

const _languages = [
  (code: 'en', name: 'English'),
  (code: 'de', name: 'German'),
  (code: 'tr', name: 'Turkish'),
  (code: 'pt', name: 'Portuguese'),
];

class ChangeLanguageScreen extends GetView<ChangeLanguageController> {
  const ChangeLanguageScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leadingWidth: MediaQuery.of(context).size.width,
        leading: Card(
          color: const Color(MyColors.whiteColor),
          shadowColor: const Color.fromARGB(158, 219, 219, 219),
          elevation: 0,
          shape: const Border(
              bottom: BorderSide(
                  color: Color.fromARGB(147, 203, 203, 203),
                  style: BorderStyle.solid)),
          child: Center(
            child: Stack(
              children: [
                Center(
                    child: HeadingTextW600(
                  text: Strings.changeLanguageText(context),
                  centerAlign: false,
                  size: 16.0.sp,
                )),
                GestureDetector(
                  onTap: () {
                    Get.back();
                  },
                  child: Padding(
                    padding: EdgeInsets.only(left: 12.0.w),
                    child: const Align(
                        alignment: Alignment.centerLeft,
                        child: Icon(Icons.arrow_back_ios)),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      backgroundColor: const Color(MyColors.whiteColor),
      body: Obx(() {
        return Column(
          children: [
            Padding(
              padding: EdgeInsets.all(12.0.r),
              child: Card(
                elevation: 0,
                color: const Color(MyColors.cardGrayColor100),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(left: 20.0.w, top: 12.h),
                      child: Align(
                        alignment: Alignment.topLeft,
                        child: HeadingTextW500(
                            text: Strings.selectLanguageText(context),
                            centerAlign: false,
                            size: 16.sp),
                      ),
                    ),
                    for (final lang in _languages)
                      Padding(
                        padding: EdgeInsets.only(
                            left: 16.0.w,
                            right: 16.0.w,
                            top: 5.0.h,
                            bottom: lang == _languages.last ? 8.0.h : 0),
                        child: Card(
                          elevation: 0,
                          color: controller.selectedLang.value == lang.code
                              ? Colors.red.shade50
                              : const Color(MyColors.whiteColor),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.0.r),
                            side: BorderSide(
                              color: controller.selectedLang.value == lang.code
                                  ? const Color(MyColors.themeRedColor)
                                  : const Color(MyColors.darkGrayColor),
                            ),
                          ),
                          child: RadioListTile(
                            title: Headingdescription(
                                text: lang.name, centerAlign: false, size: 14.sp),
                            value: lang.code,
                            groupValue: controller.selectedLang.value,
                            selected: controller.selectedLang.value == lang.code,
                            activeColor: const Color(MyColors.themeRedColor),
                            tileColor: Colors.white,
                            onChanged: (value) {
                              controller.setLanguage(lang.code);
                            },
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            )
          ],
        );
      }),
    );
  }
}
