import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:workforceclientapp/Controllers/ReviewScreenController.dart';
import 'package:workforceclientapp/Others/Commons.dart';
import 'package:workforceclientapp/Others/MyColors.dart';
import 'package:workforceclientapp/Others/Strings.dart';
import 'package:workforceclientapp/views/screens/DashBoard/SelectServiceScreen.dart';
import 'package:workforceclientapp/views/widgets/FullWidthButtonPrimary.dart';
import 'package:workforceclientapp/views/widgets/FullWidthOutlineButton.dart';
import 'package:workforceclientapp/views/widgets/HeadingTextW600.dart';
import 'package:workforceclientapp/views/widgets/Headingdescription.dart';

class ReviewJobScreen extends GetView<ReviewScreenController> {
  const ReviewJobScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Stack(
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(Strings.orderCompleted(context),
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                    color: Color(MyColors.themeRedColor),
                                    fontSize: 20,
                                    fontWeight: FontWeight.w600,
                                    fontFamily: 'Poppins')),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: SvgPicture.asset(
                              "lib/assets/icons/orderdoneIcon.svg",
                              fit: BoxFit.contain,
                              height: 60,
                              width: 60,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Headingdescription(
                                text: Strings.orderCompletedDescText(context),
                                centerAlign: true,
                                size: 14),
                          ),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: SizedBox(
                          width: MediaQuery.of(context).size.width,
                          child: Card(
                            color: const Color(MyColors.whiteColor),
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(6),
                                side: const BorderSide(
                                    width: 1,
                                    color: Color(MyColors.lightGrayColor))),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                children: [
                                  HeadingTextW600(
                                      text:
                                          Strings.howwouldYourateTradesmenText(
                                              context),
                                      centerAlign: true,
                                      size: 16),
                                  const Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: Headingdescription(
                                        text:
                                            "How has your experience been with the tradesman?",
                                        centerAlign: true,
                                        size: 14),
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
                                    itemPadding: const EdgeInsets.symmetric(
                                        horizontal: 2.0),
                                    itemBuilder: (context, _) => const Icon(
                                      Icons.star,
                                      color: Color(MyColors.infoYellowColor),
                                    ),
                                    onRatingUpdate: (rating) {
                                      controller.ratingValue.value =
                                          rating.toInt();
                                    },
                                  ),
                                  const Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: Align(
                                      alignment: Alignment.topLeft,
                                      child: HeadingTextW600(
                                          text: "Can you tell us more?",
                                          centerAlign: false,
                                          size: 14),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(12.0),
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
                                              "Please Explain in your own words",
                                          hintStyle: const TextStyle(
                                              fontSize: 15,
                                              color: Color(MyColors.grayColor),
                                              fontWeight: FontWeight.w400),
                                          fillColor:
                                              const Color(MyColors.whiteColor),
                                          filled: true,
                                          focusedBorder: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(9.0),
                                              borderSide: const BorderSide(
                                                  color: Color(MyColors
                                                      .lightGrayColor))),
                                          border: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(9.0),
                                              borderSide: const BorderSide(
                                                  color: Color(MyColors
                                                      .lightGrayColor)))),
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
              ],
            ),
            Expanded(
              child: Align(
                alignment: Alignment.bottomCenter,
                child: Padding(
                  padding: const EdgeInsets.all(9.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Expanded(
                        child: Padding(
                          padding:
                              const EdgeInsets.only(left: 25.0, right: 12.0),
                          child: FullWidthOutlineButton(
                              text: Strings.cancelText(context),
                              fontsize: 15.0,
                              color: MyColors.themeRedColor,
                              onPressed: () {
                                // Get.back();
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
                      ),
                      Expanded(
                        child: Padding(
                          padding:
                              const EdgeInsets.only(left: 12.0, right: 25.0),
                          child: FullWidthButtonPrimary(
                              text: Strings.next(context),
                              fontsize: 15.0,
                              color: MyColors.themeRedColor,
                              onPressed: () async {
                                try {
                                  if (controller.review.value.isEmpty) {
                                    Fluttertoast.showToast(
                                        msg: "Review cannot be empty.");
                                    return;
                                  }
                                  if (controller.ratingValue.value == 0) {
                                    Fluttertoast.showToast(
                                        msg: "Please give some rating.");
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
                                    Get.to(
                                      const SelectServiceScreen(),
                                      transition: Transition
                                          .rightToLeft, // Left-to-right animation
                                      duration: const Duration(
                                          milliseconds:
                                              500), // Optional: animation duration
                                    );
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
            )
          ],
        ),
      ),
    );
  }
}
