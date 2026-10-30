import 'package:auto_size_text/auto_size_text.dart';
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
import 'package:workforceclientapp/views/screens/ClientJobPosting/JobDraft.dart';
import 'package:workforceclientapp/views/widgets/FullWidthButtonPrimary.dart';
import 'package:workforceclientapp/views/widgets/FullWidthOutlineButton.dart';
import 'package:workforceclientapp/views/widgets/HeadingTextW500.dart';
import 'package:workforceclientapp/views/widgets/Headingdescription.dart';

class UploadJobImageScreen extends GetView<UploadJobImagesController> {
  const UploadJobImageScreen({super.key});

  // The stored values are inverted relative to the display order, which is
  // what made the old `val == 1 ? "2" : "1"` juggling so easy to get wrong.
  // Named here so the intent is readable; the values themselves are
  // unchanged, so anything else reading selectedValue still works.
  static const String _yes = "2";
  static const String _no = "1";

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: true,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) {
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
                style: BorderStyle.solid,
              ),
            ),
            child: Stack(
              children: [
                Center(
                  child: Padding(
                    padding: EdgeInsets.only(left: 8.0.w, right: 40.0.w),
                    child: AutoSizeText(
                      Constants.selectedServiceName,
                      maxLines: 2,
                      textAlign: TextAlign.center,
                      minFontSize: 9,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                          fontSize: 15.5, fontWeight: FontWeight.w600),
                    ),
                  ),
                ),
                Positioned(
                  top: 0,
                  bottom: 0,
                  right: 12.w,
                  child: GestureDetector(
                    onTap: () {
                      Commons.showExitJobPostingDialog(Get.context!);
                    },
                    child: const Icon(Icons.close),
                  ),
                ),
              ],
            ),
          ),
        ),
        body: SafeArea(
          child: Column(
            children: [
              // Progress Bar Section
              Padding(
                padding:
                    EdgeInsets.symmetric(horizontal: 10.0.w, vertical: 8.h),
                child: Column(
                  children: [
                    Obx(() {
                      return LinearProgressBar(
                        maxSteps: Constants.jobPostingSteps,
                        progressType: LinearProgressBar.progressTypeLinear,
                        minHeight: 6,
                        currentStep: Constants.currentJobPostingStep.value,
                        progressColor: const Color(MyColors.themeRedColor),
                        backgroundColor: const Color(MyColors.lightSilverColor),
                        borderRadius: BorderRadius.circular(2.r),
                      );
                    }),
                    Align(
                      alignment: Alignment.topRight,
                      child: Padding(
                        padding: EdgeInsets.only(top: 5.0.h, right: 5.0.w),
                        child: Obx(
                          () => Text(
                            "${Strings.step(context)} ${Constants.currentJobPostingStep.value}/${Constants.jobPostingSteps}",
                            style: TextStyle(
                              fontSize: 14.5.sp,
                              color: const Color(MyColors.midGrayColor),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // Scrollable Content Section
              Expanded(
                child: SingleChildScrollView(
                  padding: EdgeInsets.all(8.0.r),
                  child: Card(
                    elevation: 0,
                    color: const Color(MyColors.cardGrayColor50),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding:
                              EdgeInsets.fromLTRB(16.0.w, 16.0.h, 16.0.w, 0),
                          child: HeadingTextW500(
                            text: Strings.uploadPhotosText(context),
                            centerAlign: false,
                            size: 18.sp,
                          ),
                        ),
                        Padding(
                          padding:
                              EdgeInsets.fromLTRB(16.0.w, 10.h, 16.0.w, 16.0.h),
                          child: Headingdescription(
                            text: Strings.addingPicturesHelpsBetterQuotes(
                                context),
                            centerAlign: false,
                            size: 14.sp,
                          ),
                        ),

                        // "Yes"
                        _buildRadioOption(Strings.yesText(context), _yes),

                        // Picker + thumbnails + consent, only under "Yes"
                        Obx(() {
                          if (controller.selectedValue?.value != _yes) {
                            return const SizedBox.shrink();
                          }
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _imagePickOption(),
                              if (controller.selectedImages.isNotEmpty)
                                Padding(
                                  padding:
                                      EdgeInsets.only(left: 12.0.w, top: 8.h),
                                  child: SizedBox(
                                    height: 88.h,
                                    child: ListView.builder(
                                      scrollDirection: Axis.horizontal,
                                      itemCount:
                                          controller.selectedImages.length,
                                      itemBuilder: (context, index) {
                                        return ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(10.r),
                                          child: Stack(
                                            children: [
                                              Padding(
                                                padding:
                                                    const EdgeInsets.all(7.0),
                                                child: ClipRRect(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          10.r),
                                                  child: Image.file(
                                                    controller
                                                        .selectedImages[index],
                                                    width: 100.w,
                                                    height: 110.h,
                                                    fit: BoxFit.cover,
                                                  ),
                                                ),
                                              ),
                                              Positioned(
                                                right: 0,
                                                child: GestureDetector(
                                                  onTap: () => controller
                                                      .selectedImages
                                                      .removeAt(index),
                                                  child: const Icon(
                                                    Icons.cancel_outlined,
                                                    color: Color(
                                                        MyColors.themeRedColor),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                ),

                              // Consent only matters once there is at least
                              // one photo, so it only appears then. This is
                              // what stops the user being blocked by a
                              // checkbox for photos they cannot see.
                              if (controller.selectedImages.isNotEmpty)
                                Padding(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 12.0.w, vertical: 8.h),
                                  child: Row(
                                    children: [
                                      Checkbox(
                                        checkColor:
                                            const Color(MyColors.whiteColor),
                                        fillColor:
                                            WidgetStateProperty.resolveWith(
                                                (states) {
                                          return controller.isChecked.value
                                              ? const Color(
                                                  MyColors.themeRedColor)
                                              : const Color(
                                                  MyColors.whiteColor);
                                        }),
                                        value: controller.isChecked.value,
                                        onChanged: (bool? newValue) {
                                          controller.isChecked.value =
                                              newValue ?? false;
                                        },
                                      ),
                                      Expanded(
                                        child: GestureDetector(
                                          onTap: () {
                                            controller.isChecked.value =
                                                !controller.isChecked.value;
                                          },
                                          child: Headingdescription(
                                            text: Strings.photoShareAgree(
                                                context),
                                            centerAlign: false,
                                            size: 11.sp,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),

                              Padding(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 20.0.w, vertical: 2.h),
                                child: Headingdescription(
                                  text: Strings.disclaimerInPickImageText(
                                      context),
                                  centerAlign: false,
                                  size: 10.5.sp,
                                ),
                              )
                            ],
                          );
                        }),

                        // "No / maybe later"
                        _buildRadioOption(Strings.noMaybeLater(context), _no),
                        SizedBox(height: 16.h),
                      ],
                    ),
                  ),
                ),
              ),

              Container(
                padding: EdgeInsets.all(12.0.r),
                color: Colors.white,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Expanded(
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 12.0.w),
                        child: FullWidthOutlineButton(
                          text: Strings.back(context),
                          fontsize: 15.0,
                          color: MyColors.themeRedColor,
                          onPressed: () {
                            // Hold on to the picked photos so stepping back
                            // and forward again does not lose them.
                            controller.stashImages();
                            Get.back();
                          },
                        ),
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 12.0.w),
                        child: FullWidthButtonPrimary(
                          text: Strings.next(context),
                          fontsize: 15.0,
                          color: MyColors.themeRedColor,
                          onPressed: _onNext,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _onNext() {
    final hasImages = controller.selectedImages.isNotEmpty;
    final sharing = controller.selectedValue?.value == _yes;

    // Consent is required ONLY on the "Yes + at least one photo" path.
    // No option chosen, "No", or "Yes" with nothing picked all pass straight
    // through.
    if (sharing && hasImages && !controller.isChecked.value) {
      Fluttertoast.showToast(
          msg: Strings.pleaseAgreeToSharePhoto(Get.context!));
      return;
    }

    controller.stashImages();
    Constants.currentJobPostingStep.value++;
    JobDraftService.save(step: Constants.currentJobPostingStep.value);
    Get.toNamed(AppLinks.pick_address_screen);
  }

  Widget _buildRadioOption(String text, String optionValue) {
    return Obx(() {
      final bool isSelected = controller.selectedValue?.value == optionValue;

      return GestureDetector(
        // Was `if (val == 0)`, a branch that could never run, so tapping the
        // card body to choose "No" left the photos in the list. They stayed
        // hidden but still demanded the consent checkbox, and Next was stuck
        // on a toast about photos the user could not see.
        onTap: () => _selectOption(optionValue),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 14.0.w, vertical: 8.0.h),
          child: Container(
            width: double.infinity,
            padding: EdgeInsets.all(2.0.r),
            decoration: BoxDecoration(
              color: isSelected ? const Color(0xFFFFEBEE) : Colors.white,
              borderRadius: BorderRadius.circular(10.r),
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
                  value: optionValue,
                  // was selectedValue!.value — crashed if it was ever null
                  groupValue: controller.selectedValue?.value,
                  activeColor: const Color(MyColors.themeRedColor),
                  onChanged: (value) {
                    if (value != null) _selectOption(value);
                  },
                ),
                Expanded(
                  child: Text(
                    text,
                    style: TextStyle(fontSize: 16.sp, color: Colors.black),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    });
  }

  /// Single place where the option changes, so the radio and the card body
  /// can never drift apart again.
  void _selectOption(String optionValue) {
    controller.selectedValue?.value = optionValue;

    if (optionValue == _no) {
      controller.selectedImages.clear();
      controller.isChecked.value = false;
    }
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
              size: 12.0.sp,
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.all(4.0.r),
          child: GestureDetector(
            onTap: controller.pickImage,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 15.0.w),
              child: SizedBox(
                width: double.infinity,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Image.asset(
                      "lib/assets/images/pickimage_rectangle.png",
                      width: double.infinity,
                      height: 70.0.h,
                      fit: BoxFit.fill,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          "lib/assets/images/pickimage_icon.png",
                          width: 40.0.w,
                          height: 40.0.h,
                          fit: BoxFit.fill,
                        ),
                        SizedBox(width: 12.0.w),
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
