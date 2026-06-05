import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:workforceclientapp/Controllers/JobPostCompleteController.dart';
import 'package:workforceclientapp/Others/Constants.dart';
import 'package:workforceclientapp/Others/MyColors.dart';
import 'package:workforceclientapp/Others/Strings.dart';
import 'package:workforceclientapp/Others/routes.dart';
import 'package:workforceclientapp/views/widgets/FullWidthButtonPrimary.dart';
import 'package:workforceclientapp/views/widgets/FullWidthOutlineButton.dart';
import 'package:workforceclientapp/views/widgets/HeadingTextW500.dart';
import 'package:workforceclientapp/views/widgets/HeadingTextW600.dart';

class JobPostCompletedScreen extends GetView<JobPostCompleteController> {
  const JobPostCompletedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) {
        if (!controller.isLoading.value) {
          Get.offAllNamed(AppLinks.select_service_screen);
        }
      },
      child: Obx(() {
        return Scaffold(
          backgroundColor: Colors.white,
          body: !controller.isLoading.value
              ? controller.jobPostingFailed.value
                  ? const SizedBox()
                  : SafeArea(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Spacer(),
                          HeadingTextW600(
                              text: Strings.congratulations(context),
                              centerAlign: false,
                              size: 32.0.sp),
                          Padding(
                              padding: EdgeInsets.all(12.0.r),
                              child: Image.asset(
                                  "lib/assets/icons/jobpostedicon.png",
                                  fit: BoxFit.contain,
                                  height: 217.0.h,
                                  width: 267.0.r)),
                          Padding(
                            padding: EdgeInsets.all(8.0.r),
                            child: HeadingTextW600(
                                text: Strings.jobhasbeenpostedsuccessfullyText(
                                    context),
                                centerAlign: false,
                                size: 15.5.sp),
                          ),
                          Padding(
                            padding: EdgeInsets.all(8.0.r),
                            child: HeadingTextW500(
                                text: Strings.jobisnowliveandreadyText(context),
                                centerAlign: true,
                                size: 14.5.sp),
                          ),
                          const Spacer(),
                          Padding(
                            padding: EdgeInsets.all(8.0.r),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Padding(
                                  padding: EdgeInsets.all(12.0.r),
                                  child: FullWidthButtonPrimary(
                                      text: Strings.exploreRecommendedTradesmen(
                                          context),
                                      fontsize: 15.0.sp,
                                      color: MyColors.themeRedColor,
                                      onPressed: () {
                                        Get.offNamed(
                                          AppLinks.job_recommendations,
                                          arguments: {
                                            'jobId': Constants.lastPostedJobId,
                                            'remainingRequeststoSend': 10,
                                            'fromWhere': 'JobPostCompleted'
                                          },
                                        );
                                      }),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(
                                      left: 12.0.w, right: 12.0.w),
                                  child: FullWidthOutlineButton(
                                      text: Strings.viewPostedJobs(context),
                                      fontsize: 15.0.sp,
                                      color: MyColors.themeRedColor,
                                      onPressed: () {
                                        Get.offAllNamed(
                                            AppLinks.select_service_screen,
                                            arguments: {
                                              'toWhere': 'PostedJobs'
                                            });
                                      }),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    )
              : Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const CircularProgressIndicator(
                        color: Color(MyColors.themeRedColor),
                      ),
                      SizedBox(
                        height: 4.0.h,
                      ),
                      Text(Strings.postingyourJobText(Get.context!)),
                    ],
                  ),
                ),
        );
      }),
    );
  }
}
