import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:workforceclientapp/Controllers/AllChatsContoller.dart';
import 'package:workforceclientapp/Models/Chat.dart';
import 'package:workforceclientapp/Others/Commons.dart';
import 'package:workforceclientapp/Others/Constants.dart';
import 'package:workforceclientapp/Others/MyColors.dart';
import 'package:workforceclientapp/Others/Strings.dart';
import 'package:workforceclientapp/Others/routes.dart';
import 'package:workforceclientapp/views/screens/Chat/ConversationScreen.dart';
import 'package:workforceclientapp/views/widgets/FullWidthButtonPrimary.dart';
import 'package:workforceclientapp/views/widgets/HeadingTextW600.dart';
import 'package:workforceclientapp/views/widgets/Headingdescription.dart';

class AllChats extends StatefulWidget {
  const AllChats({super.key});

  @override
  State<AllChats> createState() => _AllChatsState();
}

class _AllChatsState extends State<AllChats> {
  AllChatsContoller controller = Get.put(AllChatsContoller());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(MyColors.whiteColor),
      body: SafeArea(
        child: Obx(() {
          return !controller.isLoggedIn.value
              ? _buildNoLoginView()
              : Column(
                  children: [
                    Align(
                      alignment: Alignment.topLeft,
                      child: Padding(
                        padding: EdgeInsets.only(left: 14.0.w),
                        child: HeadingTextW600(
                          text: Strings.chatText(context),
                          centerAlign: false,
                          size: 22.sp,
                        ),
                      ),
                    ),
                    controller.isLoading.value
                        ? const Expanded(
                            child: Center(
                              child: CircularProgressIndicator(
                                color: Color(MyColors.themeRedColor),
                              ),
                            ),
                          )
                        : Expanded(
                            child: Column(
                              children: [
                                controller.list.isNotEmpty
                                    ? Expanded(
                                        child: ListView.builder(
                                          itemCount: controller.list.length + 1,
                                          shrinkWrap: true,
                                          itemBuilder: (context, index) {
                                            if (index ==
                                                controller.list.length) {
                                              if (controller.chatsList!
                                                      .pagination!.hasMore ??
                                                  false) {
                                                return _buildLoadMoreButton();
                                              } else {
                                                return const SizedBox();
                                              }
                                            }
                                            return _buildChatView(
                                                controller.list[index], index);
                                          },
                                        ),
                                      )
                                    : _buildNoChatsView(),
                              ],
                            ),
                          ),
                  ],
                );
        }),
      ),
    );
  }

  Widget _buildNoLoginView() {
    return Padding(
      padding: EdgeInsets.all(8.0.r),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Spacer(),
          SvgPicture.asset("lib/assets/icons/noLoginChat.svg",
              width: MediaQuery.of(Get.context!).size.width.w,
              height: MediaQuery.of(Get.context!).size.height.h / 6,
              fit: BoxFit.contain),
          Padding(
            padding: EdgeInsets.all(4.0.r),
            child: HeadingTextW600(
                text: Strings.chatText(Get.context!),
                centerAlign: true,
                size: 20.sp),
          ),
          Padding(
            padding: EdgeInsets.only(left: 12.0.w, right: 12.0.w),
            child: Headingdescription(
                text: Strings.pleaseLoginToSeeChats(Get.context!),
                centerAlign: true,
                size: 13.5.sp),
          ),
          Padding(
            padding: EdgeInsets.only(left: 12.0.w, right: 12.0.w, top: 20.0.h),
            child: FullWidthButtonPrimary(
                text: Strings.loginText(Get.context!),
                fontsize: 15.0.sp,
                color: MyColors.themeRedColor,
                onPressed: () {
                  Constants.fromWhere = "SelectServiceScreen";
                  Get.offAllNamed(AppLinks.login_screen);
                }),
          ),
          const Spacer(),
        ],
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
          : SizedBox(
              width: 100,
              child: ElevatedButton(
                style: ButtonStyle(
                    shape: WidgetStateProperty.all(RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0.r))),
                    fixedSize: WidgetStatePropertyAll(Size.fromWidth(
                        MediaQuery.of(Get.context!).size.width.w / 2)),
                    foregroundColor: const WidgetStatePropertyAll(
                        Color(MyColors.infoPinkColor2)),
                    elevation: const WidgetStatePropertyAll(0)),
                onPressed: () {
                  try {
                    if (controller.chatsList!.pagination != null) {
                      if (controller.chatsList!.pagination!.hasMore ?? false) {
                        int page =
                            controller.chatsList!.pagination!.currentPage! + 1;
                        controller.isLoadingMore.value = true;
                        controller.getChats(page);
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
                        size: 20.0.sp,
                      )
                    ],
                  ),
                ),
              ),
            );
    });
  }

  Widget _buildNoChatsView() {
    return Expanded(
      child: Padding(
        padding: EdgeInsets.all(8.0.r),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Spacer(),
            SvgPicture.asset("lib/assets/icons/noLoginChat.svg",
                width: MediaQuery.of(Get.context!).size.width.w,
                height: MediaQuery.of(Get.context!).size.height.h / 5.5,
                fit: BoxFit.contain),
            Padding(
              padding: EdgeInsets.all(12.0.r),
              child: HeadingTextW600(
                  text: Strings.chatBoxIsEmpty(Get.context!),
                  centerAlign: true,
                  size: 20.0.sp),
            ),
            Padding(
              padding: EdgeInsets.only(left: 12.0.r, right: 12.0.r),
              child: Headingdescription(
                  text: Strings.chatBoxIsEmptyDesc(Get.context!),
                  centerAlign: true,
                  size: 13.0.sp),
            ),
            const Spacer(),
          ],
        ),
      ),
    );
  }

  Widget _buildChatView(Chat chat, int index) {
    if (index == controller.list.length) {
      return _buildLoadMoreButton();
    }
    return GestureDetector(
      onTap: () async {
        try {
          var result = await Get.to(
            const ConversationScreen(),
            arguments: {
              'chat': chat,
              'fromWhere': 'AllChats',
            },
          );
          if (result != null) {
            if (result == "reload") {
              if (Constants.unReadcount.value >= chat.unreadCount.value) {
                Constants.unReadcount.value =
                    Constants.unReadcount.value - chat.unreadCount.value;
              } else {
                // Constants.unReadcount.value -= chat.unreadCount.value;
              }
              chat.unreadCount.value = 0;
              // Constants.unReadcount.value -= chat.unreadCount.value;
              Commons.showProgressDialog(Get.context!);
              controller.updateChatObject(chat.id!, index);
            } else {
              if (Constants.unReadcount.value >= chat.unreadCount.value) {
                Constants.unReadcount.value =
                    Constants.unReadcount.value - chat.unreadCount.value;
              } else {
                // Constants.unReadcount.value -= chat.unreadCount.value;
              }
              chat.unreadCount.value = 0;
              // Constants.unReadcount.value -= chat.unreadCount.value;
              // getTradesmenList();
            }
            // if (result == "update") {
            //   if (Constants.unReadcount.value >= chat.unreadCount.value) {
            //     Constants.unReadcount.value =
            //         Constants.unReadcount.value - chat.unreadCount.value;
            //   } else {
            //     // Constants.unReadcount.value -= chat.unreadCount.value;
            //   }
            //   chat.unreadCount.value = 0;
            //   // getTradesmenList();
            // }
          }
        } catch (e) {
          throw Exception(e);
        }
      },
      child: Padding(
        padding: EdgeInsets.only(left: 12.0.w, right: 12.0.w, top: 8.0.h),
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            Card(
              color: const Color(MyColors.colorNeutral100),
              elevation: 0,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0.r),
                  side: const BorderSide(
                      color: Color(MyColors.cardGrayColor300))),
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        flex: 2, // 20%
                        child: Center(
                          child: chat.profileImg != null
                              ? Padding(
                                  padding: EdgeInsets.all(8.0.r),
                                  child: CircleAvatar(
                                    radius: 30.r,
                                    backgroundImage: NetworkImage(
                                        chat.profileImg.toString()),
                                  ),
                                )
                              : Image.asset(
                                  "lib/assets/icons/placeholder_tradesmen.png"),
                        ),
                      ),
                      SizedBox(width: 10.h),
                      Expanded(
                        flex: 8, // 80%
                        child: Padding(
                          padding: EdgeInsets.only(right: 8.0.r),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Expanded(
                                      child: Text.rich(TextSpan(
                                    text: chat.tradesmenName ?? "N/A",
                                    style: TextStyle(
                                        fontSize: 15.0.sp,
                                        color: Colors.black,
                                        fontWeight: FontWeight.w500),
                                    children: [
                                      WidgetSpan(
                                        alignment: PlaceholderAlignment.middle,
                                        child: Padding(
                                          padding: EdgeInsets.only(
                                              left: 4.0
                                                  .r), // space between text and icon
                                          child: chat.tradesmenName != null
                                              ? chat.tradesmenName != null
                                                  ? chat.isVerified!
                                                      ? SvgPicture.asset(
                                                          "lib/assets/icons/verifiedIcon.svg",
                                                          height: 14.0.h,
                                                          width: 14.0.w)
                                                      : const SizedBox()
                                                  : const SizedBox()
                                              : const SizedBox(),
                                        ),
                                      ),
                                    ],
                                  ))),
                                  Headingdescription(
                                      text: chat.lastMessage == null
                                          ? ""
                                          : chat.lastMessage!
                                                      .humanReadableCreatedAt ==
                                                  null
                                              ? ""
                                              : (chat.lastMessage!
                                                              .humanReadableCreatedAt ==
                                                          "0s ago" ||
                                                      chat.lastMessage!
                                                              .humanReadableCreatedAt ==
                                                          "1s ago" ||
                                                      chat.lastMessage!
                                                              .humanReadableCreatedAt ==
                                                          "vor 0 Sek." ||
                                                      chat.lastMessage!
                                                              .humanReadableCreatedAt ==
                                                          "vor 1 Sek.")
                                                  ? Strings.nowText(
                                                      Get.context!)
                                                  : chat.lastMessage!
                                                      .humanReadableCreatedAt!,
                                      centerAlign: false,
                                      size: 11.sp)
                                ],
                              ),
                              Padding(
                                padding:
                                    EdgeInsets.only(right: 8.0.r, top: 2.0.h),
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 4, vertical: 1.5),
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      color: Colors.grey,
                                      width: 1,
                                    ),
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  child: Text(
                                    chat.jobTitle ?? "N/A",
                                    textAlign: TextAlign.center,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                      color: Colors.black,
                                      fontSize: 12.5,
                                      fontWeight: FontWeight.w500,
                                      fontFamily: 'Poppins',
                                    ),
                                  ),
                                ),
                              ),
                              Obx(() {
                                return Padding(
                                  padding: const EdgeInsets.only(top: 1.0),
                                  child: Text(
                                      chat.lastMessage != null
                                          ? chat.lastMessage!.message ??
                                              Strings
                                                  .taptoStartConversationText(
                                                      Get.context!)
                                          : Strings.taptoStartConversationText(
                                              Get.context!),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 13.0.sp,
                                          fontWeight:
                                              chat.unreadCount.value == 0
                                                  ? FontWeight.w400
                                                  : FontWeight.w600,
                                          fontFamily: 'Poppins')),
                                );
                              }),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Obx(() {
              return chat.unreadCount.value > 0
                  ? Positioned(
                      left: -6,
                      top: -5,
                      child: Container(
                        padding: EdgeInsets.all(4.0.r),
                        decoration: BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.circular(10.0.r),
                        ),
                        constraints: BoxConstraints(
                          minWidth: 16.0.r,
                          minHeight: 16.0.r,
                        ),
                        child: Text(
                          '${chat.unreadCount.value} new ',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 12.0.sp,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    )
                  : const SizedBox();
            }),
          ],
        ),
      ),
    );
  }
}
