import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:workforceclientapp/Controllers/JobRecommendationController.dart';
import 'package:workforceclientapp/Models/Tradesmen.dart';
import 'package:workforceclientapp/Others/Constants.dart';
import 'package:workforceclientapp/Others/MyColors.dart';
import 'package:workforceclientapp/Others/Strings.dart';
import 'package:workforceclientapp/Others/routes.dart';
import 'package:workforceclientapp/views/widgets/FullWidthButtonPrimary.dart';
import 'package:workforceclientapp/views/widgets/FullWidthOutlineButton.dart';
import 'package:workforceclientapp/views/widgets/HeadingTextW600.dart';
import 'package:workforceclientapp/views/widgets/Headingdescription.dart';

class JobRecommendations extends GetView<JobRecommendationController> {
  const JobRecommendations({super.key});

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) {
        if (controller.fromWhere.value == "JobPostCompleted") {
          Get.offAllNamed(
            AppLinks.select_service_screen,
            arguments: {},
          );
        } else if (controller.fromWhere.value == "MyOrders") {
          // print(controller.remainingRequestsCount.value);
          Get.back(result: controller.remainingRequestsCount.value);
        } else {
          Get.back();
        }
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          leadingWidth: MediaQuery.of(context).size.width.w,
          leading: Card(
            color: const Color(MyColors.appbackgroundColor),
            shadowColor: const Color.fromARGB(158, 219, 219, 219),
            elevation: 2,
            shape: const Border(
                bottom: BorderSide(
                    color: Color.fromARGB(147, 203, 203, 203),
                    style: BorderStyle.solid)),
            child: Center(
              child: Stack(
                children: [
                  Center(
                      child: HeadingTextW600(
                    text: Strings.recommendations(Get.context!),
                    centerAlign: false,
                    size: 19.0.sp,
                  )),
                  GestureDetector(
                    onTap: () {
                      print(controller.fromWhere.value);
                      if (controller.fromWhere.value == "JobPostCompleted") {
                        Get.offAllNamed(AppLinks.select_service_screen);
                      } else if (controller.fromWhere.value == "MyOrders") {
                        Get.back(
                            result: controller.remainingRequestsCount.value);
                      }
                    },
                    child: Padding(
                      padding: EdgeInsets.only(right: 10.0.w),
                      child: Align(
                          alignment: Alignment.centerRight,
                          child: Image.asset(
                            "lib/assets/icons/cancelicon.png",
                            fit: BoxFit.contain,
                          )),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
        body: Obx(() {
          return SafeArea(
            child: Column(
              children: [
                Column(
                  children: [
                    Align(
                      alignment: Alignment.topLeft,
                      child: Padding(
                        padding: EdgeInsets.only(
                            left: 20.0.w, top: 12.0.h, right: 20.w),
                        child: HeadingTextW600(
                            text: Strings.recommendationScreenHeading(context),
                            centerAlign: false,
                            size: 18.sp),
                      ),
                    ),
                    Align(
                      alignment: Alignment.topLeft,
                      child: Padding(
                        padding: EdgeInsets.only(
                            left: 20.0.w, top: 10.0.h, right: 20.w),
                        child: Headingdescription(
                            text: Strings.recommendationScreenDesc(context),
                            centerAlign: false,
                            size: 14.sp),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                          left: 20.0.w, top: 8.0.h, bottom: 12.0.h),
                      child: Align(
                          alignment: Alignment.topLeft,
                          child: Text(Strings.requestUpTo10Tradesmen(context),
                              style: TextStyle(
                                  fontSize: 14.0.sp,
                                  fontFamily: 'Poppins',
                                  color: const Color(MyColors.midGrayColor)))),
                    ),
                  ],
                ),
                Expanded(
                  child: controller.isLoading.value
                      ? const Center(
                          child: CircularProgressIndicator(
                            color: Color(MyColors.themeRedColor),
                          ),
                        )
                      : ListView.builder(
                          shrinkWrap: true,
                          itemCount: controller.tradesmenList.length + 1,
                          itemBuilder: (context, index) {
                            if (index == controller.tradesmenList.length &&
                                controller.pagination != null &&
                                controller.pagination!.hasMore!) {
                              return Obx(() {
                                return Padding(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 17.0.w, vertical: 5.0.h),
                                  child: controller.isLoadingMore.value
                                      ? const Center(
                                          child: CircularProgressIndicator(
                                            color:
                                                Color(MyColors.themeRedColor),
                                          ),
                                        )
                                      : ElevatedButton(
                                          style: ButtonStyle(
                                              shape: WidgetStateProperty.all(
                                                  RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10.r))),
                                              fixedSize: WidgetStatePropertyAll(
                                                  Size.fromWidth(
                                                      MediaQuery.of(context)
                                                              .size
                                                              .width
                                                              .w /
                                                          2)),
                                              foregroundColor:
                                                  const WidgetStatePropertyAll(
                                                      Color(
                                                          MyColors.infoPinkColor2)),
                                              elevation: const WidgetStatePropertyAll(0)),
                                          onPressed: () {
                                            try {
                                              controller.loadMore();
                                            } catch (e) {
                                              throw Exception(e);
                                            }
                                          },
                                          child: Padding(
                                            padding: EdgeInsets.all(4.0.r),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Headingdescription(
                                                    text: Strings.loadMoreText(
                                                        Get.context!),
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
                                        ),
                                );
                              });
                            }
                            if (index == controller.tradesmenList.length &&
                                !controller.pagination!.hasMore!) {
                              return const SizedBox();
                            }
                            return _buildSuggestedCraftmenOptions(
                                controller.tradesmenList[index]);
                          },
                        ),
                ),
                Padding(
                  padding: EdgeInsets.all(8.0.r),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(bottom: 12.0.h, top: 6.0.h),
                        child: GestureDetector(
                          onTap: () {},
                          child: RichText(
                            text: TextSpan(
                              style: TextStyle(
                                  color: Colors.black, fontSize: 16.0.sp),
                              children: [
                                WidgetSpan(
                                  child: Image.asset(
                                    "lib/assets/icons/yellowinfo.png",
                                    height: 18.h,
                                    width: 18.w,
                                    fit: BoxFit.contain,
                                  ),
                                ),
                                TextSpan(
                                    text:
                                        ' ${Strings.selectText(Get.context!)} ${controller.remainingRequestsCount.value}',
                                    style: TextStyle(
                                        fontSize: 14.sp,
                                        fontWeight: FontWeight.w500)),
                                TextSpan(
                                    text:
                                        ' ${Strings.moreCraftmen(Get.context!)}',
                                    style: TextStyle(
                                        fontSize: 14.sp,
                                        fontWeight: FontWeight.w400)),
                              ],
                            ),
                          ),
                        ),
                      ),
                      controller.fromWhere.value == "MyOrders"
                          ? const SizedBox()
                          : Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Expanded(
                                  child: Padding(
                                    padding: EdgeInsets.only(
                                        left: 20.0.w, right: 10.0.w),
                                    child: FullWidthOutlineButton(
                                        text: Strings.cancelText(context),
                                        fontsize: 16.0.sp,
                                        color: MyColors.themeRedColor,
                                        onPressed: () {
                                          if (controller.fromWhere.value ==
                                              "JobPostCompleted") {
                                            Get.offAllNamed(
                                                AppLinks.select_service_screen);
                                          } else if (controller
                                                  .fromWhere.value ==
                                              "MyOrders") {
                                            Get.back();
                                          }
                                        }),
                                  ),
                                ),
                                Expanded(
                                  child: Padding(
                                    padding: EdgeInsets.only(
                                        left: 10.0.w, right: 20.0.w),
                                    child: FullWidthButtonPrimary(
                                        text: Strings.orderDetail(context),
                                        fontsize: 16.0.sp,
                                        color: MyColors.themeRedColor,
                                        onPressed: () {
                                          Get.toNamed(
                                            AppLinks.orders_details_screen,
                                            arguments: {
                                              'jobId': Constants.lastPostedJobId
                                            },
                                          );
                                        }),
                                  ),
                                )
                              ],
                            ),
                    ],
                  ),
                ),
              ],
            ),
          );
        }),
      ),
    );
  }

  Widget _buildOptionsButton(String icon, String label, Color color) {
    return Column(
      children: [
        Image.asset(
          icon,
          color: color,
          height: 26.h,
          width: 26.w,
          fit: BoxFit.contain,
        ),
        SizedBox(height: 4.h),
        Text(
          label,
          textAlign: TextAlign.center,
          style: TextStyle(
              fontFamily: 'Poppins',
              fontSize: 11.5.sp,
              color: color,
              fontWeight: FontWeight.w400),
        ),
      ],
    );
  }

  Widget _buildSuggestedCraftmenOptions(Tradesmen tradesmen) {
    return Padding(
      padding: EdgeInsets.only(left: 17.0.w, right: 17.0.w, top: 5.0.h),
      child: GestureDetector(
        onTap: () {
          try {
            Get.toNamed(AppLinks.tradesmen_detail_screen,
                arguments: {'tradesmenId': tradesmen.id ?? -1});
          } catch (e) {
            e.printError();
          }
        },
        child: Card(
          color: const Color(MyColors.cardGrayColor100),
          elevation: 0,
          shape: RoundedRectangleBorder(
            side: BorderSide(
                color: const Color(MyColors.cardGrayColor300).withOpacity(0.4),
                width: 1.0.w),
            borderRadius: BorderRadius.circular(12.r),
          ),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  tradesmen.tradesmenProfile != null
                      ? tradesmen.tradesmenProfile!.companyType != null
                          ? tradesmen.tradesmenProfile!.companyType
                                      ?.toLowerCase() ==
                                  "company"
                              ? Align(
                                  alignment: Alignment.topLeft,
                                  child: Padding(
                                    padding: EdgeInsets.only(left: 12.0.w),
                                    child: Card(
                                      color:
                                          const Color(MyColors.infoYellowColor),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.only(
                                            bottomLeft: Radius.circular(9.r),
                                            bottomRight: Radius.circular(9.r)),
                                      ),
                                      elevation: 0,
                                      child: Padding(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 7.0.w, vertical: 2.5.h),
                                        child: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            SvgPicture.asset(
                                              "lib/assets/icons/AgencyIconsvg.svg",
                                              fit: BoxFit.contain,
                                              height: 13.h,
                                              width: 13.w,
                                            ),
                                            SizedBox(width: 4.w),
                                            Headingdescription(
                                              text:
                                                  Strings.agency(Get.context!),
                                              centerAlign: false,
                                              size: 10.0.sp,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                )
                              : const SizedBox()
                          : const SizedBox()
                      : const SizedBox(),
                  Padding(
                    padding: EdgeInsets.only(top: 8.0.h, right: 8.0.w),
                    child: Icon(
                      Icons.arrow_forward_ios,
                      color: const Color(MyColors.blackColor80),
                      size: 16.sp,
                    ),
                  )
                ],
              ),
              Padding(
                padding: EdgeInsets.only(top: 6.0.h),
                child: Row(
                  children: [
                    Padding(
                      padding: EdgeInsets.only(left: 10.0.w),
                      child: tradesmen.profileImg != null
                          ? ClipOval(
                              child: CachedNetworkImage(
                                height: 44.h,
                                width: 44.w,
                                imageUrl: tradesmen.profileImg.toString(),
                                fit: BoxFit.cover,
                              ),
                            )
                          : Image.asset(
                              "lib/assets/icons/placeholder_tradesmen.png"),
                    ),
                    SizedBox(width: 8.0.w),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Expanded(
                                flex: 6,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Flexible(
                                      child: Text(
                                        tradesmen.name ?? "N/A",
                                        softWrap: false,
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 1,
                                        style: TextStyle(
                                            fontWeight: FontWeight.w600,
                                            color: Colors.black,
                                            fontSize: 14.0.sp),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Expanded(
                                flex: 4,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Flexible(
                                      child: Padding(
                                        padding: EdgeInsets.only(right: 10.0.w),
                                        child: RichText(
                                          maxLines: 1,
                                          softWrap: false,
                                          overflow: TextOverflow.ellipsis,
                                          text: TextSpan(
                                            style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 13.sp,
                                            ),
                                            children: [
                                              TextSpan(
                                                text:
                                                    "${tradesmen.serviceArea?.radius ?? "N/A"} KM",
                                                style: const TextStyle(
                                                  color: Colors.red,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              const TextSpan(
                                                text: ", ",
                                              ),
                                              TextSpan(
                                                text: tradesmen
                                                        .serviceArea?.city ??
                                                    "N/A",
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          Padding(
                            padding: EdgeInsets.only(top: 2.0.h),
                            child: Row(
                              children: [
                                Expanded(
                                  flex: 5,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Flexible(
                                        child: Text(
                                          "${tradesmen.reviewsCount ?? "0"} ${Strings.reviews(Get.context!)}",
                                          style: TextStyle(
                                              color: const Color(
                                                  MyColors.midGrayColor),
                                              fontSize: 14.0.sp),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Expanded(
                                  flex: 5,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      Icon(
                                        Icons.star,
                                        size: 16.0.sp,
                                        color:
                                            const Color(MyColors.themeRedColor),
                                      ),
                                      SizedBox(
                                        width: 2.0.w,
                                      ),
                                      Flexible(
                                        child: Padding(
                                          padding:
                                              EdgeInsets.only(right: 10.0.w),
                                          child: Text(
                                            tradesmen.rating != null &&
                                                    tradesmen.rating!.length > 3
                                                ? tradesmen.rating!
                                                    .substring(0, 3)
                                                : tradesmen.rating ?? "0",
                                            style: TextStyle(
                                                fontSize: 13.sp,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 12.0.h),
              Obx(() {
                return Padding(
                  padding: EdgeInsets.only(
                      left: 8.0.w, right: 8.0.w, bottom: 10.0.h),
                  child: SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        elevation: 0,
                        backgroundColor: tradesmen.status.value == "sent"
                            ? const Color(MyColors.infoPinkColor)
                            : const Color(MyColors.themeRedColor),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.r),
                        ),
                        padding: EdgeInsets.symmetric(vertical: 4.h),
                      ),
                      onPressed: () async {
                        try {
                          if (tradesmen.status.value == "sent") {
                            Fluttertoast.showToast(
                                msg: Strings.requestAlreadySentText(
                                    Get.context!));
                            return;
                          }
                          if (tradesmen.status.value == "not sent" &&
                              controller.remainingRequestsCount.value > 0) {
                            tradesmen.status.value = "loading";
                            String remainingRequests =
                                await controller.pleaseSendRequestToTradesmen(
                                    tradesmen.id!, controller.jobId.value);
                            if (remainingRequests.isNotEmpty) {
                              controller.remainingRequestsCount.value =
                                  int.parse(remainingRequests);
                              tradesmen.status.value = "sent";
                            } else {
                              tradesmen.status.value = "not sent";
                            }
                          } else {
                            Fluttertoast.showToast(
                                msg: Strings.youHaveReachedLimit(Get.context!));
                          }
                          return;
                        } catch (e) {
                          throw Exception(e);
                        }
                      },
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          tradesmen.status.value == "loading"
                              ? Padding(
                                  padding: EdgeInsets.all(8.0.r),
                                  child: SizedBox(
                                    height: 14.h,
                                    width: 14.w,
                                    child: const CircularProgressIndicator(
                                      color: Color(MyColors.whiteColor),
                                    ),
                                  ),
                                )
                              : Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      tradesmen.status.value == "sent"
                                          ? Strings.requestHasSent(Get.context!)
                                          : Strings.sendRequest(Get.context!),
                                      style: TextStyle(
                                          color:
                                              tradesmen.status.value == "sent"
                                                  ? const Color(
                                                      MyColors.themeRedColor)
                                                  : Colors.white,
                                          fontFamily: 'Poppins',
                                          fontSize: 13.sp),
                                    ),
                                  ],
                                ),
                        ],
                      ),
                    ),
                  ),
                );
              })
            ],
          ),
        ),
      ),
    );
  }
}

// Custom Clipper for Right-Side Triangle Effects
class SidePanelClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();

    // Rounded Rect Panel
    path.addRRect(RRect.fromRectAndRadius(
        Rect.fromLTWH(0, 0, size.width - 10, size.height),
        const Radius.circular(20)));

    // First Triangle (Top)
    path.moveTo(size.width - 10, size.height * 0.2);
    path.lineTo(size.width, size.height * 0.2 + 10);
    path.lineTo(size.width - 10, size.height * 0.2 + 20);
    path.close();

    // Second Triangle (Middle)
    path.moveTo(size.width - 10, size.height * 0.5);
    path.lineTo(size.width, size.height * 0.5 + 10);
    path.lineTo(size.width - 10, size.height * 0.5 + 20);
    path.close();

    // Third Triangle (Bottom)
    path.moveTo(size.width - 10, size.height * 0.8);
    path.lineTo(size.width, size.height * 0.8 + 10);
    path.lineTo(size.width - 10, size.height * 0.8 + 20);
    path.close();

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
