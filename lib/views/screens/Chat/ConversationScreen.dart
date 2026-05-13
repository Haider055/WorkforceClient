import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:workforceclientapp/Controllers/ConversationContoller.dart';
import 'package:workforceclientapp/Controllers/PostedOrderDetailsController.dart';
import 'package:workforceclientapp/Models/Chat.dart';
import 'package:workforceclientapp/Models/ChatObj.dart';
import 'package:workforceclientapp/Models/Message.dart';
import 'package:workforceclientapp/Others/Commons.dart';
import 'package:workforceclientapp/Others/Constants.dart';
import 'package:workforceclientapp/Others/MyColors.dart';
import 'package:workforceclientapp/Others/NewMessageController.dart';
import 'package:workforceclientapp/Others/Strings.dart';
import 'package:workforceclientapp/Others/routes.dart';
import 'package:workforceclientapp/views/widgets/DialogButton.dart';
import 'package:workforceclientapp/views/widgets/FullWidthButtonPrimary.dart';
import 'package:workforceclientapp/views/widgets/FullWidthElevatedButton.dart';
import 'package:simple_flutter_reverb/simple_flutter_reverb.dart';
import 'package:workforceclientapp/views/widgets/FullWidthOutlineButton.dart';
import 'package:workforceclientapp/views/widgets/HeadingTextW500.dart';
import 'package:workforceclientapp/views/widgets/Headingdescription.dart';

class ConversationScreen extends StatefulWidget {
  const ConversationScreen({super.key});

  @override
  State<ConversationScreen> createState() => _TradesmenChatScreenState();
}

class _TradesmenChatScreenState extends State<ConversationScreen> {
  late int jobId, requestId;
  late String status, jobStatus;
  String option = Strings.startContractNowText(Get.context!);
  final data = Get.arguments;
  RxBool isLoading = true.obs;
  String backResults = "update";
  String fromWhere = "";
  final PostedOrderDetailsController postedOrderDetailsController = Get.put(
    PostedOrderDetailsController(),
  );
  ConversationContoller conversationContoller = Get.put(
    ConversationContoller(),
  );
  RxList<Message> messagesList = <Message>[].obs;
  ChatObj? chatObj;
  RxBool isLoadMoreEnable = false.obs;
  late int clientId, chatId;
  late SharedPreferences _prefs;
  final ScrollController _scrollController = ScrollController();
  // final PusherChannelsFlutter _pusher = PusherChannelsFlutter.getInstance();
  Chat? chat;
  // late PusherClient pusher;
  // late Channel channel;
  // final PusherChannelsFlutter pusher = PusherChannelsFlutter.getInstance();
  // late PusherConfig pusherConfig;
  // PusherService pusherService = PusherService();
  late final SimpleFlutterReverb reverb;

  @override
  void initState() {
    super.initState();
    if (data == null) {
      return;
    }
    fromWhere = data['fromWhere'];
    if (data['chat'] != null) {
      chat = data['chat'];
      jobId = chat!.jobPostingId!;
      jobStatus = chat!.jobStatus!;
      requestId = chat!.jobApplicationId!;
      chatId = chat!.id!;
      status = chat!.applicationStatus!;
      if (jobStatus == "completed") {
        option = Strings.jobHasBeenDoneText(Get.context!);
      } else if (jobStatus == "in_progress" && status == "in_progress") {
        option = Strings.markAsCompleteText(Get.context!);
      } else if (status == "rejected") {
        option = Strings.chatIsClosedText(Get.context!);
      } else {
        option = Strings.startContractNowText(Get.context!);
      }
      // pusherService.initPusher();
      // initPusher();
      getUserInfo();
      // connectToPusher();
      getLastMessages("");
      _initializePusher();
    } else {
      if (data['chatId'] != null) {
        chatId = data['chatId'];
        getChatObject();
      } else {
        // Fluttertoast.showToast(msg: Strings.somethingWentWrong(context));
      }
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> getUserInfo() async {
    _prefs = await SharedPreferences.getInstance();
    clientId = _prefs.getInt('id')!;
    print(_prefs.getInt('id')!);
    // initilizeRoom(clientId);
    // await _prefs.setString('profile_img', userObj['profile_img'] ?? "");
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (fromWhere == "OrderDetail") {
          try {
            if (chat != null) {
              if (Constants.unReadcount.value >= chat!.unreadCount.value) {
                Constants.unReadcount.value -= chat!.unreadCount.value;
              } else {
                Constants.unReadcount.value -= chat!.unreadCount.value;
              }
              Constants.unReadcount.value = 0;
              chat!.unreadCount.value = 0;
            } else {
              Get.back();
              return true;
            }
          } catch (e) {
            throw Exception(e);
          }
        } else {
          Get.back(result: backResults);
        }
        // disconnectPusher();
        // await Future.delayed(Duration(milliseconds: 100));
        return true;
      },
      child: SafeArea(
        child: chat == null
            ? Container(
                color: const Color(MyColors.whiteColor),
                height: MediaQuery.of(context).size.height.h,
                width: MediaQuery.of(context).size.width.w,
                child: const Center(
                  child: CircularProgressIndicator(
                    color: Color(MyColors.themeRedColor),
                  ),
                ),
              )
            : GestureDetector(
                onTap: () {
                  FocusScope.of(Get.context!).unfocus();
                },
                child: Scaffold(
                  backgroundColor: Colors.white,
                  resizeToAvoidBottomInset: true,
                  appBar: appBarWidget(),
                  body: isLoading.value || chat == null
                      ? const Center(
                          child: CircularProgressIndicator(
                            color: Color(MyColors.themeRedColor),
                          ),
                        )
                      : Column(
                          children: [
                            Expanded(
                              flex: 8,
                              child: Obx(() {
                                return ListView.builder(
                                  controller: _scrollController,
                                  reverse: true,
                                  padding: EdgeInsets.only(
                                      left: 10.w, right: 10.w, bottom: 10.h),
                                  itemCount: chatObj!.pagination!.hasMore!
                                      ? messagesList.length + 1
                                      : messagesList.length,
                                  itemBuilder: (context, index) {
                                    if (index == messagesList.length) {
                                      return Obx(() {
                                        return Center(
                                          child: isLoadMoreEnable.value
                                              ? const CircularProgressIndicator(
                                                  color: Color(
                                                      MyColors.grayColor300),
                                                )
                                              : DialogButton(
                                                  text: Strings.loadMoreText(
                                                      Get.context!),
                                                  color: MyColors.midGrayColor,
                                                  onPressed: () {
                                                    isLoadMoreEnable.value =
                                                        true;
                                                    getLastMessages(chatObj!
                                                        .pagination!
                                                        .nextCursor!);
                                                  },
                                                ),
                                        );
                                      });
                                    }

                                    final message = messagesList[index];

                                    return Align(
                                      alignment: message.senderId == clientId
                                          ? Alignment.centerRight
                                          : Alignment.centerLeft,
                                      child: Container(
                                        margin:
                                            EdgeInsets.symmetric(vertical: 4.r),
                                        padding: EdgeInsets.symmetric(
                                            vertical: 10.r, horizontal: 14.r),
                                        constraints: BoxConstraints(
                                          maxWidth: MediaQuery.of(context)
                                                  .size
                                                  .width
                                                  .w *
                                              0.75,
                                        ),
                                        decoration: BoxDecoration(
                                          color: message.senderId == clientId
                                              ? Colors.red[700]
                                              : const Color(
                                                  MyColors.cardGrayColor100),
                                          borderRadius: message.senderId ==
                                                  clientId
                                              ? BorderRadius.only(
                                                  bottomLeft:
                                                      Radius.circular(8.r),
                                                  topRight:
                                                      Radius.circular(8.r),
                                                  topLeft: Radius.circular(8.r),
                                                  bottomRight:
                                                      Radius.circular(0.r))
                                              : BorderRadius.only(
                                                  bottomLeft:
                                                      Radius.circular(0.r),
                                                  topRight:
                                                      Radius.circular(8.r),
                                                  topLeft: Radius.circular(8.r),
                                                  bottomRight:
                                                      Radius.circular(8.r)),
                                        ),
                                        child: Column(
                                          crossAxisAlignment:
                                              message.senderId == clientId
                                                  ? CrossAxisAlignment.end
                                                  : CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              message.message ?? "",
                                              style: TextStyle(
                                                  fontSize: 13.8,
                                                  color: message.senderId ==
                                                          clientId
                                                      ? Colors.white
                                                      : Colors.black),
                                            ),
                                            Row(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                Align(
                                                  alignment:
                                                      Alignment.bottomRight,
                                                  child: Text(
                                                    message.humanReadableCreatedAt ==
                                                            null
                                                        ? ""
                                                        : (message
                                                                        .humanReadableCreatedAt ==
                                                                    "0s ago" ||
                                                                message.humanReadableCreatedAt ==
                                                                    "1s ago" ||
                                                                message.humanReadableCreatedAt ==
                                                                    "vor 0 Sek." ||
                                                                message.humanReadableCreatedAt ==
                                                                    "vor 1 Sek.")
                                                            ? Strings.nowText(
                                                                Get.context!)
                                                            : message
                                                                .humanReadableCreatedAt!,
                                                    style: TextStyle(
                                                        fontSize: 11,
                                                        color: message
                                                                    .senderId ==
                                                                clientId
                                                            ? Colors.white70
                                                            : Colors.black54),
                                                  ),
                                                ),
                                                const SizedBox(
                                                  width: 2,
                                                ),
                                                message.sent
                                                    ? Icon(
                                                        Icons.done,
                                                        size: 14,
                                                        color: message
                                                                    .senderId ==
                                                                clientId
                                                            ? Colors.white70
                                                            : Colors.black54,
                                                      )
                                                    : const SizedBox(
                                                        width: 7,
                                                      )
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                                  },
                                );
                              }),
                            ),
                            Row(
                              children: [
                                Expanded(flex: 10, child: textfieldWidget()),
                                Expanded(
                                  flex: 2,
                                  child: GestureDetector(
                                    onTap: () {
                                      try {
                                        if (conversationContoller
                                            .messageTextField
                                            .value
                                            .text
                                            .isNotEmpty) {
                                          sendMessage(
                                            conversationContoller
                                                .messageTextField.value.text,
                                          );
                                        }
                                      } catch (e) {
                                        throw Exception(e);
                                      }
                                    },
                                    child: Center(
                                      child: SvgPicture.asset(
                                        "lib/assets/icons/sendButton.svg",
                                        fit: BoxFit.cover,
                                        height:
                                            MediaQuery.of(context).size.height /
                                                10,
                                        width:
                                            MediaQuery.of(context).size.width /
                                                8,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            )
                          ],
                        ),
                ),
              ),
      ),
    );
  }

  void updateJobStatus(String status) async {
    try {
      Commons.showProgressDialog(context);
      int chatId =
          await postedOrderDetailsController.pleaseUpdateRequestsStatus(
        jobId,
        requestId,
        status,
        context,
      );
      Commons.hideProgressDialog();
      backResults = "reload";
      if (chatId != -1) {
        setState(() {
          if (option == Strings.startContractNowText(Get.context!)) {
            option = Strings.markAsCompleteText(Get.context!);
            Fluttertoast.showToast(
                msg: Strings.yourJobstartedActiveNowActiveText(context));
          } else {
            option = Strings.jobHasBeenDoneText(Get.context!);
            Fluttertoast.showToast(
                msg: Strings.jobhasbeenCompletedText(Get.context!));
            Get.toNamed(AppLinks.review_screen, arguments: {
              'jobPostingId': chat!.jobPostingId,
              'tradesmenId': chat!.tradesmenId
            });
          }
        });
      }
    } catch (e) {
      throw Exception(e);
    }
  }

  void sendMessage(String msg) async {
    try {
      Message message = Message(
          id: null,
          chatId: chatId,
          senderId: clientId,
          receiverId: null,
          humanReadableCreatedAt: Strings.nowText(Get.context!),
          message: msg);
      message.sent = false;
      messagesList.insert(0, message);
      Message? messageObj = await conversationContoller.sendMessage(
        context,
        msg,
        chatId,
      );
      if (messageObj != null) {
        _scrollToBottom();
      }
    } catch (e) {
      throw Exception(e);
    }
  }

  Widget textfieldWidget() {
    return Padding(
      padding: EdgeInsets.only(
          bottom: 14.0.h, right: 6.0.w, left: 14.0.w, top: 8.0.h),
      child: TextFormField(
        controller: conversationContoller.messageTextField(),
        keyboardType: TextInputType.text,
        // enabled: option == "Chat is closed"
        //     ? false
        //     : option == "Job has been done"
        //         ? false
        //         : true,
        enabled: true,
        onChanged: (value) {},
        obscuringCharacter: "*",
        validator: (value) {
          return null;
        },
        decoration: InputDecoration(
          hintText: Strings.typeaMessageText(Get.context!),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.0.r),
            borderSide: BorderSide(
              width: 2.0.w,
              color: Colors.red.withOpacity(0.7),
            ),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.0.r),
            borderSide: BorderSide(
              width: 2.0.w,
              color: Colors.red.withOpacity(0.7),
            ),
          ),
          filled: true,
          fillColor: const Color(MyColors.lightSilverColor).withOpacity(0.8),
          hintStyle: TextStyle(
            fontFamily: 'Poppins',
            fontSize: 14.0.sp,
            color: const Color(0x66000000),
            fontWeight: FontWeight.w400,
          ),
          prefixIcon: null,
          prefixIconColor: const Color(0x66000000),
          suffixIcon: null,
          suffixIconColor: const Color(0x66000000),
          contentPadding: EdgeInsets.symmetric(
            horizontal: 16.0.w,
            vertical: 14.0.h,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(26.0),
            borderSide: BorderSide(
              width: 1.5.w,
              color: const Color(MyColors.fieldBorderColor),
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(26.0.r),
            borderSide: BorderSide(
              width: 1.5.w,
              color: const Color(MyColors.themeRedColor),
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(26.0),
            borderSide: BorderSide(
              width: 1.5.w,
              color: const Color(MyColors.fieldBorderColor),
            ),
          ),
        ),
      ),
    );
  }

  void _scrollToBottom() {
    _scrollController.animateTo(
      0.0, // Since list is reversed, scroll to top (which is actually bottom)
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOut,
    );
  }

  void getLastMessages(String cursor) async {
    try {
      chatObj =
          await conversationContoller.pleaseGetChat(context, chatId, cursor);
      if (chatObj != null) {
        messagesList.addAll(chatObj!.list!);
        isLoading.value = false;
        isLoadMoreEnable.value = false;
        setState(() {});
      } else {
        Fluttertoast.showToast(msg: Strings.somethingWentWrong(context));
      }
    } catch (e) {
      throw Exception(e);
    }
  }

  Future<void> _initializePusher() async {
    try {
      NewMessageController controller = Get.put(NewMessageController());
      controller.messages.clear();
      ever<List<Message>>(controller.messages, (messages) {
        if (mounted) {
          if (messages.isNotEmpty) {
            print("New message added: ${messages.last.message}");
            if (messages.last.chatId == chatId) {
              if (messages.last.senderId == clientId) {
                messagesList.insert(0, messages.last);
                messagesList.removeAt(1);
              } else {
                messagesList.insert(0, messages.last);
              }
              _scrollToBottom();
            }
          }
        }
      });
    } catch (e) {
      print('Failed to initialize Pusher: $e');
    }
  }

  void disconnectPusher() {
    try {
      reverb.close();
      // reverb = null;
      print("🔌 Disconnected from Pusher.");
    } catch (e) {
      print("🔌 Disconnected from Pusher.");
      // debugPrint("Error while disconnecting from Pusher: $e");
    }
  }

  Future<void> getChatObject() async {
    try {
      chat = await conversationContoller.pleaseGetChatObject(chatId, context);
      if (chat == null) {
        Fluttertoast.showToast(msg: Strings.somethingWentWrong(context));
        return;
      }
      setState(() {});

      jobId = chat!.jobPostingId!;
      jobStatus = chat!.jobStatus!;
      requestId = chat!.jobApplicationId!;
      chatId = chat!.id!;
      status = chat!.applicationStatus!;
      if (jobStatus == "completed") {
        option = Strings.jobHasBeenDoneText(Get.context!);
      } else if (jobStatus == "in_progress" && status == "in_progress") {
        option = Strings.markAsCompleteText(Get.context!);
      } else if (status == "rejected") {
        option = Strings.completed(Get.context!);
      } else {
        option = Strings.startConversation(Get.context!);
      }
      getUserInfo();
      getLastMessages("");
      _initializePusher();
    } catch (e) {
      throw Exception(e);
    }
  }

  PreferredSizeWidget appBarWidget() {
    return AppBar(
      leadingWidth: MediaQuery.of(context).size.width.w,
      toolbarHeight: 170.h,
      leading: Container(
        color: const Color(MyColors.whiteColor),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  flex: 1,
                  child: Center(
                    child: GestureDetector(
                      onTap: () async {
                        try {
                          if (fromWhere == "OrderDetail") {
                            try {
                              if (chat != null) {
                                if (Constants.unReadcount.value >=
                                    chat!.unreadCount.value) {
                                  Constants.unReadcount.value -=
                                      chat!.unreadCount.value;
                                } else {
                                  Constants.unReadcount.value -=
                                      chat!.unreadCount.value;
                                }
                                Constants.unReadcount.value = 0;
                                chat!.unreadCount.value = 0;
                              }
                            } catch (e) {
                              throw Exception(e);
                            }
                            Get.back(result: backResults);
                          } else {
                            Get.back(result: backResults);
                          }
                        } catch (e) {
                          throw Exception(e);
                        }
                      },
                      child: Padding(
                        padding: EdgeInsets.only(left: 12.0.w),
                        child: const Icon(Icons.arrow_back_ios),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  flex: 7,
                  child: GestureDetector(
                    onTap: () {
                      Get.toNamed(
                        AppLinks.tradesmen_detail_screen,
                        arguments: {'tradesmenId': chat!.tradesmenId ?? -1},
                      );
                    },
                    child: Row(
                      children: [
                        chat!.profileImg != null
                            ? Padding(
                                padding: EdgeInsets.all(4.0.r),
                                child: CircleAvatar(
                                  backgroundImage: NetworkImage(
                                    chat!.profileImg.toString(),
                                  ),
                                ),
                              )
                            : Image.asset(
                                "lib/assets/icons/placeholder_tradesmen.png",
                              ),
                        Padding(
                          padding: EdgeInsets.only(
                            top: 8.0.h,
                            left: 8.0.w,
                            right: 8.0.w,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                chat!.tradesmenName!,
                                textAlign: TextAlign.start,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 16.0.sp,
                                  fontWeight: FontWeight.w500,
                                  fontFamily: 'Poppins',
                                ),
                              ),
                              Text(
                                chat!.serviceName!,
                                textAlign: TextAlign.start,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 12.0.sp,
                                  fontWeight: FontWeight.w500,
                                  fontFamily: 'Poppins',
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            Container(
              color: const Color(MyColors.cardGrayColor100),
              child: Padding(
                padding: EdgeInsets.only(left: 6.0.w, right: 6.0.w, top: 6.0.h),
                child: Column(
                  children: [
                    Align(
                      alignment: Alignment.topLeft,
                      child: Padding(
                        padding: EdgeInsets.only(left: 8.0.w),
                        child: HeadingTextW500(
                            text:
                                "${Strings.jobText(Get.context!)}: ${chat!.jobTitle ?? "N/A"}",
                            centerAlign: false,
                            size: 13.sp),
                      ),
                    ),
                    Align(
                        alignment: Alignment.topLeft,
                        child: Padding(
                          padding: EdgeInsets.all(2.0.r),
                          child: Card(
                            elevation: 0,
                            color: option ==
                                    Strings.markAsCompleteText(Get.context!)
                                ? const Color(MyColors.cardColorGreenLight)
                                : option ==
                                        Strings.chatIsClosedText(Get.context!)
                                    ? const Color(MyColors.cardcolorOrange200)
                                    : option ==
                                            Strings.startContractNowText(
                                                Get.context!)
                                        ? const Color(MyColors.cardColorSky200)
                                        : option ==
                                                Strings.jobHasBeenDoneText(
                                                    Get.context!)
                                            ? const Color(
                                                MyColors.cardColorGreen200)
                                            : const Color(
                                                MyColors.cardcolorOrange200),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(6.0.r)),
                            child: Padding(
                              padding: EdgeInsets.only(
                                  left: 3.0.w, right: 3.0.w, top: 3.0.h),
                              child: option ==
                                      Strings.markAsCompleteText(Get.context!)
                                  ? Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Lottie.asset(
                                          'lib/assets/icons/ActiveStatusRipple.json',
                                          width: 14.0.w,
                                          height: 14.0.h,
                                          fit: BoxFit.contain,
                                          repeat: true,
                                          animate: true,
                                        ),
                                        SizedBox(
                                          width: 2.0.w,
                                        ),
                                        Headingdescription(
                                            text: Strings.active(context),
                                            centerAlign: false,
                                            size: 12.sp)
                                      ],
                                    )
                                  : option ==
                                          Strings.startContractNowText(
                                              Get.context!)
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
                                                text:
                                                    Strings.inProcess(context),
                                                centerAlign: false,
                                                size: 12.sp)
                                          ],
                                        )
                                      : option ==
                                              Strings.jobHasBeenDoneText(
                                                  Get.context!)
                                          ? Row(
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
                                                    text: Strings.completed(
                                                        context),
                                                    centerAlign: false,
                                                    size: 12.sp)
                                              ],
                                            )
                                          : Row(
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
                                                        context),
                                                    centerAlign: false,
                                                    size: 12.sp)
                                              ],
                                            ),
                            ),
                          ),
                        )),
                    Padding(
                      padding: EdgeInsets.only(left: 8.0.w, right: 8.0.w),
                      child: FullWidthElevatedButton(
                        text: option,
                        color: option ==
                                Strings.markAsCompleteText(Get.context!)
                            ? MyColors.themeRedColor
                            : option == Strings.jobHasBeenDoneText(Get.context!)
                                ? MyColors.lightGrayColor
                                : option ==
                                        Strings.chatIsClosedText(Get.context!)
                                    ? MyColors.lightGrayColor
                                    : MyColors.themeRedColor,
                        onPressed: () {
                          if (option ==
                              Strings.startContractNowText(Get.context!)) {
                            updateJobStatus("in_progress");
                          } else if (option ==
                              Strings.markAsCompleteText(Get.context!)) {
                            showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                title:
                                    Text(Strings.jobHasBeenDoneText(context)),
                                content: Text(Strings
                                    .areYouSureToCompleteThisContractText(
                                        Get.context!)),
                                contentTextStyle: TextStyle(
                                    fontSize: 15.5.sp, color: Colors.black),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12.sp)),
                                backgroundColor:
                                    const Color(MyColors.colorRed200),
                                actions: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      Expanded(
                                        child: Padding(
                                          padding: EdgeInsets.only(
                                              left: 8.0.w, right: 8.0.w),
                                          child: FullWidthOutlineButton(
                                              text: Strings.noText(context),
                                              fontsize: 15.0.sp,
                                              color: MyColors.themeRedColor,
                                              onPressed: () {
                                                Get.back();
                                              }),
                                        ),
                                      ),
                                      Expanded(
                                        child: Padding(
                                          padding: EdgeInsets.only(
                                              left: 8.0.w, right: 8.0.w),
                                          child: FullWidthButtonPrimary(
                                              text: Strings.yesText(context),
                                              fontsize: 15.0.sp,
                                              color: MyColors.themeRedColor,
                                              onPressed: () {
                                                Get.back();
                                                updateJobStatus("completed");
                                              }),
                                        ),
                                      )
                                    ],
                                  ),
                                ],
                              ),
                            );
                          } else {}
                        },
                        textColor: MyColors.whiteColor,
                      ),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
