import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:workforceclientapp/Controllers/NotificationScreenContoller.dart';
import 'package:workforceclientapp/Models/NotificationModel.dart';
import 'package:workforceclientapp/Others/Commons.dart';
import 'package:workforceclientapp/Others/Constants.dart';
import 'package:workforceclientapp/Others/MyColors.dart';
import 'package:workforceclientapp/Others/Strings.dart';
import 'package:workforceclientapp/Others/routes.dart';
import 'package:workforceclientapp/views/widgets/FullWidthButtonPrimary.dart';
import 'package:workforceclientapp/views/widgets/HeadingTextW600.dart';
import 'package:workforceclientapp/views/widgets/Headingdescription.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  NotificationScreenContoller controller =
      Get.put(NotificationScreenContoller());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(MyColors.whiteColor),
      body: Obx(() {
        return controller.isLoggedin.value == "loggedOut"
            ? _buildNoLoginView()
            : Column(
                children: [
                  Align(
                    alignment: Alignment.topLeft,
                    child: Padding(
                      padding:
                          EdgeInsets.only(left: 12.w, top: 12.h, bottom: 4.h),
                      child: HeadingTextW600(
                          text: Strings.notifications(context),
                          centerAlign: false,
                          size: 20.sp),
                    ),
                  ),
                  Align(
                    alignment: Alignment.topRight,
                    child: !controller.isLoading.value &&
                            controller.notiList.isNotEmpty
                        ? GestureDetector(
                            onTap: () async {
                              try {
                                Commons.showProgressDialog(context);
                                await controller.pleaseMarkAllAsRead(context);
                                Commons.hideProgressDialog();
                              } catch (e) {
                                throw Exception(e);
                              }
                            },
                            child: Card(
                              color: const Color(MyColors.cardGrayColor50),
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadiusGeometry.circular(12.r)),
                              child: Padding(
                                padding: EdgeInsets.all(5.0.r),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    SvgPicture.asset(
                                        "lib/assets/icons/markAsReadIcon.svg"),
                                    SizedBox(
                                      width: 3.w,
                                    ),
                                    Text(
                                        Strings.markAllAsReadText(Get.context!),
                                        textAlign: TextAlign.start,
                                        style: TextStyle(
                                            color: const Color(
                                                MyColors.themeRedColor),
                                            fontSize: 14.sp,
                                            fontWeight: FontWeight.w400,
                                            fontFamily: 'Poppins'))
                                  ],
                                ),
                              ),
                            ),
                          )
                        : const SizedBox(),
                  ),
                  Obx(() {
                    return controller.isLoading.value
                        ? const Expanded(
                            child: Center(
                              child: CircularProgressIndicator(
                                color: Color(MyColors.themeRedColor),
                              ),
                            ),
                          )
                        : controller.notiList.isEmpty
                            ? _buildNoNotificationView()
                            : Expanded(
                                child: ListView.builder(
                                  itemCount: controller.notiList.length +
                                      (controller.notificationList!.pagination!
                                              .hasMore!
                                          ? 1
                                          : 0),
                                  itemBuilder: (context, index) {
                                    // Last item = Load More Button
                                    if (index == controller.notiList.length) {
                                      return _buildLoadMoreButton();
                                    }

                                    return _buildNotificationView(
                                        controller.notiList.elementAt(index),
                                        index);
                                  },
                                ),
                              );
                  })
                ],
              );
      }),
    );
  }

  Widget _buildLoadMoreButton() {
    return Obx(() {
      return controller.isLoadingMore.value
          ? Center(
              child: Padding(
                padding: EdgeInsets.all(4.0.r),
                child: const CircularProgressIndicator(
                  color: Color(MyColors.themeRedColor),
                ),
              ),
            )
          : ElevatedButton(
              style: ButtonStyle(
                  shape: WidgetStateProperty.all(RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.r))),
                  fixedSize: WidgetStatePropertyAll(
                      Size.fromWidth(MediaQuery.of(context).size.width.w / 2)),
                  foregroundColor: const WidgetStatePropertyAll(
                      Color(MyColors.infoPinkColor2)),
                  elevation: const WidgetStatePropertyAll(0)),
              onPressed: () {
                try {
                  if (controller.notificationList!.pagination != null) {
                    if (controller.notificationList!.pagination!.hasMore ??
                        false) {
                      controller.isLoadingMore.value =
                          controller.notificationList!.pagination!.hasMore!;
                      controller.getNotificationList(
                          controller.notificationList!.pagination!.nextCursor!);
                    }
                  }
                } catch (e) {
                  throw Exception(e);
                }
              },
              child: Padding(
                padding: EdgeInsets.all(4.0.r),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Headingdescription(
                        text: Strings.loadMoreText(Get.context!),
                        centerAlign: false,
                        size: 14.sp),
                    SizedBox(
                      width: 5.0.w,
                    ),
                    Icon(
                      Icons.keyboard_arrow_down,
                      size: 20.sp,
                    )
                  ],
                ),
              ),
            );
    });
  }

  Widget _buildNoLoginView() {
    return Padding(
      padding: EdgeInsets.all(8.0.r),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Spacer(),
          SvgPicture.asset("lib/assets/icons/emptyNotificationsIcon.svg",
              width: MediaQuery.of(context).size.width.w,
              height: MediaQuery.of(context).size.height.h / 7,
              fit: BoxFit.contain),
          Padding(
            padding: EdgeInsets.all(12.0.r),
            child: HeadingTextW600(
                text: Strings.notifications(context),
                centerAlign: true,
                size: 20.sp),
          ),
          Padding(
            padding: EdgeInsets.only(left: 12.0.w, right: 12.0.w),
            child: Headingdescription(
                text: Strings.notificationIsEmptyDesc(context),
                centerAlign: true,
                size: 13.5.sp),
          ),
          Padding(
            padding: EdgeInsets.only(left: 12.0.w, right: 12.0.w, top: 20.0.h),
            child: FullWidthButtonPrimary(
                text: Strings.loginText(context),
                fontsize: 15.0.sp,
                color: MyColors.themeRedColor,
                onPressed: () {
                  Constants.fromWhere = "SelectServiceScreen";
                  Get.offAllNamed(AppLinks.login_screen);
                }),
          ),
          const Spacer(),
        ],
      ),
    );
  }

  Widget _buildNoNotificationView() {
    return Expanded(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SvgPicture.asset("lib/assets/icons/emptyNotificationsIcon.svg",
              width: MediaQuery.of(context).size.width.w,
              height: MediaQuery.of(context).size.height.h / 7,
              fit: BoxFit.contain),
          Padding(
            padding: EdgeInsets.all(12.0.r),
            child: HeadingTextW600(
                text: Strings.notificationListEmpty(context),
                centerAlign: true,
                size: 17.sp),
          ),
        ],
      ),
    );
  }

  Widget _buildNotificationView(NotificationModel notification, int index) {
    return GestureDetector(
      onTap: () async {
        try {
          print(notification.actionText ?? "null");
          if (notification.actionText == "View Job Details" ||
              notification.actionText == "View Job Posting" ||
              notification.actionText == "View Request Details" ||
              notification.actionText == "Jobdetails anzeigen" ||
              notification.actionText == "Anfragedetails anzeigen") {
            int jobPostingId = notification.jobPostingId == null
                ? -1
                : int.parse(notification.jobPostingId!);
            Get.toNamed(AppLinks.orders_details_screen,
                arguments: {'jobId': jobPostingId});
          } else if (notification.actionText == "View Job Application" ||
              notification.actionText == "Bewerbung anzeigen") {
            int jobPostingId = notification.jobPostingId == null
                ? -1
                : int.parse(notification.jobPostingId!);
            Get.toNamed(AppLinks.orders_details_screen,
                arguments: {'jobId': jobPostingId, 'section': "tradesmen"});
          }
          if (!notification.isRead.value) {
            var res =
                await controller.pleaseMarkAsRead(context, notification.id!);
            if (res) {
              notification.isRead.value = true;
            }
          }
        } catch (e) {
          throw Exception(e);
        }
      },
      child: Obx(() {
        return Container(
          color: notification.isRead.value
              ? Colors.black.withOpacity(0)
              : Colors.black.withOpacity(0.05),
          child: Padding(
            padding: EdgeInsets.all(3.0.r),
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      flex: 2,
                      child: Padding(
                        padding: EdgeInsets.all(2.0.r),
                        child: Center(
                          child: SvgPicture.asset(notification.isRead.value
                              ? "lib/assets/icons/readIconNotify.svg"
                              : "lib/assets/icons/unreadIcon.svg"),
                          //  notification.isRead.value
                          //     ? SvgPicture.asset(
                          //         "lib/assets/icons/readIconNotify.svg")
                          //     : SvgPicture.asset(
                          //         "lib/assets/icons/unreadIcon.svg")),
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 9,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: EdgeInsets.only(
                                left: 4.0.w, right: 4.0.w, bottom: 3.0.h),
                            child: Text(notification.title!,
                                textAlign: TextAlign.start,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.w500,
                                    fontFamily: 'Poppins')),
                          ),
                          Padding(
                            padding: EdgeInsets.only(left: 4.0.w, right: 4.0.w),
                            child: Text(notification.body!,
                                textAlign: TextAlign.start,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 13.sp,
                                    fontWeight: FontWeight.w400,
                                    fontFamily: 'Poppins')),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      flex: 2,
                      child: Center(
                          child: Headingdescription(
                              text: notification.humanReadableCreatedAt!,
                              centerAlign: true,
                              size: 12.sp)),
                    ),
                  ],
                ),
                Padding(
                  padding: EdgeInsets.all(4.0.r),
                  child: Container(
                    color: const Color(MyColors.grayColor),
                    height: 1,
                  ),
                )
              ],
            ),
          ),
        );
      }),
    );
  }
}
