import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:linear_progress_bar/linear_progress_bar.dart';
import 'package:workforceclientapp/Controllers/PasswordUpdatedController.dart';
import 'package:workforceclientapp/Others/Constants.dart';
import 'package:workforceclientapp/Others/MyColors.dart';
import 'package:workforceclientapp/Others/Strings.dart';
import 'package:workforceclientapp/Others/routes.dart';
import 'package:workforceclientapp/views/screens/DashBoard/SelectServiceScreen.dart';
import 'package:workforceclientapp/views/widgets/FullWidthButtonPrimary.dart';
import 'package:workforceclientapp/views/widgets/FullWidthOutlineButton.dart';
import 'package:workforceclientapp/views/widgets/HeadingTextW500.dart';
import 'package:workforceclientapp/views/widgets/Headingdescription.dart';

class JobDescriptionScreen extends GetView<PasswordUpdatedController> {
  const JobDescriptionScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (FocusScope.of(context).hasFocus) {
          FocusScope.of(context).unfocus(); // Close keyboard
          return false; // DO NOT pop screen
        }
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text(Strings.discardChangesText(Get.context!)),
            content:
                Text(Strings.areYouSureToEndJobPostingProcess(Get.context!)),
            contentTextStyle: TextStyle(fontSize: 15.5.sp, color: Colors.black),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.0.r)),
            backgroundColor: const Color(MyColors.colorRed200),
            actions: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.only(left: 8.0.w, right: 8.0.w),
                      child: FullWidthOutlineButton(
                          text: Strings.noText(context),
                          fontsize: 15.0.sp,
                          color: MyColors.themeRedColor,
                          onPressed: () {
                            Get.back();
                          }),
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.only(left: 8.0.w, right: 8.0.w),
                      child: FullWidthButtonPrimary(
                          text: Strings.yesText(context),
                          fontsize: 15.0.sp,
                          color: MyColors.themeRedColor,
                          onPressed: () {
                            Get.back();
                            Get.to(
                              const SelectServiceScreen(),
                              transition: Transition
                                  .rightToLeft, // Left-to-right animation
                              duration: const Duration(
                                  milliseconds:
                                      500), // Optional: animation duration
                            );
                          }),
                    ),
                  )
                ],
              ),
            ],
          ),
        );
        return true;
      },
      child: GestureDetector(
        onTap: () {
          FocusScope.of(Get.context!).unfocus();
        },
        child: Scaffold(
          resizeToAvoidBottomInset: false,
          backgroundColor: Colors.white,
          appBar: AppBar(
            leadingWidth: MediaQuery.of(context).size.width,
            leading: Card(
              color: const Color(MyColors.appbackgroundColor),
              shadowColor: const Color.fromARGB(158, 219, 219, 219),
              elevation: 2,
              shape: const Border(
                  bottom: BorderSide(
                      color: Color.fromARGB(147, 203, 203, 203),
                      style: BorderStyle.solid)),
              child: Center(
                  child: Padding(
                padding: EdgeInsets.only(left: 8.0.w, right: 8.0.w),
                child: Text(Constants.selectedServiceName,
                    textAlign: TextAlign.center,
                    overflow: TextOverflow.ellipsis,
                    softWrap: true,
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 16.0.sp,
                        fontWeight: FontWeight.w600,
                        fontFamily: 'Poppins')),
              )),
            ),
          ),
          body: Column(
            children: [
              Expanded(
                flex: 1,
                child: Column(
                  children: [
                    Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: 10.0.w, vertical: 0),
                      child: LinearProgressBar(
                        maxSteps: Constants.jobPostingSteps,
                        progressType: LinearProgressBar.progressTypeLinear,
                        minHeight: 6,
                        currentStep: Constants.currentJobPostingStep,
                        progressColor: const Color(MyColors.themeRedColor),
                        backgroundColor: const Color(MyColors.lightSilverColor),
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                    Align(
                      alignment: Alignment.topRight,
                      child: Padding(
                        padding: EdgeInsets.only(top: 5.0.h, right: 15.w),
                        child: Text(
                          "${Strings.step(Get.context!)} ${Constants.currentJobPostingStep}/${Constants.jobPostingSteps}",
                          style: TextStyle(
                              fontSize: 14.5.sp,
                              color: const Color(MyColors.midGrayColor)),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                flex: 16,
                child: Padding(
                  padding: EdgeInsets.all(12.0.r),
                  child: Column(
                    children: [
                      Card(
                        color: const Color(MyColors.cardGrayColor50),
                        elevation: 0,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding:
                                  EdgeInsets.only(left: 18.0.w, top: 12.0.h),
                              child: HeadingTextW500(
                                  text: Strings.description(context),
                                  centerAlign: false,
                                  size: 20.sp),
                            ),
                            Padding(
                              padding:
                                  EdgeInsets.only(left: 18.0.w, top: 5.0.h),
                              child: Headingdescription(
                                text: Strings.tellUsMoreAboutYourNeed(
                                    Get.context!),
                                centerAlign: false,
                                size: 16.sp,
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.all(18.0.r),
                              child: TextField(
                                maxLines: 12,
                                controller: TextEditingController(
                                    text: Constants.jobDescription),
                                onChanged: (value) {
                                  Constants.jobDescription = value;
                                },
                                cursorColor:
                                    const Color(MyColors.themeRedColor),
                                decoration: InputDecoration(
                                    hintText:
                                        Strings.pleaseExplaininyourownWords(
                                            Get.context!),
                                    hintStyle: TextStyle(
                                        fontSize: 15.sp,
                                        color:
                                            const Color(MyColors.darkGrayColor),
                                        fontWeight: FontWeight.w400),
                                    fillColor: const Color(MyColors.whiteColor),
                                    filled: true,
                                    enabledBorder: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(9.0.r),
                                        borderSide: const BorderSide(
                                            color: Color(
                                                MyColors.lightGrayColor))),
                                    focusedBorder: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(9.0.r),
                                        borderSide: const BorderSide(
                                            color:
                                                Color(MyColors.themeRedColor))),
                                    border: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(9.0.r),
                                        borderSide:
                                            const BorderSide(color: Color(MyColors.lightGrayColor)))),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const Spacer(),
                    ],
                  ),
                ),
              ),
              Expanded(
                flex: 2,
                child: Padding(
                  padding: EdgeInsets.all(8.0.r),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Expanded(
                        child: Padding(
                          padding: EdgeInsets.only(left: 25.0.w, right: 12.0.w),
                          child: FullWidthOutlineButton(
                              text: Strings.back(context),
                              fontsize: 15.0.sp,
                              color: MyColors.themeRedColor,
                              onPressed: () {
                                Constants.currentJobPostingStep--;
                                Get.back();
                              }),
                        ),
                      ),
                      Expanded(
                        child: Padding(
                          padding: EdgeInsets.only(left: 12.0.w, right: 25.0.w),
                          child: FullWidthButtonPrimary(
                              text: Strings.next(context),
                              fontsize: 15.0.sp,
                              color: MyColors.themeRedColor,
                              onPressed: () {
                                if (Constants.jobDescription.isNotEmpty) {
                                  Constants.currentJobPostingStep++;
                                  Get.toNamed(AppLinks.upload_job_image_screen);
                                } else {
                                  Fluttertoast.showToast(
                                      msg:
                                          Strings.writeJobDescription(context));
                                }
                              }),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
