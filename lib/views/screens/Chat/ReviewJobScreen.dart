import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:workforceclientapp/Controllers/ReviewScreenController.dart';
import 'package:workforceclientapp/Others/Commons.dart';
import 'package:workforceclientapp/Others/MyColors.dart';
import 'package:workforceclientapp/Others/Strings.dart';
import 'package:workforceclientapp/Others/routes.dart';
import 'package:workforceclientapp/views/widgets/FullWidthButtonPrimary.dart';
import 'package:workforceclientapp/views/widgets/FullWidthOutlineButton.dart';
import 'package:workforceclientapp/views/widgets/HeadingTextW600.dart';
import 'package:workforceclientapp/views/widgets/Headingdescription.dart';

class ReviewJobScreen extends GetView<ReviewScreenController> {
  const ReviewJobScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(Get.context!).unfocus();
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Column(
                        children: [
                          SizedBox(
                            height: 32.h,
                          ),
                          Padding(
                            padding: EdgeInsets.all(8.0.r),
                            child: SvgPicture.asset(
                              "lib/assets/icons/orderdoneIcon.svg",
                              fit: BoxFit.contain,
                              height: 60.h,
                              width: 60.w,
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.all(8.0.r),
                            child: Text(Strings.orderCompleted(context),
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    color: const Color(MyColors.themeRedColor),
                                    fontSize: 20.sp,
                                    fontWeight: FontWeight.w600,
                                    fontFamily: 'Poppins')),
                          ),
                        ],
                      ),
                      Padding(
                        padding: EdgeInsets.all(12.0.r),
                        child: SizedBox(
                          width: MediaQuery.of(context).size.width.w,
                          child: Card(
                            color: const Color(MyColors.whiteColor),
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(6.0.r),
                                side: BorderSide(
                                    width: 1.w,
                                    color:
                                        const Color(MyColors.lightGrayColor))),
                            child: Padding(
                              padding: EdgeInsets.all(8.0.r),
                              child: Column(
                                children: [
                                  HeadingTextW600(
                                      text:
                                          Strings.howwouldYourateTradesmenText(
                                              context),
                                      centerAlign: true,
                                      size: 16.sp),
                                  Padding(
                                    padding: EdgeInsets.all(8.0.r),
                                    child: Headingdescription(
                                        text: Strings
                                            .howyourExperiencewithtradesman(
                                                context),
                                        centerAlign: true,
                                        size: 14.sp),
                                  ),
                                  RatingBar.builder(
                                    initialRating: 0.0,
                                    minRating: 1,
                                    direction: Axis.horizontal,
                                    allowHalfRating: false,
                                    itemCount: 5,
                                    glowColor: Colors.amber,
                                    itemSize:
                                        MediaQuery.of(context).size.width / 8,
                                    itemPadding:
                                        EdgeInsets.symmetric(horizontal: 2.0.r),
                                    itemBuilder: (context, _) => const Icon(
                                      Icons.star,
                                      color: Color(MyColors.infoYellowColor),
                                    ),
                                    onRatingUpdate: (rating) {
                                      controller.ratingValue.value =
                                          rating.toInt();
                                    },
                                  ),
                                  Padding(
                                    padding: EdgeInsets.all(8.0.r),
                                    child: Align(
                                      alignment: Alignment.topLeft,
                                      child: HeadingTextW600(
                                          text: Strings.canYoutellusMore(
                                              Get.context!),
                                          centerAlign: false,
                                          size: 14.sp),
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.all(12.0.r),
                                    child: TextField(
                                      maxLines: 6,
                                      onChanged: (value) {
                                        controller.review.value = value;
                                        // Constants.jobDescription = value;
                                      },
                                      cursorColor:
                                          const Color(MyColors.themeRedColor),
                                      decoration: InputDecoration(
                                          hintText:
                                              Strings.pleaseExplaininyourownWords(
                                                  context),
                                          hintStyle: TextStyle(
                                              fontSize: 15.sp,
                                              color: const Color(
                                                  MyColors.midGrayColor),
                                              fontWeight: FontWeight.w400),
                                          fillColor:
                                              const Color(MyColors.whiteColor),
                                          filled: true,
                                          focusedBorder: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(9.0.r),
                                              borderSide: const BorderSide(
                                                  color: Color(MyColors
                                                      .lightGrayColor))),
                                          border: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(9.0.r),
                                              borderSide: const BorderSide(
                                                  color:
                                                      Color(MyColors.lightGrayColor)))),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: Padding(
                  padding: EdgeInsets.all(9.0.r),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Expanded(
                        child: Padding(
                          padding: EdgeInsets.only(left: 25.0.r, right: 12.0.r),
                          child: FullWidthOutlineButton(
                              text: Strings.cancelText(context),
                              fontsize: 15.0.sp,
                              color: MyColors.themeRedColor,
                              onPressed: () {
                                // Get.back();
                                Get.offAllNamed(AppLinks.select_service_screen);
                              }),
                        ),
                      ),
                      Expanded(
                        child: Padding(
                          padding: EdgeInsets.only(left: 12.0.w, right: 25.0.w),
                          child: FullWidthButtonPrimary(
                              text: Strings.next(context),
                              fontsize: 15.0.sp,
                              color: MyColors.themeRedColor,
                              onPressed: () async {
                                try {
                                  if (controller.review.value.isEmpty) {
                                    Fluttertoast.showToast(
                                        msg: Strings.reviewCannotbeemptyText(
                                            Get.context!));
                                    return;
                                  }
                                  if (controller.ratingValue.value == 0) {
                                    Fluttertoast.showToast(
                                        msg: Strings.pleaseGiveSomeRatingText(
                                            Get.context!));
                                    return;
                                  }
                                  Commons.showProgressDialog(context);
                                  bool res =
                                      await controller.pleaseSubmitReview(
                                          context,
                                          controller.review.value,
                                          controller.ratingValue.value,
                                          controller.jobPostingId.value,
                                          controller.tradesmenId.value);
                                  Commons.hideProgressDialog();
                                  if (res) {
                                    Get.offAllNamed(
                                        AppLinks.select_service_screen);
                                  }
                                } catch (e) {
                                  throw Exception(e);
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
      ),
    );
  }
}
