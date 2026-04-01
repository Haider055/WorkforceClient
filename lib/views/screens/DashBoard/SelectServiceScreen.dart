import 'package:flutter/material.dart';
import 'dart:io';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
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

  void manageinnAppPurchase() async {
    try {
      listenToPurchases();
      final InAppPurchase inAppPurchase = InAppPurchase.instance;

      List<ProductDetails> products = [];
      Stream<List<PurchaseDetails>> purchaseStream =
          inAppPurchase.purchaseStream;
      final Set<String> kIds = {
        'connect100',
        'connect50',
        'connect10',
      };
      final bool available = await inAppPurchase.isAvailable();
      if (!available) {
        print("Store not available");
        return;
      }

      ProductDetailsResponse response =
          await inAppPurchase.queryProductDetails(kIds);
      products = response.productDetails;
      showPurchaseDialog(Get.context!, products);
      print("Store available");
      print(products.length);
    } catch (e) {
      e.printError();
    }
  }

  void listenToPurchases() {
    final InAppPurchase inAppPurchase = InAppPurchase.instance;

    inAppPurchase.purchaseStream.listen((purchases) {
      for (var purchase in purchases) {
        if (purchase.status == PurchaseStatus.purchased) {
          print("✅ Purchase Success: ${purchase.productID}");

          // TODO: give user coins here
        } else if (purchase.status == PurchaseStatus.error) {
          print("❌ Purchase Error");
        } else if (purchase.status == PurchaseStatus.pending) {
          print("⏳ Pending...");
        }

        // IMPORTANT: complete purchase
        if (purchase.pendingCompletePurchase) {
          inAppPurchase.completePurchase(purchase);
        }
      }
    });
  }

  void showPurchaseDialog(BuildContext context, List<ProductDetails> products) {
    showDialog(
      context: context,
      builder: (context) {
        return PurchaseDialog(products: products);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          resizeToAvoidBottomInset: false,
          appBar: controller.currentIndex.value == 0
              ? AppBar(
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
                )
              : controller.currentIndex.value == 1
                  ? AppBar(
                      leadingWidth: MediaQuery.of(context).size.width,
                      leading: Container(
                        color: const Color(MyColors.lightSilverColor),
                      ),
                    )
                  : controller.currentIndex.value == 2
                      ? AppBar(
                          leadingWidth: MediaQuery.of(context).size.width,
                          leading: Container(
                            color: const Color(MyColors.whiteColor),
                          ),
                        )
                      : controller.currentIndex.value == 3
                          ? AppBar(
                              leadingWidth: MediaQuery.of(context).size.width,
                              leading: Container(
                                color: const Color(MyColors.whiteColor),
                              ),
                            )
                          : AppBar(
                              leadingWidth: MediaQuery.of(context).size.width,
                              leading: Container(
                                color: const Color(MyColors.lightSilverColor),
                                child: Card(
                                  color: const Color(MyColors.lightSilverColor),
                                  shadowColor:
                                      const Color.fromARGB(158, 219, 219, 219),
                                  elevation: 0.5,
                                  shape: const Border(
                                      bottom: BorderSide(
                                          color: Color.fromARGB(
                                              147, 203, 203, 203),
                                          style: BorderStyle.solid)),
                                  child: Center(
                                    child: HeadingTextW600(
                                        text: Strings.profile(context),
                                        centerAlign: false,
                                        size: 18),
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
                                padding: const EdgeInsets.all(2),
                                decoration: BoxDecoration(
                                  color: Colors.red,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                constraints: const BoxConstraints(
                                  minWidth: 16,
                                  minHeight: 16,
                                ),
                                child: Text(
                                  '${controller.unreadMessagesCount.value}',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 10,
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
                                padding: const EdgeInsets.all(2),
                                decoration: BoxDecoration(
                                  color: Colors.red,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                constraints: const BoxConstraints(
                                  minWidth: 16,
                                  minHeight: 16,
                                ),
                                child: Text(
                                  '${Constants.unreadNotificationsCount.value}',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 10,
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
      height: 54.0,
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
          padding: const EdgeInsets.only(left: 27.0, right: 27.0, top: 3.0),
          child: Card(
            elevation: 0,
            color: const Color(MyColors.cardGrayColor50),
            margin: const EdgeInsets.symmetric(vertical: 0.1),
            shape: OutlineInputBorder(
                borderSide: const BorderSide(
                    color: Color.fromARGB(255, 212, 212, 212),
                    strokeAlign: 1.0,
                    style: BorderStyle.solid),
                borderRadius: BorderRadius.circular(5.0)),
            child: Row(
              children: [
                Padding(
                    padding: const EdgeInsets.only(left: 14.0),
                    child:
                        controller.filteredOptions.elementAt(index).icon != null
                            ? Image.network(
                                controller.filteredOptions
                                    .elementAt(index)
                                    .icon!
                                    .url!,
                                height: 24,
                                width: 24,
                                fit: BoxFit.contain,
                                errorBuilder: (context, error, stackTrace) {
                                  return SizedBox(
                                      height: 24,
                                      width: 24,
                                      child: SvgPicture.asset(
                                        "lib/assets/images/tradesmenplaceholdericon.svg",
                                        fit: BoxFit.contain,
                                        height: 24,
                                        width: 24,
                                      ));
                                },
                              )
                            : SizedBox(
                                height: 24,
                                width: 24,
                                child: SvgPicture.asset(
                                  "lib/assets/icons/bookIcon.svg",
                                  fit: BoxFit.contain,
                                  height: 24,
                                  width: 24,
                                ))),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 10.0, right: 8.0),
                    child: Text(
                        controller.filteredOptions
                            .elementAt(index)
                            .name
                            .toString(),
                        textAlign: TextAlign.start,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                        softWrap: true,
                        style: const TextStyle(
                            fontSize: 15.5,
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
        : Stack(
            children: [
              Column(
                children: [
                  Column(
                    children: [
                      controller.isLoggedIn.value == "loggedOut"
                          ? Padding(
                              padding: const EdgeInsets.only(
                                  left: 15.0, right: 15.0),
                              child: Card(
                                elevation: 0,
                                color: Colors.red.shade50,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          left: 8.0, right: 8.0, top: 9.0),
                                      child: Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          Stack(
                                            children: [
                                              Container(
                                                width: 34,
                                                height: 34,
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
                                                      offset:
                                                          const Offset(0, 2),
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
                                            ],
                                          ),
                                          const SizedBox(width: 10),
                                          Expanded(
                                              child: Headingdescription(
                                                  text: Strings
                                                      .itSeemsYouAreNotLoginText(
                                                          Get.context!),
                                                  centerAlign: false,
                                                  size: 14.5)),
                                        ],
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(12.0),
                                      child: SizedBox(
                                        height: 32,
                                        width: MediaQuery.of(Get.context!)
                                            .size
                                            .width,
                                        child: ElevatedButton(
                                          onPressed: () {
                                            // manageinnAppPurchase();
                                            Constants.fromWhere =
                                                "SelectServiceScreen";
                                            Get.toNamed(AppLinks.login_screen);
                                          },
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: const Color(MyColors
                                                .themeRedColor), // Button color
                                            shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(
                                                  8), // Optional rounded corners
                                            ),
                                          ),
                                          child: const Text(
                                            "Login",
                                            style: TextStyle(
                                              fontSize:
                                                  12, // Adjust font size to fit inside
                                              color: Colors.white, // Text color
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
                      const Align(
                        alignment: Alignment.topLeft,
                        child: Padding(
                          padding: EdgeInsets.only(top: 18.0, left: 24),
                          child: HeadingTextW600(
                              text: "Hire Now", centerAlign: false, size: 28),
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
                          padding: const EdgeInsets.only(left: 25.0, top: 18.0),
                          child: Headingdescription(
                              text: Strings.selectServiceDesc(Get.context!),
                              centerAlign: false,
                              size: 14.5),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    width: MediaQuery.of(Get.context!).size.width,
                    child: Padding(
                      padding: const EdgeInsets.only(
                          top: 24.0, left: 25.0, right: 25.0),
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
                            padding: const EdgeInsets.only(right: 6.0),
                            child: GestureDetector(
                              onTap: () {
                                if (controller
                                    .searchController.value.text.isNotEmpty) {
                                  controller.searchController.value.text = "";
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
                                    width: 30, // Adjust width
                                    height: 30, // Adjust height
                                  ),
                                  Image.asset(
                                    'lib/assets/icons/cancelicon.png', // Make sure this image is in assets folder
                                    width: 12, // Adjust width
                                    height: 12, // Adjust height
                                  ),
                                ],
                              ),
                            ),
                          ), // Search icon at start
                          border: OutlineInputBorder(
                            borderRadius: const BorderRadius.all(
                                Radius.circular(8)), // Border radius
                            borderSide: BorderSide(
                                color: Color(
                                    controller.textFieldBorderColor.value),
                                width: 1.5), // Black border
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius:
                                const BorderRadius.all(Radius.circular(8)),
                            borderSide: BorderSide(
                                color: Color(
                                    controller.textFieldBorderColor.value),
                                width: 2), // Black border when focused
                          ),
                        ),
                      ),
                    ),
                  ),
                  controller.showServicesSuggestions.value
                      ? Expanded(
                          child: controller.filteredOptions.isNotEmpty
                              ? ListView.builder(
                                  itemCount: controller.filteredOptions.length,
                                  itemBuilder: (context, index) {
                                    return buildServiceOptions(index);
                                  },
                                )
                              : controller.isSearchingQuery.value
                                  ? SizedBox(
                                      height: MediaQuery.of(Get.context!)
                                              .size
                                              .height /
                                          7,
                                      child: const Center(
                                          child: SizedBox(
                                        height: 26,
                                        width: 26,
                                        child: CircularProgressIndicator(
                                          color: Color(MyColors.themeRedColor),
                                        ),
                                      )),
                                    )
                                  : Container(),
                        )
                      : const SizedBox(),
                  controller.showServicesSuggestions.value == false
                      ? SizedBox(
                          width: MediaQuery.of(Get.context!).size.width * 0.9,
                          child: Padding(
                            padding: const EdgeInsets.only(
                                top: 50.0, left: 8, right: 8),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SvgPicture.asset(
                                  "lib/assets/icons/bookIconsvg.svg",
                                  height: 38,
                                  width: 38,
                                  fit: BoxFit.contain,
                                ),
                                Expanded(
                                  child: Padding(
                                      padding:
                                          const EdgeInsets.only(left: 12.0),
                                      child: Text(
                                          Strings.selectServiceInfo1(
                                              Get.context!),
                                          textAlign: TextAlign.start,
                                          style: const TextStyle(
                                              color: Color(0x9C000000),
                                              fontSize: 14.5,
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
                          width: MediaQuery.of(Get.context!).size.width * 0.9,
                          child: Padding(
                            padding: const EdgeInsets.only(
                                top: 32.0, left: 8, right: 8),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SvgPicture.asset(
                                  "lib/assets/icons/personredsvg.svg",
                                  height: 38,
                                  width: 38,
                                  fit: BoxFit.contain,
                                ),
                                Expanded(
                                  child: Padding(
                                      padding:
                                          const EdgeInsets.only(left: 12.0),
                                      child: Text(
                                          Strings.selectServiceInfo2(
                                              Get.context!),
                                          textAlign: TextAlign.start,
                                          style: const TextStyle(
                                              color: Color(0x9C000000),
                                              fontSize: 14.5,
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
                          width: MediaQuery.of(Get.context!).size.width * 0.9,
                          child: Padding(
                            padding: const EdgeInsets.only(
                                top: 32.0, left: 8, right: 8),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SvgPicture.asset(
                                  "lib/assets/icons/resStarsvg.svg",
                                  fit: BoxFit.contain,
                                  height: 38,
                                  width: 38,
                                ),
                                Expanded(
                                  child: Padding(
                                      padding:
                                          const EdgeInsets.only(left: 12.0),
                                      child: Text(
                                          "${Strings.moreThan(Get.context!)} 10,000+ ${Strings.independentReviews(Get.context!)}",
                                          textAlign: TextAlign.start,
                                          style: const TextStyle(
                                              color: Color(0x9C000000),
                                              fontSize: 14.5,
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
            ],
          );
  }
}

class PurchaseDialog extends StatefulWidget {
  final List<ProductDetails> products;

  const PurchaseDialog({super.key, required this.products});

  @override
  State<PurchaseDialog> createState() => _PurchaseDialogState();
}

class _PurchaseDialogState extends State<PurchaseDialog> {
  bool isLoading = false;

  void buyProduct(ProductDetails product) async {
    setState(() => isLoading = true);

    final PurchaseParam purchaseParam = PurchaseParam(productDetails: product);

    await InAppPurchase.instance.buyConsumable(purchaseParam: purchaseParam);

    setState(() => isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Container(
        padding: const EdgeInsets.all(16),
        width: double.infinity,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            /// Title
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Buy Coins",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.close),
                )
              ],
            ),

            const SizedBox(height: 10),

            /// List of Products
            widget.products.isEmpty
                ? const Padding(
                    padding: EdgeInsets.all(20),
                    child: Text("No products available"),
                  )
                : ListView.builder(
                    shrinkWrap: true,
                    itemCount: widget.products.length,
                    itemBuilder: (context, index) {
                      final product = widget.products[index];

                      return Card(
                        elevation: 2,
                        margin: const EdgeInsets.symmetric(vertical: 6),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: ListTile(
                          leading: const Icon(Icons.monetization_on,
                              color: Colors.orange),
                          title: Text(product.title),
                          subtitle: Text(product.description),
                          trailing: isLoading
                              ? const SizedBox(
                                  width: 20,
                                  height: 20,
                                  child:
                                      CircularProgressIndicator(strokeWidth: 2),
                                )
                              : Text(
                                  product.price,
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold),
                                ),
                          onTap: isLoading ? null : () => buyProduct(product),
                        ),
                      );
                    },
                  ),

            const SizedBox(height: 10),
          ],
        ),
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
            padding: const EdgeInsets.all(8.0),
            child: controller.isLoggedin.value == "loggedOut"
                ? _buildNoLoginView()
                : Column(
                    children: [
                      Align(
                        alignment: Alignment.topLeft,
                        child: Padding(
                          padding: const EdgeInsets.only(left: 10.0),
                          child: HeadingTextW600(
                              text: Strings.myPostedOrders(context),
                              centerAlign: false,
                              size: 22),
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
        padding: const EdgeInsets.all(8.0),
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
                  padding: const EdgeInsets.only(
                      left: 10.0, right: 10.0, top: 2.0, bottom: 2.0),
                  child: Text("All",
                      textAlign: TextAlign.start,
                      style: TextStyle(
                          color: controller.selectedTabName.value == "all"
                              ? const Color(MyColors.whiteColor)
                              : const Color(MyColors.blackColor),
                          fontSize: 14,
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
                      padding: const EdgeInsets.only(
                          left: 10.0, right: 10.0, top: 2.0, bottom: 2.0),
                      child: Text("In Process",
                          textAlign: TextAlign.start,
                          style: TextStyle(
                              color: controller.selectedTabName.value ==
                                      "inprocess"
                                  ? const Color(MyColors.whiteColor)
                                  : const Color(MyColors.blackColor),
                              fontSize: 14,
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
                      padding: const EdgeInsets.only(
                          left: 10.0, right: 10.0, top: 2.0, bottom: 2.0),
                      child: Text(Strings.active(Get.context!),
                          textAlign: TextAlign.start,
                          style: TextStyle(
                              color:
                                  controller.selectedTabName.value == "Active"
                                      ? const Color(MyColors.whiteColor)
                                      : const Color(MyColors.blackColor),
                              fontSize: 14,
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
                      padding: const EdgeInsets.only(
                          left: 10.0, right: 10.0, top: 2.0, bottom: 2.0),
                      child: Text("Completed",
                          textAlign: TextAlign.start,
                          style: TextStyle(
                              color: controller.selectedTabName.value ==
                                      "completed"
                                  ? const Color(MyColors.whiteColor)
                                  : const Color(MyColors.blackColor),
                              fontSize: 14,
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
                      padding: const EdgeInsets.only(
                          left: 10.0, right: 10.0, top: 2.0, bottom: 2.0),
                      child: Text("Cancelled",
                          textAlign: TextAlign.start,
                          style: TextStyle(
                              color:
                                  controller.selectedTabName.value == "canceled"
                                      ? const Color(MyColors.whiteColor)
                                      : const Color(MyColors.blackColor),
                              fontSize: 14,
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
    });
  }

  Widget _buildNoJobPostedView() {
    return SizedBox(
      height: MediaQuery.of(Get.context!).size.height * 0.6,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Spacer(),
            Image.asset(
              "lib/assets/images/noorderspostedicon.png",
              width: MediaQuery.of(Get.context!).size.width,
              height: MediaQuery.of(Get.context!).size.height / 5,
              fit: BoxFit.contain,
            ),
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: HeadingTextW700(
                text: Strings.noOrders(Get.context!),
                centerAlign: true,
                size: 22,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12.0),
              child: Headingdescription(
                text: Strings.startPostingYourOrders(Get.context!),
                centerAlign: true,
                size: 13.0,
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
      height: MediaQuery.of(Get.context!).size.height * 0.6,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Spacer(),
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: HeadingTextW700(
                text: controller.selectedTabName == "Active"
                    ? Strings.noActiveOrders(Get.context!)
                    : controller.selectedTabName == "inprocess"
                        ? Strings.noInProcessOrders(Get.context!)
                        : controller.selectedTabName == "completed"
                            ? Strings.noCompleteOrders(Get.context!)
                            : Strings.noCancelOrders(Get.context!),
                centerAlign: true,
                size: 22,
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
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Spacer(),
                SvgPicture.asset("lib/assets/icons/noorderspostedicon.svg",
                    width: MediaQuery.of(Get.context!).size.width,
                    height: MediaQuery.of(Get.context!).size.height / 7,
                    fit: BoxFit.contain),
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: HeadingTextW600(
                      text: Strings.myOrders(Get.context!),
                      centerAlign: true,
                      size: 20),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 12.0, right: 12.0),
                  child: Headingdescription(
                      text: Strings.pleaseLoginToSeeOrders(Get.context!),
                      centerAlign: true,
                      size: 13.5),
                ),
                Padding(
                  padding:
                      const EdgeInsets.only(left: 12.0, right: 12.0, top: 20.0),
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
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 8.0, right: 8.0, top: 8.0),
                child: HeadingTextW600(
                    text: job.title ?? "N/A", centerAlign: false, size: 18),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                child: HeadingTextW500(
                    text: job.serviceName ?? "N/A",
                    centerAlign: false,
                    size: 15),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                child: RichText(
                  text: TextSpan(
                    text:
                        '${Strings.postedAt(Get.context!)}: ', // default style
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 12,
                      fontFamily: 'Poppins',
                    ),
                    children: <TextSpan>[
                      TextSpan(
                        text: job.humanReadableCreatedAt ?? "N/A",
                        style: const TextStyle(
                          color: Colors.black,
                          fontSize: 12,
                          fontFamily: 'Poppins',
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Obx(() {
                return Padding(
                  padding: const EdgeInsets.only(left: 4.0, top: 4.0),
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
                        borderRadius: BorderRadius.circular(6)),
                    child: Padding(
                      padding: const EdgeInsets.all(3.0),
                      child: job.status!.value == "open"
                          ? Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                SvgPicture.asset(
                                    "lib/assets/icons/inprocessIcon.svg",
                                    height: 14.0,
                                    width: 14.0),
                                const SizedBox(
                                  width: 2.0,
                                ),
                                Headingdescription(
                                    text: Strings.inProcess(Get.context!),
                                    centerAlign: false,
                                    size: 12)
                              ],
                            )
                          : job.status!.value == "in_progress"
                              ? Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Lottie.asset(
                                      'lib/assets/icons/ActiveStatusRipple.json',
                                      width: 14,
                                      height: 14,
                                      fit: BoxFit.contain,
                                      repeat: true,
                                      animate: true,
                                    ),
                                    const SizedBox(
                                      width: 2.0,
                                    ),
                                    Headingdescription(
                                        text: Strings.active(Get.context!),
                                        centerAlign: false,
                                        size: 12)
                                  ],
                                )
                              : job.status!.value == "cancelled"
                                  ? Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        SvgPicture.asset(
                                            "lib/assets/icons/jobCancelledIcon.svg",
                                            height: 14.0,
                                            width: 14.0),
                                        const SizedBox(
                                          width: 2.0,
                                        ),
                                        Headingdescription(
                                            text: Strings.canceledText(
                                                Get.context!),
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
                                          width: 2.0,
                                        ),
                                        Headingdescription(
                                            text:
                                                Strings.completed(Get.context!),
                                            centerAlign: false,
                                            size: 12)
                                      ],
                                    ),
                    ),
                  ),
                );
              }),
              Padding(
                padding:
                    const EdgeInsets.only(left: 8.0, right: 8.0, top: 12.0),
                child: Text(job.desc ?? "N/A",
                    textAlign: TextAlign.start,
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                        color: Colors.black,
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        fontFamily: 'Poppins')),
              ),
              Obx(() {
                return job.tradespersonApplicationsCount == null
                    ? const SizedBox()
                    : job.tradespersonApplicationsCount!.value == 0
                        ? const SizedBox()
                        : Padding(
                            padding: const EdgeInsets.only(
                                left: 6.0, right: 6.0, top: 4.0),
                            child: Card(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(6)),
                              elevation: 0,
                              color: const Color(MyColors.colorNeutral100),
                              child: Padding(
                                padding: const EdgeInsets.all(6.0),
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
                                                    size: 20)
                                                : const SizedBox(),
                                            Headingdescription(
                                                text: Strings.interested(
                                                    Get.context!),
                                                centerAlign: false,
                                                size: 14)
                                          ],
                                        ),
                                      ),
                                    ),
                                    Center(
                                      child: SizedBox(
                                        width: 1.0,
                                        height: 40.0,
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
                                                    size: 20)
                                                : const SizedBox(),
                                            Headingdescription(
                                                text: Strings.chatText(
                                                    Get.context!),
                                                centerAlign: false,
                                                size: 14)
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
                      padding: const EdgeInsets.only(
                          left: 4.0, right: 4.0, top: 6.0, bottom: 3.0),
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
                            padding: const EdgeInsets.all(8.0),
                            child: Obx(() {
                              return RichText(
                                text: TextSpan(
                                  text: '',
                                  style: const TextStyle(
                                      color: Colors.black, fontSize: 13),
                                  children: <TextSpan>[
                                    TextSpan(
                                      text:
                                          '${Strings.sendARequestText(context)} ',
                                      style: TextStyle(
                                          fontFamily: 'Poppins',
                                          fontSize: 13,
                                          fontWeight: FontWeight.bold,
                                          color: Color(MyColors.themeRedColor)),
                                    ),
                                    TextSpan(
                                      text:
                                          'to more ${controller.getRemainingTrademenRequests(int.parse(job.tradespersonRequestsCount!.value))} tradesman to get additional answers.',
                                      style: const TextStyle(
                                          color: Colors.black,
                                          fontSize: 13,
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
      getProfileImage();
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
          padding: const EdgeInsets.all(8.0),
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
                    ? const HeadingTextW600(
                        text: "Haider", centerAlign: true, size: 18)
                    : const SizedBox(),
                widget.isLoggedin != "loggedOut"
                    ? const SizedBox(
                        height: 20,
                      )
                    : const SizedBox(),
                widget.isLoggedin != "loggedOut"
                    ? Align(
                        alignment: Alignment.topLeft,
                        child: Padding(
                          padding: const EdgeInsets.only(
                              left: 12.0, top: 8.0, bottom: 8.0),
                          child: HeadingTextW600(
                              text: Strings.account(context),
                              centerAlign: false,
                              size: 16),
                        ))
                    : const SizedBox(),
                widget.isLoggedin != "loggedOut"
                    ? Padding(
                        padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                        child: ProfileInfoCard(
                          icon: "lib/assets/icons/contactInfoIcon.svg",
                          text: Strings.contactInformation(context),
                          onPressed: () {
                            try {
                              Get.to(
                                const ContactInformationScreen(),
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
                widget.isLoggedin != "loggedOut"
                    ? Padding(
                        padding: const EdgeInsets.only(left: 8.0, right: 8.0),
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
                      padding: const EdgeInsets.only(
                          left: 12.0, top: 8.0, bottom: 8.0),
                      child: HeadingTextW600(
                          text: Strings.settingsText(context),
                          centerAlign: false,
                          size: 16),
                    )),
                widget.isLoggedin != "loggedOut"
                    ? Padding(
                        padding: const EdgeInsets.only(left: 8.0, right: 8.0),
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
                  padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                  child: ProfileInfoCard(
                    icon: "lib/assets/icons/bellIcon.svg",
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
                      padding: const EdgeInsets.only(
                          left: 12.0, top: 8.0, bottom: 8.0),
                      child: HeadingTextW600(
                          text: Strings.help(context),
                          centerAlign: false,
                          size: 16),
                    )),
                Padding(
                  padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                  child: ProfileInfoCard(
                    icon: "lib/assets/icons/contactIcon.svg",
                    text: Strings.supportCenter(context),
                    onPressed: () {
                      try {} catch (e) {
                        throw Exception(e);
                      }
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 8.0, right: 8.0),
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
                      padding: const EdgeInsets.only(
                          left: 12.0, top: 8.0, bottom: 8.0),
                      child: HeadingTextW600(
                          text: Strings.auftragText(context),
                          centerAlign: false,
                          size: 16),
                    )),
                Padding(
                  padding: const EdgeInsets.only(left: 8.0, right: 8.0),
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
                  padding: const EdgeInsets.only(left: 8.0, right: 8.0),
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
                        padding: const EdgeInsets.all(12.0),
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
                              padding: const EdgeInsets.all(12.0),
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
                                  height: 22,
                                  width: 22,
                                ),
                                const SizedBox(width: 8),
                                Padding(
                                  padding: const EdgeInsets.only(left: 6.0),
                                  child: Text(
                                    Strings.logoutText(context),
                                    style: const TextStyle(
                                      fontSize:
                                          16, // Adjust font size to fit inside
                                      color: Color(
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
      padding: const EdgeInsets.all(12.0),
      child: Card(
        elevation: 0,
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SvgPicture.asset(
                "lib/assets/icons/noProfileIcon.svg",
                fit: BoxFit.contain,
                width: 50,
                height: 50,
              ),
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: HeadingTextW500(
                    text: "Please Login to See Your Profile",
                    centerAlign: true,
                    size: 16),
              ),
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: FullWidthElevatedButton(
                    text: "Login",
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
            padding: const EdgeInsets.all(6.0),
            child: SizedBox(
                height: 96,
                width: 96,
                child: Stack(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: SizedBox(
                        height: 90,
                        width: 90,
                        child: imageUrl.isNotEmpty
                            ? Image.network(
                                imageUrl,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) {
                                  return SvgPicture.asset(
                                    "lib/assets/images/tradesmenplaceholdericon.svg",
                                    fit: BoxFit.cover,
                                    height: 100,
                                    width: 110,
                                  );
                                },
                              )
                            : _selectedImage != null
                                ? Image.file(_selectedImage!,
                                    width: 100, height: 110, fit: BoxFit.cover)
                                : SvgPicture.asset(
                                    "lib/assets/images/tradesmenplaceholdericon.svg",
                                    fit: BoxFit.cover,
                                    height: 100,
                                    width: 110,
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
                          height: 22,
                          width: 22,
                        ),
                      ),
                    )
                  ],
                ))),
      ],
    );
  }

  Future<void> getProfileImage() async {
    imageUrl = "";
    _prefs = await SharedPreferences.getInstance();
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
    // Get.to(
    //   const SelectServiceScreen(),
    //   transition: Transition.rightToLeft, // Left-to-right animation
    //   duration:
    //       const Duration(milliseconds: 500), // Optional: animation duration
    // );
  }
}
