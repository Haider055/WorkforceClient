import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
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
    return WillPopScope(
      onWillPop: () async {
        if (controller.fromWhere.value == "JobPostCompleted") {
          Get.offAllNamed(
            AppLinks.select_service_screen,
            arguments: {},
          ); // Optional: animation duration
        } else if (controller.fromWhere.value == "MyOrders") {
          Get.back(result: controller.remainingRequestsCount.value);
        }
        return false;
      },
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
                    text: Strings.recommendations(Get.context!),
                    centerAlign: false,
                    size: 19.0,
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
                      padding: const EdgeInsets.only(right: 10.0),
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
          return Column(
            children: [
              Column(
                children: [
                  Align(
                    alignment: Alignment.topLeft,
                    child: Padding(
                      padding: const EdgeInsets.only(
                          left: 20.0, top: 12.0, right: 20),
                      child: HeadingTextW600(
                          text: Strings.recommendationScreenHeading(context),
                          centerAlign: false,
                          size: 18),
                    ),
                  ),
                  Align(
                    alignment: Alignment.topLeft,
                    child: Padding(
                      padding: const EdgeInsets.only(
                          left: 20.0, top: 10.0, right: 20),
                      child: Headingdescription(
                          text: Strings.recommendationScreenDesc(context),
                          centerAlign: false,
                          size: 14),
                    ),
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.only(left: 20, top: 22.0, right: 20),
                    child: Align(
                      alignment: Alignment.topLeft,
                      child: HeadingTextW600(
                          text: Strings.recommendedCraftsmen(context),
                          centerAlign: false,
                          size: 18.0),
                    ),
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.only(left: 20, top: 8.0, bottom: 12.0),
                    child: Align(
                        alignment: Alignment.topLeft,
                        child: Text(Strings.requestUpTo10Tradesmen(context),
                            style: const TextStyle(
                                fontSize: 14.0,
                                fontFamily: 'Poppins',
                                color: Color(MyColors.midGrayColor)))),
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
                        itemCount: controller.tradesmenList.length,
                        itemBuilder: (context, index) {
                          return _buildSuggestedCraftmenOptions(
                              controller.tradesmenList[index]);
                        },
                      ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(bottom: 12.0, top: 6.0),
                      child: GestureDetector(
                        onTap: () {},
                        child: RichText(
                          text: TextSpan(
                            style: const TextStyle(
                                color: Colors.black, fontSize: 16),
                            children: [
                              WidgetSpan(
                                child: Image.asset(
                                  "lib/assets/icons/yellowinfo.png",
                                  height: 18,
                                  width: 18,
                                  fit: BoxFit.contain,
                                ),
                              ),
                              TextSpan(
                                  text:
                                      ' Select ${controller.remainingRequestsCount.value}',
                                  style: const TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500)),
                              const TextSpan(
                                  text: ' more craftsmen',
                                  style: TextStyle(
                                      fontSize: 14,
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
                                  padding: const EdgeInsets.only(
                                      left: 20.0, right: 10.0),
                                  child: FullWidthOutlineButton(
                                      text: Strings.cancelText(context),
                                      fontsize: 16.0,
                                      color: MyColors.themeRedColor,
                                      onPressed: () {
                                        if (controller.fromWhere.value ==
                                            "JobPostCompleted") {
                                          Get.offAllNamed(
                                              AppLinks.select_service_screen);
                                        } else if (controller.fromWhere.value ==
                                            "MyOrders") {
                                          Get.back();
                                        }
                                      }),
                                ),
                              ),
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                      left: 10.0, right: 20.0),
                                  child: FullWidthButtonPrimary(
                                      text: Strings.orderDetail(context),
                                      fontsize: 16.0,
                                      color: MyColors.themeRedColor,
                                      onPressed: () {
                                        Get.offAllNamed(
                                          AppLinks.posted_orders_section,
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
          height: 26,
          width: 26,
          fit: BoxFit.contain,
        ),
        const SizedBox(height: 4),
        Text(
          label,
          textAlign: TextAlign.center,
          style: TextStyle(
              fontFamily: 'Poppins',
              fontSize: 11.5,
              color: color,
              fontWeight: FontWeight.w400),
        ),
      ],
    );
  }

  Widget _buildSuggestedCraftmenOptions(Tradesmen tradesmen) {
    return Obx(() {
      return Padding(
        padding: const EdgeInsets.only(left: 17.0, right: 17.0, top: 5.0),
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
                  color:
                      const Color(MyColors.cardGrayColor300).withOpacity(0.4),
                  width: 1.0),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    tradesmen.tradesmenProfile != null
                        ? tradesmen.tradesmenProfile!.companyType != null
                            ? tradesmen.tradesmenProfile!.companyType ==
                                    "Company"
                                ? Align(
                                    alignment: Alignment.topLeft,
                                    child: Padding(
                                      padding:
                                          const EdgeInsets.only(left: 12.0),
                                      child: Card(
                                        color: const Color(
                                            MyColors.infoYellowColor),
                                        shape: const RoundedRectangleBorder(
                                          borderRadius: BorderRadius.only(
                                              bottomLeft: Radius.circular(9),
                                              bottomRight: Radius.circular(9)),
                                        ),
                                        elevation: 0,
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 7.0, vertical: 2.5),
                                          child: Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              SvgPicture.asset(
                                                "lib/assets/icons/AgencyIconsvg.svg",
                                                fit: BoxFit.contain,
                                                height: 13,
                                                width: 13,
                                              ),
                                              const SizedBox(width: 4),
                                              Headingdescription(
                                                text: Strings.agency(
                                                    Get.context!),
                                                centerAlign: false,
                                                size: 10.0,
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
                    const Padding(
                      padding: EdgeInsets.only(top: 8.0, right: 8.0),
                      child: Icon(
                        Icons.arrow_forward_ios,
                        color: Color(MyColors.blackColor80),
                        size: 16,
                      ),
                    )
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 6.0),
                  child: Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 10.0),
                        child: tradesmen.profileImg != null
                            ? CircleAvatar(
                                radius: 24,
                                backgroundImage: NetworkImage(tradesmen
                                    .profileImg
                                    .toString()), // Replace with actual image
                              )
                            : Image.asset(
                                "lib/assets/icons/placeholder_tradesmen.png"),
                      ),
                      const SizedBox(width: 8.0),
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
                                          style: const TextStyle(
                                              fontWeight: FontWeight.w600,
                                              color: Colors.black,
                                              fontSize: 14.0),
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
                                          padding: const EdgeInsets.only(
                                              right: 10.0),
                                          child: RichText(
                                            maxLines: 1,
                                            softWrap: false,
                                            overflow: TextOverflow.ellipsis,
                                            text: TextSpan(
                                              style: const TextStyle(
                                                color: Colors.black,
                                                fontSize: 13,
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
                              padding: const EdgeInsets.only(top: 2.0),
                              child: Row(
                                children: [
                                  Expanded(
                                    flex: 5,
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        Flexible(
                                          child: Text(
                                            "${tradesmen.reviewsCount ?? "0"} reviews",
                                            style: const TextStyle(
                                                color: Color(
                                                    MyColors.midGrayColor),
                                                fontSize: 14.0),
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
                                        const Icon(
                                          Icons.star,
                                          size: 16,
                                          color: Color(MyColors.themeRedColor),
                                        ),
                                        const SizedBox(
                                          width: 2.0,
                                        ),
                                        Flexible(
                                          child: Padding(
                                            padding: const EdgeInsets.only(
                                                right: 10.0),
                                            child: Text(
                                              "${tradesmen.rating!.length > 3 ? tradesmen.rating!.substring(0, 3) : tradesmen.rating! ?? "0"}/5",
                                              style: const TextStyle(
                                                  fontSize: 13,
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
                const SizedBox(height: 12),
                // Send Request Button
                Padding(
                  padding: const EdgeInsets.only(
                      left: 8.0, right: 8.0, bottom: 10.0),
                  child: SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        elevation: 0,
                        backgroundColor: tradesmen.status.value == "sent"
                            ? const Color(MyColors.infoPinkColor)
                            : const Color(MyColors.themeRedColor),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 4),
                      ),
                      onPressed: () async {
                        try {
                          if (tradesmen.status.value == "not sent") {
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
                              ? const Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: SizedBox(
                                    height: 14,
                                    width: 14,
                                    child: CircularProgressIndicator(
                                      color: Color(MyColors.whiteColor),
                                    ),
                                  ),
                                )
                              : Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      tradesmen.status.value == "sent"
                                          ? "Request has sent"
                                          : Strings.sendRequest(Get.context!),
                                      style: TextStyle(
                                          color:
                                              tradesmen.status.value == "sent"
                                                  ? const Color(
                                                      MyColors.themeRedColor)
                                                  : Colors.white,
                                          fontFamily: 'Poppins',
                                          fontSize: 13),
                                    ),
                                  ],
                                ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    });
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
