import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:linear_progress_bar/linear_progress_bar.dart';
import 'package:workforceclientapp/Others/Constants.dart';
import 'package:workforceclientapp/Others/MyColors.dart';
import 'package:workforceclientapp/Others/Strings.dart';
import 'package:workforceclientapp/views/screens/ClientJobPosting/CheckBoxQuestionsScreen.dart';
import 'package:workforceclientapp/views/screens/ClientJobPosting/JobDraft.dart';
import 'package:workforceclientapp/views/widgets/FullWidthButtonPrimary.dart';
import 'package:workforceclientapp/views/widgets/FullWidthOutlineButton.dart';
import 'package:workforceclientapp/views/widgets/HeadingTextW500.dart';
import 'package:workforceclientapp/views/widgets/Headingdescription.dart';

class JobTitleScreen extends GetView<JobTitleController> {
  const JobTitleScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: true,
      onPopInvokedWithResult: (didPop, result) {},
      child: GestureDetector(
        onTap: () {
          FocusManager.instance.primaryFocus?.unfocus();
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
                  style: BorderStyle.solid,
                ),
              ),
              child: Center(
                child: Padding(
                  padding: EdgeInsets.only(left: 8.0.w, right: 8.0.w),
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
            ),
          ),
          body: SafeArea(
            child: Column(
              children: [
                Expanded(
                  flex: 1,
                  child: Column(
                    children: [
                      Obx(() {
                        return Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: 10.0.w,
                            vertical: 0,
                          ),
                          child: LinearProgressBar(
                            maxSteps: Constants.jobPostingSteps,
                            progressType: LinearProgressBar.progressTypeLinear,
                            minHeight: 6,
                            currentStep: Constants.currentJobPostingStep.value,
                            progressColor: const Color(MyColors.themeRedColor),
                            backgroundColor: const Color(
                              MyColors.lightSilverColor,
                            ),
                            borderRadius: BorderRadius.circular(2),
                          ),
                        );
                      }),
                      Align(
                        alignment: Alignment.topRight,
                        child: Padding(
                          padding: EdgeInsets.only(top: 5.0.h, right: 15.0.w),
                          // The bar was in an Obx but this label was not, so
                          // "Step 1/4" never changed.
                          child: Obx(() {
                            return Text(
                              "${Strings.step(context)} ${Constants.currentJobPostingStep.value}/${Constants.jobPostingSteps}",
                              style: TextStyle(
                                fontSize: 14.5.sp,
                                color: const Color(MyColors.midGrayColor),
                              ),
                            );
                          }),
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
                                padding: EdgeInsets.only(
                                  left: 18.0.w,
                                  top: 12.0.h,
                                  right: 18.0.w,
                                ),
                                child: HeadingTextW500(
                                  text: Strings.jobTitle(context),
                                  centerAlign: false,
                                  size: 20,
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.only(
                                  left: 18.0.w,
                                  top: 5.0.h,
                                  right: 18.0.w,
                                ),
                                child: Headingdescription(
                                  text: Strings.jobTitleDesc(context),
                                  centerAlign: false,
                                  size: 16,
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.all(18.0.r),
                                child: TextField(
                                  maxLines: 2,
                                  keyboardType: TextInputType.text,
                                  textInputAction: TextInputAction.done,
                                  autofocus: false,
                                  // `enabled: Constants.titleTVFocus.value`
                                  // is gone. It was read outside any Obx so
                                  // it never took effect, and toggling a
                                  // field's enabled state to kill the
                                  // keyboard causes its own flicker. A real
                                  // unfocus does the job.
                                  maxLength: 150,
                                  showCursor: true,
                                  cursorColor: const Color(
                                    MyColors.themeRedColor,
                                  ),
                                  onSubmitted: (value) {
                                    onTextSubmit();
                                  },
                                  controller: controller.titleTextField(),
                                  decoration: InputDecoration(
                                    hintText: Strings.jobTitleHint(context),
                                    hintStyle: TextStyle(
                                      fontSize: 15.sp,
                                      color: const Color(
                                        MyColors.darkGrayColor,
                                      ),
                                      fontWeight: FontWeight.w400,
                                    ),
                                    fillColor: const Color(
                                      MyColors.whiteColor,
                                    ),
                                    filled: true,
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(
                                        9.0.r,
                                      ),
                                      borderSide: const BorderSide(
                                        color: Color(MyColors.lightGrayColor),
                                      ),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(
                                        9.0.r,
                                      ),
                                      borderSide: const BorderSide(
                                        color: Color(MyColors.themeRedColor),
                                      ),
                                    ),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(
                                        9.0.r,
                                      ),
                                      borderSide: const BorderSide(
                                        color: Color(MyColors.lightGrayColor),
                                      ),
                                    ),
                                  ),
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
                            padding: EdgeInsets.only(
                              left: 25.0.w,
                              right: 12.0.w,
                            ),
                            child: FullWidthOutlineButton(
                              text: Strings.back(context),
                              fontsize: 15,
                              color: MyColors.themeRedColor,
                              onPressed: () {
                                FocusManager.instance.primaryFocus?.unfocus();
                                Get.back();
                              },
                            ),
                          ),
                        ),
                        Expanded(
                          child: Padding(
                            padding: EdgeInsets.only(
                              left: 12.0.w,
                              right: 25.0.w,
                            ),
                            child: FullWidthButtonPrimary(
                              text: Strings.next(context),
                              fontsize: 15,
                              color: MyColors.themeRedColor,
                              onPressed: () {
                                onTextSubmit();
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void onTextSubmit() {
    try {
      Constants.jobTitle = controller.titleTextField.value.text.trim();

      if (Constants.jobTitle.isEmpty) {
        Fluttertoast.showToast(msg: Strings.writeJobTitle(Get.context!));
        return;
      }

      // The 4-step flow skipped this length check; the other one applied it.
      // Keeping that difference, just stated plainly.
      if (Constants.jobPostingSteps != 4 && Constants.jobTitle.length <= 3) {
        Fluttertoast.showToast(msg: Strings.nameMustBeAtLeast(Get.context!));
        return;
      }

      Constants.currentJobPostingStep.value++;
      JobDraftService.save(step: Constants.currentJobPostingStep.value);
      _goNext();
    } catch (e) {
      debugPrint('Error in onTextSubmit: $e');
    }
  }

  Future<void> _goNext() async {
    // Drop focus for real. FocusScope.of(Get.context!).unfocus() leaves the
    // field's own node focused, so the keyboard was still "owned" by this
    // screen while the next route pushed — hence the flash.
    FocusManager.instance.primaryFocus?.unfocus();

    // Give the keyboard one frame plus a moment to finish closing before the
    // push animation starts.
    await Future.delayed(const Duration(milliseconds: 120));

    // Get.to takes a builder; passing the widget itself is the old form.
    Get.to(() => const CheckBoxQuestionsScreen());
  }
}

class JobTitleController extends GetxController {
  final titleTextField = TextEditingController().obs;

  @override
  void onClose() {
    titleTextField.value.dispose();
    super.onClose();
  }
}
