import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:linear_progress_bar/linear_progress_bar.dart';
import 'package:workforceclientapp/Controllers/UploadJobImagesController.dart';
import 'package:workforceclientapp/Others/Commons.dart';
import 'package:workforceclientapp/Others/Constants.dart';
import 'package:workforceclientapp/Others/MyColors.dart';
import 'package:workforceclientapp/Others/Strings.dart';
import 'package:workforceclientapp/Others/routes.dart';
import 'package:workforceclientapp/views/widgets/FullWidthButtonPrimary.dart';
import 'package:workforceclientapp/views/widgets/FullWidthOutlineButton.dart';
import 'package:workforceclientapp/views/widgets/HeadingTextW500.dart';
import 'package:workforceclientapp/views/widgets/Headingdescription.dart';

class UploadJobImageScreen extends GetView<UploadJobImagesController> {
  const UploadJobImageScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: Platform.isAndroid,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop && Platform.isAndroid) {
          Constants.currentJobPostingStep.value--;
        }
      },
      child: Scaffold(
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
              child: Stack(
                children: [
                  Center(
                      child: Padding(
                    padding: EdgeInsets.only(left: 8.0.w, right: 40.0.w),
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
                  Positioned(
                      top: 0,
                      bottom: 0,
                      right: 12.w,
                      child: GestureDetector(
                          onTap: () {
                            Commons.showExitJobPostingDialog(Get.context!);
                          },
                          child: const Icon(Icons.close)))
                ],
              ),
            ),
          ),
          body: SafeArea(
            child: Stack(
              children: [
                Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        flex: 1,
                        child: Column(
                          children: [
                            Obx(() {
                              return Padding(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 10.0.w, vertical: 0),
                                child: LinearProgressBar(
                                  maxSteps: Constants.jobPostingSteps,
                                  progressType:
                                      LinearProgressBar.progressTypeLinear,
                                  minHeight: 6,
                                  currentStep:
                                      Constants.currentJobPostingStep.value,
                                  progressColor:
                                      const Color(MyColors.themeRedColor),
                                  backgroundColor:
                                      const Color(MyColors.lightSilverColor),
                                  borderRadius: BorderRadius.circular(2.r),
                                ),
                              );
                            }),
                            Align(
                              alignment: Alignment.topRight,
                              child: Padding(
                                padding:
                                    EdgeInsets.only(top: 5.0.h, right: 15.0.w),
                                child: Text(
                                  "${Strings.step(Get.context!)} ${Constants.currentJobPostingStep.value}/${Constants.jobPostingSteps}",
                                  style: TextStyle(
                                      fontSize: 14.5.sp,
                                      color:
                                          const Color(MyColors.midGrayColor)),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        flex: 16,
                        child: Padding(
                          padding: EdgeInsets.all(8.0.r),
                          child: Column(
                            children: [
                              const Spacer(),
                              Card(
                                elevation: 0,
                                color: const Color(MyColors.cardGrayColor50),
                                child: Column(
                                  children: [
                                    // ... static content (headings, descriptions) stays outside Obx ...
                                    Padding(
                                      padding: EdgeInsets.only(
                                          left: 16.0.w,
                                          right: 16.0.w,
                                          top: 16.0.h),
                                      child: Align(
                                        alignment: Alignment.topLeft,
                                        child: HeadingTextW500(
                                            text: Strings
                                                .photosOfConstructionPlansOptional(
                                                    Get.context!),
                                            centerAlign: false,
                                            size: 18.sp),
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.only(
                                          left: 16.0.w,
                                          right: 16.0.w,
                                          top: 10.h,
                                          bottom: 16.0.h),
                                      child: Headingdescription(
                                          text: Strings
                                              .addingPicturesHelpsBetterQuotes(
                                                  context),
                                          centerAlign: false,
                                          size: 15.sp),
                                    ),

                                    Obx(() => _buildRadioOption(
                                        Strings.yesText(context), 1)),
                                    Obx(() =>
                                        controller.selectedValue!.value == "Yes"
                                            ? _imagePickOption()
                                            : const SizedBox()),
                                    Obx(() =>
                                        controller.selectedValue!.value == "Yes"
                                            ? const SizedBox(height: 10)
                                            : const SizedBox()),
                                    Obx(() {
                                      if (controller.selectedValue!.value !=
                                          "Yes") {
                                        return const SizedBox();
                                      }
                                      if (controller.selectedImages.isEmpty) {
                                        return Container();
                                      }
                                      return Padding(
                                        padding:
                                            const EdgeInsets.only(left: 12.0),
                                        child: SizedBox(
                                          height: 88.h,
                                          child: ListView.builder(
                                            scrollDirection: Axis.horizontal,
                                            itemCount: controller
                                                .selectedImages.length,
                                            itemBuilder: (context, index) {
                                              return Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 0),
                                                child: ClipRRect(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          10.r),
                                                  child: Stack(
                                                    children: [
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(7.0),
                                                        child: ClipRRect(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      10.r),
                                                          child: Image.file(
                                                              controller
                                                                      .selectedImages[
                                                                  index],
                                                              width: 100.w,
                                                              height: 110.h,
                                                              fit:
                                                                  BoxFit.cover),
                                                        ),
                                                      ),
                                                      Positioned(
                                                        right: 0,
                                                        child: GestureDetector(
                                                          onTap: () => controller
                                                              .selectedImages
                                                              .removeAt(index),
                                                          child: const Icon(
                                                              Icons
                                                                  .cancel_outlined,
                                                              color: Color(MyColors
                                                                  .themeRedColor)),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              );
                                            },
                                          ),
                                        ),
                                      );
                                    }),
                                    Obx(() => controller.selectedValue!.value ==
                                            "Yes"
                                        ? Row(
                                            children: [
                                              Checkbox(
                                                checkColor: const Color(
                                                    MyColors.whiteColor),
                                                fillColor: WidgetStateProperty
                                                    .all(controller
                                                            .isChecked.value
                                                        ? const Color(MyColors
                                                            .themeRedColor)
                                                        : const Color(MyColors
                                                            .whiteColor)),
                                                value:
                                                    controller.isChecked.value,
                                                onChanged: (bool? newValue) {
                                                  controller.isChecked.value =
                                                      newValue!;
                                                },
                                              ),
                                              Expanded(
                                                child: Headingdescription(
                                                    text:
                                                        Strings.photoShareAgree(
                                                            context),
                                                    centerAlign: false,
                                                    size: 14.sp),
                                              ),
                                            ],
                                          )
                                        : const SizedBox()),
                                    Obx(() => _buildRadioOption(
                                        Strings.noMaybeLater(context), 0)),
                                    SizedBox(height: 16.h),
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
                          padding: EdgeInsets.all(9.0.r),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Expanded(
                                child: Padding(
                                  padding: EdgeInsets.only(
                                      left: 25.0.w, right: 12.0.w),
                                  child: FullWidthOutlineButton(
                                      text: Strings.back(context),
                                      fontsize: 15.0.sp,
                                      color: MyColors.themeRedColor,
                                      onPressed: () {
                                        if (Platform.isIOS) {
                                          Constants
                                              .currentJobPostingStep.value--;
                                        }
                                        Get.back();
                                      }),
                                ),
                              ),
                              Expanded(
                                child: Padding(
                                  padding: EdgeInsets.only(
                                      left: 12.0.w, right: 25.0.w),
                                  child: FullWidthButtonPrimary(
                                      text: Strings.next(context),
                                      fontsize: 15.0.sp,
                                      color: MyColors.themeRedColor,
                                      onPressed: () {
                                        if (controller
                                            .selectedImages.isNotEmpty) {
                                          if (controller.isChecked.value) {
                                            try {
                                              Constants.selectedImages.clear();
                                              Constants.selectedImages.addAll(
                                                  controller.selectedImages);
                                              Constants.currentJobPostingStep
                                                  .value++;
                                              Get.toNamed(
                                                  AppLinks.pick_address_screen);
                                            } catch (e) {
                                              throw Exception(e);
                                            }
                                          } else {
                                            Fluttertoast.showToast(
                                                msg: Strings
                                                    .pleaseAgreeToSharePhoto(
                                                        context));
                                          }
                                        } else {
                                          try {
                                            Constants.selectedImages.clear();
                                            Constants
                                                .currentJobPostingStep.value++;
                                            Get.toNamed(
                                                AppLinks.pick_address_screen);
                                          } catch (e) {
                                            throw Exception(e);
                                          }
                                        }
                                      }),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          )),
    );
  }

  Widget _buildRadioOption(String text, int val) {
    bool isSelected = controller.selectedValue!.value == text;

    return GestureDetector(
      onTap: () {
        if (val == 0) {
          controller.selectedImages.clear();
        }
        controller.selectedValue!.value = text; // Toggle selection
      },
      child: Padding(
        padding: EdgeInsets.only(left: 16.0.w, right: 16.0.w),
        child: Container(
          width: MediaQuery.of(Get.context!).size.width * 0.95,
          height: MediaQuery.of(Get.context!).size.height / 16,
          margin: EdgeInsets.symmetric(vertical: 8.0.h),
          padding: EdgeInsets.all(12.0.r),
          decoration: BoxDecoration(
            color: isSelected
                ? const Color(0xFFFFEBEE)
                : Colors.white, // Change background when selected
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: isSelected
                  ? const Color(MyColors.themeRedColor)
                  : const Color(MyColors.lightSilverColor),
              width: 1,
            ),
          ),
          child: Row(
            children: [
              Radio<String>(
                value: text,
                groupValue: controller.selectedValue!.value,
                activeColor: const Color(MyColors.themeRedColor),
                onChanged: (value) {
                  controller.selectedValue!.value = value!; // Toggle selection
                },
              ),
              Text(
                text,
                style: TextStyle(fontSize: 18.sp, color: Colors.black),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _imagePickOption() {
    return Column(
      children: [
        SizedBox(height: 9.0.h),
        Padding(
          padding: EdgeInsets.only(left: 19.0.w),
          child: Align(
            alignment: Alignment.topLeft,
            child: Headingdescription(
                text: Strings.max15MbFileText(Get.context!),
                centerAlign: false,
                size: 13.0.sp),
          ),
        ),
        Padding(
          padding: EdgeInsets.all(4.0.r),
          child: GestureDetector(
            onTap: controller.pickImage,
            child: Padding(
              padding: EdgeInsets.only(left: 15.0.w, right: 15.0.w),
              child: SizedBox(
                width: MediaQuery.of(Get.context!).size.width *
                    0.9, // Adjust width
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Image.asset(
                      width: MediaQuery.of(Get.context!).size.width,
                      height: 70.0.h,
                      "lib/assets/images/pickimage_rectangle.png",
                      fit: BoxFit.fill,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          width: 40.0.w,
                          height: 40.0.h,
                          "lib/assets/images/pickimage_icon.png",
                          fit: BoxFit.fill,
                        ),
                        SizedBox(
                          width: 12.0.w,
                        ),
                        Flexible(
                          child: Text(
                            Strings.uploadFilesFromGallery(Get.context!),
                            style: TextStyle(
                                fontSize: 16.0.sp, color: Colors.black),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
