import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:workforceclientapp/Controllers/OnboardingScreenController.dart';
import 'package:workforceclientapp/Others/MyColors.dart';
import 'package:workforceclientapp/Others/Strings.dart';
import 'package:workforceclientapp/views/widgets/FullWidthButtonPrimary.dart';
import 'package:workforceclientapp/views/widgets/HeadingTextW500.dart';
import 'package:workforceclientapp/views/widgets/HeadingTextW600.dart';
import 'package:workforceclientapp/views/widgets/Headingdescription.dart';
import 'package:workforceclientapp/views/widgets/RectangleIndicator.dart';
import 'package:workforceclientapp/views/widgets/SkipandNextText.dart';
import 'package:workforceclientapp/views/widgets/SplashScreenimage.dart';

class OnBoardScreen1 extends GetView<OnboardingScreenController> {
  const OnBoardScreen1({super.key});

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (Platform.isAndroid) {
          SystemNavigator.pop();
        } else if (Platform.isIOS) {
          exit(0);
        }
        return false;
      },
      child: Obx(() {
        return Scaffold(
          backgroundColor: const Color(MyColors.appbackgroundColor),
          body: SafeArea(
            child: Column(
              children: [
                SizedBox(
                  height: 0.72.sh,
                  child: PageView.builder(
                    controller: controller.pageController,
                    itemCount: 3,
                    onPageChanged: (index) {
                      controller.currentIndex.value = index;
                    },
                    itemBuilder: (context, index) {
                      return SliderViewSplash(index);
                    },
                  ),
                ),
                Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(3, (index) {
                        return Rectangleindicator(
                          size: controller.currentIndex.value == index
                              ? 40.0.w
                              : 20.0.w,
                          color: controller.currentIndex.value == index
                              ? 0xFFD60107
                              : 0x7F900B09,
                        );
                      }),
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                          left: 32.0.w, right: 32.0.w, top: 8.0.h),
                      child: FullWidthButtonPrimary(
                        text: controller.currentIndex.value == 2
                            ? Strings.letsStartText(context)
                            : Strings.continueText(context),
                        fontsize: 17.0.sp,
                        color: MyColors.themeRedColor,
                        onPressed: () async {
                          controller.nextPage();
                        },
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        controller.goToDashboard();
                      },
                      child: Padding(
                        padding: EdgeInsets.all(4.0.r),
                        child: Skipandnexttext(
                          text: Strings.skipText(context),
                        ),
                      ),
                    ),
                  ],
                ),
                const Spacer(),
              ],
            ),
          ),
        );
      }),
    );
  }

  Widget SliderViewSplash(int page) {
    if (page == 0) {
      return Padding(
        padding: EdgeInsets.all(16.0.r),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Padding(
              padding: EdgeInsets.only(left: 18.0.w, right: 18.0.w),
              child: const SplashScreenimage(
                  path: "lib/assets/images/splashscreenimage1.png"),
            ),
            Column(children: [
              HeadingTextW600(
                  text: Strings.postJob(Get.context!),
                  centerAlign: true,
                  size: 22.0.sp),
              const SizedBox(
                height: 12,
              ),
              HeadingTextW500(
                  text: Strings.onBoardScreen1Heading(Get.context!),
                  size: 18.0.sp,
                  centerAlign: true),
              Headingdescription(
                text: Strings.onBoardScreen1Description(Get.context!),
                centerAlign: true,
                size: 14.0.sp,
              ),
            ]),
          ],
        ),
      );
    } else if (page == 1) {
      return Padding(
        padding: EdgeInsets.all(16.0.r),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Padding(
              padding: EdgeInsets.only(left: 18.0.w, right: 18.0.w),
              child: const SplashScreenimage(
                  path: "lib/assets/images/splashscreenimage2.png"),
            ),
            Column(children: [
              HeadingTextW600(
                  text: Strings.reviewApplicants(Get.context!),
                  centerAlign: true,
                  size: 22.0.sp),
              const SizedBox(
                height: 12,
              ),
              HeadingTextW500(
                  text: Strings.onBoardScreen2Heading(Get.context!),
                  centerAlign: true,
                  size: 18.0.sp),
              Headingdescription(
                text: Strings.onBoardScreen2Description(Get.context!),
                centerAlign: true,
                size: 14.0,
              ),
            ]),
          ],
        ),
      );
    } else {
      return Padding(
        padding: EdgeInsets.all(16.0.r),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Padding(
              padding: EdgeInsets.only(left: 18.0.w, right: 18.0.w),
              child: const SplashScreenimage(
                  path: "lib/assets/images/splashscreenimage3.png"),
            ),
            Column(children: [
              HeadingTextW600(
                  text: Strings.chatAndAssign(Get.context!),
                  centerAlign: true,
                  size: 22.0.sp),
              const SizedBox(
                height: 12,
              ),
              HeadingTextW500(
                  text: Strings.onBoardScreen3Heading(Get.context!),
                  centerAlign: true,
                  size: 18.0.sp),
              Headingdescription(
                text: Strings.onBoardScreen3Description(Get.context!),
                centerAlign: true,
                size: 14.0.sp,
              ),
            ]),
          ],
        ),
      );
    }
  }
}
