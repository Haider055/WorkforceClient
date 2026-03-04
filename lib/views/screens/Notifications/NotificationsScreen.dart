import 'package:flutter/material.dart';
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
      body: SafeArea(
        child: Obx(() {
          return controller.isLoggedin.value == "loggedOut"
              ? _buildNoLoginView()
              : Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 12.0, top: 4.0),
                          child: HeadingTextW600(
                              text: Strings.notifications(context),
                              centerAlign: false,
                              size: 22),
                        ),
                        !controller.isLoading.value &&
                                controller.notiList.isNotEmpty
                            ? GestureDetector(
                                onTap: () async {
                                  try {
                                    Commons.showProgressDialog(context);
                                    await controller
                                        .pleaseMarkAllAsRead(context);
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
                                          BorderRadiusGeometry.circular(12)),
                                  child: Padding(
                                    padding: const EdgeInsets.all(5.0),
                                    child: Row(
                                      children: [
                                        SvgPicture.asset(
                                            "lib/assets/icons/markAsReadIcon.svg"),
                                        const SizedBox(
                                          width: 3,
                                        ),
                                        const Text("Mark all as read",
                                            textAlign: TextAlign.start,
                                            style: TextStyle(
                                                color: Color(
                                                    MyColors.themeRedColor),
                                                fontSize: 14,
                                                fontWeight: FontWeight.w400,
                                                fontFamily: 'Poppins'))
                                      ],
                                    ),
                                  ),
                                ),
                              )
                            : const SizedBox()
                      ],
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
                                        (controller.notificationList!
                                                .pagination!.hasMore!
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
      ),
    );
  }

  Widget _buildLoadMoreButton() {
    return controller.isLoadingMore.value
        ? const Center(
            child: Padding(
              padding: EdgeInsets.all(4.0),
              child: CircularProgressIndicator(
                color: Color(MyColors.themeRedColor),
              ),
            ),
          )
        : ElevatedButton(
            style: ButtonStyle(
                shape: WidgetStateProperty.all(RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10))),
                fixedSize: WidgetStatePropertyAll(
                    Size.fromWidth(MediaQuery.of(context).size.width / 2)),
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
            child: const Padding(
              padding: EdgeInsets.all(4.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Headingdescription(
                      text: "Load More", centerAlign: false, size: 14),
                  SizedBox(
                    width: 5.0,
                  ),
                  Icon(
                    Icons.keyboard_arrow_down,
                    size: 20,
                  )
                ],
              ),
            ),
          );
  }

  Widget _buildNoLoginView() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Spacer(),
          SvgPicture.asset("lib/assets/icons/emptyNotificationsIcon.svg",
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height / 7,
              fit: BoxFit.contain),
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: HeadingTextW600(
                text: Strings.notifications(context),
                centerAlign: true,
                size: 20),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 12.0, right: 12.0),
            child: Headingdescription(
                text: Strings.notificationIsEmptyDesc(context),
                centerAlign: true,
                size: 13.5),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 12.0, right: 12.0, top: 20.0),
            child: FullWidthButtonPrimary(
                text: Strings.loginText(context),
                fontsize: 15.0,
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
    return SizedBox(
      height: MediaQuery.of(context).size.height / 1.4,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SvgPicture.asset("lib/assets/icons/emptyNotificationsIcon.svg",
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height / 7,
              fit: BoxFit.contain),
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: HeadingTextW600(
                text: Strings.notificationListEmpty(context),
                centerAlign: true,
                size: 17),
          ),
        ],
      ),
    );
  }

  Widget _buildNotificationView(NotificationModel notification, int index) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              flex: 2, // 20%
              child: Padding(
                padding: const EdgeInsets.all(2.0),
                child: GestureDetector(
                  onTap: () async {
                    try {
                      if (notification.id != null) {
                        if (!notification.isRead!) {
                          Commons.showProgressDialog(context);
                          await controller.pleaseMarkAsRead(
                              context, notification.id!);
                          Commons.hideProgressDialog();
                          notification.isRead = true;
                        }
                      }
                    } catch (e) {
                      throw Exception(e);
                    }
                  },
                  child: Center(
                      child:
                          SvgPicture.asset("lib/assets/icons/unreadIcon.svg")),
                ),
              ),
            ),
            Expanded(
              flex: 6, // 60%
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(
                        left: 4.0, right: 4.0, bottom: 3.0),
                    child: Text(notification.title!,
                        textAlign: TextAlign.start,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                            color: Colors.black,
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            fontFamily: 'Poppins')),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 4.0, right: 4.0),
                    child: Text(notification.body!,
                        textAlign: TextAlign.start,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                            color: Colors.black,
                            fontSize: 13,
                            fontWeight: FontWeight.w400,
                            fontFamily: 'Poppins')),
                  ),
                ],
              ),
            ),
            Expanded(
              flex: 2, // 20%
              child: Center(
                  child: Headingdescription(
                      text: notification.humanReadableCreatedAt!,
                      centerAlign: true,
                      size: 12)),
            ),
          ],
        ),
        Padding(
          padding: const EdgeInsets.all(4.0),
          child: Container(
            color: const Color(MyColors.grayColor),
            height: 1,
          ),
        )
      ],
    );
  }
}
