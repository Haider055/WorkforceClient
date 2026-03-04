import 'package:flutter/material.dart';
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
    return WillPopScope(
      onWillPop: () async {
        if (!controller.isLoading.value) {
          Get.offAllNamed(AppLinks.select_service_screen);
        }
        return false;
      },
      child: Obx(() {
        return Scaffold(
          backgroundColor: Colors.white,
          body: SafeArea(
              child: !controller.isLoading.value
                  ? Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Spacer(),
                        HeadingTextW600(
                            text: Strings.congratulations(context),
                            centerAlign: false,
                            size: 32.0),
                        Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Image.asset(
                                "lib/assets/icons/jobpostedicon.png",
                                fit: BoxFit.contain,
                                height: 217.0,
                                width: 267.0)),
                        const HeadingTextW600(
                            text: "Your job has been posted successfully!",
                            centerAlign: false,
                            size: 13.5),
                        const HeadingTextW500(
                            text:
                                "Your job is now live and ready to attract skilled professionals.",
                            centerAlign: true,
                            size: 16),
                        const Spacer(),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(12.0),
                                child: FullWidthButtonPrimary(
                                    text: Strings.exploreRecommendedTradesmen(
                                        context),
                                    fontsize: 15.0,
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
                                padding: const EdgeInsets.only(
                                    left: 12.0, right: 12.0),
                                child: FullWidthOutlineButton(
                                    text: Strings.viewPostedJobs(context),
                                    fontsize: 15.0,
                                    color: MyColors.themeRedColor,
                                    onPressed: () {
                                      Get.offAllNamed(
                                          AppLinks.select_service_screen,
                                          arguments: {'toWhere': 'PostedJobs'});
                                    }),
                              ),
                            ],
                          ),
                        ),
                      ],
                    )
                  : const Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CircularProgressIndicator(
                            color: Color(MyColors.themeRedColor),
                          ),
                          SizedBox(
                            height: 4.0,
                          ),
                          Text("Posting your Job...")
                        ],
                      ),
                    )),
        );
      }),
    );
  }
}
