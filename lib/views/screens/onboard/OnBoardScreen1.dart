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
      child: AnnotatedRegion<SystemUiOverlayStyle>(
        value: const SystemUiOverlayStyle(
          systemNavigationBarColor: Color(MyColors.appbackgroundColor),
          systemNavigationBarIconBrightness:
              Brightness.dark, // dark icons on a light bar
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: Brightness.dark,
        ),
        child: Scaffold(
          backgroundColor: const Color(MyColors.appbackgroundColor),
          // SafeArea on top too, so the image never sits under the notch,
          // Dynamic Island or status bar.
          body: SafeArea(
            child: Center(
              // On tablets, keep the content phone-width instead of
              // stretching the image, text and button edge to edge.
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: _maxContentWidth),
                child: Column(
                  children: [
                    // The pages take whatever height is left after the
                    // controls below, instead of a fixed 72% of the screen,
                    // so nothing overflows on short screens or behind big
                    // bottom insets.
                    Expanded(
                      child: PageView.builder(
                        controller: controller.pageController,
                        itemCount: 3,
                        onPageChanged: (index) {
                          controller.currentIndex.value = index;
                        },
                        itemBuilder: (context, index) {
                          return _sliderPage(context, index);
                        },
                      ),
                    ),
                    // Only the controls depend on the current page, so only
                    // they rebuild when it changes.
                    Obx(() {
                      return Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: List.generate(3, (index) {
                              // Rectangleindicator applies .w itself, so the
                              // size is passed unscaled (it was scaled twice).
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
                            padding: EdgeInsets.only(
                                left: 32.0.w, right: 32.0.w, top: 8.0.h),
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
                              padding: EdgeInsets.all(4.0.r),
                              child: Skipandnexttext(
                                text: Strings.skipText(context),
                              ),
                            ),
                          ),
                          SizedBox(height: 8.0.h),
                        ],
                      );
                    }),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  static const double _maxContentWidth = 500;

  static const List<String> _images = [
    "lib/assets/images/splashscreenimage1.png",
    "lib/assets/images/splashscreenimage2.png",
    "lib/assets/images/splashscreenimage3.png",
  ];

  Widget _sliderPage(BuildContext context, int page) {
    final titles = [
      Strings.postJob(context),
      Strings.reviewApplicants(context),
      Strings.chatAndAssign(context),
    ];
    final headings = [
      Strings.onBoardScreen1Heading(context),
      Strings.onBoardScreen2Heading(context),
      Strings.onBoardScreen3Heading(context),
    ];
    final descriptions = [
      Strings.onBoardScreen1Description(context),
      Strings.onBoardScreen2Description(context),
      Strings.onBoardScreen3Description(context),
    ];

    return Padding(
      padding: EdgeInsets.fromLTRB(16.0.w, 16.0.h, 16.0.w, 8.0.h),
      child: Column(
        children: [
          // The image fills the space the text doesn't need and shrinks on
          // short screens. The old fixed 287x357 box was portrait-shaped
          // while the images are landscape, which wasted height.
          Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 18.0.w),
              child: Image.asset(_images[page], fit: BoxFit.contain),
            ),
          ),
          SizedBox(height: 16.0.h),
          HeadingTextW600(
              text: titles[page], centerAlign: true, size: 22, minSize: 18),
          SizedBox(height: 12.0.h),
          HeadingTextW500(
              text: headings[page], centerAlign: true, size: 18, minSize: 15),
          Headingdescription(
            text: descriptions[page],
            centerAlign: true,
            size: 14,
            minSize: 11,
          ),
        ],
      ),
    );
  }
}
