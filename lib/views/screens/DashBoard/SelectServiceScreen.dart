import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
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
import 'package:workforceclientapp/Models/Services.dart';
import 'package:workforceclientapp/Others/Commons.dart';
import 'package:workforceclientapp/Others/Constants.dart';
import 'package:workforceclientapp/Others/MyColors.dart';
import 'package:workforceclientapp/Others/Strings.dart';
import 'package:workforceclientapp/Others/routes.dart';
import 'package:workforceclientapp/views/screens/Chat/AllChats.dart';
import 'package:workforceclientapp/views/screens/Notifications/NotificationsScreen.dart';
import 'package:workforceclientapp/views/screens/Profile/ContactInformationScreen.dart';
import 'package:workforceclientapp/views/widgets/ContinueLastJobCard.dart';
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
    return Scaffold(
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
            enableFeedback: true,
            showSelectedLabels: true,
            elevation: 7,
            selectedLabelStyle: const TextStyle(fontFamily: 'Poppins'),
            unselectedLabelStyle: const TextStyle(fontFamily: 'Poppins'),
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
                      ? SvgPicture.asset("lib/assets/icons/postjobRedIcon.svg")
                      : SvgPicture.asset(
                          "lib/assets/icons/postjobBlackIcon.svg"),
                  label: Strings.postJob(context),
                  backgroundColor: const Color(MyColors.whiteColor)),
              BottomNavigationBarItem(
                  icon: controller.currentIndex.value == 1
                      ? SvgPicture.asset("lib/assets/icons/myordersRedIcon.svg")
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
                      ? SvgPicture.asset("lib/assets/icons/profileRedicon.svg")
                      : SvgPicture.asset(
                          "lib/assets/icons/profileBlackicon.svg"),
                  label: Strings.profile(context),
                  backgroundColor: const Color(MyColors.whiteColor)),
            ],
            selectedItemColor:
                const Color(MyColors.themeRedColor), // Active tab color
            unselectedItemColor: const Color(0x9C000000), // Inactive tab color
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
        }));
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

  Widget buildServiceListItem(Services service) {
    return GestureDetector(
      onTap: () async {
        try {
          controller.searchController.value.text = service.name!;
          controller.selectedServiceName = service.name!;
          controller.selectedServiceId = service.id!;
        } catch (e) {
          e.printError();
        }

        Commons.showProgressDialog(Get.context!);
        await controller.pleaseGetAllServiceQuestions(
            controller.selectedServiceId, controller.selectedServiceName);
        Commons.hideProgressDialog();
      },
      child: Card(
        elevation: 0,
        margin: EdgeInsets.zero,
        color: const Color(MyColors.cardGrayColor50),
        shape: RoundedRectangleBorder(
            side: const BorderSide(color: Color.fromARGB(255, 212, 212, 212)),
            borderRadius: BorderRadius.circular(8.0.r)),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 12.0.w, vertical: 12.0.h),
          child: Row(
            children: [
              service.icon != null
                  ? SvgPicture.network(
                      service.icon!.url!,
                      height: 40.h,
                      width: 40.w,
                      fit: BoxFit.contain,
                      errorBuilder: (context, error, stackTrace) {
                        return SvgPicture.asset(
                          "lib/assets/images/tradesmenplaceholdericon.svg",
                          fit: BoxFit.contain,
                          height: 40.h,
                          width: 40.w,
                        );
                      },
                    )
                  : SvgPicture.asset(
                      "lib/assets/icons/bookIcon.svg",
                      fit: BoxFit.contain,
                      height: 40.h,
                      width: 40.w,
                    ),
              SizedBox(width: 12.w),
              Expanded(
                child: AutoSizeText(
                  '${service.name}',
                  maxLines: 3,
                  minFontSize: 10,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontSize: 15),
                ),
              ),
              const Icon(Icons.chevron_right, color: Color(0x9C000000)),
            ],
          ),
        ),
      ),
    );
  }

  Widget mainScreenUI() {
    return RefreshIndicator(
      color: const Color(MyColors.themeRedColor),
      onRefresh: () async {
        controller.refreshData();
      },
      child: controller.isLoading.value
          ? const Center(
              child: CircularProgressIndicator(
              color: Color(MyColors.themeRedColor),
            ))
          : GestureDetector(
              onTap: () {
                FocusScope.of(Get.context!).unfocus();
              },
              child: CustomScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                keyboardDismissBehavior:
                    ScrollViewKeyboardDismissBehavior.onDrag,
                slivers: [
                  // 1. Scrollable header content (login card + headings)
                  SliverToBoxAdapter(
                    child: Column(
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
                                            Container(
                                              width: 34.w,
                                              height: 34.h,
                                              decoration: BoxDecoration(
                                                color: Colors.white,
                                                shape: BoxShape.circle,
                                                boxShadow: [
                                                  BoxShadow(
                                                    color: Colors.grey
                                                        .withOpacity(0.3),
                                                    blurRadius: 5,
                                                    spreadRadius: 2,
                                                    offset: const Offset(0, 2),
                                                  ),
                                                ],
                                              ),
                                              child: const Center(
                                                  child: Icon(
                                                      Icons.person_outline,
                                                      color: Color(MyColors
                                                          .themeRedColor),
                                                      size: 26)),
                                            ),
                                            SizedBox(width: 10.0.r),
                                            Expanded(
                                                child: Headingdescription(
                                                    text: Strings
                                                        .itSeemsYouAreNotLoginText(
                                                            Get.context!),
                                                    centerAlign: false,
                                                    size: 13.0.sp)),
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
                                              Constants.fromWhere =
                                                  "SelectServiceScreen";
                                              Get.toNamed(
                                                  AppLinks.login_screen);
                                            },
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor: const Color(
                                                  MyColors.themeRedColor),
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(8.r),
                                              ),
                                            ),
                                            child: Text(
                                              Strings.loginText(Get.context!),
                                              style: TextStyle(
                                                fontSize: 13.sp,
                                                color: Colors.white,
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
                        const ContinueLastJobCard(),
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
                              text: Strings.selectServiceHeading(Get.context!),
                              centerAlign: false),
                        ),
                        Align(
                          alignment: Alignment.topLeft,
                          child: Padding(
                            padding: EdgeInsets.only(left: 25.0.w, top: 18.0.h),
                            child: Headingdescription(
                                text: Strings.selectServiceDesc(Get.context!),
                                centerAlign: false,
                                size: 14.5.sp),
                          ),
                        ),
                      ],
                    ),
                  ),

                  // 2. Search field, pinned to the top while the list scrolls
                  SliverPersistentHeader(
                    pinned: true,
                    delegate: _PinnedHeaderDelegate(
                      height:
                          controller.searchInput.value.isNotEmpty ? 95.h : 74.h,
                      child: Container(
                        color: Colors.white,
                        padding: EdgeInsets.only(
                            top: 12.0.h,
                            left: 25.0.w,
                            right: 25.0.w,
                            bottom: 8.0.h),
                        child: _buildSearchField(),
                      ),
                    ),
                  ),

                  // 3. Services list
                  SliverToBoxAdapter(
                    child: Obx(() {
                      final services = controller.searchInput.value.isEmpty
                          ? controller.allListOptions.toList()
                          : controller.filteredOptions.toList();
                      if (services.isEmpty) {
                        return Padding(
                          padding: EdgeInsets.only(top: 40.0.h),
                          child: Center(
                            child: Text(
                                controller.searchInput.value.isEmpty
                                    ? ""
                                    : Strings.noDataFound(Get.context!),
                                style: TextStyle(
                                    color: const Color(0x9C000000),
                                    fontSize: 14.5.sp,
                                    fontFamily: 'Poppins')),
                          ),
                        );
                      }
                      return ListView.separated(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        padding: EdgeInsets.only(
                            top: 12.0.h,
                            left: 25.0.w,
                            right: 25.0.w,
                            bottom: 24.0.h),
                        separatorBuilder: (context, index) =>
                            SizedBox(height: 10.h),
                        itemCount: services.length,
                        itemBuilder: (context, index) {
                          return buildServiceListItem(services[index]);
                        },
                      );
                    }),
                  ),
                ],
              ),
            ),
    );
  }

  Widget _buildSearchField() {
    return Obx(() {
      return Column(
        children: [
          TextField(
            autofocus: false,
            enabled: controller.isEnabled.value,
            controller: controller.searchController.value,
            onTap: () {
              if (controller.searchInput.value.isEmpty) {
                controller.filterSearchResults(controller.searchInput.value);
              }
            },
            onChanged: (value) {
              controller.searchInput.value = value;
              controller.filterSearchResults(controller.searchInput.value);
            },
            cursorColor: const Color(MyColors.themeRedColor),
            decoration: InputDecoration(
              prefixIcon: const Icon(Icons.search, color: Colors.black),
              hintStyle: const TextStyle(color: Color(MyColors.lightGrayColor)),
              hintMaxLines: 1,
              hint: AutoSizeText(
                Strings.searchForServicesText(Get.context!),
                maxLines: 1,
                minFontSize: 9,
                maxFontSize: 16,
                overflow: TextOverflow.visible,
                style: const TextStyle(
                  fontSize: 16, // starting size
                  color: Color(MyColors.lightGrayColor),
                ),
              ),
              suffixIcon: Padding(
                padding: EdgeInsets.only(right: 6.0.w),
                child: GestureDetector(
                  onTap: () {
                    controller.searchController.value.text = "";
                    controller.searchInput.value = "";
                    controller.filteredOptions.value = [];
                  },
                  child: controller.searchInput.value.isNotEmpty
                      ? Stack(
                          alignment: Alignment.center,
                          children: [
                            Image.asset(
                              'lib/assets/images/select_service_suffixicon.png',
                              width: 30.w,
                              height: 30.h,
                            ),
                            Image.asset(
                              'lib/assets/icons/cancelicon.png',
                              width: 12.w,
                              height: 12.h,
                            ),
                          ],
                        )
                      : const SizedBox(),
                ),
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(8.r)),
                borderSide: BorderSide(
                    color: Color(controller.textFieldBorderColor.value),
                    width: 1.5.w),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(8.r)),
                borderSide: BorderSide(
                    color: Color(controller.textFieldBorderColor.value),
                    width: 2.w),
              ),
            ),
          ),
          controller.searchInput.value.isNotEmpty
              ? Padding(
                  padding: EdgeInsets.only(top: 4.0.h),
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: Text(
                        controller.searchInput.value.isEmpty
                            ? ""
                            : "${controller.filteredOptions.toList().length} ${Strings.resultsFoundText(Get.context!)}",
                        textAlign: TextAlign.left,
                        style: TextStyle(
                            color: const Color(0x9C000000),
                            fontSize: 12.5.sp,
                            fontFamily: 'Poppins')),
                  ),
                )
              : const SizedBox(),
        ],
      );
    });
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
                                                const NeverScrollableScrollPhysics(),
                                            shrinkWrap: true,
                                            itemBuilder: (context, index) {
                                              return _buildOrderView(
                                                  controller.postedOrdersList
                                                      .elementAt(index),
                                                  index);
                                            },
                                          )
                                        : controller.selectedTabName.value ==
                                                "all"
                                            ? _buildNoJobPostedView()
                                            : _buildNoJobPostedView2(),
                                    controller.totalpostedOrders >
                                            controller.postedOrdersList.length
                                        ? _buildLoadMoreButton(context)
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
                controller.selectedTabName.value = "open";
                controller.isLoading.value = true;
                controller.status.value = "open";
                controller.getPostedOrdersList(1, controller.status.value);
              },
              child: Column(
                children: [
                  Card(
                    elevation: 0,
                    color: controller.selectedTabName.value == "open"
                        ? const Color(MyColors.themeRedColor)
                        : const Color(MyColors.whiteColor),
                    child: Padding(
                      padding: EdgeInsets.only(
                          left: 10.0.w,
                          right: 10.0.w,
                          top: 2.0.h,
                          bottom: 2.0.h),
                      child: Text(Strings.openText(Get.context!),
                          textAlign: TextAlign.start,
                          style: TextStyle(
                              color: controller.selectedTabName.value == "open"
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
                controller.selectedTabName.value = "cancelled";
                controller.status.value = "cancelled";
                controller.getPostedOrdersList(1, controller.status.value);
              },
              child: Column(
                children: [
                  Card(
                    elevation: 0,
                    color: controller.selectedTabName.value == "cancelled"
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
                              color: controller.selectedTabName.value ==
                                      "cancelled"
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

  void _loadMoreData() {
    try {
      if (controller.postedOrders!.pagination != null) {
        if (controller.postedOrders!.pagination!.hasMore ?? false) {
          int page = controller.postedOrders!.pagination!.currentPage! + 1;
          controller.isLoadingMore.value = true;
          controller.getPostedOrdersList(page, controller.status.value);
        }
      }
    } catch (e) {
      throw Exception(e);
    }
  }

  Widget _buildLoadMoreButton(BuildContext context) {
    return Obx(() {
      final loading = controller.isLoadingMore.value;

      return Padding(
        padding: EdgeInsets.symmetric(vertical: 12.h),
        child: Center(
          child: SizedBox(
            width: MediaQuery.of(context).size.width / 1.6,
            height: 42.h,
            child: ElevatedButton(
              onPressed: loading ? null : () => _loadMoreData(),
              style: ElevatedButton.styleFrom(
                elevation: 0,
                padding: EdgeInsets.zero,
                backgroundColor:
                    const Color(MyColors.themeRedColor).withOpacity(0.07),
                disabledBackgroundColor:
                    const Color(MyColors.themeRedColor).withOpacity(0.04),
                foregroundColor: const Color(MyColors.themeRedColor),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(21.r),
                  side: BorderSide(
                    color:
                        const Color(MyColors.themeRedColor).withOpacity(0.25),
                  ),
                ),
              ),
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 200),
                child: loading
                    ? SizedBox(
                        key: const ValueKey(''),
                        width: 18.w,
                        height: 18.w,
                        child: const CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Color(MyColors.themeRedColor),
                        ),
                      )
                    : Row(
                        key: const ValueKey('label'),
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            Strings.loadMoreText(context),
                            style: TextStyle(
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w500,
                              fontFamily: 'Poppins',
                              color: const Color(MyColors.themeRedColor),
                            ),
                          ),
                          SizedBox(width: 6.w),
                          Icon(Icons.keyboard_arrow_down, size: 19.sp),
                        ],
                      ),
              ),
            ),
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
            SvgPicture.asset(
              "lib/assets/icons/noordersicon.svg",
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
                text: controller.selectedTabName.value == "Active"
                    ? Strings.noActiveOrders(Get.context!)
                    : controller.selectedTabName.value == "open"
                        ? Strings.noOpenOrders(Get.context!)
                        : controller.selectedTabName.value == "completed"
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
                      fontsize: 15.0,
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
              arguments: {'jobId': job.id ?? -1, 'index': index});
          Commons.showProgressDialog(Get.context!);
          controller.updateJobObject(job.id!, index);
        } catch (e) {
          throw Exception(e);
        }
      },
      child: Container(
        margin: EdgeInsets.all(8.r),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(color: const Color(0xFFEDEDEF)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.04),
              blurRadius: 5,
              offset: const Offset(0, 1),
            ),
          ],
        ),
        child: Padding(
          padding: EdgeInsets.all(14.r),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ---- Title + Status row ----
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Text(
                      job.title ?? "N/A",
                      style: TextStyle(
                        fontSize: 17.sp,
                        fontWeight: FontWeight.w600,
                        fontFamily: 'Poppins',
                        color: Colors.black,
                        height: 1.3,
                      ),
                    ),
                  ),
                  SizedBox(width: 8.w),
                  Obx(() => _statusBadge(job)),
                ],
              ),
              SizedBox(height: 6.h),

              // ---- Service name chip ----
              Container(
                padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
                decoration: BoxDecoration(
                  color: const Color(MyColors.themeRedColor)
                      .withValues(alpha: 0.07),
                  borderRadius: BorderRadius.circular(20.r),
                ),
                child: Text(
                  job.serviceName ?? "N/A",
                  style: TextStyle(
                    fontSize: 12.5.sp,
                    fontWeight: FontWeight.w500,
                    fontFamily: 'Poppins',
                    color: const Color(MyColors.themeRedColor),
                  ),
                ),
              ),
              SizedBox(height: 10.h),

              // ---- Description ----
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(10.r),
                decoration: BoxDecoration(
                  color: const Color(0xFFF7F7F8),
                  borderRadius: BorderRadius.circular(10.r),
                ),
                child: Text(
                  job.desc ?? "N/A",
                  textAlign: TextAlign.start,
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: const Color(MyColors.darkGrayColor),
                    fontSize: 13.5.sp,
                    fontWeight: FontWeight.w400,
                    fontFamily: 'Poppins',
                    height: 1.45,
                  ),
                ),
              ),
              SizedBox(height: 10.h),

              // ---- Posted at ----
              Row(
                children: [
                  Icon(Icons.access_time_rounded,
                      size: 14.r, color: const Color(MyColors.darkGrayColor)),
                  SizedBox(width: 5.w),
                  Text(
                    '${Strings.postedAt(Get.context!)}: ${job.humanReadableCreatedAt ?? "N/A"}',
                    style: TextStyle(
                      color: const Color(MyColors.darkGrayColor),
                      fontSize: 12.sp,
                      fontFamily: 'Poppins',
                    ),
                  ),
                ],
              ),

              // ---- Interested / Chat stats ----
              Obx(() {
                if (job.tradespersonApplicationsCount == null ||
                    job.tradespersonApplicationsCount!.value == 0) {
                  return const SizedBox();
                }
                return Padding(
                  padding: EdgeInsets.only(top: 12.h),
                  child: Container(
                    padding:
                        EdgeInsets.symmetric(vertical: 10.h, horizontal: 6.w),
                    decoration: BoxDecoration(
                      color: const Color(MyColors.colorNeutral100),
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            children: [
                              if (job.tradespersonApplicationsCount != null)
                                HeadingTextW600(
                                  text:
                                      '${job.tradespersonApplicationsCount!.value}',
                                  centerAlign: true,
                                  size: 20.sp,
                                ),
                              Headingdescription(
                                text: Strings.interested(Get.context!),
                                centerAlign: true,
                                size: 13.sp,
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          width: 1.w,
                          height: 36.h,
                          child: Container(
                              color: const Color(MyColors.silverColor)),
                        ),
                        Expanded(
                          child: Column(
                            children: [
                              if (job.inContactTradesmenCount != null)
                                HeadingTextW600(
                                  text: '${job.inContactTradesmenCount!.value}',
                                  centerAlign: true,
                                  size: 20.sp,
                                ),
                              Headingdescription(
                                text: Strings.chatText(Get.context!),
                                centerAlign: true,
                                size: 13.sp,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }),

              // ---- Send request card ----
              job.status!.value == "open"
                  ? Padding(
                      padding: EdgeInsets.only(top: 12.h),
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
                              'fromWhere': 'MyOrders',
                              'index': index,
                            },
                          );
                          if (result != null) {
                            job.tradespersonRequestsCount!.value =
                                (10 - result).toString();
                          }
                        },
                        child: Container(
                          width: double.infinity,
                          padding: EdgeInsets.symmetric(
                              horizontal: 12.w, vertical: 10.h),
                          decoration: BoxDecoration(
                            color: const Color(MyColors.themeRedColor)
                                .withValues(alpha: 0.06),
                            borderRadius: BorderRadius.circular(12.r),
                            border: Border.all(
                              color: const Color(MyColors.themeRedColor)
                                  .withValues(alpha: 0.15),
                            ),
                          ),
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
                                    text: _remainingTradesmenText(job),
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
                    )
                  : const SizedBox(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _statusBadge(PostedJobDetail job) {
    final status = job.status!.value;

    late Color bgColor;
    late String label;
    late Widget icon;

    switch (status) {
      case "open":
        bgColor = const Color(MyColors.cardColorSky200);
        label = Strings.openText(Get.context!);
        icon = SvgPicture.asset("lib/assets/icons/inprocessIcon.svg",
            height: 12.h, width: 12.w);
        break;
      case "in_progress":
        bgColor = const Color(MyColors.cardColorGreenLight);
        label = Strings.active(Get.context!);
        icon = Lottie.asset(
          'lib/assets/icons/ActiveStatusRipple.json',
          width: 12.w,
          height: 12.h,
          fit: BoxFit.contain,
          repeat: true,
          animate: true,
        );
        break;
      case "cancelled":
        bgColor = const Color(MyColors.cardcolorOrange200);
        label = Strings.canceledText(Get.context!);
        icon = SvgPicture.asset("lib/assets/icons/jobCancelledIcon.svg",
            height: 12.h, width: 12.w);
        break;
      default:
        bgColor = const Color(MyColors.cardColorGreen200);
        label = Strings.completed(Get.context!);
        icon = SvgPicture.asset("lib/assets/icons/completedTickIcon.svg",
            height: 12.h, width: 12.w);
    }

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          icon,
          SizedBox(width: 4.w),
          Text(
            label,
            style: TextStyle(
              fontSize: 11.5.sp,
              fontWeight: FontWeight.w500,
              fontFamily: 'Poppins',
              color: Colors.black87,
            ),
          ),
        ],
      ),
    );
  }

  String _remainingTradesmenText(PostedJobDetail job) {
    final remaining = controller.getRemainingTrademenRequests(
        int.parse(job.tradespersonRequestsCount!.value));
    switch (remaining) {
      case 0:
        return Strings.toMore0TradesmenText(Get.context!);
      case 1:
        return Strings.toMore1TradesmenText(Get.context!);
      case 2:
        return Strings.toMore2TradesmenText(Get.context!);
      case 3:
        return Strings.toMore3TradesmenText(Get.context!);
      case 4:
        return Strings.toMore4TradesmenText(Get.context!);
      case 5:
        return Strings.toMore5TradesmenText(Get.context!);
      case 6:
        return Strings.toMore6TradesmenText(Get.context!);
      case 7:
        return Strings.toMore7TradesmenText(Get.context!);
      case 8:
        return Strings.toMore8TradesmenText(Get.context!);
      case 9:
        return Strings.toMore9TradesmenText(Get.context!);
      default:
        return Strings.toMore10TradesmenText(Get.context!);
    }
  }
}

class _PinnedHeaderDelegate extends SliverPersistentHeaderDelegate {
  final double height;
  final Widget child;

  _PinnedHeaderDelegate({required this.height, required this.child});

  @override
  double get minExtent => height;

  @override
  double get maxExtent => height;

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return child;
  }

  @override
  bool shouldRebuild(covariant _PinnedHeaderDelegate oldDelegate) {
    return oldDelegate.height != height || oldDelegate.child != child;
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
  String userEmail = "";
  ProfileController controller = Get.put(ProfileController());
  File? _selectedImage;

  Future<void> _pickImage() async {
    // ✅ Show options bottom sheet first
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16.r)),
      ),
      builder: (context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.camera_alt,
                    color: Color(MyColors.themeRedColor)),
                title: Text(Strings.cameraText(context)),
                onTap: () {
                  Get.back();
                  _pickImageFromSource(ImageSource.camera);
                },
              ),
              ListTile(
                leading: const Icon(Icons.photo_library,
                    color: Color(MyColors.themeRedColor)),
                title: Text(Strings.galleryText(context)), // add this string
                onTap: () {
                  Get.back(); // close bottom sheet
                  _pickImageFromSource(ImageSource.gallery);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _pickImageFromSource(ImageSource source) async {
    final XFile? pickedFile = await _picker.pickImage(
        source: source, maxHeight: 1024, maxWidth: 1024, imageQuality: 70);

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
                        text: userName, centerAlign: true, size: 16.sp)
                    : const SizedBox(),
                widget.isLoggedin != "loggedOut"
                    ? HeadingTextW500(
                        text: userEmail, centerAlign: true, size: 13.sp)
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
                              Get.toNamed(AppLinks.manage_account_screen);
                            } catch (e) {
                              throw Exception(e);
                            }
                          },
                        ),
                      )
                    : const SizedBox(),
                widget.isLoggedin != "loggedOut"
                    ? Align(
                        alignment: Alignment.topLeft,
                        child: Padding(
                          padding: EdgeInsets.only(
                              left: 12.0.r, top: 8.0.h, bottom: 8.0.h),
                          child: HeadingTextW600(
                              text: Strings.settingsText(context),
                              centerAlign: false,
                              size: 16.sp),
                        ))
                    : const SizedBox(),
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
                widget.isLoggedin != "loggedOut"
                    ? Padding(
                        padding: EdgeInsets.only(left: 8.0.r, right: 8.0.r),
                        child: ProfileInfoCard(
                          icon: "lib/assets/icons/languageIcon.svg",
                          text: Strings.languageText(context),
                          onPressed: () {
                            try {
                              Get.toNamed(AppLinks.change_language_screen);
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
                      try {
                        Get.toNamed(AppLinks.support_centre);
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
                          text: Strings.auftragText(context),
                          centerAlign: false,
                          size: 16.sp),
                    )),
                Padding(
                  padding: EdgeInsets.only(left: 8.0.r, right: 8.0.r),
                  child: ProfileInfoCard(
                    icon: "lib/assets/icons/bookIcon.svg",
                    text: Strings.legalText(context),
                    onPressed: () {
                      try {
                        Get.toNamed(AppLinks.legal_guides_screen);
                      } catch (e) {
                        throw Exception(e);
                      }
                    },
                  ),
                ),
                // Padding(
                //   padding: EdgeInsets.only(left: 8.0.r, right: 8.0.r),
                //   child: ProfileInfoCard(
                //     icon: "lib/assets/icons/eyeOffIcon.svg",
                //     text: Strings.privacyPolicy(context),
                //     onPressed: () {
                //       try {
                //         Get.toNamed(AppLinks.privacy_policy);
                //       } catch (e) {
                //         throw Exception(e);
                //       }
                //     },
                //   ),
                // ),
                widget.isLoggedin == "loggedOut"
                    ? const SizedBox()
                    : Padding(
                        padding: EdgeInsets.all(12.0.r),
                        child: SizedBox(
                          width: MediaQuery.of(context).size.width,
                          child: ElevatedButton(
                            onPressed: () async {
                              try {
                                Commons.logoutUser(false);
                              } catch (e) {
                                throw Exception(e);
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              padding: EdgeInsets.all(12.0.r),
                              elevation: 0,
                              backgroundColor:
                                  const Color(MyColors.themeRedColor),
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
                            ? ClipOval(
                                child: CachedNetworkImage(
                                imageUrl: imageUrl,
                                fit: BoxFit.cover,
                                errorWidget: (context, url, error) =>
                                    SvgPicture.asset(
                                  "lib/assets/images/tradesmenplaceholdericon.svg",
                                  fit: BoxFit.cover,
                                  height: 100.h,
                                  width: 110.w,
                                ),
                              ))
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
    userEmail = _prefs.getString('email') ?? "";
    setState(() {});
  }

  Future<void> getProfileImage() async {
    imageUrl = _prefs.getString('profile_img') ?? "";
    _selectedImage = null;
    if (mounted) {
      setState(() {});
    }
  }
}
