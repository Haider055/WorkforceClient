import 'package:flutter/material.dart';
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
                        padding: const EdgeInsets.only(left: 14.0),
                        child: HeadingTextW600(
                          text: Strings.chatText(context),
                          centerAlign: false,
                          size: 22,
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
                                          itemCount: controller.list.length,
                                          shrinkWrap: true,
                                          itemBuilder: (context, index) {
                                            return _buildChatView(
                                                controller.list[index], index);
                                          },
                                        ),
                                      )
                                    : _buildNoChatsView(),
                                controller.totalChats > controller.list.length
                                    ? _buildLoadMoreButton()
                                    : const SizedBox()
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
      padding: const EdgeInsets.all(8.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Spacer(),
          SvgPicture.asset("lib/assets/icons/noLoginChat.svg",
              width: MediaQuery.of(Get.context!).size.width,
              height: MediaQuery.of(Get.context!).size.height / 6,
              fit: BoxFit.contain),
          const Padding(
            padding: EdgeInsets.all(4.0),
            child:
                HeadingTextW600(text: "My Chats", centerAlign: true, size: 20),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 12.0, right: 12.0),
            child: Headingdescription(
                text: Strings.pleaseLoginToSeeChats(Get.context!),
                centerAlign: true,
                size: 13.5),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 12.0, right: 12.0, top: 20.0),
            child: FullWidthButtonPrimary(
                text: Strings.loginText(Get.context!),
                fontsize: 15.0,
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

  Widget _buildNoChatsView() {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Spacer(),
            SvgPicture.asset("lib/assets/icons/noLoginChat.svg",
                width: MediaQuery.of(Get.context!).size.width,
                height: MediaQuery.of(Get.context!).size.height / 5.5,
                fit: BoxFit.contain),
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: HeadingTextW600(
                  text: Strings.chatBoxIsEmpty(Get.context!),
                  centerAlign: true,
                  size: 20),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 12.0, right: 12.0),
              child: Headingdescription(
                  text: Strings.chatBoxIsEmptyDesc(Get.context!),
                  centerAlign: true,
                  size: 13.0),
            ),
            const Spacer(),
          ],
        ),
      ),
    );
  }

  Widget _buildChatView(Chat chat, int index) {
    return GestureDetector(
      onTap: () async {
        try {
          var result = await Get.to(
            const ConversationScreen(),
            arguments: {
              'chat': chat,
              'fromWhere': 'AllChats',
            },
            transition: Transition.rightToLeft,
            duration: const Duration(
                milliseconds: 500), // Optional: animation duration
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
              print("Updated jobStatus: ${chat.jobStatus}");
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
        padding: const EdgeInsets.only(left: 12.0, right: 12.0, top: 8.0),
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            Card(
              color: const Color(MyColors.colorNeutral100),
              elevation: 0,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                  side: const BorderSide(
                      color: Color(MyColors.cardGrayColor300))),
              child: Padding(
                padding: const EdgeInsets.all(6.0),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                      child: Text("Job: ${chat.jobTitle ?? "N/A"}",
                          textAlign: TextAlign.center,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                              color: Colors.black,
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              fontFamily: 'Poppins')),
                    ),
                    Row(
                      children: [
                        Expanded(
                          flex: 2, // 20%
                          child: Center(
                            child: chat.profileImg != null
                                ? Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: CircleAvatar(
                                      radius: MediaQuery.of(Get.context!)
                                              .size
                                              .height /
                                          25,
                                      backgroundImage: NetworkImage(
                                          chat.profileImg.toString()),
                                    ),
                                  )
                                : Image.asset(
                                    "lib/assets/icons/placeholder_tradesmen.png"),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          flex: 8, // 80%
                          child: Padding(
                            padding: const EdgeInsets.only(right: 8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text.rich(TextSpan(
                                  text: chat.tradesmenName ?? "N/A",
                                  style: const TextStyle(
                                      fontSize: 16,
                                      color: Colors.black,
                                      fontWeight: FontWeight.w500),
                                  children: [
                                    WidgetSpan(
                                      alignment: PlaceholderAlignment.middle,
                                      child: Padding(
                                        padding: const EdgeInsets.only(
                                            left:
                                                4), // space between text and icon
                                        child: chat.tradesmenName != null
                                            ? chat.tradesmenName != null
                                                ? chat.isVerified!
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
                                Obx(() {
                                  return Text(
                                      chat.lastMessage != null
                                          ? chat.lastMessage!.message ??
                                              "Tap to start conversation"
                                          : "Tap to start conversation",
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 14,
                                          fontWeight:
                                              chat.unreadCount.value == 0
                                                  ? FontWeight.w400
                                                  : FontWeight.w600,
                                          fontFamily: 'Poppins'));
                                }),
                                Headingdescription(
                                    text: chat.lastMessage == null
                                        ? ""
                                        : chat.lastMessage!
                                                .humanReadableCreatedAt ??
                                            "",
                                    centerAlign: false,
                                    size: 12.5)
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            Obx(() {
              return chat.unreadCount.value > 0
                  ? Positioned(
                      right: -4,
                      top: -4,
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        constraints: const BoxConstraints(
                          minWidth: 16,
                          minHeight: 16,
                        ),
                        child: Text(
                          '${chat.unreadCount} new ',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 12,
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
