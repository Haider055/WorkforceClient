import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:workforceclientapp/Controllers/NotificationsContoller.dart';
import 'package:workforceclientapp/Models/NotificationPreference.dart';
import 'package:workforceclientapp/Others/Commons.dart';
import 'package:workforceclientapp/Others/MyColors.dart';
import 'package:workforceclientapp/Others/Strings.dart';
import 'package:workforceclientapp/views/widgets/HeadingTextW500.dart';
import 'package:workforceclientapp/views/widgets/HeadingTextW600.dart';
import 'package:workforceclientapp/views/widgets/Headingdescription.dart';

class NotificationSettingScreen extends GetView<NotificationsContoller> {
  const NotificationSettingScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                  text: Strings.notification(context),
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
        return controller.isLoading.value
            ? const Center(
                child: CircularProgressIndicator(
                  color: Color(MyColors.themeRedColor),
                ),
              )
            : SingleChildScrollView(
                child: Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.all(14.0.w),
                      child: RichText(
                        text: TextSpan(
                          text:
                              "${Strings.youCanAdjustYourNotificationSettingText(Get.context!)} ",
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 14.5.sp,
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.w400,
                          ),
                          children: <TextSpan>[
                            TextSpan(
                              text: Strings.seeourPrivacyPlolicyText(
                                  Get.context!),
                              style: TextStyle(
                                color: const Color(MyColors.themeRedColor),
                                fontSize: 14.5.sp,
                                fontFamily: 'Poppins',
                                fontWeight: FontWeight.w500,
                                decoration: TextDecoration.underline,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.topLeft,
                      child: Padding(
                        padding: EdgeInsets.only(
                            left: 14.0.w, top: 12.h, bottom: 12.h),
                        child: HeadingTextW600(
                            text: Strings.updatesOnJobsText(Get.context!),
                            centerAlign: false,
                            size: 20.sp),
                      ),
                    ),
                    ListView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: controller.list.length,
                      itemBuilder: (context, index) {
                        return _buildView(controller.list.elementAt(index));
                      },
                    )
                  ],
                ),
              );
      }),
    );
  }

  Widget _buildView(NotificationPreference preference) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 14.0.w, vertical: 6.h),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          HeadingTextW600(
            text: preference.title ?? '',
            centerAlign: false,
            size: 18.sp,
          ),
          SizedBox(height: 6.h),
          Headingdescription(
            text: preference.description ?? '',
            centerAlign: false,
            size: 14.sp,
          ),
          SizedBox(height: 12.h),
          Card(
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.r),
            ),
            color: const Color(MyColors.whiteColor),
            child: Padding(
              padding: EdgeInsets.all(9.0.r),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      HeadingTextW500(
                          text: "E-mail", centerAlign: false, size: 14.sp),
                      Transform.scale(
                        scale: 0.8, // Set to 0.6 or 0.7 for even smaller size
                        child: Obx(() {
                          return Switch(
                            value: preference.emailEnabled.value,
                            trackOutlineColor: const WidgetStatePropertyAll(
                                Color(MyColors.whiteColor)),
                            activeTrackColor:
                                const Color(MyColors.themeRedColor),
                            inactiveTrackColor:
                                const Color(MyColors.lightSilverColor),
                            thumbColor: const WidgetStatePropertyAll(
                                Color(MyColors.whiteColor)),
                            onChanged: (value) async {
                              try {
                                Commons.showProgressDialog(Get.context!);
                                preference.emailEnabled.value = value;
                                bool res = await controller.pleaseUpdatePref(
                                    Get.context!, preference);
                                if (!res) {
                                  preference.emailEnabled.value = !value;
                                }
                              } catch (e) {
                                throw Exception(e);
                              }
                              Commons.hideProgressDialog();
                            },
                          );
                        }),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      HeadingTextW500(
                          text: Strings.notification(Get.context!),
                          centerAlign: false,
                          size: 14.sp),
                      Transform.scale(
                        scale: 0.8, // Set to 0.6 or 0.7 for even smaller size
                        child: Obx(() {
                          return Switch(
                            value: preference.pushEnabled.value,
                            trackOutlineColor: const WidgetStatePropertyAll(
                                Color(MyColors.whiteColor)),
                            activeTrackColor:
                                const Color(MyColors.themeRedColor),
                            inactiveTrackColor:
                                const Color(MyColors.lightSilverColor),
                            thumbColor: const WidgetStatePropertyAll(
                                Color(MyColors.whiteColor)),
                            onChanged: (value) async {
                              try {
                                Commons.showProgressDialog(Get.context!);
                                preference.pushEnabled.value = value;
                                bool res = await controller.pleaseUpdatePref(
                                    Get.context!, preference);
                                if (!res) {
                                  preference.pushEnabled.value = !value;
                                }
                              } catch (e) {
                                throw Exception(e);
                              }
                              Commons.hideProgressDialog();
                            },
                          );
                        }),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
// 1//03RNsu_rLMiBYCgYIARAAGAMSNwF-L9IrHbQjVBVhn-qv6pyKbI0UtNz8E-ieQlMRLOijyMMqhK0ZeiI4x_sA-s1spFWkqM7LFjA
