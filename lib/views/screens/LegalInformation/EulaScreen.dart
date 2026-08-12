import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:workforceclientapp/Controllers/EulaController.dart';
import 'package:workforceclientapp/Others/MyColors.dart';
import 'package:workforceclientapp/Others/Strings.dart';
import 'package:workforceclientapp/views/widgets/FullWidthButtonPrimary.dart';
import 'package:workforceclientapp/views/widgets/FullWidthOutlineButton.dart';
import 'package:workforceclientapp/views/widgets/HeadingTextW600.dart';
import 'package:workforceclientapp/views/widgets/Headingdescription.dart';

class EulaScreen extends GetView<EulaController> {
  const EulaScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        // Block system back — user must explicitly Agree or Cancel.
      },
      child: Scaffold(
        backgroundColor: const Color(MyColors.cardGrayColor100),
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: const Color(MyColors.cardGrayColor100),
          elevation: 0.5,
          shadowColor: const Color.fromARGB(158, 219, 219, 219),
          shape: const Border(
              bottom: BorderSide(
                  color: Color.fromARGB(147, 203, 203, 203),
                  style: BorderStyle.solid)),
          centerTitle: true,
          title: HeadingTextW600(
            text: "End User Lisence Agreement",
            centerAlign: true,
            size: 18.0.sp,
          ),
        ),
        body: SafeArea(
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  padding: EdgeInsets.all(16.0.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Headingdescription(
                        text: Strings.eULAText(context),
                        centerAlign: false,
                        size: 14.sp,
                      ),
                      SizedBox(height: 16.h),
                      Headingdescription(
                        text: Strings.lisenceText(context),
                        centerAlign: false,
                        size: 14.sp,
                      ),
                    ],
                  ),
                ),
              ),
              Obx(() {
                return Padding(
                  padding: EdgeInsets.only(
                    left: 16.0.w,
                    right: 16.0.w,
                    bottom: 12.0.h,
                    top: 8.0.h,
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: FullWidthOutlineButton(
                          text: Strings.cancelText(context),
                          fontsize: 15.0.sp,
                          color: MyColors.themeRedColor,
                          onPressed: controller.isLoading.value
                              ? () {}
                              : () {
                                  controller.cancelEula();
                                },
                        ),
                      ),
                      SizedBox(width: 12.w),
                      Expanded(
                        child: controller.isLoading.value
                            ? const Center(
                                child: CircularProgressIndicator(
                                  color: Color(MyColors.themeRedColor),
                                ),
                              )
                            : FullWidthButtonPrimary(
                                text: "Agree",
                                fontsize: 15.0.sp,
                                color: MyColors.themeRedColor,
                                onPressed: () {
                                  controller.agreeToEula();
                                },
                              ),
                      ),
                    ],
                  ),
                );
              }),
            ],
          ),
        ),
      ),
    );
  }
}
