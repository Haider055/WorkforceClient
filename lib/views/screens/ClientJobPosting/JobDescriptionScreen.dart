import 'package:flutter/material.dart';
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
            title: const Text("Discard changes!"),
            content: const Text("Are you sure to end Job Posting process?"),
            contentTextStyle:
                const TextStyle(fontSize: 15.5, color: Colors.black),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            backgroundColor: const Color(MyColors.colorRed200),
            actions: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                      child: FullWidthOutlineButton(
                          text: Strings.noText(context),
                          fontsize: 15.0,
                          color: MyColors.themeRedColor,
                          onPressed: () {
                            Get.back();
                          }),
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                      child: FullWidthButtonPrimary(
                          text: Strings.yesText(context),
                          fontsize: 15.0,
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
              padding: const EdgeInsets.only(left: 8.0, right: 8.0),
              child: Text(Constants.selectedServiceName,
                  textAlign: TextAlign.center,
                  overflow: TextOverflow.ellipsis,
                  softWrap: true,
                  style: const TextStyle(
                      color: Colors.black,
                      fontSize: 16.0,
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
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10.0, vertical: 0),
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
                      padding: const EdgeInsets.only(top: 5.0, right: 15),
                      child: Text(
                        "Step ${Constants.currentJobPostingStep}/${Constants.jobPostingSteps}",
                        style: const TextStyle(
                            fontSize: 14.5,
                            color: Color(MyColors.midGrayColor)),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              flex: 16,
              child: Padding(
                padding: const EdgeInsets.all(12.0),
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
                                const EdgeInsets.only(left: 18.0, top: 12.0),
                            child: HeadingTextW500(
                                text: Strings.description(context),
                                centerAlign: false,
                                size: 20),
                          ),
                          const Padding(
                            padding: EdgeInsets.only(left: 18.0, top: 5),
                            child: Headingdescription(
                              text: "Tell us more about your need",
                              centerAlign: false,
                              size: 16,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(18.0),
                            child: TextField(
                              maxLines: 12,
                              controller: TextEditingController(
                                  text: Constants.jobDescription),
                              onChanged: (value) {
                                Constants.jobDescription = value;
                              },
                              cursorColor: const Color(MyColors.themeRedColor),
                              decoration: InputDecoration(
                                  hintText: "Please Explain in your own words",
                                  hintStyle: const TextStyle(
                                      fontSize: 15,
                                      color: Color(MyColors.darkGrayColor),
                                      fontWeight: FontWeight.w400),
                                  fillColor: const Color(MyColors.whiteColor),
                                  filled: true,
                                  enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(9.0),
                                      borderSide: const BorderSide(
                                          color:
                                              Color(MyColors.lightGrayColor))),
                                  focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(9.0),
                                      borderSide: const BorderSide(
                                          color:
                                              Color(MyColors.themeRedColor))),
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(9.0),
                                      borderSide: const BorderSide(
                                          color:
                                              Color(MyColors.lightGrayColor)))),
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
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(left: 25.0, right: 12.0),
                        child: FullWidthOutlineButton(
                            text: Strings.back(context),
                            fontsize: 15.0,
                            color: MyColors.themeRedColor,
                            onPressed: () {
                              Constants.currentJobPostingStep--;
                              Get.back();
                            }),
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(left: 12.0, right: 25.0),
                        child: FullWidthButtonPrimary(
                            text: Strings.next(context),
                            fontsize: 15.0,
                            color: MyColors.themeRedColor,
                            onPressed: () {
                              if (Constants.jobDescription.isNotEmpty) {
                                Constants.currentJobPostingStep++;
                                Get.toNamed(AppLinks.upload_job_image_screen);
                              } else {
                                Fluttertoast.showToast(
                                    msg: Strings.writeJobDescription(context));
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
    );
  }
}
