import 'package:auto_size_text/auto_size_text.dart';
import 'package:expandable_text/expandable_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:photo_viewer/photo_viewer.dart';
import 'package:workforceclientapp/Controllers/PostedOrderDetailsController.dart';
import 'package:workforceclientapp/Models/PostedJobAnswers.dart';
import 'package:workforceclientapp/Models/RequestedTradesmen.dart';
import 'package:workforceclientapp/Models/TradesmenRequest.dart';
import 'package:workforceclientapp/Others/Commons.dart';
import 'package:workforceclientapp/Others/Constants.dart';
import 'package:workforceclientapp/Others/MyColors.dart';
import 'package:workforceclientapp/Others/Strings.dart';
import 'package:workforceclientapp/Others/routes.dart';
import 'package:workforceclientapp/views/screens/Chat/ConversationScreen.dart';
import 'package:workforceclientapp/views/screens/JobRecommendations/TradesmenDetailScreen.dart';
import 'package:workforceclientapp/views/widgets/FullWidthButtonPrimary.dart';
import 'package:workforceclientapp/views/widgets/FullWidthElevatedButton.dart';
import 'package:workforceclientapp/views/widgets/FullWidthOutlineButton.dart';
import 'package:workforceclientapp/views/widgets/GlowingButton.dart';
import 'package:workforceclientapp/views/widgets/HeadingTextW500.dart';
import 'package:workforceclientapp/views/widgets/HeadingTextW600.dart';
import 'package:workforceclientapp/views/widgets/HeadingTextW700.dart';
import 'package:workforceclientapp/views/widgets/Headingdescription.dart';
import 'package:lottie/lottie.dart' as lottie;

class OrdersDetailsScreen extends GetView<PostedOrderDetailsController> {
  OrdersDetailsScreen({super.key});

  RxBool chatAvailable = false.obs;

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: true,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) {
          // Get.back(result: "back");
        }
      },
      child: Obx(() {
        return Scaffold(
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
                      text: Strings.orderDetail(context),
                      centerAlign: false,
                      size: 19.0.sp,
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
                    controller.isLoading.value
                        ? const SizedBox()
                        : controller.postedJobDetail.status!.value ==
                                    "cancelled" ||
                                controller.postedJobDetail.status!.value ==
                                    "completed" ||
                                controller.postedJobDetail.status!.value ==
                                    'in_progress'
                            ? const SizedBox()
                            : Positioned(
                                right: 0,
                                child: PopupMenuButton<int>(
                                  color: const Color(MyColors.cardBlueColor50),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12.r),
                                  ),
                                  onSelected: (value) {
                                    if (value == 0) {
                                      try {
                                        Get.toNamed(
                                          AppLinks.end_the_order_screen,
                                          arguments: {
                                            'jobId':
                                                controller.postedJobDetail.id,
                                          },
                                        );
                                      } catch (e) {
                                        throw Exception(e);
                                      }
                                    }
                                  },
                                  itemBuilder: (context) => [
                                    PopupMenuItem(
                                      value: 0,
                                      child: Row(
                                        children: [
                                          SvgPicture.asset(
                                            "lib/assets/icons/cancelRedIcon.svg",
                                            fit: BoxFit.contain,
                                            height: 18.h,
                                            width: 18.w,
                                          ),
                                          SizedBox(width: 10.w),
                                          Text(Strings.removeJob(context),
                                              style: const TextStyle(
                                                  color: Color(
                                                      MyColors.themeRedColor))),
                                        ],
                                      ),
                                    ),
                                  ],
                                  icon: const Icon(Icons.more_vert),
                                ),
                              ),
                  ],
                ),
              ),
            ),
          ),
          body: controller.isLoading.value
              ? const Center(
                  child: CircularProgressIndicator(
                    color: Color(MyColors.themeRedColor),
                  ),
                )
              : SafeArea(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        Padding(
                          padding: EdgeInsets.only(left: 28.0.w, top: 12.0.h),
                          child: SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    controller.chatTabColor.value =
                                        MyColors.silverColor;
                                    controller.recommendedTabColor.value =
                                        MyColors.silverColor;
                                    controller.tradesmenTabColor.value =
                                        MyColors.silverColor;
                                    controller.orderDetailTabColor.value =
                                        MyColors.themeRedColor;
                                    controller.selectedTabName.value =
                                        "orderDetail";
                                  },
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(Strings.orderDetail(Get.context!),
                                          textAlign: TextAlign.start,
                                          style: TextStyle(
                                              color: Color(controller
                                                  .orderDetailTabColor.value),
                                              fontSize: 15.sp,
                                              fontWeight: FontWeight.w500,
                                              fontFamily: 'Poppins')),
                                      SizedBox(
                                        height: 8.h,
                                      ),
                                      controller.selectedTabName.value ==
                                              "orderDetail"
                                          ? Container(
                                              width: 70.w, // Thin line
                                              height: 2
                                                  .h, // Adjust height as needed
                                              color: Color(controller
                                                  .orderDetailTabColor
                                                  .value), // Red color
                                            )
                                          : const SizedBox(),
                                    ],
                                  ),
                                ),
                                SizedBox(width: 25.w),
                                GestureDetector(
                                  onTap: () {
                                    controller.chatTabColor.value =
                                        MyColors.silverColor;
                                    controller.recommendedTabColor.value =
                                        MyColors.silverColor;
                                    controller.tradesmenTabColor.value =
                                        MyColors.themeRedColor;
                                    controller.orderDetailTabColor.value =
                                        MyColors.silverColor;
                                    controller.selectedTabName.value =
                                        "tradesmen";
                                  },
                                  child: Column(
                                    children: [
                                      Text(Strings.tradesman(Get.context!),
                                          textAlign: TextAlign.start,
                                          style: TextStyle(
                                              color: Color(controller
                                                  .tradesmenTabColor.value),
                                              fontSize: 15.sp,
                                              fontWeight: FontWeight.w500,
                                              fontFamily: 'Poppins')),
                                      SizedBox(
                                        height: 8.h,
                                      ),
                                      controller.selectedTabName.value ==
                                              "tradesmen"
                                          ? Container(
                                              width: 70.w, // Thin line
                                              height: 2
                                                  .h, // Adjust height as needed
                                              color: Color(controller
                                                  .tradesmenTabColor
                                                  .value), // Red color
                                            )
                                          : const SizedBox(),
                                    ],
                                  ),
                                ),
                                SizedBox(width: 25.w),
                                SizedBox(width: 25.w),
                                SizedBox(width: 30.w),
                              ],
                            ),
                          ),
                        ),
                        controller.selectedTabName.value == "orderDetail"
                            ? orderDetailsView()
                            : controller.selectedTabName.value == "tradesmen"
                                ? TradesmenSection(
                                    jobId: controller.jobId.value,
                                    jobStatus: controller
                                            .postedJobDetail.status!.value ??
                                        "",
                                  )
                                : const SizedBox()
                      ],
                    ),
                  ),
                ),
        );
      }),
    );
  }

  Widget _buildNoTradesmenView() {
    return Expanded(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Spacer(),
          Image.asset("lib/assets/images/nointerstedtradesmenimage.png",
              width: MediaQuery.of(Get.context!).size.width.w,
              height: MediaQuery.of(Get.context!).size.height.h / 5,
              fit: BoxFit.contain),
          Padding(
            padding: EdgeInsets.all(12.0.r),
            child: HeadingTextW700(
                text: Strings.nointerestedTradesmanText(Get.context!),
                centerAlign: true,
                size: 22.sp),
          ),
          Padding(
            padding: EdgeInsets.only(left: 12.0.w, right: 12.0.w),
            child: Headingdescription(
                text:
                    Strings.nointerestedTradesmanDescriptionText(Get.context!),
                centerAlign: true,
                size: 13.0.sp),
          ),
          const Spacer(),
        ],
      ),
    );
  }

  Widget _jobAnswersView(PostedJobAnswers postedJobAnswers) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 12.0.h),
        HeadingTextW500(
            text: postedJobAnswers.question!.question ?? "N/A",
            centerAlign: false,
            size: 14.0.sp),
        SizedBox(height: 10.0.h),
        Headingdescription(
            text: postedJobAnswers.answer ?? "N/A",
            centerAlign: false,
            size: 14.0.sp),
        SizedBox(height: 7.0.h),
        postedJobAnswers.id == controller.postedJobDetail.jobAnswers!.last.id
            ? const SizedBox()
            : Container(
                height: 0.5.h,
                color: const Color(MyColors.lightGrayColor),
              )
      ],
    );
  }

  Widget _jobPhotosView(String url) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 0),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10.r),
        child: Stack(
          children: [
            Padding(
              padding: EdgeInsets.all(6.0.r),
              child: ClipRRect(
                  borderRadius: BorderRadius.circular(10.r),
                  child: SizedBox(
                      height: 90.r,
                      width: 90.w,
                      child: PhotoViewerImage(
                        imageUrl: url,
                        fit: BoxFit.cover,
                      ))),
            ),
          ],
        ),
      ),
    );
  }

  Widget _jobContactView() {
    return Obx(() {
      final status = controller.postedJobDetail.status!.value;
      if (status != "completed" && status != "in_progress") {
        return const SizedBox();
      }
      if (controller.loadingJobContact.value) {
        return Padding(
          padding: EdgeInsets.symmetric(vertical: 12.h),
          child: const Center(
            child: CircularProgressIndicator(
              color: Color(MyColors.themeRedColor),
            ),
          ),
        );
      }
      final contact = controller.jobContact.value;
      final tradesman = contact?.tradesman;
      if (tradesman == null) return const SizedBox();
      final review = status == "completed" ? contact!.tradesmanReview : null;

      return Padding(
        padding: EdgeInsets.only(left: 14.0.w, right: 14.0.w, bottom: 4.0.h),
        child: Card(
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.0.r),
          ),
          color: const Color(MyColors.cardGrayColor100),
          child: Padding(
            padding: EdgeInsets.all(16.0.r),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    SvgPicture.asset(
                      "lib/assets/icons/interestedtradesmenLogo.svg",
                      height: 16.h,
                      width: 16.w,
                    ),
                    SizedBox(width: 8.w),
                    HeadingTextW500(
                      text: Strings.tradesman(Get.context!),
                      centerAlign: false,
                      size: 14.sp,
                    ),
                  ],
                ),
                SizedBox(height: 12.h),
                Row(
                  children: [
                    CircleAvatar(
                      radius: 24.r,
                      backgroundColor: const Color(MyColors.silverColor),
                      backgroundImage: tradesman.profileImg != null
                          ? NetworkImage(tradesman.profileImg!)
                          : null,
                      child: tradesman.profileImg == null
                          ? const Icon(Icons.person, color: Colors.white)
                          : null,
                    ),
                    SizedBox(width: 12.w),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Flexible(
                                child: Text(
                                  tradesman.name ?? "N/A",
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    fontSize: 15.sp,
                                    fontWeight: FontWeight.w600,
                                    fontFamily: 'Poppins',
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                              if (tradesman.isVerified ?? false) ...[
                                SizedBox(width: 6.w),
                                SvgPicture.asset(
                                  "lib/assets/icons/verifiedIcon.svg",
                                  height: 15.0.h,
                                  width: 15.0.w,
                                ),
                              ],
                            ],
                          ),
                          if ((tradesman.companyName ?? "").isNotEmpty)
                            Text(
                              tradesman.companyName!,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: 13.sp,
                                fontFamily: 'Poppins',
                                color: const Color(MyColors.darkGrayColor),
                              ),
                            ),
                          if (tradesman.memberSince != null)
                            Text(
                              "${Strings.memberSinceText(Get.context!)} ${tradesman.memberSince}",
                              style: TextStyle(
                                fontSize: 12.sp,
                                fontFamily: 'Poppins',
                                color: const Color(MyColors.darkGrayColor),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ],
                ),
                if (review != null) ...[
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 12.h),
                    child: const Divider(
                        height: 1, color: Color(MyColors.silverColor)),
                  ),
                  HeadingTextW500(
                    text: Strings.reviews(Get.context!),
                    centerAlign: false,
                    size: 14.sp,
                  ),
                  SizedBox(height: 6.h),
                  Row(
                    children: [
                      RatingBarIndicator(
                        rating: (review.rating ?? 0).toDouble(),
                        itemCount: 5,
                        itemSize: 16.r,
                        itemPadding: EdgeInsets.only(right: 2.w),
                        itemBuilder: (context, _) => const Icon(
                            Icons.star_rounded,
                            color: Color(MyColors.themeRedColor)),
                      ),
                      SizedBox(width: 8.w),
                      Flexible(
                        child: Text(
                          "${Strings.reviewedOn(Get.context!)} ${TradesmenDetailScreen.formatDate(review.createdAt)}",
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 11.5.sp,
                            fontFamily: 'Poppins',
                            color: const Color(MyColors.darkGrayColor),
                          ),
                        ),
                      ),
                    ],
                  ),
                  if ((review.comment ?? "").trim().isNotEmpty) ...[
                    SizedBox(height: 8.h),
                    Text(
                      review.comment!,
                      style: TextStyle(
                        fontSize: 13.sp,
                        height: 1.5,
                        fontFamily: 'Poppins',
                        color: Colors.black,
                      ),
                    ),
                  ],
                ],
                controller.postedJobDetail.status!.value == 'in_progress'
                    ? Padding(
                        padding:
                            EdgeInsets.only(top: 18.0.h, left: 8.w, right: 8.w),
                        child: SizedBox(
                          height: 37.h,
                          width: MediaQuery.of(Get.context!).size.width.w,
                          child: ElevatedButton(
                            onPressed: () async {
                              _confirmAndComplete();
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor:
                                  const Color(MyColors.themeRedColor),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8.r),
                              ),
                            ),
                            child: Text(
                              Strings.markAsCompleteText(Get.context!),
                              style: TextStyle(
                                fontSize: 13.sp,
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                      )
                    : const SizedBox(),
                if (status == "completed" && review == null) ...[
                  SizedBox(height: 12.h),
                  FullWidthElevatedButton(
                    text: Strings.giveReview(Get.context!),
                    color: MyColors.themeRedColor,
                    textColor: MyColors.whiteColor,
                    onPressed: () async {
                      await Get.toNamed(AppLinks.review_screen, arguments: {
                        'jobPostingId': controller.jobId.value,
                        'tradesmenId': tradesman.id,
                      });
                      // Refresh in case a review was submitted.
                      controller.getJobContact(controller.jobId.value);
                    },
                  ),
                ],
              ],
            ),
          ),
        ),
      );
    });
  }

  Widget orderDetailsView() {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.only(
              top: 20.0.h, bottom: 7.0.h, left: 18.r, right: 18.r),
          child: HeadingTextW600(
              text: controller.postedJobDetail.serviceName ?? "N/A",
              centerAlign: false,
              size: 17.0.sp),
        ),
        Padding(
          padding: EdgeInsets.only(left: 14.0.w, top: 4.0.h),
          child: Align(
            alignment: Alignment.topLeft,
            child: Card(
              elevation: 0,
              color: controller.postedJobDetail.status!.value == "open"
                  ? const Color(MyColors.cardColorSky200)
                  : controller.postedJobDetail.status!.value == "in_progress"
                      ? const Color(MyColors.cardColorGreenLight)
                      : controller.postedJobDetail.status!.value == "cancelled"
                          ? const Color(MyColors.cardcolorOrange200)
                          : const Color(MyColors.cardColorGreen200),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(6.r)),
              child: Padding(
                padding: EdgeInsets.all(5.0.r),
                child: controller.postedJobDetail.status!.value == "open"
                    ? Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          SvgPicture.asset("lib/assets/icons/inprocessIcon.svg",
                              height: 14.0.h, width: 14.0.w),
                          SizedBox(
                            width: 6.0.w,
                          ),
                          Headingdescription(
                              text: Strings.openText(Get.context!),
                              centerAlign: false,
                              size: 12.sp)
                        ],
                      )
                    : controller.postedJobDetail.status!.value == "in_progress"
                        ? Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              lottie.Lottie.asset(
                                'lib/assets/icons/ActiveStatusRipple.json',
                                width: 14.w,
                                height: 14.h,
                                fit: BoxFit.contain,
                                repeat: true,
                                animate: true,
                              ),
                              SizedBox(
                                width: 6.0.w,
                              ),
                              Headingdescription(
                                  text: Strings.active(Get.context!),
                                  centerAlign: false,
                                  size: 12.sp)
                            ],
                          )
                        : controller.postedJobDetail.status!.value ==
                                "cancelled"
                            ? Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  SvgPicture.asset(
                                      "lib/assets/icons/jobCancelledIcon.svg",
                                      height: 14.0.h,
                                      width: 14.0.w),
                                  SizedBox(
                                    width: 6.0.w,
                                  ),
                                  Headingdescription(
                                      text: Strings.canceledText(Get.context!),
                                      centerAlign: false,
                                      size: 12.sp)
                                ],
                              )
                            : Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  SvgPicture.asset(
                                      "lib/assets/icons/completedTickIcon.svg",
                                      height: 14.0.h,
                                      width: 14.0.w),
                                  SizedBox(
                                    width: 6.0.w,
                                  ),
                                  Headingdescription(
                                      text: Strings.completed(Get.context!),
                                      centerAlign: false,
                                      size: 12.sp)
                                ],
                              ),
              ),
            ),
          ),
        ),
        controller.postedJobDetail.status!.value == 'completed'
            ? SizedBox(
                width: 170.w,
                height: 170.h,
                child: Center(
                  child: lottie.Lottie.asset(
                    'lib/assets/icons/auftragnow_completed_contract.json',
                    width: 170.w,
                    height: 170.h,
                    fit: BoxFit.contain,
                    repeat: true,
                    animate: true,
                  ),
                ),
              )
            : controller.postedJobDetail.status!.value == 'in_progress'
                ? SizedBox(
                    width: 170.w,
                    height: 170.h,
                    child: Center(
                      child: lottie.Lottie.asset(
                        'lib/assets/icons/auftragnow_running_contract.json',
                        width: 170.w,
                        height: 170.h,
                        fit: BoxFit.contain,
                        repeat: true,
                        animate: true,
                      ),
                    ),
                  )
                : const SizedBox(),
        controller.postedJobDetail.status!.value == 'completed'
            ? Column(children: [
                HeadingTextW600(
                    text: Strings.contractCompleted(Get.context!),
                    centerAlign: false,
                    size: 16.sp),
                AutoSizeText(
                  controller.jobContact.value == null
                      ? ""
                      : "${Strings.dated(Get.context!)}: ${formatDates(controller.jobContact.value!.updatedAt)}",
                  maxFontSize: 14,
                  minFontSize: 9,
                  maxLines: 1,
                  style: const TextStyle(),
                ),
              ])
            : controller.postedJobDetail.status!.value == 'in_progress'
                ? Column(
                    children: [
                      HeadingTextW600(
                          text: Strings.contractInProgress(Get.context!),
                          centerAlign: false,
                          size: 16.sp),
                      AutoSizeText(
                        controller.jobContact.value == null
                            ? ""
                            : "${Strings.dated(Get.context!)}: ${formatDates(controller.jobContact.value!.updatedAt)}",
                        maxFontSize: 14,
                        minFontSize: 9,
                        maxLines: 1,
                        style: const TextStyle(),
                      ),
                    ],
                  )
                : const SizedBox(),
        controller.postedJobDetail.status!.value == 'completed' ||
                controller.postedJobDetail.status!.value == 'in_progress'
            ? const SizedBox(
                height: 15,
              )
            : const SizedBox(),
        _jobContactView(),
        Obx(() {
          return (controller.postedJobDetail.status!.value == "completed" ||
                  controller.postedJobDetail.status!.value == 'in_progress')
              ? const SizedBox()
              : controller.loadingInterestedTradesmen.value
                  ? const Center(
                      child: CircularProgressIndicator(
                        color: Color(MyColors.themeRedColor),
                      ),
                    )
                  : Padding(
                      padding: EdgeInsets.only(left: 14.0.w, right: 14.0.w),
                      child: Card(
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0.r),
                        ),
                        color: const Color(MyColors.cardGrayColor100),
                        child: Padding(
                          padding: EdgeInsets.all(8.0.r),
                          child: Column(
                            children: [
                              Padding(
                                padding: EdgeInsets.all(8.0.r),
                                child: Row(
                                  children: [
                                    SvgPicture.asset(
                                      "lib/assets/icons/interestedtradesmenLogo.svg",
                                      height: 16.h,
                                      width: 16.w,
                                    ),
                                    SizedBox(width: 8.w),
                                    HeadingTextW500(
                                      text: Strings.interestedTradesman(
                                          Get.context!),
                                      centerAlign: false,
                                      size: 14.sp,
                                    ),
                                  ],
                                ),
                              ),
                              Align(
                                alignment: Alignment.topLeft,
                                child: Padding(
                                  padding: EdgeInsets.only(
                                      left: 8.0.w, right: 8.0.w),
                                  child: RichText(
                                    maxLines: 2,
                                    softWrap: false,
                                    overflow: TextOverflow.ellipsis,
                                    text: TextSpan(
                                      text: Strings.youGot(Get.context!),
                                      style: TextStyle(
                                        fontFamily: 'Poppins',
                                        color: Colors.black,
                                        fontSize: 14.sp,
                                      ),
                                      children: [
                                        TextSpan(
                                          text:
                                              " ${controller.postedJobDetail.tradespersonApplicationsCount ?? "0"} ",
                                          style: TextStyle(
                                            color: const Color(
                                                MyColors.themeRedColor),
                                            fontFamily: 'Poppins',
                                            fontSize: 16.sp,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        TextSpan(
                                          text: Strings.pickTheBestAndStartWork(
                                              Get.context!),
                                          style: TextStyle(
                                            color: const Color(
                                                MyColors.blackColor),
                                            fontFamily: 'Poppins',
                                            fontSize: 14.sp,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              GridView.builder(
                                padding: EdgeInsets.all(8.r),
                                itemCount: controller.tradesmenImages.length,
                                gridDelegate:
                                    const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 8,
                                  crossAxisSpacing: 5,
                                  mainAxisSpacing: 5,
                                ),
                                itemBuilder: (context, index) {
                                  return CircleAvatar(
                                    radius: 33.r,
                                    backgroundImage: NetworkImage(
                                        controller.tradesmenImages[index]),
                                  );
                                },
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                              ),
                              Padding(
                                padding: EdgeInsets.all(4.0.r),
                                child: FullWidthElevatedButton(
                                  text:
                                      Strings.interestedTradesman(Get.context!),
                                  color: MyColors.themeRedColor,
                                  onPressed: () {
                                    try {
                                      controller.chatTabColor.value =
                                          MyColors.silverColor;
                                      controller.recommendedTabColor.value =
                                          MyColors.silverColor;
                                      controller.tradesmenTabColor.value =
                                          MyColors.themeRedColor;
                                      controller.orderDetailTabColor.value =
                                          MyColors.silverColor;
                                      controller.selectedTabName.value =
                                          "tradesmen";
                                      // TradesmenSection(
                                      //     jobId: controller.jobId.value,
                                      //     jobStatus:
                                      //         controller.postedJobDetail.status!.value ??
                                      //             "");
                                    } catch (e) {
                                      throw Exception(e);
                                    }
                                  },
                                  textColor: MyColors.whiteColor,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
        }),
        Padding(
          padding: EdgeInsets.only(left: 14.0.w, right: 14.0.w, top: 14.0.h),
          child: SizedBox(
            width: MediaQuery.of(Get.context!).size.width.w,
            child: Card(
              elevation: 0,
              color: const Color(MyColors.infoPinkColor),
              child: Padding(
                padding: EdgeInsets.all(8.0.r),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.all(7.0.r),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SvgPicture.asset(
                            "lib/assets/icons/ChatAnswers.svg",
                            height: 22.h,
                            width: 22.w,
                          ),
                          Padding(
                            padding:
                                EdgeInsets.only(left: 12.0.w, right: 8.0.w),
                            child: Headingdescription(
                                text: Strings.zeroAnswers(Get.context!),
                                centerAlign: false,
                                size: 14.sp),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(7.0.r),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SvgPicture.asset(
                            "lib/assets/icons/timer.svg",
                            height: 22.h,
                            width: 22.w,
                          ),
                          Padding(
                            padding:
                                EdgeInsets.only(left: 12.0.w, right: 8.0.w),
                            child: Headingdescription(
                                text: controller.postedJobDetail
                                        .humanReadableCreatedAt ??
                                    "N/A",
                                centerAlign: false,
                                size: 14.sp),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(7.0.r),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SvgPicture.asset(
                            "lib/assets/icons/location.svg",
                            height: 22.h,
                            width: 22.w,
                          ),
                          Padding(
                            padding:
                                EdgeInsets.only(left: 12.0.w, right: 8.0.w),
                            child: Headingdescription(
                                text: controller.postedJobDetail.city ?? "N/A",
                                centerAlign: false,
                                size: 14.sp),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.only(left: 14.0.w, right: 14.0.w, top: 14.0.h),
          child: Card(
            elevation: 0,
            color: const Color(MyColors.cardGrayColor50),
            child: Padding(
              padding: EdgeInsets.all(4.0.r),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Padding(
                      padding: EdgeInsets.only(top: 12.0.h),
                      child: HeadingTextW500(
                          text: Strings.info(Get.context!),
                          centerAlign: false,
                          size: 18.0.r),
                    ),
                  ),
                  Align(
                    alignment: Alignment.topLeft,
                    child: Padding(
                      padding: EdgeInsets.only(top: 12.0.h, left: 8.0.w),
                      child: HeadingTextW500(
                          text: Strings.jobTitle(Get.context!),
                          centerAlign: false,
                          size: 16.0.r),
                    ),
                  ),
                  Align(
                    alignment: Alignment.topLeft,
                    child: Padding(
                      padding: EdgeInsets.only(top: 4.0.h, left: 8.0.w),
                      child: Headingdescription(
                          text: controller.postedJobDetail.title ?? "N/A",
                          centerAlign: false,
                          size: 16.0.sp),
                    ),
                  ),
                  Align(
                    alignment: Alignment.topLeft,
                    child: Padding(
                      padding: EdgeInsets.only(top: 12.0.h, left: 8.0.w),
                      child: HeadingTextW500(
                          text: Strings.jobDescription(Get.context!),
                          centerAlign: false,
                          size: 16.0.sp),
                    ),
                  ),
                  Align(
                    alignment: Alignment.topLeft,
                    child: Padding(
                      padding: EdgeInsets.only(
                          top: 4.0.h, left: 8.0.w, right: 8.0.w, bottom: 6.0.h),
                      child: Headingdescription(
                          text: controller.postedJobDetail.desc ?? "N/A",
                          centerAlign: false,
                          size: 14.0.sp),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.all(14.0.r),
          child: Card(
            elevation: 0,
            color: const Color(MyColors.cardGrayColor50),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: EdgeInsets.only(top: 12.0.h),
                  child: HeadingTextW500(
                      text: Strings.detailsText(Get.context!),
                      centerAlign: false,
                      size: 18.0.sp),
                ),
                Padding(
                  padding: EdgeInsets.all(10.0.r),
                  child: controller.postedJobDetail.jobAnswers != null
                      ? ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount:
                              controller.postedJobDetail.jobAnswers!.length,
                          itemBuilder: (context, index) {
                            return _jobAnswersView(
                                controller.postedJobDetail.jobAnswers![index]);
                          },
                        )
                      : Padding(
                          padding: EdgeInsets.all(5.0.r),
                          child: Headingdescription(
                              text: Strings.dataNotFound(Get.context!),
                              centerAlign: false,
                              size: 15.sp),
                        ),
                ),
              ],
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.only(left: 14.0.w, right: 14.0.w, bottom: 14.0.h),
          child: SizedBox(
            width: MediaQuery.of(Get.context!).size.width.w,
            child: Card(
              elevation: 0,
              color: const Color(MyColors.cardGrayColor50),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.all(12.0.r),
                    child: HeadingTextW500(
                        text: Strings.photos(Get.context!),
                        centerAlign: false,
                        size: 18.0.sp),
                  ),
                  controller.postedJobDetail.imageList != null
                      ? controller.postedJobDetail.imageList!.isNotEmpty
                          ? Padding(
                              padding:
                                  EdgeInsets.only(left: 14.0.w, bottom: 6.0.h),
                              child: SizedBox(
                                height: 95
                                    .h, // Adjust height based on your image size
                                child: ListView.builder(
                                  shrinkWrap: true,
                                  scrollDirection: Axis.horizontal,
                                  itemCount: controller
                                      .postedJobDetail.imageList!.length,
                                  itemBuilder: (context, index) {
                                    return _jobPhotosView(controller
                                        .postedJobDetail.imageList![index]);
                                  },
                                ),
                              ),
                            )
                          : Padding(
                              padding: EdgeInsets.only(bottom: 16.0.h),
                              child: Center(
                                child: Headingdescription(
                                    text: Strings.noPhotosWereUploaded(
                                        Get.context!),
                                    centerAlign: false,
                                    size: 15.sp),
                              ),
                            )
                      : Padding(
                          padding: EdgeInsets.only(bottom: 16.0.h),
                          child: Center(
                            child: Headingdescription(
                                text:
                                    Strings.noPhotosWereUploaded(Get.context!),
                                centerAlign: false,
                                size: 15.sp),
                          ),
                        ),
                ],
              ),
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.only(left: 14.0.w, right: 14.0.w),
          child: SizedBox(
            width: MediaQuery.of(Get.context!).size.width.w,
            height: MediaQuery.of(Get.context!).size.height.h / 2,
            child: Card(
              elevation: 0,
              color: const Color(MyColors.lightSilverColor),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.only(left: 12.0.w, top: 12.0.h),
                    child: HeadingTextW500(
                        text: Strings.yourAddress(Get.context!),
                        centerAlign: false,
                        size: 18.0.sp),
                  ),
                  Padding(
                    padding: EdgeInsets.all(6.0.r),
                    child: Card(
                      elevation: 0,
                      color: Colors.white,
                      child: Padding(
                        padding: EdgeInsets.all(7.0.r),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: RichText(
                                    maxLines: 3,
                                    softWrap: true,
                                    overflow: TextOverflow.visible,
                                    text: TextSpan(
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 13.sp,
                                      ),
                                      children: [
                                        TextSpan(
                                          text:
                                              "${Strings.addressText(Get.context!)}: ",
                                          style: TextStyle(
                                            color: const Color(
                                                MyColors.blackColor),
                                            fontFamily: 'Poppins',
                                            fontSize: 14.sp,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                        TextSpan(
                                          text: controller
                                                  .postedJobDetail.location ??
                                              "N/A",
                                          style: TextStyle(
                                            color: const Color(
                                                MyColors.blackColor),
                                            fontFamily: 'Poppins',
                                            fontSize: 14.sp,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            RichText(
                              maxLines: 2,
                              softWrap: true,
                              overflow: TextOverflow.ellipsis,
                              text: TextSpan(
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 13.sp,
                                ),
                                children: [
                                  TextSpan(
                                    text:
                                        "${Strings.postcodeText(Get.context!)}: ",
                                    style: TextStyle(
                                      color: const Color(MyColors.blackColor),
                                      fontFamily: 'Poppins',
                                      fontSize: 14.sp,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  TextSpan(
                                    text: controller.postedJobDetail.postcode ??
                                        "N/A",
                                    style: TextStyle(
                                      color: const Color(MyColors.blackColor),
                                      fontFamily: 'Poppins',
                                      fontSize: 14.sp,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            RichText(
                              maxLines: 2,
                              softWrap: true,
                              overflow: TextOverflow.ellipsis,
                              text: TextSpan(
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 13.sp,
                                ),
                                children: [
                                  TextSpan(
                                    text: "${Strings.cityText(Get.context!)}: ",
                                    style: TextStyle(
                                      color: const Color(MyColors.blackColor),
                                      fontFamily: 'Poppins',
                                      fontSize: 14.sp,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  TextSpan(
                                    text: controller.postedJobDetail.city ??
                                        "N/A",
                                    style: TextStyle(
                                      color: const Color(MyColors.blackColor),
                                      fontFamily: 'Poppins',
                                      fontSize: 14.sp,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            RichText(
                              maxLines: 2,
                              softWrap: true,
                              overflow: TextOverflow.ellipsis,
                              text: TextSpan(
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 13.sp,
                                ),
                                children: [
                                  TextSpan(
                                    text:
                                        "${Strings.countryText(Get.context!)}: ",
                                    style: TextStyle(
                                      color: const Color(MyColors.blackColor),
                                      fontFamily: 'Poppins',
                                      fontSize: 14.sp,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  TextSpan(
                                    text: controller.postedJobDetail.country ??
                                        "N/A",
                                    style: TextStyle(
                                      color: const Color(MyColors.blackColor),
                                      fontFamily: 'Poppins',
                                      fontSize: 14.sp,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                        left: 10.0.w, right: 10.0.w, top: 14.0.h),
                    child: HeadingTextW500(
                        text: Strings.viewOnMap(Get.context!),
                        centerAlign: false,
                        size: 18.0.sp),
                  ),
                  Obx(() {
                    return Expanded(
                      child: Padding(
                        padding: EdgeInsets.all(10.0.r),
                        child: GoogleMap(
                          // onMapCreated: _onMapCreated,
                          initialCameraPosition: CameraPosition(
                            target: controller.currentPosition.value,
                            zoom: 15.0,
                          ),
                          markers: {
                            Marker(
                              markerId: const MarkerId("selected_location"),
                              position: controller.currentPosition.value,
                              draggable:
                                  false, // Marker moves with camera, not drag
                            ),
                          },
                          rotateGesturesEnabled: false,
                          scrollGesturesEnabled: false,
                          // onCameraMove:
                          //     _onCameraMove, // Updates marker as the camera moves
                          // onCameraIdle:
                          //     _onCameraIdle, // When the map stops moving
                        ),
                      ),
                    );
                  }),
                ],
              ),
            ),
          ),
        ),
        Obx(() {
          return Padding(
            padding: EdgeInsets.all(14.0.r),
            child: Card(
              elevation: 0,
              color: const Color(MyColors.cardGrayColor200),
              child: Padding(
                padding: EdgeInsets.all(16.0.r),
                child: Center(
                  child: Row(
                    children: [
                      Padding(
                          padding: EdgeInsets.only(left: 4.0.w, right: 12.0.w),
                          child: SvgPicture.asset(
                              "lib/assets/icons/informationLogo.svg",
                              height: 24.0.h,
                              width: 24.0.w)),
                      Expanded(
                        child: GestureDetector(
                            onTap: () async {
                              try {
                                if (controller.postedJobDetail
                                        .tradespersonRequestsCount ==
                                    null) {
                                  Fluttertoast.showToast(
                                      msg: Strings.somethingWentWrong(
                                          Get.context!));
                                  return;
                                }
                                int remainingReqCount =
                                    controller.getRemainingTrademenRequests(
                                        int.parse(controller.postedJobDetail
                                            .tradespersonRequestsCount!.value));
                                await Get.toNamed(
                                  AppLinks.job_recommendations,
                                  arguments: {
                                    'jobId': controller.postedJobDetail.id,
                                    'remainingRequeststoSend':
                                        remainingReqCount,
                                    'fromWhere': 'orderDetail',
                                    'index': controller.jobIndex
                                  },
                                );
                                // controller.postedJobDetail
                                //         .tradespersonRequestsCount!.value =
                                //     Constants.remainingRequestsCount.toString();
                                // Constants.remainingRequestsCount = 0;
                              } catch (e) {
                                throw Exception(e);
                              }
                            },
                            child: RichText(
                              text: TextSpan(
                                text: '',
                                style: TextStyle(
                                    color: Colors.black, fontSize: 13.sp),
                                children: <TextSpan>[
                                  TextSpan(
                                    text:
                                        '${Strings.sendARequestText(Get.context!)} ',
                                    style: TextStyle(
                                        fontFamily: 'Poppins',
                                        fontSize: 13.sp,
                                        fontWeight: FontWeight.bold,
                                        color: const Color(
                                            MyColors.themeRedColor)),
                                  ),
                                  TextSpan(
                                    text: controller.getRemainingTrademenRequests(
                                                int.parse(controller
                                                    .postedJobDetail
                                                    .tradespersonRequestsCount!
                                                    .value)) ==
                                            0
                                        ? Strings.toMore0TradesmenText(
                                            Get.context!)
                                        : controller.getRemainingTrademenRequests(
                                                    int.parse(controller
                                                        .postedJobDetail
                                                        .tradespersonRequestsCount!
                                                        .value)) ==
                                                1
                                            ? Strings.toMore1TradesmenText(Get.context!)
                                            : controller.getRemainingTrademenRequests(int.parse(controller.postedJobDetail.tradespersonRequestsCount!.value)) == 2
                                                ? Strings.toMore2TradesmenText(Get.context!)
                                                : controller.getRemainingTrademenRequests(int.parse(controller.postedJobDetail.tradespersonRequestsCount!.value)) == 3
                                                    ? Strings.toMore3TradesmenText(Get.context!)
                                                    : controller.getRemainingTrademenRequests(int.parse(controller.postedJobDetail.tradespersonRequestsCount!.value)) == 4
                                                        ? Strings.toMore4TradesmenText(Get.context!)
                                                        : controller.getRemainingTrademenRequests(int.parse(controller.postedJobDetail.tradespersonRequestsCount!.value)) == 5
                                                            ? Strings.toMore5TradesmenText(Get.context!)
                                                            : controller.getRemainingTrademenRequests(int.parse(controller.postedJobDetail.tradespersonRequestsCount!.value)) == 6
                                                                ? Strings.toMore6TradesmenText(Get.context!)
                                                                : controller.getRemainingTrademenRequests(int.parse(controller.postedJobDetail.tradespersonRequestsCount!.value)) == 7
                                                                    ? Strings.toMore7TradesmenText(Get.context!)
                                                                    : controller.getRemainingTrademenRequests(int.parse(controller.postedJobDetail.tradespersonRequestsCount!.value)) == 8
                                                                        ? Strings.toMore8TradesmenText(Get.context!)
                                                                        : controller.getRemainingTrademenRequests(int.parse(controller.postedJobDetail.tradespersonRequestsCount!.value)) == 9
                                                                            ? Strings.toMore9TradesmenText(Get.context!)
                                                                            : Strings.toMore10TradesmenText(Get.context!),
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 13.sp,
                                        fontWeight: FontWeight.w400,
                                        fontFamily: 'Poppins'),
                                  ),
                                ],
                              ),
                            )),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        }),
      ],
    );
  }

  String formatDates(String? raw, {String pattern = 'd MMM, yyyy'}) {
    try {
      if (raw == null || raw.trim().isEmpty) return "";
      final parsed = DateTime.tryParse(raw.trim());
      if (parsed == null) return raw;
      return DateFormat(pattern).format(parsed.toLocal());
    } catch (e) {
      throw Exception(e);
    }
  }

  final bool _isUpdatingStatus = false;

  Future<void> _confirmAndComplete() async {
    final bool? confirmed = await showDialog<bool>(
      context: Get.context!,
      barrierDismissible: true,
      builder: (dialogContext) => Dialog(
        backgroundColor: Colors.white,
        insetPadding: EdgeInsets.symmetric(horizontal: 24.w),
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.r)),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 24.h),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: EdgeInsets.all(14.r),
                decoration: const BoxDecoration(
                  color: Color(MyColors.cardColorGreen200),
                  shape: BoxShape.circle,
                ),
                child: SvgPicture.asset(
                  "lib/assets/icons/completedTickIcon.svg",
                  height: 26.h,
                  width: 26.w,
                ),
              ),
              SizedBox(height: 16.h),
              Text(
                "${Strings.markAsCompleteText(dialogContext)}?",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 17.sp,
                  fontWeight: FontWeight.w600,
                  fontFamily: 'Poppins',
                  color: const Color(MyColors.blackColor),
                ),
              ),
              SizedBox(height: 10.h),
              Text(
                Strings.areYouSureToCompleteThisContractText(dialogContext),
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14.sp,
                  fontFamily: 'Poppins',
                  color: const Color(MyColors.darkGrayColor),
                  height: 1.4,
                ),
              ),
              SizedBox(height: 24.h),
              Row(
                children: [
                  Expanded(
                    child: FullWidthOutlineButton(
                      text: Strings.noText(dialogContext),
                      fontsize: 14,
                      color: MyColors.colorNeutral700,
                      onPressed: () => Navigator.of(dialogContext).pop(false),
                    ),
                  ),
                  SizedBox(width: 12.w),
                  Expanded(
                    child: FullWidthButtonPrimary(
                      text: Strings.yesText(dialogContext),
                      fontsize: 14,
                      color: MyColors.themeRedColor,
                      onPressed: () {
                        completeTheJob();
                      },
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void completeTheJob() {
    try {
      Get.back();
      Commons.showProgressDialog(Get.context!);
      int requestId = 0;
      int tradesmanId = 0;
      if (controller.jobContact.value != null) {
        if (controller.jobContact.value!.tradesman != null) {
          if (controller.jobContact.value!.tradesman!.id != null &&
              controller.jobContact.value!.id != null) {
            tradesmanId = controller.jobContact.value!.tradesman!.id!;
            requestId = controller.jobContact.value!.id!;
          } else {
            Fluttertoast.showToast(
                msg: Strings.somethingWentWrong(Get.context!));
            return;
          }
        } else {
          Fluttertoast.showToast(msg: Strings.somethingWentWrong(Get.context!));
          return;
        }
      } else {
        Fluttertoast.showToast(msg: Strings.somethingWentWrong(Get.context!));
        return;
      }
      if (tradesmanId == 0 || requestId == 0) {
        Fluttertoast.showToast(msg: Strings.somethingWentWrong(Get.context!));

        return;
      }
      controller.updateJobStatus(
          "completed", controller.postedJobDetail.id!, requestId, tradesmanId);
    } catch (e) {
      throw Exception(e);
    }
  }
}

class TradesmenSection extends StatefulWidget {
  final int jobId;
  final String jobStatus;
  const TradesmenSection(
      {super.key, required this.jobId, required this.jobStatus});

  @override
  State<TradesmenSection> createState() => _TradesmenSectionState();
}

class _TradesmenSectionState extends State<TradesmenSection> {
  bool isLoading = true.obs();
  String applicationStatus = "All";
  int allOptionColor = MyColors.cardSkyColor100;
  int acceptedOptionColor = MyColors.colorNeutral100;
  int rejectedOptionColor = MyColors.colorNeutral100;
  int allOptionTextColor = MyColors.cardSkyColor700;
  int acceptedOptionTextColor = MyColors.colorNeutral700;
  int rejectedOptionTextColor = MyColors.colorNeutral700;
  RequestedTradesmen? requestedTradesmen;
  final PostedOrderDetailsController controller =
      Get.put(PostedOrderDetailsController());

  void getTradesmenList() async {
    if (widget.jobId != -1) {
      isLoading = true.obs();
      requestedTradesmen = await controller.pleaseGetTradesmenRequestsList(
          widget.jobId, applicationStatus, context);
      if (requestedTradesmen != null) {
        setState(() {
          isLoading = false.obs();
        });
      }
    } else {
      // Fluttertoast.showToast(msg: Strings.somethingWentWrong(context))
    }
  }

  @override
  void initState() {
    super.initState();
    getTradesmenList();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.all(8.0),
        child: _buildInterstedTradesmenView());
  }

  Widget _buildInterstedTradesmenView() {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.only(top: 12.0.h),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              GestureDetector(
                onTap: () {
                  try {
                    if (applicationStatus == "All") {
                      return;
                    }
                    setState(() {
                      allOptionColor = MyColors.cardSkyColor100;
                      allOptionTextColor = MyColors.cardSkyColor700;
                      acceptedOptionColor = MyColors.colorNeutral100;
                      acceptedOptionTextColor = MyColors.colorNeutral700;
                      rejectedOptionColor = MyColors.colorNeutral100;
                      rejectedOptionTextColor = MyColors.colorNeutral700;
                      applicationStatus = "All";
                    });
                    getTradesmenList();
                  } catch (e) {
                    throw Exception(e);
                  }
                },
                child: Card(
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5.r)),
                  color: Color(allOptionColor),
                  child: Padding(
                    padding: EdgeInsets.all(4.0.r),
                    child: Row(
                      children: [
                        SvgPicture.asset(
                          applicationStatus == "All"
                              ? "lib/assets/icons/ticklogoblue.svg"
                              : "lib/assets/icons/ticklogoblack.svg",
                          height: 14.h,
                          width: 14.w,
                          fit: BoxFit.contain,
                        ),
                        SizedBox(
                          width: 4.0.w,
                        ),
                        Text(Strings.allText(context),
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                color: Color(allOptionTextColor),
                                fontSize: 12.sp,
                                fontWeight: FontWeight.w400,
                                fontFamily: 'Poppins')),
                      ],
                    ),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(left: 6.0.w),
                child: GestureDetector(
                  onTap: () {
                    try {
                      if (applicationStatus == "approved") {
                        return;
                      }
                      setState(() {
                        acceptedOptionColor = MyColors.cardSkyColor100;
                        acceptedOptionTextColor = MyColors.cardSkyColor700;
                        allOptionColor = MyColors.colorNeutral100;
                        allOptionTextColor = MyColors.colorNeutral700;
                        rejectedOptionColor = MyColors.colorNeutral100;
                        rejectedOptionTextColor = MyColors.colorNeutral700;
                        applicationStatus = "approved";
                      });
                      getTradesmenList();
                    } catch (e) {
                      throw Exception(e);
                    }
                  },
                  child: Card(
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5.r)),
                    color: Color(acceptedOptionColor),
                    child: Padding(
                      padding: EdgeInsets.all(4.0.r),
                      child: Row(
                        children: [
                          SvgPicture.asset(
                            applicationStatus == "approved"
                                ? "lib/assets/icons/ticklogoblue.svg"
                                : "lib/assets/icons/ticklogoblack.svg",
                            height: 14.h,
                            width: 14.w,
                            fit: BoxFit.contain,
                          ),
                          SizedBox(
                            width: 4.0.w,
                          ),
                          Text(Strings.accepted(context),
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  color: Color(acceptedOptionTextColor),
                                  fontSize: 12.sp,
                                  fontWeight: FontWeight.w400,
                                  fontFamily: 'Poppins')),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(left: 6.0.w),
                child: GestureDetector(
                  onTap: () {
                    try {
                      if (applicationStatus == "declined") {
                        return;
                      }
                      setState(() {
                        rejectedOptionColor = MyColors.colorRed200;
                        rejectedOptionTextColor = MyColors.themeRedColor;
                        acceptedOptionColor = MyColors.colorNeutral100;
                        acceptedOptionTextColor = MyColors.colorNeutral700;
                        allOptionColor = MyColors.colorNeutral100;
                        allOptionTextColor = MyColors.colorNeutral700;
                        applicationStatus = "declined";
                      });
                      getTradesmenList();
                    } catch (e) {
                      throw Exception(e);
                    }
                  },
                  child: Card(
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5.r)),
                    color: Color(rejectedOptionColor),
                    child: Padding(
                      padding: EdgeInsets.all(4.0.r),
                      child: Row(
                        children: [
                          SvgPicture.asset(
                            applicationStatus == "declined"
                                ? "lib/assets/icons/crossLogoRed.svg"
                                : "lib/assets/icons/crossLogoBlack.svg",
                            height: 14.h,
                            width: 14.w,
                            fit: BoxFit.contain,
                          ),
                          SizedBox(
                            width: 4.0.w,
                          ),
                          Text(Strings.rejected(context),
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  color: Color(rejectedOptionTextColor),
                                  fontSize: 12.sp,
                                  fontWeight: FontWeight.w400,
                                  fontFamily: 'Poppins')),
                        ],
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
        isLoading
            ? Center(
                child: Padding(
                  padding: EdgeInsets.only(top: 32.0.h),
                  child: const CircularProgressIndicator(
                      color: Color(MyColors.themeRedColor)),
                ),
              )
            : requestedTradesmen!.tradesmenRequestList != null
                ? requestedTradesmen!.tradesmenRequestList!.isNotEmpty
                    ? ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount:
                            requestedTradesmen!.tradesmenRequestList!.length,
                        itemBuilder: (context, index) {
                          return _buildTradesmenView(
                              requestedTradesmen!.tradesmenRequestList![index]);
                        },
                      )
                    : SizedBox(
                        height: MediaQuery.of(context).size.height.h / 1.5,
                        child: Center(
                          child: Headingdescription(
                              text: Strings.noTradesmen(context),
                              centerAlign: false,
                              size: 16.0.sp),
                        ),
                      )
                : const SizedBox(),
      ],
    );
  }

  Widget _buildTradesmenView(TradesmenRequest tradesmen) {
    return Padding(
        padding: EdgeInsets.only(left: 8.0.w, right: 8.0.w, top: 5.0.h),
        child: GestureDetector(
          onTap: () {
            try {
              Get.toNamed(AppLinks.tradesmen_detail_screen,
                  arguments: {'tradesmenId': tradesmen.userId ?? "-1"});
            } catch (e) {
              throw Exception(e);
            }
          },
          child: Card(
            elevation: 0,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            color: const Color(MyColors.colorNeutral100),
            child: Column(children: [
              Padding(
                padding: EdgeInsets.only(top: 12.0.h),
                child: Row(
                  children: [
                    Padding(
                      padding: EdgeInsets.only(left: 10.0.w),
                      child: tradesmen.userProfileImg != null
                          ? CircleAvatar(
                              radius: 24.r,
                              backgroundImage: NetworkImage(tradesmen
                                  .userProfileImg
                                  .toString()), // Replace with actual image
                            )
                          : SvgPicture.asset(
                              "lib/assets/images/tradesmenplaceholdericon.svg"),
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
                                        tradesmen.userName ?? "N/A",
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
                                              tradesmen.serviceArea != null
                                                  ? TextSpan(
                                                      text:
                                                          "${tradesmen.serviceArea!.radius ?? "N/A"} KM",
                                                      style: const TextStyle(
                                                        color: Colors.red,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                    )
                                                  : const TextSpan(
                                                      text: "N/A KM",
                                                      style: TextStyle(
                                                        color: Colors.red,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                    ),
                                              const TextSpan(
                                                text: ", ",
                                              ),
                                              tradesmen.serviceArea != null
                                                  ? TextSpan(
                                                      text: tradesmen
                                                              .serviceArea!
                                                              .city ??
                                                          "N/A",
                                                    )
                                                  : const TextSpan(
                                                      text: "N/A",
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
                          Row(
                            children: [
                              Expanded(
                                flex: 5,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Flexible(
                                      child: Text(
                                        "${tradesmen.reviewsCount ?? 0} ${Strings.reviews(Get.context!)}",
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
                                      size: 16.sp,
                                      color:
                                          const Color(MyColors.themeRedColor),
                                    ),
                                    SizedBox(
                                      width: 2.0.w,
                                    ),
                                    Flexible(
                                      child: Padding(
                                        padding: EdgeInsets.only(right: 10.0.w),
                                        child: Text(
                                          "${tradesmen.rating!.length > 3 ? tradesmen.rating!.substring(0, 3) : tradesmen.rating! ?? "0"}/5",
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
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 12.h),
              Align(
                  alignment: Alignment.topLeft,
                  child: Padding(
                    padding: EdgeInsets.only(top: 4.0.h, left: 12.0.w),
                    child: Headingdescription(
                        text:
                            "${Strings.appliedText(Get.context!)} : ${tradesmen.humanReadableCreatedAt ?? "N/A"}",
                        centerAlign: false,
                        size: 12.sp),
                  )),
              Padding(
                padding: EdgeInsets.only(left: 8.0.w, right: 8.0.w, top: 4.0.h),
                child: Align(
                  alignment: Alignment.topLeft,
                  child: Card(
                    color: const Color(MyColors.whiteColor),
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(9.r)),
                    child: Padding(
                        padding: EdgeInsets.all(4.0.r),
                        child: ExpandableText(tradesmen.coverLetter ?? "N/A",
                            expandText: Strings.showMore(context),
                            collapseText: Strings.showLess(context),
                            maxLines: 2,
                            linkStyle: TextStyle(
                                color: Colors.grey,
                                fontFamily: 'Poppins',
                                fontSize: 12.0.sp),
                            style: TextStyle(
                                color: Colors.black,
                                fontFamily: 'Poppins',
                                fontSize: 14.0.sp))),
                  ),
                ),
              ),
              // Send Request Button
              Obx(() {
                return tradesmen.loadingValue.value.isEmpty
                    ? tradesmen.status == "pending"
                        ? Padding(
                            padding: EdgeInsets.all(8.0.r),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Expanded(
                                  child: Padding(
                                    padding: EdgeInsets.only(
                                        left: 5.0.w, right: 5.0.w),
                                    child: FullWidthElevatedButton(
                                        onPressed: () async {
                                          tradesmen.loadingValue.value = "0";
                                          int chatId = await controller
                                              .pleaseUpdateRequestsStatus(
                                                  widget.jobId,
                                                  tradesmen.id!,
                                                  "approved",
                                                  context);
                                          if (!mounted) return;
                                          if (chatId != -1) {
                                            Fluttertoast.showToast(
                                                msg: Strings
                                                    .therequesthasbeenapproved(
                                                        context));
                                            tradesmen.status = "approved";
                                            tradesmen.loadingValue.value = "";
                                            print(chatId);
                                            tradesmen.chatId = chatId;
                                          } else {
                                            Fluttertoast.showToast(
                                                msg: Strings.somethingWentWrong(
                                                    context));
                                            tradesmen.loadingValue.value = "";
                                          }
                                        },
                                        text: Strings.accept(context),
                                        color: MyColors.themeRedColor,
                                        textColor: MyColors.whiteColor),
                                  ),
                                ),
                                Expanded(
                                  child: Padding(
                                    padding: EdgeInsets.only(
                                        left: 5.0.w, right: 5.0.w),
                                    child: FullWidthElevatedButton(
                                        onPressed: () async {
                                          tradesmen.loadingValue.value = "0";
                                          int chatId = await controller
                                              .pleaseUpdateRequestsStatus(
                                                  widget.jobId,
                                                  tradesmen.id!,
                                                  "declined",
                                                  context);
                                          if (!mounted) return;
                                          if (chatId != -1) {
                                            Fluttertoast.showToast(
                                                msg: Strings
                                                    .therequesthasbeendeclined(
                                                        Get.context!));
                                            tradesmen.status = "declined";
                                            tradesmen.loadingValue.value = "";
                                          } else {
                                            Fluttertoast.showToast(
                                                msg: Strings.somethingWentWrong(
                                                    context));
                                            tradesmen.loadingValue.value = "";
                                          }
                                        },
                                        text: Strings.reject(context),
                                        color: MyColors.colorNeutral200,
                                        textColor: MyColors.blackColor),
                                  ),
                                )
                              ],
                            ),
                          )
                        : tradesmen.status == "declined" ||
                                tradesmen.status == "expired" ||
                                tradesmen.status == "rejected"
                            ? Padding(
                                padding: EdgeInsets.only(
                                    left: 13.0.w,
                                    right: 13.0.w,
                                    bottom: 8.0.h,
                                    top: 5.0.h),
                                child: FullWidthElevatedButton(
                                    onPressed: () {
                                      // Fluttertoast.showToast(msg: "Chat");
                                    },
                                    text: Strings.requestRejected(context),
                                    color: MyColors.lightGrayColor,
                                    textColor: MyColors.whiteColor),
                              )
                            : Padding(
                                padding: EdgeInsets.only(
                                    left: 13.0.w,
                                    right: 13.0.w,
                                    bottom: 8.0.h,
                                    top: 5.0.h),
                                child: FullWidthElevatedButton(
                                    onPressed: () async {
                                      var result = await Get.to(
                                        const ConversationScreen(),
                                        arguments: {
                                          'chat': null,
                                          'chatId': tradesmen.chatId,
                                          'fromWhere': 'OrderDetail'
                                        },
                                      );
                                      if (result != null) {
                                        // Update your UI
                                        if (result == "update") {}
                                      }
                                    },
                                    text: Strings.chatText(context),
                                    color: MyColors.themeRedColor,
                                    textColor: MyColors.whiteColor),
                              )
                    : Center(
                        child: Padding(
                          padding: EdgeInsets.all(4.0.r),
                          child: const CircularProgressIndicator(
                            color: Color(MyColors.themeRedColor),
                          ),
                        ),
                      );
              }),
            ]),
          ),
        ));
  }
}
