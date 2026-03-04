import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:photo_viewer/photo_viewer.dart';
import 'package:workforceclientapp/Controllers/TradesmenDetailController.dart';
import 'package:workforceclientapp/Models/Portfolio.dart';
import 'package:workforceclientapp/Models/Reviews.dart';
import 'package:workforceclientapp/Others/MyColors.dart';
import 'package:workforceclientapp/Others/Strings.dart';
import 'package:workforceclientapp/views/widgets/HeadingTextW500.dart';
import 'package:workforceclientapp/views/widgets/HeadingTextW600.dart';
import 'package:workforceclientapp/views/widgets/Headingdescription.dart';

class TradesmenDetailScreen extends GetView<TradesmenDetailController> {
  const TradesmenDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
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
              child: Stack(
                children: [
                  Center(
                      child: HeadingTextW600(
                    text: Strings.overview(context),
                    centerAlign: false,
                    size: 19.0,
                  )),
                  GestureDetector(
                    onTap: () {
                      Get.back();
                    },
                    child: const Padding(
                      padding: EdgeInsets.only(left: 10.0),
                      child: Align(
                          alignment: Alignment.centerLeft,
                          child: Icon(Icons.arrow_back_ios)),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
        body: Obx(() {
          return !controller.loading.value
              ? SingleChildScrollView(
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(11.0),
                        child: Card(
                          shape: RoundedRectangleBorder(
                              side: const BorderSide(
                                  color: Color(MyColors.cardGrayColor200)),
                              borderRadius: BorderRadius.circular(12)),
                          elevation: 0,
                          color: const Color(MyColors.cardGrayColor100),
                          child: Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Placeholder for the image
                                Expanded(
                                  flex: 2,
                                  child:
                                      controller.tradesmen!.profileImg != null
                                          ? Card(
                                              elevation: 0,
                                              shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(9)),
                                              child: ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(9),
                                                child: PhotoViewerImage(
                                                  imageUrl: controller
                                                      .tradesmen!.profileImg!
                                                      .toString(),
                                                  errorWidget: (p0, p1, p2) {
                                                    return Center(
                                                        child: SvgPicture.asset(
                                                      "lib/assets/images/tradesmenplaceholdericon.svg",
                                                      fit: BoxFit.fill,
                                                      height: 20,
                                                      width: 20,
                                                    ));
                                                  },
                                                ),
                                              ),
                                            )
                                          : SizedBox(
                                              height: MediaQuery.of(context)
                                                      .size
                                                      .height /
                                                  8,
                                              child: Image.asset(
                                                "lib/assets/images/tradesmenplaceholdericon.svg",
                                                fit: BoxFit.fill,
                                              ),
                                            ),
                                ),
                                const SizedBox(width: 12),
                                // Tradesman details
                                Expanded(
                                  flex: 6,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text.rich(TextSpan(
                                        text:
                                            controller.tradesmen!.name ?? "N/A",
                                        style: const TextStyle(
                                            fontSize: 16,
                                            color: Colors.black,
                                            fontWeight: FontWeight.w600),
                                        children: [
                                          WidgetSpan(
                                            alignment:
                                                PlaceholderAlignment.middle,
                                            child: Padding(
                                              padding: const EdgeInsets.only(
                                                  left:
                                                      4), // space between text and icon
                                              child: controller.tradesmen!
                                                          .tradesmenProfile !=
                                                      null
                                                  ? controller
                                                              .tradesmen!
                                                              .tradesmenProfile!
                                                              .isVerified !=
                                                          null
                                                      ? controller
                                                              .tradesmen!
                                                              .tradesmenProfile!
                                                              .isVerified!
                                                          ? SvgPicture.asset(
                                                              "lib/assets/icons/verifiedIcon.svg",
                                                              height: 14.0,
                                                              width: 14.0)
                                                          : const SizedBox()
                                                      : const SizedBox()
                                                  : const SizedBox(),
                                            ),
                                          ),
                                        ],
                                      )),
                                      const SizedBox(height: 6),
                                      Row(
                                        children: [
                                          SvgPicture.asset(
                                              "lib/assets/icons/thumbIcon.svg",
                                              height: 16,
                                              width: 16),
                                          const SizedBox(width: 6),
                                          const Text.rich(
                                            TextSpan(
                                              text: "Recommend ",
                                              style: TextStyle(fontSize: 14),
                                              children: [
                                                TextSpan(
                                                  text: "1488 ",
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.w500,
                                                    color: Colors.black,
                                                  ),
                                                ),
                                                TextSpan(
                                                  text: "Times",
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.w500,
                                                    color: Colors.black,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 6),
                                      Row(
                                        children: [
                                          SvgPicture.asset(
                                              "lib/assets/icons/starIcon.svg",
                                              height: 16,
                                              width: 16),
                                          const SizedBox(width: 6),
                                          Text.rich(
                                            TextSpan(
                                              text:
                                                  "${controller.tradesmen!.rating!.length > 3 ? controller.tradesmen!.rating!.substring(0, 3) : controller.tradesmen!.rating! ?? "0"}/5",
                                              style: const TextStyle(
                                                fontWeight: FontWeight.w500,
                                                fontSize: 14,
                                              ),
                                              children: [
                                                TextSpan(
                                                  text:
                                                      " (${controller.tradesmen!.reviewsCount ?? 0} reviews)",
                                                  style: const TextStyle(
                                                      color: Colors.grey,
                                                      fontSize: 14),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 6),
                                      Row(
                                        children: [
                                          SvgPicture.asset(
                                              "lib/assets/icons/locationIcon.svg",
                                              height: 16,
                                              width: 16),
                                          const SizedBox(width: 6),
                                          Expanded(
                                            child: Text.rich(
                                              overflow: TextOverflow.ellipsis,
                                              softWrap: true,
                                              maxLines: 2,
                                              TextSpan(
                                                text: "Active within ",
                                                style: const TextStyle(
                                                    fontSize: 14,
                                                    color: Colors.black),
                                                children: [
                                                  controller.tradesmen!
                                                              .serviceArea !=
                                                          null
                                                      ? TextSpan(
                                                          text:
                                                              "${controller.tradesmen?.serviceArea?.radius ?? 'N/A'} KM of ${controller.tradesmen?.serviceArea?.city ?? 'N/A'}",
                                                          style: const TextStyle(
                                                              color:
                                                                  Colors.black,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500),
                                                        )
                                                      : const TextSpan(
                                                          text: "N/A",
                                                          style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500),
                                                        ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 6),
                                      Row(
                                        children: [
                                          SvgPicture.asset(
                                              "lib/assets/icons/member_since_icon.svg",
                                              height: 16,
                                              width: 16),
                                          const SizedBox(width: 6),
                                          Expanded(
                                            child: Text.rich(
                                              overflow: TextOverflow.ellipsis,
                                              softWrap: true,
                                              maxLines: 1,
                                              TextSpan(
                                                text: Strings.memberSince(
                                                    context),
                                                style: const TextStyle(
                                                    fontSize: 14),
                                                children: [
                                                  controller.tradesmen!
                                                              .memberSince !=
                                                          null
                                                      ? TextSpan(
                                                          text:
                                                              " ${controller.tradesmen?.memberSince ?? 'N/A'}",
                                                          style: const TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500),
                                                        )
                                                      : const TextSpan(
                                                          text: " N/A",
                                                          style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500),
                                                        ),
                                                ],
                                              ),
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
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 11.0, right: 11.0),
                        child: Row(
                          children: [
                            Expanded(
                              child: Card(
                                shape: RoundedRectangleBorder(
                                    side: const BorderSide(
                                        color:
                                            Color(MyColors.cardGrayColor200)),
                                    borderRadius: BorderRadius.circular(12)),
                                elevation: 0,
                                color: const Color(MyColors.cardGrayColor100),
                                child: Padding(
                                    padding: const EdgeInsets.all(9.0),
                                    child: Column(
                                      children: [
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(top: 2.0),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Stack(
                                                children: [
                                                  Container(
                                                    width: 25,
                                                    height: 25,
                                                    decoration: BoxDecoration(
                                                      color: Colors
                                                          .white, // White background
                                                      shape: BoxShape
                                                          .circle, // Circular shape
                                                      boxShadow: [
                                                        BoxShadow(
                                                          color: Colors.grey
                                                              .withOpacity(
                                                                  0.3), // Soft shadow
                                                          blurRadius: 1,
                                                          spreadRadius: 1,
                                                          offset: const Offset(
                                                              0, 1),
                                                        ),
                                                      ],
                                                    ),
                                                    child: Center(
                                                      child: SvgPicture.asset(
                                                          "lib/assets/icons/workerIcon.svg",
                                                          height: 16,
                                                          width: 16),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              const SizedBox(
                                                width: 5,
                                              ),
                                              HeadingTextW500(
                                                  text:
                                                      Strings.services(context),
                                                  centerAlign: false,
                                                  size: 17),
                                            ],
                                          ),
                                        ),
                                        const SizedBox(
                                          height: 12,
                                        ),
                                        ListView.builder(
                                          shrinkWrap: true,
                                          physics:
                                              const NeverScrollableScrollPhysics(),
                                          itemCount:
                                              controller.professionsList.length,
                                          itemBuilder: (context, index) {
                                            return Padding(
                                              padding:
                                                  const EdgeInsets.all(2.5),
                                              child: Align(
                                                alignment: Alignment.topLeft,
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  children: [
                                                    controller.professionsList
                                                                .elementAt(
                                                                    index)
                                                                .icon !=
                                                            null
                                                        ? controller.professionsList
                                                                    .elementAt(
                                                                        index)
                                                                    .icon!
                                                                    .url !=
                                                                null
                                                            ? Image.network(
                                                                controller
                                                                    .professionsList
                                                                    .elementAt(
                                                                        index)
                                                                    .icon!
                                                                    .url!,
                                                                height: 16,
                                                                width: 16,
                                                                fit:
                                                                    BoxFit.fill)
                                                            : const SizedBox()
                                                        : const SizedBox(),
                                                    const SizedBox(
                                                      width: 6,
                                                    ),
                                                    Headingdescription(
                                                        text: controller
                                                                .professionsList
                                                                .elementAt(
                                                                    index)
                                                                .name ??
                                                            "N/A",
                                                        centerAlign: false,
                                                        size: 16),
                                                  ],
                                                ),
                                              ),
                                            );
                                          },
                                        )
                                      ],
                                    )),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(11.0),
                        child: Card(
                          shape: RoundedRectangleBorder(
                              side: const BorderSide(
                                  color: Color(MyColors.cardGrayColor200)),
                              borderRadius: BorderRadius.circular(12)),
                          elevation: 0,
                          color: const Color(MyColors.cardGrayColor100),
                          child: Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: Column(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Align(
                                      alignment: Alignment.topLeft,
                                      child: Row(
                                        children: [
                                          SvgPicture.asset(
                                              "lib/assets/icons/informationLogo.svg",
                                              height: 18,
                                              width: 18),
                                          const SizedBox(
                                            width: 4,
                                          ),
                                          HeadingTextW500(
                                              text: Strings.aboutThisCompany(
                                                  context),
                                              centerAlign: false,
                                              size: 16),
                                        ],
                                      ),
                                    ),
                                  ),
                                  Align(
                                    alignment: Alignment.topLeft,
                                    child: Padding(
                                      padding: const EdgeInsets.only(
                                          left: 8.0, right: 8.0, bottom: 8.0),
                                      child: controller.tradesmen!
                                                  .tradesmenProfile !=
                                              null
                                          ? Headingdescription(
                                              text: controller.tradesmen!
                                                      .tradesmenProfile!.bio ??
                                                  "No Information",
                                              centerAlign: false,
                                              size: 14)
                                          : const Headingdescription(
                                              text: "No Information",
                                              centerAlign: false,
                                              size: 14),
                                    ),
                                  )
                                ],
                              )),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 11.0, right: 11.0),
                        child: Card(
                          shape: RoundedRectangleBorder(
                              side: const BorderSide(
                                  color: Color(MyColors.cardGrayColor200)),
                              borderRadius: BorderRadius.circular(12)),
                          elevation: 0,
                          color: const Color(MyColors.cardGrayColor100),
                          child: Padding(
                              padding: const EdgeInsets.all(5.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: Padding(
                                      padding: const EdgeInsets.only(
                                          left: 8.0, right: 8.0),
                                      child: SizedBox(
                                        width:
                                            MediaQuery.of(context).size.width,
                                        child: ElevatedButton(
                                          onPressed: () {
                                            if (controller
                                                    .selectedOption.value !=
                                                "portfolio") {
                                              controller.selectedOption.value =
                                                  "portfolio";
                                              controller.portfolioBackColor
                                                      .value =
                                                  MyColors.themeRedColor;
                                              controller.reviewsBackColor
                                                  .value = MyColors.silverColor;
                                              controller
                                                      .reviewsTextColor.value =
                                                  MyColors.darkGrayColor;
                                              controller.portfolioTextColor
                                                  .value = MyColors.whiteColor;
                                              // getTradesmenPortfolios(
                                              //     tradesmenId);
                                            }
                                          },
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: Color(controller
                                                .portfolioBackColor.value),
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                            ),
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 2, horizontal: 2),
                                          ),
                                          child: Text(
                                              Strings.portfolio(context),
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                  color: Color(controller
                                                      .portfolioTextColor
                                                      .value),
                                                  fontSize: 14.5,
                                                  fontWeight: FontWeight.w500,
                                                  fontFamily: 'Poppins')),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: Padding(
                                      padding: const EdgeInsets.only(
                                          left: 8.0, right: 8.0),
                                      child: SizedBox(
                                        width:
                                            MediaQuery.of(context).size.width,
                                        child: ElevatedButton(
                                          onPressed: () {
                                            if (controller
                                                    .selectedOption.value !=
                                                "reviews") {
                                              controller.selectedOption.value =
                                                  "reviews";
                                              controller.portfolioBackColor
                                                  .value = MyColors.silverColor;
                                              controller
                                                      .reviewsBackColor.value =
                                                  MyColors.themeRedColor;
                                              controller.reviewsTextColor
                                                  .value = MyColors.whiteColor;
                                              controller.portfolioTextColor
                                                      .value =
                                                  MyColors.darkGrayColor;
                                            }
                                            if (controller.tradesmenReview ==
                                                null) {
                                              controller.loadingReviews.value =
                                                  true;
                                              controller.getTradesmenReviews(1);
                                            }
                                          },
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: Color(controller
                                                .reviewsBackColor.value),
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                            ),
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 2, horizontal: 2),
                                          ),
                                          child: Text(Strings.reviews(context),
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                  color: Color(controller
                                                      .reviewsTextColor.value),
                                                  fontSize: 14.5,
                                                  fontWeight: FontWeight.w500,
                                                  fontFamily: 'Poppins')),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              )),
                        ),
                      ),
                      controller.selectedOption.value == "portfolio"
                          ? controller.portfolioList == null
                              ? const Center(
                                  child: CircularProgressIndicator(
                                    color: Color(MyColors.themeRedColor),
                                  ),
                                )
                              : Column(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          top: 12.0, left: 22),
                                      child: Align(
                                        alignment: Alignment.topLeft,
                                        child: HeadingTextW600(
                                            text:
                                                "Portfolios (${controller.totalPortfolio.value})",
                                            centerAlign: false,
                                            size: 16),
                                      ),
                                    ),
                                    controller.portfolioList!.isNotEmpty
                                        ? ListView.builder(
                                            shrinkWrap: true,
                                            physics:
                                                const NeverScrollableScrollPhysics(),
                                            itemCount: controller
                                                .portfolioList!.length,
                                            itemBuilder: (context, index) {
                                              Portfolio portfolio = controller
                                                  .portfolioList![index];
                                              return _buildPortfolioView(
                                                  portfolio);
                                            },
                                          )
                                        : Center(
                                            child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Headingdescription(
                                                text: Strings.noPortfolioFound(
                                                    context),
                                                centerAlign: false,
                                                size: 14.0),
                                          )),
                                  ],
                                )
                          : Obx(() => controller.loadingReviews.value
                              ? const Center(
                                  child: Padding(
                                    padding: EdgeInsets.only(top: 16.0),
                                    child: CircularProgressIndicator(
                                      color: Color(MyColors.themeRedColor),
                                    ),
                                  ),
                                )
                              : Column(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          top: 12.0, left: 22),
                                      child: Align(
                                        alignment: Alignment.topLeft,
                                        child: HeadingTextW600(
                                            text:
                                                "Reviews (${controller.totalReviews.value})",
                                            centerAlign: false,
                                            size: 16),
                                      ),
                                    ),
                                    Obx(() => Column(
                                          children: [
                                            controller.reviewList!.isNotEmpty
                                                ? ListView.builder(
                                                    shrinkWrap: true,
                                                    physics:
                                                        const NeverScrollableScrollPhysics(),
                                                    itemCount: controller
                                                        .reviewList!.length,
                                                    itemBuilder:
                                                        (context, index) {
                                                      Reviews review =
                                                          controller
                                                                  .reviewList![
                                                              index];
                                                      return _buildReviewView(
                                                          review);
                                                    },
                                                  )
                                                : Center(
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              8.0),
                                                      child: Headingdescription(
                                                        text: Strings
                                                            .noReviewFound(
                                                                context),
                                                        centerAlign: false,
                                                        size: 14.0,
                                                      ),
                                                    ),
                                                  ),
                                            controller.totalReviews.value >
                                                    controller
                                                        .reviewList!.length
                                                ? _buildLoadMoreButton()
                                                : const SizedBox(),
                                          ],
                                        ))
                                  ],
                                ))
                    ],
                  ),
                )
              : const Center(
                  child: CircularProgressIndicator(
                    color: Color(MyColors.themeRedColor),
                  ),
                );
        }),
      ),
    );
  }

  Widget _buildPortfolioView(Portfolio portfolio) {
    return Padding(
      padding: const EdgeInsets.only(left: 11.0, right: 11.0, top: 7.0),
      child: Card(
        shape: RoundedRectangleBorder(
            side: const BorderSide(color: Color(MyColors.cardGrayColor200)),
            borderRadius: BorderRadius.circular(12)),
        elevation: 0,
        color: const Color(MyColors.cardGrayColor100),
        child: Padding(
            padding: const EdgeInsets.all(5.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding:
                      const EdgeInsets.only(left: 12.0, right: 12, top: 8.0),
                  child: HeadingTextW500(
                      text: portfolio.title ?? "N/A",
                      centerAlign: false,
                      size: 17),
                ),
                Padding(
                  padding:
                      const EdgeInsets.only(left: 12.0, right: 12.0, top: 4.0),
                  child: Headingdescription(
                      text: portfolio.desc ?? "N/A",
                      centerAlign: false,
                      size: 14),
                ),
                Padding(
                  padding:
                      const EdgeInsets.only(left: 12.0, top: 8.0, right: 8.0),
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children:
                          List.generate(portfolio.imageList!.length, (index) {
                        return SizedBox(
                          height: 80,
                          width: 70,
                          child: Card(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10)),
                            elevation: 1,
                            child: ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: PhotoViewerImage(
                                  imageUrl: portfolio.imageList![index],
                                  errorWidget: (p0, p1, p2) {
                                    return Center(
                                        child: SvgPicture.asset(
                                      "lib/assets/images/tradesmenplaceholdericon.svg",
                                      fit: BoxFit.fill,
                                      height: 20,
                                      width: 20,
                                    ));
                                  },
                                )),
                          ),
                        );
                      }),
                    ),
                  ),
                ),
              ],
            )),
      ),
    );
  }

  Widget _buildReviewView(Reviews review) {
    return Padding(
      padding: const EdgeInsets.only(left: 11.0, right: 11.0, top: 7),
      child: Card(
        shape: RoundedRectangleBorder(
            side: const BorderSide(color: Color(MyColors.cardGrayColor200)),
            borderRadius: BorderRadius.circular(12)),
        elevation: 0,
        color: const Color(MyColors.cardGrayColor100),
        child: Padding(
            padding: const EdgeInsets.all(5.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      Headingdescription(
                          text: review.userName ?? "N/A",
                          centerAlign: false,
                          size: 13),
                      const Headingdescription(
                          text: ", ", centerAlign: false, size: 14),
                      Headingdescription(
                          text: review.userCity! ?? "N/A",
                          centerAlign: false,
                          size: 13)
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 8.0, bottom: 4.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      review.rating != null
                          ? RatingBar.builder(
                              initialRating: review.rating!.toDouble(),
                              minRating: 1,
                              direction: Axis.horizontal,
                              allowHalfRating: true,
                              itemCount: 5,
                              itemSize: 20,
                              itemPadding:
                                  const EdgeInsets.symmetric(horizontal: 2.0),
                              itemBuilder: (context, _) => const Icon(
                                Icons.star,
                                color: Color(MyColors.themeRedColor),
                              ),
                              onRatingUpdate: (rating) {},
                            )
                          : const SizedBox(),
                      const SizedBox(
                        width: 4,
                      ),
                      Text(
                          "Reviewed on ${review.humanReadableCreatedAt ?? "N/A"}",
                          textAlign: TextAlign.start,
                          style: const TextStyle(
                              color: Colors.grey,
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              fontFamily: 'Poppins')),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 12.0, right: 8.0),
                  child: Text(review.title ?? "N/A",
                      textAlign: TextAlign.start,
                      style: const TextStyle(
                          color: Colors.black,
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          fontFamily: 'Poppins')),
                ),
                Padding(
                  padding:
                      const EdgeInsets.only(left: 8.0, right: 8.0, top: 3.0),
                  child: Card(
                    elevation: 0,
                    color: const Color(MyColors.infoPinkColor).withOpacity(0.5),
                    shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(8),
                            bottomRight: Radius.circular(8),
                            topRight: Radius.circular(8))),
                    child: Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: Text(review.comment ?? "N/A",
                          textAlign: TextAlign.start,
                          style: const TextStyle(
                              color: Colors.black,
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                              fontFamily: 'Poppins')),
                    ),
                  ),
                ),
              ],
            )),
      ),
    );
  }

  Widget _buildLoadMoreButton() {
    return Obx(() => controller.loadMore.value
        ? const Padding(
            padding: EdgeInsets.all(4.0),
            child: CircularProgressIndicator(
              color: Color(MyColors.themeRedColor),
            ),
          )
        : ElevatedButton(
            style: ButtonStyle(
              shape: WidgetStateProperty.all(
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
              fixedSize: WidgetStateProperty.all(
                Size.fromWidth(MediaQuery.of(Get.context!).size.width / 2.5),
              ),
              foregroundColor: WidgetStateProperty.all(
                const Color(MyColors.infoPinkColor2),
              ),
              elevation: WidgetStateProperty.all(0),
            ),
            onPressed: () {
              try {
                if (controller.tradesmenReview?.pagination != null &&
                    (controller.tradesmenReview!.pagination!.hasMore ??
                        false)) {
                  controller.loadMore.value = true;
                  int page =
                      controller.tradesmenReview!.pagination!.currentPage! + 1;
                  controller.getTradesmenReviews(page);
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
                  SizedBox(width: 5.0),
                  Icon(Icons.keyboard_arrow_down, size: 20),
                ],
              ),
            ),
          ));
  }
}
