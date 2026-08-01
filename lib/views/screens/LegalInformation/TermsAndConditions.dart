import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:workforceclientapp/Others/MyColors.dart';
import 'package:workforceclientapp/Others/Strings.dart';
import 'package:workforceclientapp/views/widgets/HeadingTextW600.dart';

class TermsAndConditions extends GetView<TermsandconditionController> {
  const TermsAndConditions({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      bottom: true,
      child: Scaffold(
        backgroundColor: const Color(MyColors.cardGrayColor100),
        appBar: AppBar(
          leadingWidth: MediaQuery.of(context).size.width.w,
          leading: Card(
            color: const Color(MyColors.cardGrayColor100),
            shadowColor: const Color.fromARGB(158, 219, 219, 219),
            elevation: 0.5,
            shape: const Border(
                bottom: BorderSide(
                    color: Color.fromARGB(147, 203, 203, 203),
                    style: BorderStyle.solid)),
            child: Center(
              child: Stack(
                children: [
                  Center(
                      child: HeadingTextW600(
                    text: Strings.termsAndConditionText(context),
                    centerAlign: false,
                    size: 18.0.sp,
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
        body: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(12.0.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                HeadingTextW600(text: "EULA", centerAlign: true, size: 18.sp),
                SizedBox(height: 8.h),
                Text(
                  Strings.eULAText(Get.context!),
                  textAlign: TextAlign.justify,
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w500,
                    height: 1.4,
                  ),
                ),
                SizedBox(height: 12.h),
                Text(
                  Strings.lisenceText(Get.context!),
                  textAlign: TextAlign.justify,
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.normal,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class TermsandconditionController extends GetxController {}
