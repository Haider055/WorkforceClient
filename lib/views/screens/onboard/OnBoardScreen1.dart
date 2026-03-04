import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:workforceclientapp/Controllers/OnboardingScreenController.dart';
import 'package:workforceclientapp/Others/MyColors.dart';
import 'package:workforceclientapp/Others/Strings.dart';
import 'package:workforceclientapp/views/widgets/FullWidthButtonPrimary.dart';
import 'package:workforceclientapp/views/widgets/HeadingText.dart';
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
          SystemNavigator.pop(); // Closes the app in Android
        } else if (Platform.isIOS) {
          exit(0); // Closes the app in iOS
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
                  height: MediaQuery.of(context).size.height / 1.4,
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
                              ? 40.0
                              : 20.0,
                          color: controller.currentIndex.value == index
                              ? 0xFFD60107
                              : 0x7F900B09,
                        );
                      }),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                          left: 32.0, right: 32.0, top: 8.0),
                      child: FullWidthButtonPrimary(
                        text: controller.currentIndex.value == 2
                            ? Strings.letsStartText(context)
                            : Strings.continueText(context),
                        fontsize: 17.0,
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
                        padding: const EdgeInsets.all(4.0),
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
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            const Padding(
              padding: EdgeInsets.only(left: 18.0, right: 18.0),
              child: SplashScreenimage(
                  path: "lib/assets/images/splashscreenimage1.png"),
            ),
            Column(children: [
              HeadingText(
                  text: Strings.onBoardScreen1Heading(Get.context!),
                  centerAlign: true),
              Headingdescription(
                text: Strings.onBoardScreen1Description(Get.context!),
                centerAlign: true,
                size: 13.0,
              ),
            ]),
          ],
        ),
      );
    } else if (page == 1) {
      return Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            const Padding(
              padding: EdgeInsets.only(left: 18.0, right: 18.0),
              child: SplashScreenimage(
                  path: "lib/assets/images/splashscreenimage2.png"),
            ),
            Column(children: [
              HeadingText(
                  text: Strings.onBoardScreen2Heading(Get.context!),
                  centerAlign: true),
              Headingdescription(
                text: Strings.onBoardScreen2Description(Get.context!),
                centerAlign: true,
                size: 13.0,
              ),
            ]),
          ],
        ),
      );
    } else {
      return Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            const Padding(
              padding: EdgeInsets.only(left: 18.0, right: 18.0),
              child: SplashScreenimage(
                  path: "lib/assets/images/splashscreenimage3.png"),
            ),
            Column(children: [
              HeadingText(
                  text: Strings.onBoardScreen3Heading(Get.context!),
                  centerAlign: true),
              Headingdescription(
                text: Strings.onBoardScreen3Description(Get.context!),
                centerAlign: true,
                size: 13.0,
              ),
            ]),
          ],
        ),
      );
    }
  }
}
