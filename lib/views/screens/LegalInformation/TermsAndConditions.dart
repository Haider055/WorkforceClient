import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:workforceclientapp/Others/MyColors.dart';
import 'package:workforceclientapp/Others/Strings.dart';
import 'package:workforceclientapp/views/widgets/HeadingTextW600.dart';
import 'package:workforceclientapp/views/widgets/Headingdescription.dart';

class TermsAndConditions extends GetView<TermsandconditionController> {
  const TermsAndConditions({super.key});
  @override
  Widget build(BuildContext context) {
    return SafeArea(
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
                HeadingTextW600(text: "EULA", centerAlign: true, size: 16.sp),
                Headingdescription(
                    text: Strings.eULAText(Get.context!),
                    centerAlign: false,
                    size: 14.sp),
                HeadingTextW600(
                    text: Strings.lisenceText(Get.context!),
                    centerAlign: true,
                    size: 16.sp),
                Headingdescription(
                    text: Strings.lisenceText(Get.context!),
                    centerAlign: false,
                    size: 14.sp),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class TermsandconditionController extends GetxController {}
