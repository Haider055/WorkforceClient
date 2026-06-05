import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:workforceclientapp/Controllers/EndtheOrderController.dart';
import 'package:workforceclientapp/Others/MyColors.dart';
import 'package:workforceclientapp/Others/Strings.dart';
import 'package:workforceclientapp/views/widgets/FullWidthButtonPrimary.dart';
import 'package:workforceclientapp/views/widgets/HeadingTextW500.dart';
import 'package:workforceclientapp/views/widgets/HeadingTextW600.dart';
import 'package:workforceclientapp/views/widgets/Headingdescription.dart';

class EndTheOrderScreen extends GetView<EndtheOrderController> {
  const EndTheOrderScreen({super.key});

  // @override
  // void didChangeDependencies() {
  //   super.didChangeDependencies();

  //   reasons.add(Strings.endOrderReason1(context));
  //   reasons.add(Strings.endOrderReason2(context));
  //   reasons.add(Strings.endOrderReason3(context));
  //   reasons.add(Strings.endOrderReason4(context));
  //   reasons.add(Strings.endOrderReason5(context));
  // }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      bottom: true,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          leadingWidth: MediaQuery.of(context).size.width..w,
          leading: Card(
            color: const Color(MyColors.appbackgroundColor),
            shadowColor: const Color.fromARGB(158, 219, 219, 219),
            elevation: 2,
            shape: const Border(
                bottom: BorderSide(
                    color: Color.fromARGB(147, 203, 203, 203),
                    strokeAlign: 2,
                    style: BorderStyle.solid)),
            child: Center(
              child: Stack(
                children: [
                  Center(
                      child: HeadingTextW600(
                    text: Strings.assignment(context),
                    centerAlign: false,
                    size: 19.0.sp,
                  )),
                  Padding(
                    padding: EdgeInsets.only(left: 10.0.w),
                    child: Align(
                        alignment: Alignment.centerLeft,
                        child: Icon(
                          Icons.arrow_back_ios_new,
                          size: 20.sp,
                        )),
                  )
                ],
              ),
            ),
          ),
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Align(
              alignment: Alignment.topLeft,
              child: Padding(
                padding: EdgeInsets.only(top: 12.0.h, left: 25.0.w),
                child: HeadingTextW600(
                    text: Strings.endingOrderPageHead(context),
                    centerAlign: false,
                    size: 18.0.sp),
              ),
            ),
            Align(
              alignment: Alignment.topLeft,
              child: Padding(
                padding: EdgeInsets.only(left: 25.0.w, top: 15.0.h),
                child: HeadingTextW500(
                    text: Strings.endingOrderPageDesc(context),
                    centerAlign: false,
                    size: 14.0.sp),
              ),
            ),
            Expanded(
              child: Padding(
                padding: EdgeInsets.all(8.0.r),
                child: ListView.builder(
                  itemCount: controller.reasons.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: EdgeInsets.only(
                          left: 12.0.w, right: 12.0.w, top: 5.0.h),
                      child: Obx(() {
                        return Card(
                          elevation: 0,
                          color: controller.selectedReason.value ==
                                  controller.reasons[index]
                              ? Colors.red.shade50
                              : const Color(MyColors.whiteColor),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.0.r),
                            side: BorderSide(
                              color: controller.selectedReason.value ==
                                      controller.reasons[index]
                                  ? const Color(MyColors.themeRedColor)
                                  : const Color(MyColors.darkGrayColor),
                            ),
                          ),
                          child: RadioListTile(
                            title: Headingdescription(
                                text: controller.reasons[index],
                                centerAlign: false,
                                size: 14.sp),
                            value: controller.reasons[index],
                            groupValue: controller.selectedReason.value,
                            activeColor: const Color(MyColors.themeRedColor),
                            onChanged: (value) {
                              if (value != null) {
                                controller.selectedReason.value = value;
                              }
                            },
                          ),
                        );
                      }),
                    );
                  },
                ),
              ),
            ),
            Padding(
              padding:
                  EdgeInsets.only(left: 25.0.w, right: 25.0.w, bottom: 12.0.h),
              child: FullWidthButtonPrimary(
                  text: Strings.continueText(context),
                  fontsize: 15.0.sp,
                  color: MyColors.themeRedColor,
                  onPressed: () {
                    if (controller.selectedReason.value.isNotEmpty) {
                      controller.pleaseCancelTheOrder(controller.jobId.value,
                          controller.selectedReason.value, context);
                    }
                  }),
            ),
          ],
        ),
      ),
    );
  }
}
