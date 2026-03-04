import 'package:expandable_text/expandable_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:photo_viewer/photo_viewer.dart';
import 'package:workforceclientapp/Controllers/PostedOrderDetailsController.dart';
import 'package:workforceclientapp/Models/PostedJobAnswers.dart';
import 'package:workforceclientapp/Models/RequestedTradesmen.dart';
import 'package:workforceclientapp/Models/TradesmenRequest.dart';
import 'package:workforceclientapp/Others/MyColors.dart';
import 'package:workforceclientapp/Others/Strings.dart';
import 'package:workforceclientapp/Others/routes.dart';
import 'package:workforceclientapp/views/screens/Chat/ConversationScreen.dart';
import 'package:workforceclientapp/views/widgets/FullWidthElevatedButton.dart';
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
    return WillPopScope(
      onWillPop: () async {
        Get.back(result: "back");
        return true;
      },
      child: Obx(() {
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
                        text: Strings.orderDetail(context),
                        centerAlign: false,
                        size: 19.0,
                      )),
                      GestureDetector(
                        onTap: () {
                          Get.back();
                        },
                        child: const Padding(
                          padding: EdgeInsets.only(left: 12.0),
                          child: Align(
                              alignment: Alignment.centerLeft,
                              child: Icon(Icons.arrow_back_ios)),
                        ),
                      ),
                      controller.isLoading.value
                          ? const SizedBox()
                          : controller.postedJobDetail.status == "cancelled" ||
                                  controller.postedJobDetail.status ==
                                      "completed"
                              ? const SizedBox()
                              : Positioned(
                                  right: 0,
                                  child: PopupMenuButton<int>(
                                    color:
                                        const Color(MyColors.cardBlueColor50),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    onSelected: (value) {
                                      if (value == 0) {
                                        try {
                                          Get.offNamed(
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
                                              height: 18,
                                              width: 18,
                                            ),
                                            const SizedBox(width: 10),
                                            Text(Strings.removeJob(context),
                                                style: const TextStyle(
                                                    color: Color(MyColors
                                                        .themeRedColor))),
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
                : SingleChildScrollView(
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 28.0, top: 12),
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
                                      Text("Order Detail",
                                          textAlign: TextAlign.start,
                                          style: TextStyle(
                                              color: Color(controller
                                                  .orderDetailTabColor.value),
                                              fontSize: 15,
                                              fontWeight: FontWeight.w500,
                                              fontFamily: 'Poppins')),
                                      const SizedBox(
                                        height: 8,
                                      ),
                                      controller.selectedTabName.value ==
                                              "orderDetail"
                                          ? Container(
                                              width: 70, // Thin line
                                              height:
                                                  2, // Adjust height as needed
                                              color: Color(controller
                                                  .orderDetailTabColor
                                                  .value), // Red color
                                            )
                                          : const SizedBox(),
                                    ],
                                  ),
                                ),
                                const SizedBox(width: 25),
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
                                      Text("Tradesmen",
                                          textAlign: TextAlign.start,
                                          style: TextStyle(
                                              color: Color(controller
                                                  .tradesmenTabColor.value),
                                              fontSize: 15,
                                              fontWeight: FontWeight.w500,
                                              fontFamily: 'Poppins')),
                                      const SizedBox(
                                        height: 8,
                                      ),
                                      controller.selectedTabName.value ==
                                              "tradesmen"
                                          ? Container(
                                              width: 70, // Thin line
                                              height:
                                                  2, // Adjust height as needed
                                              color: Color(controller
                                                  .tradesmenTabColor
                                                  .value), // Red color
                                            )
                                          : const SizedBox(),
                                    ],
                                  ),
                                ),
                                const SizedBox(width: 25),
                                GestureDetector(
                                  onTap: () {
                                    controller.chatTabColor.value =
                                        MyColors.themeRedColor;
                                    controller.recommendedTabColor.value =
                                        MyColors.silverColor;
                                    controller.tradesmenTabColor.value =
                                        MyColors.silverColor;
                                    controller.orderDetailTabColor.value =
                                        MyColors.silverColor;
                                    controller.selectedTabName.value = "chat";
                                  },
                                  child: Column(
                                    children: [
                                      Row(
                                        children: [
                                          Text("Chat",
                                              textAlign: TextAlign.start,
                                              style: TextStyle(
                                                  color: Color(controller
                                                      .chatTabColor.value),
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.w500,
                                                  fontFamily: 'Poppins')),
                                          // Card(
                                          //   elevation: 0,
                                          //   color: Color(
                                          //       controller.chatTabColor.value),
                                          //   child: SizedBox(
                                          //     width: 8,
                                          //     height: 8,
                                          //   ),
                                          //   shape: RoundedRectangleBorder(
                                          //       borderRadius:
                                          //           BorderRadiusGeometry.all(
                                          //               Radius.circular(22.0))),
                                          // )
                                        ],
                                      ),
                                      const SizedBox(
                                        height: 8,
                                      ),
                                      controller.selectedTabName.value == "chat"
                                          ? Container(
                                              width: 50,
                                              height: 2,
                                              color: Color(controller
                                                  .chatTabColor.value),
                                            )
                                          : const SizedBox(),
                                    ],
                                  ),
                                ),
                                const SizedBox(width: 25),
                                GestureDetector(
                                  onTap: () {
                                    controller.chatTabColor.value =
                                        MyColors.silverColor;
                                    controller.recommendedTabColor.value =
                                        MyColors.themeRedColor;
                                    controller.tradesmenTabColor.value =
                                        MyColors.silverColor;
                                    controller.orderDetailTabColor.value =
                                        MyColors.silverColor;
                                    controller.selectedTabName.value =
                                        "recommended";
                                  },
                                  child: Column(
                                    children: [
                                      Text("Recommended",
                                          textAlign: TextAlign.start,
                                          style: TextStyle(
                                              color: Color(controller
                                                  .recommendedTabColor.value),
                                              fontSize: 15,
                                              fontWeight: FontWeight.w500,
                                              fontFamily: 'Poppins')),
                                      const SizedBox(
                                        height: 8,
                                      ),
                                      controller.selectedTabName.value ==
                                              "recommended"
                                          ? Container(
                                              width: 100, // Thin line
                                              height:
                                                  2, // Adjust height as needed
                                              color: Color(controller
                                                  .recommendedTabColor
                                                  .value), // Red color
                                            )
                                          : const SizedBox(),
                                    ],
                                  ),
                                ),
                                const SizedBox(width: 30),
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
                                : controller.selectedTabName.value == "chat"
                                    ? ChatSection(
                                        jobId: controller.jobId.value,
                                        jobStatus: controller.postedJobDetail
                                                .status!.value ??
                                            "",
                                      )
                                    : controller.selectedTabName.value ==
                                            "recommended"
                                        ? controller.recommendedTradesmen
                                                    .value ==
                                                0
                                            ? _buildNoRecommendedView()
                                            : const Column(
                                                children: [],
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
              width: MediaQuery.of(Get.context!).size.width,
              height: MediaQuery.of(Get.context!).size.height / 5,
              fit: BoxFit.contain),
          const Padding(
            padding: EdgeInsets.all(12.0),
            child: HeadingTextW700(
                text: "No Interested Tradesman", centerAlign: true, size: 22),
          ),
          const Padding(
            padding: EdgeInsets.only(left: 12.0, right: 12.0),
            child: Headingdescription(
                text:
                    "No tradesman has expressed interest in your job yet. You can start a conversation once someone shows interest.",
                centerAlign: true,
                size: 13.0),
          ),
          const Spacer(),
        ],
      ),
    );
  }

  Widget _buildEmptyChatView() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Spacer(),
          Image.asset("lib/assets/images/emptychatimage.png",
              width: MediaQuery.of(Get.context!).size.width,
              height: MediaQuery.of(Get.context!).size.height / 5,
              fit: BoxFit.contain),
          const Padding(
            padding: EdgeInsets.all(12.0),
            child: HeadingTextW700(
                text: "Chat box is empty", centerAlign: true, size: 22),
          ),
          const Padding(
            padding: EdgeInsets.only(left: 12.0, right: 12.0),
            child: Headingdescription(
                text:
                    "You have not started chatting with tradesman yet. Start a chat to get you job done soon.",
                centerAlign: true,
                size: 13.0),
          ),
          const Spacer(),
        ],
      ),
    );
  }

  Widget _buildNoRecommendedView() {
    return Expanded(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Spacer(),
          Image.asset("lib/assets/images/norecommendedtradesmenimage.png",
              width: MediaQuery.of(Get.context!).size.width,
              height: MediaQuery.of(Get.context!).size.height / 5,
              fit: BoxFit.contain),
          const Padding(
            padding: EdgeInsets.all(12.0),
            child: HeadingTextW700(
                text: "No  Recommended", centerAlign: true, size: 22),
          ),
          const Padding(
            padding: EdgeInsets.only(left: 12.0, right: 12.0),
            child: Headingdescription(
                text:
                    "You have not started chatting with tradesman yet. Start a chat to get you job done soon.",
                centerAlign: true,
                size: 13.0),
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
        const SizedBox(height: 12.0),
        HeadingTextW500(
            text: postedJobAnswers.question ?? "N/A",
            centerAlign: false,
            size: 14.0),
        const SizedBox(height: 10.0),
        Headingdescription(
            text: postedJobAnswers.answer ?? "N/A",
            centerAlign: false,
            size: 14.0),
        const SizedBox(height: 7.0),
        postedJobAnswers.id == controller.postedJobDetail.jobAnswers!.last.id
            ? const SizedBox()
            : Container(
                height: 0.5,
                color: const Color(MyColors.lightGrayColor),
              )
      ],
    );
  }

  Widget _jobPhotosView(String url) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 0),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.all(6.0),
              child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: SizedBox(
                      height: 90,
                      width: 90,
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

  Widget orderDetailsView() {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(
              top: 30.0, bottom: 10.0, left: 18, right: 18),
          child: HeadingTextW600(
              text: controller.postedJobDetail.serviceName ?? "N/A",
              centerAlign: false,
              size: 18.0),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 14.0, top: 4.0),
          child: Align(
            alignment: Alignment.topLeft,
            child: Card(
              elevation: 0,
              color: controller.postedJobDetail.status == "open"
                  ? const Color(MyColors.cardColorSky200)
                  : controller.postedJobDetail.status == "in_progress"
                      ? const Color(MyColors.cardColorGreenLight)
                      : controller.postedJobDetail.status == "cancelled"
                          ? const Color(MyColors.cardcolorOrange200)
                          : const Color(MyColors.cardColorGreen200),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(6)),
              child: Padding(
                padding: const EdgeInsets.all(5.0),
                child: controller.postedJobDetail.status == "open"
                    ? Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          SvgPicture.asset("lib/assets/icons/inprocessIcon.svg",
                              height: 14.0, width: 14.0),
                          const SizedBox(
                            width: 6.0,
                          ),
                          Headingdescription(
                              text: Strings.inProcess(Get.context!),
                              centerAlign: false,
                              size: 12)
                        ],
                      )
                    : controller.postedJobDetail.status == "in_progress"
                        ? Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              lottie.Lottie.asset(
                                'lib/assets/icons/ActiveStatusRipple.json',
                                width: 14,
                                height: 14,
                                fit: BoxFit.contain,
                                repeat: true,
                                animate: true,
                              ),
                              const SizedBox(
                                width: 6.0,
                              ),
                              Headingdescription(
                                  text: Strings.active(Get.context!),
                                  centerAlign: false,
                                  size: 12)
                            ],
                          )
                        : controller.postedJobDetail.status == "cancelled"
                            ? Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  SvgPicture.asset(
                                      "lib/assets/icons/jobCancelledIcon.svg",
                                      height: 14.0,
                                      width: 14.0),
                                  const SizedBox(
                                    width: 6.0,
                                  ),
                                  Headingdescription(
                                      text: Strings.canceledText(Get.context!),
                                      centerAlign: false,
                                      size: 12)
                                ],
                              )
                            : Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  SvgPicture.asset(
                                      "lib/assets/icons/completedTickIcon.svg",
                                      height: 14.0,
                                      width: 14.0),
                                  const SizedBox(
                                    width: 6.0,
                                  ),
                                  Headingdescription(
                                      text: Strings.completed(Get.context!),
                                      centerAlign: false,
                                      size: 12)
                                ],
                              ),
              ),
            ),
          ),
        ),
        Obx(() {
          return controller.loadingInterestedTradesmen.value
              ? const Center(
                  child: CircularProgressIndicator(
                    color: Color(MyColors.themeRedColor),
                  ),
                )
              : Padding(
                  padding: const EdgeInsets.only(left: 14.0, right: 14.0),
                  child: Card(
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    color: const Color(MyColors.cardGrayColor100),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              children: [
                                SvgPicture.asset(
                                  "lib/assets/icons/interestedtradesmenLogo.svg",
                                  height: 16,
                                  width: 16,
                                ),
                                const SizedBox(width: 8),
                                HeadingTextW500(
                                  text:
                                      Strings.interestedTradesman(Get.context!),
                                  centerAlign: false,
                                  size: 14,
                                ),
                              ],
                            ),
                          ),
                          Align(
                            alignment: Alignment.topLeft,
                            child: Padding(
                              padding:
                                  const EdgeInsets.only(left: 8.0, right: 8.0),
                              child: RichText(
                                maxLines: 2,
                                softWrap: false,
                                overflow: TextOverflow.ellipsis,
                                text: TextSpan(
                                  text: Strings.youGot(Get.context!),
                                  style: const TextStyle(
                                    fontFamily: 'Poppins',
                                    color: Colors.black,
                                    fontSize: 14,
                                  ),
                                  children: [
                                    TextSpan(
                                      text:
                                          " ${controller.postedJobDetail.tradespersonApplicationsCount ?? "0"} ",
                                      style: const TextStyle(
                                        color: Color(MyColors.themeRedColor),
                                        fontFamily: 'Poppins',
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    TextSpan(
                                      text: Strings.pickTheBestAndStartWork(
                                          Get.context!),
                                      style: const TextStyle(
                                        color: Color(MyColors.blackColor),
                                        fontFamily: 'Poppins',
                                        fontSize: 14,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          GridView.builder(
                            padding: const EdgeInsets.all(8),
                            itemCount: controller.tradesmenImages.length,
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 8,
                              crossAxisSpacing: 5,
                              mainAxisSpacing: 5,
                            ),
                            itemBuilder: (context, index) {
                              return CircleAvatar(
                                radius: 33,
                                backgroundImage: NetworkImage(
                                    controller.tradesmenImages[index]),
                              );
                            },
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: FullWidthElevatedButton(
                              text: Strings.interestedTradesman(Get.context!),
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
          padding: const EdgeInsets.only(left: 14.0, right: 14.0, top: 14.0),
          child: SizedBox(
            width: MediaQuery.of(Get.context!).size.width,
            child: Card(
              elevation: 0,
              color: const Color(MyColors.infoPinkColor),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(7.0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SvgPicture.asset(
                            "lib/assets/icons/ChatAnswers.svg",
                            height: 22,
                            width: 22,
                          ),
                          const Padding(
                            padding: EdgeInsets.only(left: 12.0, right: 8.0),
                            child: Headingdescription(
                                text: "0 Answers",
                                centerAlign: false,
                                size: 14),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(7.0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SvgPicture.asset(
                            "lib/assets/icons/timer.svg",
                            height: 22,
                            width: 22,
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.only(left: 12.0, right: 8.0),
                            child: Headingdescription(
                                text: controller.postedJobDetail
                                        .humanReadableCreatedAt ??
                                    "N/A",
                                centerAlign: false,
                                size: 14),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(7.0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SvgPicture.asset(
                            "lib/assets/icons/location.svg",
                            height: 22,
                            width: 22,
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.only(left: 12.0, right: 8.0),
                            child: Headingdescription(
                                text: controller.postedJobDetail.city ?? "N/A",
                                centerAlign: false,
                                size: 14),
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
          padding: const EdgeInsets.only(left: 14.0, right: 14.0, top: 14.0),
          child: Card(
            elevation: 0,
            color: const Color(MyColors.cardGrayColor50),
            child: Padding(
              padding: const EdgeInsets.all(4.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.only(top: 12.0),
                      child: HeadingTextW500(
                          text: Strings.info(Get.context!),
                          centerAlign: false,
                          size: 18.0),
                    ),
                  ),
                  Align(
                    alignment: Alignment.topLeft,
                    child: Padding(
                      padding: const EdgeInsets.only(top: 12.0, left: 8.0),
                      child: HeadingTextW500(
                          text: Strings.jobTitle(Get.context!),
                          centerAlign: false,
                          size: 16.0),
                    ),
                  ),
                  Align(
                    alignment: Alignment.topLeft,
                    child: Padding(
                      padding: const EdgeInsets.only(top: 4.0, left: 8.0),
                      child: Headingdescription(
                          text: controller.postedJobDetail.title ?? "N/A",
                          centerAlign: false,
                          size: 16.0),
                    ),
                  ),
                  Align(
                    alignment: Alignment.topLeft,
                    child: Padding(
                      padding: const EdgeInsets.only(top: 12.0, left: 8.0),
                      child: HeadingTextW500(
                          text: Strings.jobDescription(Get.context!),
                          centerAlign: false,
                          size: 16.0),
                    ),
                  ),
                  Align(
                    alignment: Alignment.topLeft,
                    child: Padding(
                      padding: const EdgeInsets.only(
                          top: 4.0, left: 8.0, right: 8.0, bottom: 6.0),
                      child: Headingdescription(
                          text: controller.postedJobDetail.desc ?? "N/A",
                          centerAlign: false,
                          size: 14.0),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(14.0),
          child: Card(
            elevation: 0,
            color: const Color(MyColors.cardGrayColor50),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 12.0),
                  child: HeadingTextW500(
                      text: Strings.details(Get.context!),
                      centerAlign: false,
                      size: 18.0),
                ),
                Padding(
                  padding: const EdgeInsets.all(10.0),
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
                          padding: const EdgeInsets.all(5.0),
                          child: Headingdescription(
                              text: Strings.dataNotFound(Get.context!),
                              centerAlign: false,
                              size: 15),
                        ),
                ),
              ],
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 14.0, right: 14.0, bottom: 14.0),
          child: SizedBox(
            width: MediaQuery.of(Get.context!).size.width,
            child: Card(
              elevation: 0,
              color: const Color(MyColors.cardGrayColor50),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: HeadingTextW500(
                        text: Strings.photos(Get.context!),
                        centerAlign: false,
                        size: 18.0),
                  ),
                  controller.postedJobDetail.imageList != null
                      ? controller.postedJobDetail.imageList!.isNotEmpty
                          ? Padding(
                              padding: const EdgeInsets.only(
                                  left: 14.0, bottom: 6.0),
                              child: SizedBox(
                                height:
                                    95, // Adjust height based on your image size
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
                              padding: const EdgeInsets.only(bottom: 16.0),
                              child: Center(
                                child: Headingdescription(
                                    text: Strings.noPhotosWereUploaded(
                                        Get.context!),
                                    centerAlign: false,
                                    size: 15),
                              ),
                            )
                      : Padding(
                          padding: const EdgeInsets.only(bottom: 16.0),
                          child: Center(
                            child: Headingdescription(
                                text:
                                    Strings.noPhotosWereUploaded(Get.context!),
                                centerAlign: false,
                                size: 15),
                          ),
                        ),
                ],
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 14.0, right: 14.0),
          child: SizedBox(
            width: MediaQuery.of(Get.context!).size.width,
            height: MediaQuery.of(Get.context!).size.height / 2,
            child: Card(
              elevation: 0,
              color: const Color(MyColors.lightSilverColor),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 12.0, top: 12.0),
                    child: HeadingTextW500(
                        text: Strings.yourAddress(Get.context!),
                        centerAlign: false,
                        size: 18.0),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(6.0),
                    child: Card(
                      elevation: 0,
                      color: Colors.white,
                      child: Padding(
                        padding: const EdgeInsets.all(7.0),
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
                                      style: const TextStyle(
                                        color: Colors.black,
                                        fontSize: 13,
                                      ),
                                      children: [
                                        const TextSpan(
                                          text: "Address: ",
                                          style: TextStyle(
                                            color: Color(MyColors.blackColor),
                                            fontFamily: 'Poppins',
                                            fontSize: 14,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                        TextSpan(
                                          text: controller
                                                  .postedJobDetail.location ??
                                              "N/A",
                                          style: const TextStyle(
                                            color: Color(MyColors.blackColor),
                                            fontFamily: 'Poppins',
                                            fontSize: 14,
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
                                style: const TextStyle(
                                  color: Colors.black,
                                  fontSize: 13,
                                ),
                                children: [
                                  const TextSpan(
                                    text: "PostCode: ",
                                    style: TextStyle(
                                      color: Color(MyColors.blackColor),
                                      fontFamily: 'Poppins',
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  TextSpan(
                                    text: controller.postedJobDetail.postcode ??
                                        "N/A",
                                    style: const TextStyle(
                                      color: Color(MyColors.blackColor),
                                      fontFamily: 'Poppins',
                                      fontSize: 14,
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
                                style: const TextStyle(
                                  color: Colors.black,
                                  fontSize: 13,
                                ),
                                children: [
                                  const TextSpan(
                                    text: "City: ",
                                    style: TextStyle(
                                      color: Color(MyColors.blackColor),
                                      fontFamily: 'Poppins',
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  TextSpan(
                                    text: controller.postedJobDetail.city ??
                                        "N/A",
                                    style: const TextStyle(
                                      color: Color(MyColors.blackColor),
                                      fontFamily: 'Poppins',
                                      fontSize: 14,
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
                                style: const TextStyle(
                                  color: Colors.black,
                                  fontSize: 13,
                                ),
                                children: [
                                  const TextSpan(
                                    text: "Country: ",
                                    style: TextStyle(
                                      color: Color(MyColors.blackColor),
                                      fontFamily: 'Poppins',
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  TextSpan(
                                    text: controller.postedJobDetail.country ??
                                        "N/A",
                                    style: const TextStyle(
                                      color: Color(MyColors.blackColor),
                                      fontFamily: 'Poppins',
                                      fontSize: 14,
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
                    padding: const EdgeInsets.only(
                        left: 10.0, right: 10.0, top: 14.0),
                    child: HeadingTextW500(
                        text: Strings.viewOnMap(Get.context!),
                        centerAlign: false,
                        size: 18.0),
                  ),
                  Obx(() {
                    return Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
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
        Padding(
          padding: const EdgeInsets.all(14.0),
          child: Card(
            elevation: 0,
            color: const Color(MyColors.cardGrayColor200),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Center(
                child: Row(
                  children: [
                    Padding(
                        padding: const EdgeInsets.only(left: 4.0, right: 12.0),
                        child: SvgPicture.asset(
                            "lib/assets/icons/informationLogo.svg",
                            height: 24.0,
                            width: 24.0)),
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          try {
                            if (controller.postedJobDetail
                                    .tradespersonRequestsCount ==
                                null) {
                              Fluttertoast.showToast(
                                  msg:
                                      Strings.somethingWentWrong(Get.context!));
                              return;
                            }
                            int remainingReqCount =
                                controller.getRemainingTrademenRequests(
                                    int.parse(controller.postedJobDetail
                                        .tradespersonRequestsCount!.value));
                            Get.offNamed(
                              AppLinks.job_recommendations,
                              arguments: {
                                'jobId': controller.postedJobDetail.id,
                                'remainingRequeststoSend': remainingReqCount,
                                'fromWhere': 'MyOrders'
                              },
                            );
                          } catch (e) {
                            throw Exception(e);
                          }
                        },
                        child: RichText(
                          maxLines: 2,
                          softWrap: false,
                          overflow: TextOverflow.ellipsis,
                          text: TextSpan(
                            style: const TextStyle(
                              color: Colors.black,
                              fontSize: 13,
                            ),
                            children: [
                              const TextSpan(
                                text: "Send Requests",
                                style: TextStyle(
                                  decoration: TextDecoration.underline,
                                  color: Color(MyColors.themeRedColor),
                                  fontFamily: 'Poppins',
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              TextSpan(
                                text:
                                    " to ${controller.getRemainingTrademenRequests(int.parse(controller.postedJobDetail.tradespersonRequestsCount!.value))} more tradesman to get more answers.",
                                style: const TextStyle(
                                  color: Color(MyColors.blackColor),
                                  fontFamily: 'Poppins',
                                  fontSize: 14,
                                ),
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
          ),
        ),
      ],
    );
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
      Fluttertoast.showToast(msg: Strings.somethingWentWrong(context));
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
          padding: const EdgeInsets.only(top: 12.0),
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
                      borderRadius: BorderRadius.circular(5)),
                  color: Color(allOptionColor),
                  child: Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: Row(
                      children: [
                        SvgPicture.asset(
                          applicationStatus == "All"
                              ? "lib/assets/icons/ticklogoblue.svg"
                              : "lib/assets/icons/ticklogoblack.svg",
                          height: 14,
                          width: 14,
                          fit: BoxFit.contain,
                        ),
                        const SizedBox(
                          width: 4.0,
                        ),
                        Text(Strings.allText(context),
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                color: Color(allOptionTextColor),
                                fontSize: 12,
                                fontWeight: FontWeight.w400,
                                fontFamily: 'Poppins')),
                      ],
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 6.0),
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
                        borderRadius: BorderRadius.circular(5)),
                    color: Color(acceptedOptionColor),
                    child: Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: Row(
                        children: [
                          SvgPicture.asset(
                            applicationStatus == "approved"
                                ? "lib/assets/icons/ticklogoblue.svg"
                                : "lib/assets/icons/ticklogoblack.svg",
                            height: 14,
                            width: 14,
                            fit: BoxFit.contain,
                          ),
                          const SizedBox(
                            width: 4.0,
                          ),
                          Text(Strings.accepted(context),
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  color: Color(acceptedOptionTextColor),
                                  fontSize: 12,
                                  fontWeight: FontWeight.w400,
                                  fontFamily: 'Poppins')),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 6.0),
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
                        borderRadius: BorderRadius.circular(5)),
                    color: Color(rejectedOptionColor),
                    child: Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: Row(
                        children: [
                          SvgPicture.asset(
                            applicationStatus == "declined"
                                ? "lib/assets/icons/crossLogoRed.svg"
                                : "lib/assets/icons/crossLogoBlack.svg",
                            height: 14,
                            width: 14,
                            fit: BoxFit.contain,
                          ),
                          const SizedBox(
                            width: 4.0,
                          ),
                          Text(Strings.rejected(context),
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  color: Color(rejectedOptionTextColor),
                                  fontSize: 12,
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
            ? const Center(
                child: Padding(
                  padding: EdgeInsets.only(top: 32.0),
                  child: CircularProgressIndicator(
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
                        height: MediaQuery.of(context).size.height / 1.5,
                        child: Center(
                          child: Headingdescription(
                              text: Strings.noTradesmen(context),
                              centerAlign: false,
                              size: 16.0),
                        ),
                      )
                : const SizedBox(),
        // Padding(
        //   padding: const EdgeInsets.only(top: 16.0, left: 16.0),
        //   child: Align(
        //       alignment: Alignment.topLeft,
        //       child: HeadingTextW600(
        //           text: Strings.acceptedText, centerAlign: false, size: 16.0)),
        // ),
        // Align(
        //   alignment: Alignment.topLeft,
        //   child: Padding(
        //     padding: const EdgeInsets.only(left: 16.0, top: 4.0),
        //     child: Headingdescription(
        //         text: "You choose a tradesman to work for you.",
        //         centerAlign: false,
        //         size: 14),
        //   ),
        // ),
        // Padding(
        //   padding: const EdgeInsets.only(top: 16.0, left: 16.0),
        //   child: Align(
        //       alignment: Alignment.topLeft,
        //       child: HeadingTextW600(
        //           text: Strings.rejectedText, centerAlign: false, size: 16)),
        // ),
        // Align(
        //   alignment: Alignment.topLeft,
        //   child: Padding(
        //     padding: const EdgeInsets.only(left: 16.0, top: 4.0),
        //     child: Headingdescription(
        //         text: "These are tradesmen you do not want to work with.",
        //         centerAlign: false,
        //         size: 14),
        //   ),
        // )
      ],
    );
  }

  Widget _buildTradesmenView(TradesmenRequest tradesmen) {
    return Padding(
        padding: const EdgeInsets.only(left: 8.0, right: 8.0, top: 5.0),
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
                padding: const EdgeInsets.only(top: 12.0),
                child: Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 10.0),
                      child: tradesmen.userProfileImg != null
                          ? CircleAvatar(
                              radius: 24,
                              backgroundImage: NetworkImage(tradesmen
                                  .userProfileImg
                                  .toString()), // Replace with actual image
                            )
                          : SvgPicture.asset(
                              "lib/assets/images/tradesmenplaceholdericon.svg"),
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
                                        tradesmen.userName ?? "N/A",
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
                                        padding:
                                            const EdgeInsets.only(right: 10.0),
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
                                        "${tradesmen.reviewsCount ?? 0} reviews",
                                        style: const TextStyle(
                                            color: Color(MyColors.midGrayColor),
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
                                        padding:
                                            const EdgeInsets.only(right: 10.0),
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
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              Align(
                  alignment: Alignment.topLeft,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 4.0, left: 12.0),
                    child: Headingdescription(
                        text:
                            "Applied : ${tradesmen.humanReadableCreatedAt ?? "N/A"}",
                        centerAlign: false,
                        size: 12),
                  )),
              Padding(
                padding: const EdgeInsets.only(left: 8.0, right: 8.0, top: 4.0),
                child: Align(
                  alignment: Alignment.topLeft,
                  child: Card(
                    color: const Color(MyColors.whiteColor),
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(9)),
                    child: Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: ExpandableText(tradesmen.coverLetter ?? "N/A",
                            expandText: Strings.showMore(context),
                            collapseText: Strings.showLess(context),
                            maxLines: 2,
                            linkStyle: const TextStyle(
                                color: Colors.grey,
                                fontFamily: 'Poppins',
                                fontSize: 12.0),
                            style: const TextStyle(
                                color: Colors.black,
                                fontFamily: 'Poppins',
                                fontSize: 14.0))),
                  ),
                ),
              ),
              // Send Request Button
              Obx(() {
                return tradesmen.loadingValue.value.isEmpty
                    ? tradesmen.status == "pending"
                        ? Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                        left: 5.0, right: 5.0),
                                    child: FullWidthElevatedButton(
                                        onPressed: () async {
                                          tradesmen.loadingValue.value = "0";
                                          bool res = await controller
                                              .pleaseUpdateRequestsStatus(
                                                  widget.jobId,
                                                  tradesmen.id!,
                                                  "approved",
                                                  context);
                                          if (res) {
                                            Fluttertoast.showToast(
                                                msg:
                                                    "The Request has been Accepted, now you an start Chat");
                                            tradesmen.status = "approved";
                                            tradesmen.loadingValue.value = "";
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
                                    padding: const EdgeInsets.only(
                                        left: 5.0, right: 5.0),
                                    child: FullWidthElevatedButton(
                                        onPressed: () async {
                                          tradesmen.loadingValue.value = "0";
                                          bool res = await controller
                                              .pleaseUpdateRequestsStatus(
                                                  widget.jobId,
                                                  tradesmen.id!,
                                                  "declined",
                                                  context);
                                          if (res) {
                                            Fluttertoast.showToast(
                                                msg:
                                                    "The Request has been Declined");
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
                                padding: const EdgeInsets.only(
                                    left: 13.0,
                                    right: 13.0,
                                    bottom: 8.0,
                                    top: 5.0),
                                child: FullWidthElevatedButton(
                                    onPressed: () {
                                      // Fluttertoast.showToast(msg: "Chat");
                                    },
                                    text: Strings.requestRejected(context),
                                    color: MyColors.lightGrayColor,
                                    textColor: MyColors.whiteColor),
                              )
                            : Padding(
                                padding: const EdgeInsets.only(
                                    left: 13.0,
                                    right: 13.0,
                                    bottom: 8.0,
                                    top: 5.0),
                                child: FullWidthElevatedButton(
                                    onPressed: () async {
                                      var result = await Get.to(
                                        const ConversationScreen(),
                                        arguments: {
                                          'chat': null,
                                          'chatId': tradesmen.chatId,
                                          'fromWhere': 'OrderDetail'
                                        },
                                        transition: Transition
                                            .rightToLeft, // Left-to-right animation
                                        duration: const Duration(
                                            milliseconds:
                                                500), // Optional: animation duration
                                      );
                                      if (result != null) {
                                        // Update your UI
                                        if (result == "update") {}
                                        // print("Result received: $result");
                                        // Call setState or update observable
                                      }
                                      // Fluttertoast.showToast(msg: "Chat");
                                    },
                                    text: Strings.chatText(context),
                                    color: MyColors.themeRedColor,
                                    textColor: MyColors.whiteColor),
                              )
                    : const Center(
                        child: Padding(
                          padding: EdgeInsets.all(4.0),
                          child: CircularProgressIndicator(
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

class ChatSection extends StatefulWidget {
  final int jobId;
  final String jobStatus;
  const ChatSection({super.key, required this.jobId, required this.jobStatus});

  @override
  State<ChatSection> createState() => _ChatSectionState();
}

class _ChatSectionState extends State<ChatSection> {
  bool isLoading = true.obs();
  String applicationStatus = "approved";
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
      Fluttertoast.showToast(msg: Strings.somethingWentWrong(context));
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
        child: isLoading
            ? SizedBox(
                height: MediaQuery.of(context).size.height / 1.5,
                child: const Center(
                  child: CircularProgressIndicator(
                      color: Color(MyColors.themeRedColor)),
                ),
              )
            : _buildInterstedTradesmenView());
  }

  Widget _buildInterstedTradesmenView() {
    return Column(
      children: [
        requestedTradesmen!.tradesmenRequestList != null
            ? requestedTradesmen!.tradesmenRequestList!.isNotEmpty
                ? ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: requestedTradesmen!.tradesmenRequestList!.length,
                    itemBuilder: (context, index) {
                      return _buildTradesmenView(
                          requestedTradesmen!.tradesmenRequestList![index]);
                    },
                  )
                : SizedBox(
                    height: MediaQuery.of(context).size.height / 1.5,
                    child: Center(
                      child: Headingdescription(
                          text: Strings.noTradesmen(context),
                          centerAlign: false,
                          size: 16.0),
                    ),
                  )
            : const SizedBox(),
        // Padding(
        //   padding: const EdgeInsets.only(top: 16.0, left: 16.0),
        //   child: Align(
        //       alignment: Alignment.topLeft,
        //       child: HeadingTextW600(
        //           text: Strings.acceptedText, centerAlign: false, size: 16.0)),
        // ),
        // Align(
        //   alignment: Alignment.topLeft,
        //   child: Padding(
        //     padding: const EdgeInsets.only(left: 16.0, top: 4.0),
        //     child: Headingdescription(
        //         text: "You choose a tradesman to work for you.",
        //         centerAlign: false,
        //         size: 14),
        //   ),
        // ),
        // Padding(
        //   padding: const EdgeInsets.only(top: 16.0, left: 16.0),
        //   child: Align(
        //       alignment: Alignment.topLeft,
        //       child: HeadingTextW600(
        //           text: Strings.rejectedText, centerAlign: false, size: 16)),
        // ),
        // Align(
        //   alignment: Alignment.topLeft,
        //   child: Padding(
        //     padding: const EdgeInsets.only(left: 16.0, top: 4.0),
        //     child: Headingdescription(
        //         text: "These are tradesmen you do not want to work with.",
        //         centerAlign: false,
        //         size: 14),
        //   ),
        // )
      ],
    );
  }

  Widget _buildTradesmenView(TradesmenRequest tradesmen) {
    return Padding(
        padding: const EdgeInsets.only(left: 8.0, right: 8.0, top: 5.0),
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
                padding: const EdgeInsets.only(top: 12.0),
                child: Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 10.0),
                      child: tradesmen.userProfileImg != null
                          ? CircleAvatar(
                              radius: 24,
                              backgroundImage: NetworkImage(tradesmen
                                  .userProfileImg
                                  .toString()), // Replace with actual image
                            )
                          : SvgPicture.asset(
                              "lib/assets/images/tradesmenplaceholdericon.svg"),
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
                                        tradesmen.userName ?? "N/A",
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
                                        padding:
                                            const EdgeInsets.only(right: 10.0),
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
                                        "${tradesmen.reviewsCount ?? 0} reviews",
                                        style: const TextStyle(
                                            color: Color(MyColors.midGrayColor),
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
                                        padding:
                                            const EdgeInsets.only(right: 10.0),
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
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              Align(
                  alignment: Alignment.topLeft,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 4.0, left: 12.0),
                    child: Headingdescription(
                        text:
                            "Applied : ${tradesmen.humanReadableCreatedAt ?? "N/A"}",
                        centerAlign: false,
                        size: 12),
                  )),
              Padding(
                padding: const EdgeInsets.only(left: 8.0, right: 8.0, top: 4.0),
                child: Align(
                  alignment: Alignment.topLeft,
                  child: Card(
                    color: const Color(MyColors.whiteColor),
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(9)),
                    child: Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: ExpandableText(tradesmen.coverLetter ?? "N/A",
                            expandText: Strings.showMore(context),
                            collapseText: Strings.showLess(context),
                            maxLines: 2,
                            linkStyle: const TextStyle(
                                color: Colors.grey,
                                fontFamily: 'Poppins',
                                fontSize: 12.0),
                            style: const TextStyle(
                                color: Colors.black,
                                fontFamily: 'Poppins',
                                fontSize: 14.0))),
                  ),
                ),
              ),
              // Send Request Button
              Obx(() {
                return tradesmen.loadingValue.value.isEmpty
                    ? tradesmen.status == "pending"
                        ? Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                        left: 5.0, right: 5.0),
                                    child: FullWidthElevatedButton(
                                        onPressed: () async {
                                          tradesmen.loadingValue.value = "0";
                                          bool res = await controller
                                              .pleaseUpdateRequestsStatus(
                                                  widget.jobId,
                                                  tradesmen.id!,
                                                  "approved",
                                                  context);
                                          if (res) {
                                            Fluttertoast.showToast(
                                                msg:
                                                    "The Request has been Accepted, now you an start Chat");
                                            tradesmen.status = "approved";
                                            tradesmen.loadingValue.value = "";
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
                                    padding: const EdgeInsets.only(
                                        left: 5.0, right: 5.0),
                                    child: FullWidthElevatedButton(
                                        onPressed: () async {
                                          tradesmen.loadingValue.value = "0";
                                          bool res = await controller
                                              .pleaseUpdateRequestsStatus(
                                                  widget.jobId,
                                                  tradesmen.id!,
                                                  "declined",
                                                  context);
                                          if (res) {
                                            Fluttertoast.showToast(
                                                msg:
                                                    "The Request has been Declined");
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
                                padding: const EdgeInsets.only(
                                    left: 13.0,
                                    right: 13.0,
                                    bottom: 8.0,
                                    top: 5.0),
                                child: FullWidthElevatedButton(
                                    onPressed: () {
                                      // Fluttertoast.showToast(msg: "Chat");
                                    },
                                    text: Strings.requestRejected(context),
                                    color: MyColors.lightGrayColor,
                                    textColor: MyColors.whiteColor),
                              )
                            : Padding(
                                padding: const EdgeInsets.only(
                                    left: 13.0,
                                    right: 13.0,
                                    bottom: 8.0,
                                    top: 5.0),
                                child: FullWidthElevatedButton(
                                    onPressed: () async {
                                      var result = await Get.to(
                                        const ConversationScreen(),
                                        arguments: {
                                          'chat': null,
                                          'chatId': tradesmen.chatId,
                                          'fromWhere': 'OrderDetail'
                                        },
                                        transition: Transition
                                            .rightToLeft, // Left-to-right animation
                                        duration: const Duration(
                                            milliseconds:
                                                500), // Optional: animation duration
                                      );
                                      if (result != null) {
                                        // Update your UI
                                        if (result == "update") {}
                                        // print("Result received: $result");
                                        // Call setState or update observable
                                      }
                                      // Fluttertoast.showToast(msg: "Chat");
                                    },
                                    text: Strings.chatText(context),
                                    color: MyColors.themeRedColor,
                                    textColor: MyColors.whiteColor),
                              )
                    : const Center(
                        child: Padding(
                          padding: EdgeInsets.all(4.0),
                          child: CircularProgressIndicator(
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
