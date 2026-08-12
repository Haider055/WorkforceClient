import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:workforceclientapp/Controllers/ReportController.dart';
import 'package:workforceclientapp/Others/MyColors.dart';
import 'package:workforceclientapp/Others/Strings.dart';
import 'package:workforceclientapp/views/widgets/FullWidthButtonPrimary.dart';
import 'package:workforceclientapp/views/widgets/HeadingTextW600.dart';

class ReportScreen extends GetView<ReportController> {
  const ReportScreen({super.key});

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
                    text: "Report",
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
        body: Obx(() {
          if (controller.isLoading.value) {
            return const Center(
              child: CircularProgressIndicator(
                color: Color(MyColors.themeRedColor),
              ),
            );
          }

          if (controller.options.value == null) {
            return Center(
              child: Text(
                "Failed to load report options",
                style: TextStyle(fontSize: 14.sp),
              ),
            );
          }

          return Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  padding: EdgeInsets.all(16.0.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Why are you reporting this?",
                        style: TextStyle(
                          fontSize: 16.sp,
                          color: Colors.grey[600],
                          fontFamily: 'Poppins',
                        ),
                      ),
                      SizedBox(height: 8.h),
                      ...controller.options.value!.reasons
                          .asMap()
                          .entries
                          .map((entry) {
                        final reason = entry.value;
                        return RadioListTile<String>(
                          contentPadding: EdgeInsets.zero,
                          dense: true,
                          activeColor: const Color(MyColors.themeRedColor),
                          title: Text(
                            reason.label ?? "",
                            style: TextStyle(fontSize: 14.sp),
                          ),
                          value: reason.value ?? "",
                          groupValue: controller.selectedReason.value.isEmpty
                              ? null
                              : controller.selectedReason.value,
                          onChanged: (value) {
                            controller.selectedReason.value = value ?? "";
                          },
                        );
                      }),
                      if (controller.showDetailsField) ...[
                        SizedBox(height: 12.h),
                        TextField(
                          controller: controller.otherDetailsController,
                          maxLines: 4,
                          maxLength: controller.options.value!.detailsMaxLength,
                          style: TextStyle(fontSize: 14.sp),
                          decoration: InputDecoration(
                            hintText: "Tell us more...",
                            hintStyle: TextStyle(
                              fontSize: 13.sp,
                            ),
                            fillColor: Colors.white,
                            filled: true,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(9.r),
                              borderSide: const BorderSide(
                                  color: Color(MyColors.lightGrayColor)),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(9.r),
                              borderSide: const BorderSide(
                                  color: Color(MyColors.lightGrayColor)),
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(
                  left: 16.0.w,
                  right: 16.0.w,
                  bottom: 16.0.h,
                  top: 8.0.h,
                ),
                child: controller.isSubmitting.value
                    ? const Center(
                        child: CircularProgressIndicator(
                          color: Color(MyColors.themeRedColor),
                        ),
                      )
                    : FullWidthButtonPrimary(
                        text: Strings.submitReportText(context),
                        fontsize: 15.0.sp,
                        color: MyColors.themeRedColor,
                        onPressed: () {
                          controller.submitReport();
                        },
                      ),
              ),
            ],
          );
        }),
      ),
    );
  }
}
