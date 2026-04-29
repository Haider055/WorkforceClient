import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'dart:io';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lottie/lottie.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:workforceclientapp/Controllers/AllChatsContoller.dart';
import 'package:workforceclientapp/Controllers/NotificationScreenContoller.dart';
import 'package:workforceclientapp/Controllers/PostedOrdersController.dart';
import 'package:workforceclientapp/Controllers/ProfileController.dart';
import 'package:workforceclientapp/Controllers/SelectServiceController.dart';
import 'package:workforceclientapp/Models/PostedJobDetail.dart';
import 'package:workforceclientapp/Others/Commons.dart';
import 'package:workforceclientapp/Others/Constants.dart';
import 'package:workforceclientapp/Others/MyColors.dart';
import 'package:workforceclientapp/Others/Strings.dart';
import 'package:workforceclientapp/Others/routes.dart';
import 'package:workforceclientapp/views/screens/Chat/AllChats.dart';
import 'package:workforceclientapp/views/screens/Notifications/NotificationsScreen.dart';
import 'package:workforceclientapp/views/screens/Profile/ChangeLanguageScreen.dart';
import 'package:workforceclientapp/views/screens/Profile/ContactInformationScreen.dart';
import 'package:workforceclientapp/views/screens/Profile/ManageAccountScreen.dart';
import 'package:workforceclientapp/views/widgets/FullWidthButtonPrimary.dart';
import 'package:workforceclientapp/views/widgets/FullWidthElevatedButton.dart';
import 'package:workforceclientapp/views/widgets/HeadingText.dart';
import 'package:workforceclientapp/views/widgets/HeadingTextW500.dart';
import 'package:workforceclientapp/views/widgets/HeadingTextW600.dart';
import 'package:workforceclientapp/views/widgets/HeadingTextW700.dart';
import 'package:workforceclientapp/views/widgets/Headingdescription.dart';
import 'package:workforceclientapp/views/widgets/LogoImage.dart';
import 'package:workforceclientapp/views/widgets/ProfileInfoCard.dart';

class SelectServiceScreen extends GetView<SelectServiceController> {
  const SelectServiceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          resizeToAvoidBottomInset: false,
          appBar: AppBar(
            leadingWidth: MediaQuery.of(context).size.width,
            leading: Container(
              color: const Color(MyColors.whiteColor),
              child: const Card(
                color: Color(MyColors.appbackgroundColor),
                shadowColor: Color.fromARGB(158, 219, 219, 219),
                elevation: 0.5,
                shape: Border(
                    bottom: BorderSide(
                        color: Color(MyColors.cardGrayColor100),
                        style: BorderStyle.solid)),
                child: Center(
                  child: LogoImage(),
                ),
              ),
            ),
          ),
          backgroundColor: Colors.white,
          bottomNavigationBar: Obx(() {
            return BottomNavigationBar(
              backgroundColor: Colors.white,
              elevation: 7,
              showUnselectedLabels: true,
              currentIndex: controller.currentIndex.value,
              onTap: (index) {
                print(index);
                if (controller.isLoading.value) {
                  return;
                }
                changeTab(index);
                controller.currentIndex.value = index;
              },
              items: [
                BottomNavigationBarItem(
                    icon: controller.currentIndex.value == 0
                        ? SvgPicture.asset(
                            "lib/assets/icons/postjobRedIcon.svg")
                        : SvgPicture.asset(
                            "lib/assets/icons/postjobBlackIcon.svg"),
                    label: Strings.postJob(context),
                    backgroundColor: const Color(MyColors.whiteColor)),
                BottomNavigationBarItem(
                    icon: controller.currentIndex.value == 1
                        ? SvgPicture.asset(
                            "lib/assets/icons/myordersRedIcon.svg")
                        : SvgPicture.asset(
                            "lib/assets/icons/myordersBlackIcon.svg"),
                    label: Strings.myJobsText(context),
                    backgroundColor: const Color(MyColors.whiteColor)),
                BottomNavigationBarItem(
                    icon: Obx(() {
                      return Stack(
                        clipBehavior: Clip.none,
                        children: [
                          controller.currentIndex.value == 2
                              ? SvgPicture.asset(
                                  "lib/assets/icons/chatRedIcon.svg")
                              : SvgPicture.asset(
                                  "lib/assets/icons/chatBlackIcon.svg"),
                          if (controller.unreadMessagesCount.value > 0)
                            Positioned(
                              right: -6,
                              top: -4,
                              child: Container(
                                padding: EdgeInsets.all(2.r),
                                decoration: BoxDecoration(
                                  color: Colors.red,
                                  borderRadius: BorderRadius.circular(10.r),
                                ),
                                constraints: const BoxConstraints(
                                  minWidth: 16,
                                  minHeight: 16,
                                ),
                                child: Text(
                                  '${controller.unreadMessagesCount.value}',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 10.sp,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ),
                        ],
                      );
                    }),
                    label: Strings.chatText(context),
                    backgroundColor: const Color(MyColors.whiteColor)),
                // BottomNavigationBarItem(
                //     icon: _currentIndex == 2
                //         ? SvgPicture.asset("lib/assets/icons/chatRedIcon.svg")
                //         : SvgPicture.asset(
                //             "lib/assets/icons/chatBlackIcon.svg"),
                //     label: Strings.chatText(context),
                //     backgroundColor: Color(MyColors.whiteColor)),
                BottomNavigationBarItem(
                    icon: Obx(() {
                      return Stack(
                        clipBehavior: Clip.none,
                        children: [
                          controller.currentIndex.value == 3
                              ? SvgPicture.asset(
                                  "lib/assets/icons/notificationRedIcon.svg")
                              : SvgPicture.asset(
                                  "lib/assets/icons/bellblackIcon.svg"),
                          if (Constants.unreadNotificationsCount.value > 0)
                            Positioned(
                              right: -6,
                              top: -4,
                              child: Container(
                                padding: EdgeInsets.all(2.r),
                                decoration: BoxDecoration(
                                  color: Colors.red,
                                  borderRadius: BorderRadius.circular(10.r),
                                ),
                                constraints: BoxConstraints(
                                  minWidth: 16.r,
                                  minHeight: 16.r,
                                ),
                                child: Text(
                                  '${Constants.unreadNotificationsCount.value}',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 10.sp,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ),
                        ],
                      );
                    }),
                    label: Strings.notification(context),
                    backgroundColor: const Color(MyColors.whiteColor)),
                BottomNavigationBarItem(
                    icon: controller.currentIndex.value == 4
                        ? SvgPicture.asset(
                            "lib/assets/icons/profileRedicon.svg")
                        : SvgPicture.asset(
                            "lib/assets/icons/profileBlackicon.svg"),
                    label: Strings.profile(context),
                    backgroundColor: const Color(MyColors.whiteColor)),
              ],
              selectedItemColor:
                  const Color(MyColors.themeRedColor), // Active tab color
              unselectedItemColor:
                  const Color(0x9C000000), // Inactive tab color
            );
          }),
          body: Obx(() {
            return controller.currentIndex.value == 0
                ? mainScreenUI()
                : controller.currentIndex.value == 1
                    ? const PostedOrdersSection()
                    : controller.currentIndex.value == 2
                        ? const AllChats()
                        : controller.currentIndex.value == 3
                            ? const NotificationsScreen()
                            : ProfileSection(
                                isLoggedin: controller.isLoggedIn.value);
          })),
    );
  }

  void changeTab(int index) {
    if (index == 0) {
      if (controller.currentIndex.value == 0) {
        return;
      }
      controller.currentIndex.value = index;
      if (Get.isRegistered<SelectServiceController>()) {
        if (!Get.find<SelectServiceController>().isLoading.value) {
          Get.find<SelectServiceController>().refreshData();
        }
      }
    } else if (index == 1) {
      controller.currentIndex.value = index;
      if (Get.isRegistered<PostedOrdersController>()) {
        if (!Get.find<PostedOrdersController>().isLoading.value) {
          Get.find<PostedOrdersController>().refreshData();
        }
      }
    } else if (index == 2) {
      controller.currentIndex.value = index;
      // controller.unreadMessagesCount.value = 0;
      if (Get.isRegistered<AllChatsContoller>()) {
        if (!Get.find<AllChatsContoller>().isLoading.value) {
          Get.find<AllChatsContoller>().refreshData();
        }
      }
    } else if (index == 3) {
      controller.currentIndex.value = index;
      if (Get.isRegistered<NotificationScreenContoller>()) {
        if (!Get.find<NotificationScreenContoller>().isLoading.value) {
          Get.find<NotificationScreenContoller>().refreshData();
        }
      }
    }
  }

  Widget buildServiceOptions(int index) {
    return SizedBox(
      height: 54.0.h,
      child: GestureDetector(
        onTap: () async {
          try {
            controller.searchController.value.text =
                controller.filteredOptions.elementAt(index).name!;
            controller.selectedServiceName =
                controller.filteredOptions.elementAt(index).name!;
            controller.selectedServiceId =
                controller.filteredOptions.elementAt(index).id!;
            controller.showServicesSuggestions.value = false;
          } catch (e) {
            e.printError();
          }

          Commons.showProgressDialog(Get.context!);
          await controller.pleaseGetAllServiceQuestions(
              controller.selectedServiceId, controller.selectedServiceName);
          Commons.hideProgressDialog();
        },
        child: Padding(
          padding: EdgeInsets.only(left: 27.0.w, right: 27.0.w, top: 3.0.h),
          child: Card(
            elevation: 0,
            color: const Color(MyColors.cardGrayColor50),
            margin: EdgeInsets.symmetric(vertical: 0.1.h),
            shape: OutlineInputBorder(
                borderSide: const BorderSide(
                    color: Color.fromARGB(255, 212, 212, 212),
                    strokeAlign: 1.0,
                    style: BorderStyle.solid),
                borderRadius: BorderRadius.circular(5.0.r)),
            child: Row(
              children: [
                Padding(
                    padding: EdgeInsets.only(left: 14.0.w),
                    child:
                        controller.filteredOptions.elementAt(index).icon != null
                            ? Image.network(
                                controller.filteredOptions
                                    .elementAt(index)
                                    .icon!
                                    .url!,
                                height: 24.h,
                                width: 24.w,
                                fit: BoxFit.contain,
                                errorBuilder: (context, error, stackTrace) {
                                  return SizedBox(
                                      height: 24.h,
                                      width: 24.w,
                                      child: SvgPicture.asset(
                                        "lib/assets/images/tradesmenplaceholdericon.svg",
                                        fit: BoxFit.contain,
                                        height: 24.h,
                                        width: 24.w,
                                      ));
                                },
                              )
                            : SizedBox(
                                height: 24.h,
                                width: 24.w,
                                child: SvgPicture.asset(
                                  "lib/assets/icons/bookIcon.svg",
                                  fit: BoxFit.contain,
                                  height: 24.h,
                                  width: 24.w,
                                ))),
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.only(left: 10.0.w, right: 8.0.w),
                    child: Text(
                        controller.filteredOptions
                            .elementAt(index)
                            .name
                            .toString(),
                        textAlign: TextAlign.start,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                        softWrap: true,
                        style: TextStyle(
                            fontSize: 15.5.sp,
                            fontWeight: FontWeight.w400,
                            fontFamily: 'Poppins')),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget mainScreenUI() {
    return controller.isLoading.value
        ? const Center(
            child: CircularProgressIndicator(
            color: Color(MyColors.themeRedColor),
          ))
        : GestureDetector(
            onTap: () {
              if (controller.searchInput.value.isEmpty) {
                controller.showServicesSuggestions.value = false;
              }
              FocusScope.of(Get.context!).unfocus();
            },
            child: Stack(
              children: [
                SingleChildScrollView(
                  child: Column(
                    children: [
                      Column(
                        children: [
                          controller.isLoggedIn.value == "loggedOut"
                              ? Padding(
                                  padding: EdgeInsets.only(
                                      left: 15.0.w, right: 15.0.w),
                                  child: Card(
                                    elevation: 0,
                                    color: Colors.red.shade50,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Padding(
                                          padding: EdgeInsets.only(
                                              left: 8.0.w,
                                              right: 8.0.w,
                                              top: 9.0.h),
                                          child: Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              Stack(
                                                children: [
                                                  Container(
                                                    width: 34.w,
                                                    height: 34.h,
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
                                                          blurRadius: 5,
                                                          spreadRadius: 2,
                                                          offset: const Offset(
                                                              0, 2),
                                                        ),
                                                      ],
                                                    ),
                                                    child: const Center(
                                                        child: Icon(
                                                            Icons
                                                                .person_outline,
                                                            color: Color(MyColors
                                                                .themeRedColor),
                                                            size: 26)),
                                                  ),
                                                ],
                                              ),
                                              SizedBox(width: 10.0.r),
                                              Expanded(
                                                  child: Headingdescription(
                                                      text: Strings
                                                          .itSeemsYouAreNotLoginText(
                                                              Get.context!),
                                                      centerAlign: false,
                                                      size: 14.5.sp)),
                                            ],
                                          ),
                                        ),
                                        Padding(
                                          padding: EdgeInsets.all(12.0.r),
                                          child: SizedBox(
                                            height: 32.h,
                                            width: MediaQuery.of(Get.context!)
                                                .size
                                                .width
                                                .w,
                                            child: ElevatedButton(
                                              onPressed: () {
                                                // manageinnAppPurchase();
                                                Constants.fromWhere =
                                                    "SelectServiceScreen";
                                                Get.toNamed(
                                                    AppLinks.login_screen);
                                              },
                                              style: ElevatedButton.styleFrom(
                                                backgroundColor: const Color(
                                                    MyColors
                                                        .themeRedColor), // Button color
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(8
                                                          .r), // Optional rounded corners
                                                ),
                                              ),
                                              child: Text(
                                                Strings.loginText(Get.context!),
                                                style: TextStyle(
                                                  fontSize: 12
                                                      .sp, // Adjust font size to fit inside
                                                  color: Colors
                                                      .white, // Text color
                                                  fontWeight: FontWeight.bold,
                                                ),
                                                textAlign: TextAlign.center,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                )
                              : const SizedBox(),
                          Align(
                            alignment: Alignment.topLeft,
                            child: Padding(
                              padding: EdgeInsets.only(top: 18.0.h, left: 24.w),
                              child: HeadingTextW600(
                                  text: Strings.hireNow(Get.context!),
                                  centerAlign: false,
                                  size: 28.sp),
                            ),
                          ),
                          Align(
                            alignment: Alignment.topLeft,
                            child: HeadingText(
                                text:
                                    Strings.selectServiceHeading(Get.context!),
                                centerAlign: false),
                          ),
                          Align(
                            alignment: Alignment.topLeft,
                            child: Padding(
                              padding:
                                  EdgeInsets.only(left: 25.0.w, top: 18.0.h),
                              child: Headingdescription(
                                  text: Strings.selectServiceDesc(Get.context!),
                                  centerAlign: false,
                                  size: 14.5.sp),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        width: MediaQuery.of(Get.context!).size.width,
                        child: Padding(
                          padding: EdgeInsets.only(
                              top: 24.0.h, left: 25.0.w, right: 25.0.w),
                          child: TextField(
                            controller: controller.searchController(),
                            onChanged: (value) {
                              controller.searchInput.value = value;
                              // searchMillis =
                              //     DateTime.now().millisecondsSinceEpoch;
                              controller.filterSearchResults(
                                  controller.searchInput.value);
                              // searchQuery();
                            },
                            cursorColor: const Color(MyColors.themeRedColor),
                            decoration: InputDecoration(
                              prefixIcon:
                                  const Icon(Icons.search, color: Colors.black),
                              hintText: "e.g. ${Strings.painter(Get.context!)}",
                              hintStyle: const TextStyle(
                                  color: Color(MyColors.lightGrayColor)),
                              suffixIcon: Padding(
                                padding: EdgeInsets.only(right: 6.0.w),
                                child: GestureDetector(
                                  onTap: () {
                                    if (controller.searchController.value.text
                                        .isNotEmpty) {
                                      controller.searchController.value.text =
                                          "";
                                      controller.filteredOptions.value = [];
                                      controller.showServicesSuggestions.value =
                                          false;
                                    }
                                  },
                                  child: Stack(
                                    alignment: Alignment.center,
                                    children: [
                                      Image.asset(
                                        'lib/assets/images/select_service_suffixicon.png', // Make sure this image is in assets folder
                                        width: 30.w, // Adjust width
                                        height: 30.h, // Adjust height
                                      ),
                                      Image.asset(
                                        'lib/assets/icons/cancelicon.png', // Make sure this image is in assets folder
                                        width: 12.w, // Adjust width
                                        height: 12.h, // Adjust height
                                      ),
                                    ],
                                  ),
                                ),
                              ), // Search icon at start
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.all(
                                    Radius.circular(8.r)), // Border radius
                                borderSide: BorderSide(
                                    color: Color(
                                        controller.textFieldBorderColor.value),
                                    width: 1.5.w), // Black border
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(8.r)),
                                borderSide: BorderSide(
                                    color: Color(
                                        controller.textFieldBorderColor.value),
                                    width: 2.w),
                              ),
                            ),
                          ),
                        ),
                      ),
                      controller.showServicesSuggestions.value
                          ? controller.filteredOptions.isNotEmpty
                              ? SizedBox(
                                  height:
                                      controller.isLoggedIn.value == "loggedOut"
                                          ? 220.h
                                          : 350.h,
                                  child: ListView.builder(
                                    itemCount:
                                        controller.filteredOptions.length,
                                    itemBuilder: (context, index) {
                                      return buildServiceOptions(index);
                                    },
                                  ),
                                )
                              : controller.isSearchingQuery.value
                                  ? SizedBox(
                                      height: MediaQuery.of(Get.context!)
                                              .size
                                              .height /
                                          7,
                                      child: Center(
                                          child: SizedBox(
                                        height: 26.h,
                                        width: 26.w,
                                        child: const CircularProgressIndicator(
                                          color: Color(MyColors.themeRedColor),
                                        ),
                                      )),
                                    )
                                  : Container()
                          : const SizedBox(),
                      controller.showServicesSuggestions.value == false
                          ? SizedBox(
                              width:
                                  MediaQuery.of(Get.context!).size.width * 0.9,
                              child: Padding(
                                padding: EdgeInsets.only(
                                    top: 50.0.h, left: 8.w, right: 8.w),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    SvgPicture.asset(
                                      "lib/assets/icons/bookIconsvg.svg",
                                      height: 38.h,
                                      width: 38.w,
                                      fit: BoxFit.contain,
                                    ),
                                    Expanded(
                                      child: Padding(
                                          padding:
                                              EdgeInsets.only(left: 12.0.w),
                                          child: Text(
                                              Strings.selectServiceInfo1(
                                                  Get.context!),
                                              textAlign: TextAlign.start,
                                              style: TextStyle(
                                                  color:
                                                      const Color(0x9C000000),
                                                  fontSize: 14.5.sp,
                                                  fontWeight: FontWeight.w400,
                                                  fontFamily: 'Poppins'))),
                                    )
                                  ],
                                ),
                              ),
                            )
                          : const SizedBox(),
                      controller.showServicesSuggestions.value == false
                          ? SizedBox(
                              width:
                                  MediaQuery.of(Get.context!).size.width * 0.9,
                              child: Padding(
                                padding: EdgeInsets.only(
                                    top: 32.0.h, left: 8.w, right: 8.w),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    SvgPicture.asset(
                                      "lib/assets/icons/personredsvg.svg",
                                      height: 38.h,
                                      width: 38.w,
                                      fit: BoxFit.contain,
                                    ),
                                    Expanded(
                                      child: Padding(
                                          padding:
                                              EdgeInsets.only(left: 12.0.w),
                                          child: Text(
                                              Strings.selectServiceInfo2(
                                                  Get.context!),
                                              textAlign: TextAlign.start,
                                              style: TextStyle(
                                                  color:
                                                      const Color(0x9C000000),
                                                  fontSize: 14.5.sp,
                                                  fontWeight: FontWeight.w400,
                                                  fontFamily: 'Poppins'))),
                                    )
                                  ],
                                ),
                              ),
                            )
                          : const SizedBox(),
                      controller.showServicesSuggestions.value == false
                          ? SizedBox(
                              width:
                                  MediaQuery.of(Get.context!).size.width * 0.9,
                              child: Padding(
                                padding: EdgeInsets.only(
                                    top: 32.0.h, left: 8.w, right: 8.w),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    SvgPicture.asset(
                                      "lib/assets/icons/resStarsvg.svg",
                                      fit: BoxFit.contain,
                                      height: 38.h,
                                      width: 38.w,
                                    ),
                                    Expanded(
                                      child: Padding(
                                          padding:
                                              EdgeInsets.only(left: 12.0.w),
                                          child: Text(
                                              "${Strings.moreThan(Get.context!)} 10,000+ ${Strings.independentReviews(Get.context!)}",
                                              textAlign: TextAlign.start,
                                              style: TextStyle(
                                                  color:
                                                      const Color(0x9C000000),
                                                  fontSize: 14.5.sp,
                                                  fontWeight: FontWeight.w400,
                                                  fontFamily: 'Poppins'))),
                                    )
                                  ],
                                ),
                              ),
                            )
                          : const SizedBox(),
                    ],
                  ),
                ),
              ],
            ),
          );
  }
}

class PostedOrdersSection extends StatefulWidget {
  const PostedOrdersSection({super.key});

  @override
  State<PostedOrdersSection> createState() => _PostedOrdersSectionState();
}

class _PostedOrdersSectionState extends State<PostedOrdersSection> {
  PostedOrdersController controller = Get.put(PostedOrdersController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(() {
        return Container(
          color: const Color(MyColors.lightSilverColor),
          child: Padding(
            padding: EdgeInsets.all(8.0.r),
            child: controller.isLoggedin.value == "loggedOut"
                ? _buildNoLoginView()
                : Column(
                    children: [
                      Align(
                        alignment: Alignment.topLeft,
                        child: Padding(
                          padding: EdgeInsets.only(left: 10.0.r),
                          child: HeadingTextW600(
                              text: Strings.myPostedOrders(context),
                              centerAlign: false,
                              size: 22.sp),
                        ),
                      ),
                      _buildFilterOptionsView(),
                      controller.isLoading.value == false
                          ? Expanded(
                              child: SingleChildScrollView(
                                child: Column(
                                  children: [
                                    controller.postedOrdersList.isNotEmpty
                                        ? ListView.builder(
                                            itemCount: controller
                                                .postedOrdersList.length,
                                            physics:
                                                const NeverScrollableScrollPhysics(), // important
                                            shrinkWrap: true,
                                            itemBuilder: (context, index) {
                                              return _buildOrderView(
                                                  controller.postedOrdersList
                                                      .elementAt(index),
                                                  index);
                                            },
                                          )
                                        : controller.selectedTabName == "all"
                                            ? _buildNoJobPostedView()
                                            : _buildNoJobPostedView2(),
                                    controller.totalpostedOrders >
                                            controller.postedOrdersList.length
                                        ? _buildLoadMoreButton()
                                        : const SizedBox()
                                  ],
                                ),
                              ),
                            )
                          : SizedBox(
                              height: MediaQuery.of(context).size.height / 2,
                              child: const Center(
                                child: CircularProgressIndicator(
                                  color: Color(MyColors.themeRedColor),
                                ),
                              ),
                            ),
                    ],
                  ),
          ),
        );
      }),
    );
  }

  Widget _buildFilterOptionsView() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Padding(
        padding: EdgeInsets.all(8.0.r),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            GestureDetector(
              onTap: () {
                controller.selectedTabName.value = "all";
                controller.isLoading.value = true;
                controller.status.value = "";
                controller.getPostedOrdersList(1, controller.status.value);
              },
              child: Card(
                elevation: 0,
                color: controller.selectedTabName.value == "all"
                    ? const Color(MyColors.themeRedColor)
                    : const Color(MyColors.whiteColor),
                child: Padding(
                  padding: EdgeInsets.only(
                      left: 10.0.w, right: 10.0.w, top: 2.0.h, bottom: 2.0.h),
                  child: Text(Strings.allText(Get.context!),
                      textAlign: TextAlign.start,
                      style: TextStyle(
                          color: controller.selectedTabName.value == "all"
                              ? const Color(MyColors.whiteColor)
                              : const Color(MyColors.blackColor),
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w400,
                          fontFamily: 'Poppins')),
                ),
              ),
            ),
            GestureDetector(
              onTap: () {
                controller.selectedTabName.value = "inprocess";
                controller.isLoading.value = true;
                controller.status.value = "open";
                controller.getPostedOrdersList(1, controller.status.value);
              },
              child: Column(
                children: [
                  Card(
                    elevation: 0,
                    color: controller.selectedTabName.value == "inprocess"
                        ? const Color(MyColors.themeRedColor)
                        : const Color(MyColors.whiteColor),
                    child: Padding(
                      padding: EdgeInsets.only(
                          left: 10.0.w,
                          right: 10.0.w,
                          top: 2.0.h,
                          bottom: 2.0.h),
                      child: Text(Strings.inProcess(Get.context!),
                          textAlign: TextAlign.start,
                          style: TextStyle(
                              color: controller.selectedTabName.value ==
                                      "inprocess"
                                  ? const Color(MyColors.whiteColor)
                                  : const Color(MyColors.blackColor),
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w400,
                              fontFamily: 'Poppins')),
                    ),
                  ),
                ],
              ),
            ),
            GestureDetector(
              onTap: () {
                controller.isLoading.value = true;
                controller.selectedTabName.value = "Active";
                controller.status.value = "in_progress";
                controller.getPostedOrdersList(1, controller.status.value);
              },
              child: Column(
                children: [
                  Card(
                    elevation: 0,
                    color: controller.selectedTabName.value == "Active"
                        ? const Color(MyColors.themeRedColor)
                        : const Color(MyColors.whiteColor),
                    child: Padding(
                      padding: EdgeInsets.only(
                          left: 10.0.w,
                          right: 10.0.w,
                          top: 2.0.h,
                          bottom: 2.0.h),
                      child: Text(Strings.active(Get.context!),
                          textAlign: TextAlign.start,
                          style: TextStyle(
                              color:
                                  controller.selectedTabName.value == "Active"
                                      ? const Color(MyColors.whiteColor)
                                      : const Color(MyColors.blackColor),
                              fontSize: 14.0.sp,
                              fontWeight: FontWeight.w400,
                              fontFamily: 'Poppins')),
                    ),
                  ),
                ],
              ),
            ),
            GestureDetector(
              onTap: () {
                controller.isLoading.value = true;
                controller.selectedTabName.value = "completed";
                controller.status.value = "completed";
                controller.getPostedOrdersList(1, controller.status.value);
              },
              child: Column(
                children: [
                  Card(
                    elevation: 0,
                    color: controller.selectedTabName.value == "completed"
                        ? const Color(MyColors.themeRedColor)
                        : const Color(MyColors.whiteColor),
                    child: Padding(
                      padding: EdgeInsets.only(
                          left: 10.0.w,
                          right: 10.0.w,
                          top: 2.0.h,
                          bottom: 2.0.h),
                      child: Text(Strings.completed(Get.context!),
                          textAlign: TextAlign.start,
                          style: TextStyle(
                              color: controller.selectedTabName.value ==
                                      "completed"
                                  ? const Color(MyColors.whiteColor)
                                  : const Color(MyColors.blackColor),
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w400,
                              fontFamily: 'Poppins')),
                    ),
                  ),
                ],
              ),
            ),
            GestureDetector(
              onTap: () {
                controller.isLoading.value = true;
                controller.selectedTabName.value = "canceled";
                controller.status.value = "cancelled";
                controller.getPostedOrdersList(1, controller.status.value);
              },
              child: Column(
                children: [
                  Card(
                    elevation: 0,
                    color: controller.selectedTabName.value == "canceled"
                        ? const Color(MyColors.themeRedColor)
                        : const Color(MyColors.whiteColor),
                    child: Padding(
                      padding: EdgeInsets.only(
                          left: 10.0.w,
                          right: 10.0.w,
                          top: 2.0.h,
                          bottom: 2.0.h),
                      child: Text(Strings.canceledText(Get.context!),
                          textAlign: TextAlign.start,
                          style: TextStyle(
                              color:
                                  controller.selectedTabName.value == "canceled"
                                      ? const Color(MyColors.whiteColor)
                                      : const Color(MyColors.blackColor),
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w400,
                              fontFamily: 'Poppins')),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
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
                  fixedSize: WidgetStatePropertyAll(Size.fromWidth(
                      MediaQuery.of(Get.context!).size.width / 2)),
                  foregroundColor: const WidgetStatePropertyAll(
                      Color(MyColors.infoPinkColor2)),
                  elevation: const WidgetStatePropertyAll(0)),
              onPressed: () {
                try {
                  if (controller.postedOrders!.pagination != null) {
                    if (controller.postedOrders!.pagination!.hasMore ?? false) {
                      int page =
                          controller.postedOrders!.pagination!.currentPage! + 1;
                      controller.isLoadingMore.value = true;
                      controller.getPostedOrdersList(
                          page, controller.status.value);
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

  Widget _buildNoJobPostedView() {
    return SizedBox(
      height: MediaQuery.of(Get.context!).size.height * 0.6,
      child: Padding(
        padding: EdgeInsets.all(8.0.r),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Spacer(),
            Image.asset(
              "lib/assets/images/noorderspostedicon.png",
              width: MediaQuery.of(Get.context!).size.width.w,
              height: MediaQuery.of(Get.context!).size.height.h / 5,
              fit: BoxFit.contain,
            ),
            Padding(
              padding: EdgeInsets.all(12.0.r),
              child: HeadingTextW700(
                text: Strings.noOrders(Get.context!),
                centerAlign: true,
                size: 22.sp,
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 12.0.r),
              child: Headingdescription(
                text: Strings.startPostingYourOrders(Get.context!),
                centerAlign: true,
                size: 13.0.sp,
              ),
            ),
            const Spacer(),
          ],
        ),
      ),
    );
  }

  Widget _buildNoJobPostedView2() {
    return SizedBox(
      height: MediaQuery.of(Get.context!).size.height.h * 0.6,
      child: Padding(
        padding: EdgeInsets.all(8.0.r),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Spacer(),
            Padding(
              padding: EdgeInsets.all(12.0.r),
              child: HeadingTextW700(
                text: controller.selectedTabName == "Active"
                    ? Strings.noActiveOrders(Get.context!)
                    : controller.selectedTabName == "inprocess"
                        ? Strings.noInProcessOrders(Get.context!)
                        : controller.selectedTabName == "completed"
                            ? Strings.noCompleteOrders(Get.context!)
                            : Strings.noCancelOrders(Get.context!),
                centerAlign: true,
                size: 22.sp,
              ),
            ),
            const Spacer(),
          ],
        ),
      ),
    );
  }

  Widget _buildNoLoginView() {
    return Column(
      children: [
        Expanded(
          child: Padding(
            padding: EdgeInsets.all(8.0.r),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Spacer(),
                SvgPicture.asset("lib/assets/icons/noorderspostedicon.svg",
                    width: MediaQuery.of(Get.context!).size.width.w,
                    height: MediaQuery.of(Get.context!).size.height.h / 7,
                    fit: BoxFit.contain),
                Padding(
                  padding: EdgeInsets.all(12.0.r),
                  child: HeadingTextW600(
                      text: Strings.myOrders(Get.context!),
                      centerAlign: true,
                      size: 20.sp),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 12.0.r, right: 12.0.r),
                  child: Headingdescription(
                      text: Strings.pleaseLoginToSeeOrders(Get.context!),
                      centerAlign: true,
                      size: 13.5.sp),
                ),
                Padding(
                  padding:
                      EdgeInsets.only(left: 12.0.r, right: 12.0.r, top: 20.0.r),
                  child: FullWidthButtonPrimary(
                      text: Strings.loginText(Get.context!),
                      fontsize: 15.0.sp,
                      color: MyColors.themeRedColor,
                      onPressed: () {
                        Constants.fromWhere = "SelectServiceScreen";
                        Get.toNamed(AppLinks.login_screen);
                      }),
                ),
                const Spacer(),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildOrderView(PostedJobDetail job, int index) {
    return GestureDetector(
      onTap: () async {
        try {
          var res = await Get.toNamed(AppLinks.orders_details_screen,
              arguments: {'jobId': job.id ?? -1});
          if (res == "back") {
            Commons.showProgressDialog(Get.context!);
            controller.updateJobObject(job.id!, index);
          }
        } catch (e) {
          throw Exception(e);
        }
      },
      child: Card(
        elevation: 0,
        color: const Color(MyColors.whiteColor),
        child: Padding(
          padding: EdgeInsets.all(8.0.r),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.only(left: 8.0.r, right: 8.0.r, top: 8.0.r),
                child: HeadingTextW600(
                    text: job.title ?? "N/A", centerAlign: false, size: 18.sp),
              ),
              Padding(
                padding: EdgeInsets.only(left: 8.0.r, right: 8.0.r),
                child: HeadingTextW500(
                    text: job.serviceName ?? "N/A",
                    centerAlign: false,
                    size: 15.sp),
              ),
              Padding(
                padding: EdgeInsets.only(left: 8.0.r, right: 8.0.r),
                child: RichText(
                  text: TextSpan(
                    text:
                        '${Strings.postedAt(Get.context!)}: ', // default style
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 12.sp,
                      fontFamily: 'Poppins',
                    ),
                    children: <TextSpan>[
                      TextSpan(
                        text: job.humanReadableCreatedAt ?? "N/A",
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 12.sp,
                          fontFamily: 'Poppins',
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Obx(() {
                return Padding(
                  padding: EdgeInsets.only(left: 4.0.r, top: 4.0.r),
                  child: Card(
                    elevation: 0,
                    color: job.status!.value == "open"
                        ? const Color(MyColors.cardColorSky200)
                        : job.status!.value == "in_progress"
                            ? const Color(MyColors.cardColorGreenLight)
                            : job.status!.value == "cancelled"
                                ? const Color(MyColors.cardcolorOrange200)
                                : const Color(MyColors.cardColorGreen200),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(6.r)),
                    child: Padding(
                      padding: EdgeInsets.all(3.0.r),
                      child: job.status!.value == "open"
                          ? Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                SvgPicture.asset(
                                    "lib/assets/icons/inprocessIcon.svg",
                                    height: 14.0.h,
                                    width: 14.0.w),
                                SizedBox(
                                  width: 2.0.w,
                                ),
                                Headingdescription(
                                    text: Strings.inProcess(Get.context!),
                                    centerAlign: false,
                                    size: 12.sp)
                              ],
                            )
                          : job.status!.value == "in_progress"
                              ? Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Lottie.asset(
                                      'lib/assets/icons/ActiveStatusRipple.json',
                                      width: 14.w,
                                      height: 14.h,
                                      fit: BoxFit.contain,
                                      repeat: true,
                                      animate: true,
                                    ),
                                    SizedBox(
                                      width: 2.0.w,
                                    ),
                                    Headingdescription(
                                        text: Strings.active(Get.context!),
                                        centerAlign: false,
                                        size: 12.sp)
                                  ],
                                )
                              : job.status!.value == "cancelled"
                                  ? Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        SvgPicture.asset(
                                            "lib/assets/icons/jobCancelledIcon.svg",
                                            height: 14.0.h,
                                            width: 14.0.w),
                                        SizedBox(
                                          width: 2.0.w,
                                        ),
                                        Headingdescription(
                                            text: Strings.canceledText(
                                                Get.context!),
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
                                          width: 2.0.w,
                                        ),
                                        Headingdescription(
                                            text:
                                                Strings.completed(Get.context!),
                                            centerAlign: false,
                                            size: 12.sp)
                                      ],
                                    ),
                    ),
                  ),
                );
              }),
              Padding(
                padding:
                    EdgeInsets.only(left: 8.0.w, right: 8.0.w, top: 12.0.h),
                child: Text(job.desc ?? "N/A",
                    textAlign: TextAlign.start,
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w400,
                        fontFamily: 'Poppins')),
              ),
              Obx(() {
                return job.tradespersonApplicationsCount == null
                    ? const SizedBox()
                    : job.tradespersonApplicationsCount!.value == 0
                        ? const SizedBox()
                        : Padding(
                            padding: EdgeInsets.only(
                                left: 6.0.w, right: 6.0.w, top: 4.0.h),
                            child: Card(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(6.r)),
                              elevation: 0,
                              color: const Color(MyColors.colorNeutral100),
                              child: Padding(
                                padding: EdgeInsets.all(6.0.r),
                                child: Row(
                                  children: [
                                    Expanded(
                                      flex: 24,
                                      child: Center(
                                        child: Column(
                                          children: [
                                            job.tradespersonApplicationsCount !=
                                                    null
                                                ? HeadingTextW600(
                                                    text:
                                                        '${job.tradespersonApplicationsCount!.value}',
                                                    centerAlign: false,
                                                    size: 20.sp)
                                                : const SizedBox(),
                                            Headingdescription(
                                                text: Strings.interested(
                                                    Get.context!),
                                                centerAlign: false,
                                                size: 14.sp)
                                          ],
                                        ),
                                      ),
                                    ),
                                    Center(
                                      child: SizedBox(
                                        width: 1.0.w,
                                        height: 40.0.h,
                                        child: Container(
                                            color: const Color(
                                                MyColors.silverColor)),
                                      ),
                                    ),
                                    Expanded(
                                      flex: 24,
                                      child: Center(
                                        child: Column(
                                          children: [
                                            job.inContactTradesmenCount != null
                                                ? HeadingTextW600(
                                                    text:
                                                        '${job.inContactTradesmenCount!.value}',
                                                    centerAlign: false,
                                                    size: 20.sp)
                                                : const SizedBox(),
                                            Headingdescription(
                                                text: Strings.chatText(
                                                    Get.context!),
                                                centerAlign: false,
                                                size: 14.sp)
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
              }),
              job.status!.value == "open"
                  ? Padding(
                      padding: EdgeInsets.only(
                          left: 4.0.w, right: 4.0.w, top: 6.0.h, bottom: 3.0.h),
                      child: GestureDetector(
                        onTap: () async {
                          if (job.tradespersonRequestsCount!.value == "10") {
                            Fluttertoast.showToast(
                                msg: Strings.youHaveReachedLimit(Get.context!));
                            return;
                          }
                          int remainingReqCount =
                              controller.getRemainingTrademenRequests(int.parse(
                                  job.tradespersonRequestsCount!.value));
                          var result = await Get.toNamed(
                            AppLinks.job_recommendations,
                            arguments: {
                              'jobId': job.id,
                              'remainingRequeststoSend': remainingReqCount,
                              'fromWhere': 'MyOrders'
                            },
                          );
                          if (result != null) {
                            job.tradespersonRequestsCount!.value =
                                (10 - result).toString();
                          }
                        },
                        child: Card(
                          elevation: 0,
                          color: const Color(MyColors.lightSilverColor),
                          child: Padding(
                            padding: EdgeInsets.all(8.0.r),
                            child: Obx(() {
                              return RichText(
                                text: TextSpan(
                                  text: '',
                                  style: TextStyle(
                                      color: Colors.black, fontSize: 13.sp),
                                  children: <TextSpan>[
                                    TextSpan(
                                      text:
                                          '${Strings.sendARequestText(context)} ',
                                      style: TextStyle(
                                          fontFamily: 'Poppins',
                                          fontSize: 13.sp,
                                          fontWeight: FontWeight.bold,
                                          color: const Color(
                                              MyColors.themeRedColor)),
                                    ),
                                    TextSpan(
                                      text: controller.getRemainingTrademenRequests(
                                                  int.parse(job
                                                      .tradespersonRequestsCount!
                                                      .value)) ==
                                              1
                                          ? Strings.toMore1TradesmenText(
                                              Get.context!)
                                          : controller.getRemainingTrademenRequests(
                                                      int.parse(job
                                                          .tradespersonRequestsCount!
                                                          .value)) ==
                                                  2
                                              ? Strings.toMore2TradesmenText(Get.context!)
                                              : controller.getRemainingTrademenRequests(int.parse(job.tradespersonRequestsCount!.value)) == 3
                                                  ? Strings.toMore3TradesmenText(Get.context!)
                                                  : controller.getRemainingTrademenRequests(int.parse(job.tradespersonRequestsCount!.value)) == 4
                                                      ? Strings.toMore4TradesmenText(Get.context!)
                                                      : controller.getRemainingTrademenRequests(int.parse(job.tradespersonRequestsCount!.value)) == 5
                                                          ? Strings.toMore5TradesmenText(Get.context!)
                                                          : controller.getRemainingTrademenRequests(int.parse(job.tradespersonRequestsCount!.value)) == 6
                                                              ? Strings.toMore6TradesmenText(Get.context!)
                                                              : controller.getRemainingTrademenRequests(int.parse(job.tradespersonRequestsCount!.value)) == 7
                                                                  ? Strings.toMore7TradesmenText(Get.context!)
                                                                  : controller.getRemainingTrademenRequests(int.parse(job.tradespersonRequestsCount!.value)) == 8
                                                                      ? Strings.toMore8TradesmenText(Get.context!)
                                                                      : controller.getRemainingTrademenRequests(int.parse(job.tradespersonRequestsCount!.value)) == 9
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
                              );
                            }),
                          ),
                        ),
                      ),
                    )
                  : const SizedBox()
            ],
          ),
        ),
      ),
    );
  }
}

class ProfileSection extends StatefulWidget {
  final String isLoggedin;
  const ProfileSection({super.key, required this.isLoggedin});

  @override
  State<ProfileSection> createState() => _ProfileSectionState();
}

class _ProfileSectionState extends State<ProfileSection> {
  bool isLoading = true.obs();
  String selectedTabName = "all";
  // final PostedOrdersController controller = Get.put(PostedOrdersController());
  final ImagePicker _picker = ImagePicker();
  late SharedPreferences _prefs;
  String imageUrl = "";
  String userName = "";
  ProfileController controller = Get.put(ProfileController());
  File? _selectedImage;

  Future<void> _pickImage() async {
    final XFile? pickedFile =
        await _picker.pickImage(source: ImageSource.gallery);

    if (pickedFile == null) {
      Fluttertoast.showToast(
          msg: Strings.somethingWentWrongPickingImages(context));
      return;
    }

    setState(() {
      _selectedImage = File(pickedFile.path);
    });
    Commons.showProgressDialog(context);
    bool res =
        await controller.pleaseUpdateProfileImage(_selectedImage!, context);
    if (res) {
      Commons.hideProgressDialog();
      getProfileImage();
    } else {
      Commons.hideProgressDialog();
    }
  }

  void checkIsLoggedIn() async {
    if (widget.isLoggedin == "loggedOut") {
      setState(() {
        isLoading = false.obs();
      });
    } else {
      setState(() {
        isLoading = false.obs();
      });
      _prefs = await SharedPreferences.getInstance();
      getProfileImage();
      updateNameValue();
    }
  }

  @override
  void initState() {
    super.initState();
    checkIsLoggedIn();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        backgroundColor: const Color(MyColors.lightSilverColor),
        body: Padding(
          padding: EdgeInsets.all(8.0.r),
          child: SingleChildScrollView(
            child: Column(
              children: [
                widget.isLoggedin == "loggedOut"
                    ? _buildNoLoginView()
                    : const SizedBox(),
                widget.isLoggedin != "loggedOut"
                    ? _buildImageView()
                    : const SizedBox(),
                widget.isLoggedin != "loggedOut"
                    ? HeadingTextW600(
                        text: userName, centerAlign: true, size: 18.sp)
                    : const SizedBox(),
                widget.isLoggedin != "loggedOut"
                    ? SizedBox(
                        height: 20.h,
                      )
                    : const SizedBox(),
                widget.isLoggedin != "loggedOut"
                    ? Align(
                        alignment: Alignment.topLeft,
                        child: Padding(
                          padding: EdgeInsets.only(
                              left: 12.0.r, top: 8.0.h, bottom: 8.0.h),
                          child: HeadingTextW600(
                              text: Strings.account(context),
                              centerAlign: false,
                              size: 16.sp),
                        ))
                    : const SizedBox(),
                widget.isLoggedin != "loggedOut"
                    ? Padding(
                        padding: EdgeInsets.only(left: 8.0.r, right: 8.0.r),
                        child: ProfileInfoCard(
                          icon: "lib/assets/icons/contactInfoIcon.svg",
                          text: Strings.contactInformation(context),
                          onPressed: () async {
                            try {
                              await Get.to(
                                const ContactInformationScreen(),
                              );
                              updateNameValue();
                            } catch (e) {
                              throw Exception(e);
                            }
                          },
                        ),
                      )
                    : const SizedBox(),
                widget.isLoggedin != "loggedOut"
                    ? Padding(
                        padding: EdgeInsets.only(left: 8.0.r, right: 8.0.r),
                        child: ProfileInfoCard(
                          icon: "lib/assets/icons/manageAccountIcon.svg",
                          text: Strings.manageAccount(context),
                          onPressed: () {
                            try {
                              Get.to(
                                const ManageAccountScreen(),
                                transition: Transition
                                    .rightToLeft, // Left-to-right animation
                                duration: const Duration(
                                    milliseconds:
                                        500), // Optional: animation duration
                              );
                            } catch (e) {
                              throw Exception(e);
                            }
                          },
                        ),
                      )
                    : const SizedBox(),
                Align(
                    alignment: Alignment.topLeft,
                    child: Padding(
                      padding: EdgeInsets.only(
                          left: 12.0.r, top: 8.0.h, bottom: 8.0.h),
                      child: HeadingTextW600(
                          text: Strings.settingsText(context),
                          centerAlign: false,
                          size: 16.sp),
                    )),
                widget.isLoggedin != "loggedOut"
                    ? Padding(
                        padding: EdgeInsets.only(left: 8.0.r, right: 8.0.r),
                        child: ProfileInfoCard(
                          icon: "lib/assets/icons/bellIcon.svg",
                          text: Strings.notifications(context),
                          onPressed: () {
                            try {
                              Get.toNamed(AppLinks.notification_setting_screen);
                            } catch (e) {
                              throw Exception(e);
                            }
                          },
                        ),
                      )
                    : const SizedBox(),
                Padding(
                  padding: EdgeInsets.only(left: 8.0.r, right: 8.0.r),
                  child: ProfileInfoCard(
                    icon: "lib/assets/icons/languageIcon.svg",
                    text: Strings.languageText(context),
                    onPressed: () {
                      try {
                        Get.to(
                          const ChangeLanguageScreen(),
                          transition:
                              Transition.rightToLeft, // Left-to-right animation
                          duration: const Duration(
                              milliseconds:
                                  500), // Optional: animation duration
                        );
                      } catch (e) {
                        throw Exception(e);
                      }
                    },
                  ),
                ),
                Align(
                    alignment: Alignment.topLeft,
                    child: Padding(
                      padding: EdgeInsets.only(
                          left: 12.0.r, top: 8.0.h, bottom: 8.0.h),
                      child: HeadingTextW600(
                          text: Strings.help(context),
                          centerAlign: false,
                          size: 16.sp),
                    )),
                Padding(
                  padding: EdgeInsets.only(left: 8.0.r, right: 8.0.r),
                  child: ProfileInfoCard(
                    icon: "lib/assets/icons/supportcentreIcon.svg",
                    text: Strings.supportCenter(context),
                    onPressed: () {
                      try {} catch (e) {
                        throw Exception(e);
                      }
                    },
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 8.0.r, right: 8.0.r),
                  child: ProfileInfoCard(
                    icon: "lib/assets/icons/contactIcon.svg",
                    text: Strings.contact(context),
                    onPressed: () {
                      try {} catch (e) {
                        throw Exception(e);
                      }
                    },
                  ),
                ),
                Align(
                    alignment: Alignment.topLeft,
                    child: Padding(
                      padding: EdgeInsets.only(
                          left: 12.0.r, top: 8.0.h, bottom: 8.0.h),
                      child: HeadingTextW600(
                          text: Strings.auftragText(context),
                          centerAlign: false,
                          size: 16.sp),
                    )),
                Padding(
                  padding: EdgeInsets.only(left: 8.0.r, right: 8.0.r),
                  child: ProfileInfoCard(
                    icon: "lib/assets/icons/bookIcon.svg",
                    text: Strings.legalGuidelines(context),
                    onPressed: () {
                      try {} catch (e) {
                        throw Exception(e);
                      }
                    },
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 8.0.r, right: 8.0.r),
                  child: ProfileInfoCard(
                    icon: "lib/assets/icons/eyeOffIcon.svg",
                    text: Strings.dataSafeguards(context),
                    onPressed: () {
                      try {
                        Get.toNamed(AppLinks.terms_and_conditions);
                      } catch (e) {
                        throw Exception(e);
                      }
                    },
                  ),
                ),
                widget.isLoggedin == "loggedOut"
                    ? const SizedBox()
                    : Padding(
                        padding: EdgeInsets.all(12.0.r),
                        child: SizedBox(
                          width: MediaQuery.of(context).size.width,
                          child: ElevatedButton(
                            onPressed: () async {
                              try {
                                logoutUser();
                              } catch (e) {
                                throw Exception(e);
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              padding: EdgeInsets.all(12.0.r),
                              elevation: 0,
                              backgroundColor: const Color(
                                  MyColors.themeRedColor), // Button color
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(
                                    8), // Optional rounded corners
                              ),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                SvgPicture.asset(
                                  "lib/assets/icons/logoutIcon.svg",
                                  height: 22.h,
                                  width: 22.w,
                                ),
                                SizedBox(width: 8.r),
                                Padding(
                                  padding: EdgeInsets.only(left: 6.0.r),
                                  child: Text(
                                    Strings.logoutText(context),
                                    style: TextStyle(
                                      fontSize: 16
                                          .sp, // Adjust font size to fit inside
                                      color: const Color(
                                          MyColors.whiteColor), // Text color
                                    ),
                                    textAlign: TextAlign.center,
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
    );
  }

  Widget _buildNoLoginView() {
    return Padding(
      padding: EdgeInsets.all(12.0.r),
      child: Card(
        elevation: 0,
        color: Colors.white,
        child: Padding(
          padding: EdgeInsets.all(12.0.r),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SvgPicture.asset(
                "lib/assets/icons/noProfileIcon.svg",
                fit: BoxFit.contain,
                width: 50.w,
                height: 50.h,
              ),
              Padding(
                padding: EdgeInsets.all(8.0.r),
                child: HeadingTextW500(
                    text: Strings.pleaseLoginToSeeprofileText(Get.context!),
                    centerAlign: true,
                    size: 16.sp),
              ),
              Padding(
                padding: EdgeInsets.all(12.0.r),
                child: FullWidthElevatedButton(
                    text: Strings.loginText(Get.context!),
                    color: MyColors.themeRedColor,
                    onPressed: () {
                      Constants.fromWhere = "SelectServiceScreen";
                      Get.toNamed(AppLinks.login_screen);
                    },
                    textColor: MyColors.whiteColor),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildImageView() {
    return Stack(
      children: [
        Padding(
            padding: EdgeInsets.all(6.0.r),
            child: SizedBox(
                height: 96.h,
                width: 96.w,
                child: Stack(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: SizedBox(
                        height: 90.h,
                        width: 90.w,
                        child: imageUrl.isNotEmpty
                            ? Image.network(
                                imageUrl,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) {
                                  return SvgPicture.asset(
                                    "lib/assets/images/tradesmenplaceholdericon.svg",
                                    fit: BoxFit.cover,
                                    height: 100.h,
                                    width: 110.w,
                                  );
                                },
                              )
                            : _selectedImage != null
                                ? Image.file(_selectedImage!,
                                    width: 100.w,
                                    height: 110.h,
                                    fit: BoxFit.cover)
                                : SvgPicture.asset(
                                    "lib/assets/images/tradesmenplaceholdericon.svg",
                                    fit: BoxFit.cover,
                                    height: 100.h,
                                    width: 110.w,
                                  ),
                      ),
                    ),
                    Positioned(
                      right: 1,
                      bottom: 1,
                      child: GestureDetector(
                        onTap: () {
                          try {
                            _pickImage();
                          } catch (e) {
                            throw Exception(e);
                          }
                        },
                        child: SvgPicture.asset(
                          "lib/assets/icons/uploadImageicon.svg",
                          fit: BoxFit.cover,
                          height: 22.h,
                          width: 22.w,
                        ),
                      ),
                    )
                  ],
                ))),
      ],
    );
  }

  Future<void> updateNameValue() async {
    userName = _prefs.getString('name') ?? "";
    setState(() {});
  }

  Future<void> getProfileImage() async {
    imageUrl = _prefs.getString('profile_img') ?? "";
    _selectedImage = null;
    if (mounted) {
      setState(() {});
    }
  }

  void logoutUser() async {
    _prefs = await SharedPreferences.getInstance();
    await _prefs.setString('isLogin', "loggedOut");
    Get.offAllNamed(AppLinks.select_service_screen);
    Constants.unReadcount.value = 0;
    Constants.unreadNotificationsCount.value = 0;
    // Get.to(
    //   const SelectServiceScreen(),
    //   transition: Transition.rightToLeft, // Left-to-right animation
    //   duration:
    //       const Duration(milliseconds: 500), // Optional: animation duration
    // );
  }
}
