import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:linear_progress_bar/linear_progress_bar.dart';
import 'package:workforceclientapp/Controllers/UploadJobImagesController.dart';
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
    return WillPopScope(
      onWillPop: () async {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text("Discard changes!"),
            content: const Text("Are you sure to end Job Posting procress?"),
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
                            Get.offAllNamed(AppLinks.select_service_screen);
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
      child: SafeArea(
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
            body: Obx(() {
              return Stack(
                children: [
                  Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                                  progressType:
                                      LinearProgressBar.progressTypeLinear,
                                  minHeight: 6,
                                  currentStep: Constants.currentJobPostingStep,
                                  progressColor:
                                      const Color(MyColors.themeRedColor),
                                  backgroundColor:
                                      const Color(MyColors.lightSilverColor),
                                  borderRadius: BorderRadius.circular(2),
                                ),
                              ),
                              Align(
                                alignment: Alignment.topRight,
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                      top: 5.0, right: 15),
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
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              children: [
                                const Spacer(),
                                Card(
                                  elevation: 0,
                                  color: const Color(MyColors.cardGrayColor50),
                                  child: Column(
                                    children: [
                                      const Padding(
                                        padding: EdgeInsets.only(
                                            left: 16.0, right: 16, top: 16),
                                        child: Align(
                                          alignment: Alignment.topLeft,
                                          child: HeadingTextW500(
                                              text:
                                                  "Photos of construction plans (optional)",
                                              centerAlign: false,
                                              size: 18),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            left: 16.0,
                                            right: 16.0,
                                            top: 10,
                                            bottom: 16.0),
                                        child: Headingdescription(
                                            text: Strings
                                                .addingPicturesHelpsBetterQuotes(
                                                    context),
                                            centerAlign: false,
                                            size: 17),
                                      ),
                                      _buildRadioOption(
                                          Strings.yesText(context), 1),
                                      controller.selectedValue == "Yes"
                                          ? const SizedBox()
                                          : const SizedBox(),
                                      controller.selectedValue == "Yes"
                                          ? _imagePickOption()
                                          : const SizedBox(),
                                      controller.selectedValue == "Yes"
                                          ? const SizedBox(height: 10)
                                          : const SizedBox(),
                                      controller.selectedValue == "Yes"
                                          ? controller.selectedImages.isNotEmpty
                                              ? SizedBox(
                                                  height: 110,
                                                  child: ListView.builder(
                                                    scrollDirection:
                                                        Axis.horizontal,
                                                    itemCount: controller
                                                        .selectedImages.length,
                                                    itemBuilder:
                                                        (context, index) {
                                                      return Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .symmetric(
                                                                horizontal: 0),
                                                        child: ClipRRect(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(10),
                                                          child: Stack(
                                                            children: [
                                                              Padding(
                                                                padding:
                                                                    const EdgeInsets
                                                                        .all(
                                                                        7.0),
                                                                child:
                                                                    ClipRRect(
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              10),
                                                                  child: Image.file(
                                                                      controller.selectedImages[
                                                                          index],
                                                                      width:
                                                                          100,
                                                                      height:
                                                                          110,
                                                                      fit: BoxFit
                                                                          .cover),
                                                                ),
                                                              ),
                                                              Positioned(
                                                                right: 0,
                                                                child:
                                                                    GestureDetector(
                                                                  onTap: () {
                                                                    controller
                                                                        .selectedImages
                                                                        .removeAt(
                                                                            index);
                                                                  },
                                                                  child:
                                                                      const Icon(
                                                                    Icons
                                                                        .cancel_outlined,
                                                                    color: Color(
                                                                        MyColors
                                                                            .themeRedColor),
                                                                  ),
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      );
                                                    },
                                                  ),
                                                )
                                              : Container()
                                          : const SizedBox(),
                                      controller.selectedValue!.value == "Yes"
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
                                                  value: controller
                                                      .isChecked.value,
                                                  onChanged: (bool? newValue) {
                                                    controller.isChecked.value =
                                                        newValue!;
                                                  },
                                                ),
                                                Expanded(
                                                  child: Headingdescription(
                                                      text: Strings
                                                          .photoShareAgree(
                                                              context),
                                                      centerAlign: false,
                                                      size: 14),
                                                ),
                                              ],
                                            )
                                          : const SizedBox(),
                                      _buildRadioOption(
                                          Strings.noMaybeLater(context), 0),
                                      const SizedBox(height: 16),
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
                            padding: const EdgeInsets.all(9.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                        left: 25.0, right: 12.0),
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
                                    padding: const EdgeInsets.only(
                                        left: 12.0, right: 25.0),
                                    child: FullWidthButtonPrimary(
                                        text: Strings.next(context),
                                        fontsize: 15.0,
                                        color: MyColors.themeRedColor,
                                        onPressed: () {
                                          if (controller
                                              .selectedImages.isNotEmpty) {
                                            if (controller.isChecked.value) {
                                              try {
                                                Constants.selectedImages
                                                    .clear();
                                                Constants.selectedImages.addAll(
                                                    controller.selectedImages);
                                                Constants
                                                    .currentJobPostingStep++;
                                                Get.toNamed(AppLinks
                                                    .pick_address_screen);
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
                                              Constants.selectedImages.clear();
                                              Constants.currentJobPostingStep++;
                                              Get.toNamed(
                                                  AppLinks.pick_address_screen);
                                            } catch (e) {
                                              throw Exception(e);
                                            }
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
                ],
              );
            })),
      ),
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
        padding: const EdgeInsets.only(left: 16.0, right: 16.0),
        child: Container(
          width: MediaQuery.of(Get.context!).size.width * 0.95,
          height: MediaQuery.of(Get.context!).size.height / 16,
          margin: const EdgeInsets.symmetric(vertical: 8),
          padding: const EdgeInsets.all(12),
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
                style: const TextStyle(fontSize: 18, color: Colors.black),
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
        const SizedBox(height: 9.0),
        const Padding(
          padding: EdgeInsets.only(left: 19.0),
          child: Align(
            alignment: Alignment.topLeft,
            child: Headingdescription(
                text: "Max. 15 files, Max. 2 MB per file",
                centerAlign: false,
                size: 13),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(4.0),
          child: GestureDetector(
            onTap: controller.pickImage,
            child: Padding(
              padding: const EdgeInsets.only(left: 15.0, right: 15.0),
              child: SizedBox(
                width: MediaQuery.of(Get.context!).size.width *
                    0.9, // Adjust width
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Image.asset(
                      width: MediaQuery.of(Get.context!).size.width,
                      height: 70.0,
                      "lib/assets/images/pickimage_rectangle.png",
                      fit: BoxFit.fill,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          width: 40.0,
                          height: 40.0,
                          "lib/assets/images/pickimage_icon.png",
                          fit: BoxFit.fill,
                        ),
                        const SizedBox(
                          width: 12.0,
                        ),
                        const Flexible(
                          child: Text(
                            "Upload files from gallery",
                            style: TextStyle(fontSize: 16, color: Colors.black),
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
