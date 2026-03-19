import 'dart:async';

import 'package:flutter/material.dart';
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
  String option = "Start Contract Now";
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
  late Chat? chat;
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
      print("object");
      chat = data['chat'];
      jobId = chat!.jobPostingId!;
      jobStatus = chat!.jobStatus!;
      requestId = chat!.jobApplicationId!;
      chatId = chat!.id!;
      status = chat!.applicationStatus!;
      if (jobStatus == "completed") {
        option = "Job has been done";
      } else if (jobStatus == "in_progress" && status == "in_progress") {
        option = "Mark as Complete";
      } else if (status == "rejected") {
        option = "Chat is closed";
      } else {
        option = "Start Contract Now";
      }
      // pusherService.initPusher();
      // initPusher();
      getUserInfo();
      // connectToPusher();
      getLastMessages("");
      _initializePusher();
    } else {
      print("object2");
      if (data['chatId'] != null) {
        chatId = data['chatId'];
        getChatObject();
      } else {
        Fluttertoast.showToast(msg: Strings.somethingWentWrong(context));
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
      child: SafeArea(child: Obx(() {
        return isLoading.value
            ? const Center(
                child: CircularProgressIndicator(
                  color: Color(MyColors.themeRedColor),
                ),
              )
            : Scaffold(
                backgroundColor: Colors.white,
                resizeToAvoidBottomInset: false,
                appBar: AppBar(
                  leadingWidth: MediaQuery.of(context).size.width,
                  leading: Container(
                    color: const Color(MyColors.whiteColor),
                    child: Row(
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
                              child: const Padding(
                                padding: EdgeInsets.only(left: 12.0),
                                child: Icon(Icons.arrow_back_ios),
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
                                arguments: {
                                  'tradesmenId': chat!.tradesmenId ?? -1
                                },
                              );
                            },
                            child: Row(
                              children: [
                                chat!.profileImg != null
                                    ? Padding(
                                        padding: const EdgeInsets.all(4.0),
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
                                  padding: const EdgeInsets.only(
                                    top: 8.0,
                                    left: 8.0,
                                    right: 8.0,
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        chat!.tradesmenName!,
                                        textAlign: TextAlign.start,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: const TextStyle(
                                          color: Colors.black,
                                          fontSize: 16,
                                          fontWeight: FontWeight.w500,
                                          fontFamily: 'Poppins',
                                        ),
                                      ),
                                      Text(
                                        chat!.serviceName!,
                                        textAlign: TextAlign.start,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: const TextStyle(
                                          color: Colors.black,
                                          fontSize: 12,
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
                  ),
                ),
                body: Obx(() {
                  return Column(
                    children: [
                      Expanded(
                        flex: 3,
                        child: Container(
                          color: const Color(MyColors.cardGrayColor100),
                          child: Padding(
                            padding: const EdgeInsets.only(
                                left: 6.0, right: 6.0, top: 6.0),
                            child: Column(
                              children: [
                                Align(
                                  alignment: Alignment.topLeft,
                                  child: Padding(
                                    padding: const EdgeInsets.only(left: 8.0),
                                    child: HeadingTextW500(
                                        text: "Job: ${chat!.jobTitle ?? "N/A"}",
                                        centerAlign: false,
                                        size: 13),
                                  ),
                                ),
                                Align(
                                    alignment: Alignment.topLeft,
                                    child: Padding(
                                      padding: const EdgeInsets.all(2.0),
                                      child: Card(
                                        elevation: 0,
                                        color: option == "Mark as Complete"
                                            ? const Color(
                                                MyColors.cardColorGreenLight)
                                            : option == "Chat is closed"
                                                ? const Color(
                                                    MyColors.cardcolorOrange200)
                                                : option == "Start Contract Now"
                                                    ? const Color(MyColors
                                                        .cardColorSky200)
                                                    : option ==
                                                            "Job has been done"
                                                        ? const Color(MyColors
                                                            .cardColorGreen200)
                                                        : const Color(MyColors
                                                            .cardcolorOrange200),
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(6)),
                                        child: Padding(
                                          padding: const EdgeInsets.only(
                                              left: 3.0, right: 3.0, top: 3.0),
                                          child: option == "Mark as Complete"
                                              ? Row(
                                                  mainAxisSize:
                                                      MainAxisSize.min,
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
                                                        text: Strings.active(
                                                            context),
                                                        centerAlign: false,
                                                        size: 12)
                                                  ],
                                                )
                                              : option == "Start Contract Now"
                                                  ? Row(
                                                      mainAxisSize:
                                                          MainAxisSize.min,
                                                      children: [
                                                        SvgPicture.asset(
                                                            "lib/assets/icons/inprocessIcon.svg",
                                                            height: 14.0,
                                                            width: 14.0),
                                                        const SizedBox(
                                                          width: 2.0,
                                                        ),
                                                        Headingdescription(
                                                            text: Strings
                                                                .inProcess(
                                                                    context),
                                                            centerAlign: false,
                                                            size: 12)
                                                      ],
                                                    )
                                                  : option ==
                                                          "Job has been done"
                                                      ? Row(
                                                          mainAxisSize:
                                                              MainAxisSize.min,
                                                          children: [
                                                            SvgPicture.asset(
                                                                "lib/assets/icons/completedTickIcon.svg",
                                                                height: 14.0,
                                                                width: 14.0),
                                                            const SizedBox(
                                                              width: 2.0,
                                                            ),
                                                            Headingdescription(
                                                                text: Strings
                                                                    .completed(
                                                                        context),
                                                                centerAlign:
                                                                    false,
                                                                size: 12)
                                                          ],
                                                        )
                                                      : Row(
                                                          mainAxisSize:
                                                              MainAxisSize.min,
                                                          children: [
                                                            SvgPicture.asset(
                                                                "lib/assets/icons/jobCancelledIcon.svg",
                                                                height: 14.0,
                                                                width: 14.0),
                                                            const SizedBox(
                                                              width: 2.0,
                                                            ),
                                                            Headingdescription(
                                                                text: Strings
                                                                    .canceledText(
                                                                        context),
                                                                centerAlign:
                                                                    false,
                                                                size: 12)
                                                          ],
                                                        ),
                                        ),
                                      ),
                                    )),
                                Padding(
                                  padding: const EdgeInsets.only(
                                      left: 8.0, right: 8.0),
                                  child: FullWidthElevatedButton(
                                    text: option,
                                    color: option == "Mark as Complete"
                                        ? MyColors.themeRedColor
                                        : option == "Job has been done"
                                            ? MyColors.lightGrayColor
                                            : option == "Chat is closed"
                                                ? MyColors.lightGrayColor
                                                : MyColors.themeRedColor,
                                    onPressed: () {
                                      if (option == "Start Contract Now") {
                                        updateJobStatus("in_progress");
                                      } else if (option == "Mark as Complete") {
                                        showDialog(
                                          context: context,
                                          builder: (context) => AlertDialog(
                                            title: const Text("Job is done"),
                                            content: const Text(
                                                "Are you sure to complete this contract?"),
                                            contentTextStyle: const TextStyle(
                                                fontSize: 15.5,
                                                color: Colors.black),
                                            shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(12)),
                                            backgroundColor: const Color(
                                                MyColors.colorRed200),
                                            actions: [
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceEvenly,
                                                children: [
                                                  Expanded(
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              left: 8.0,
                                                              right: 8.0),
                                                      child:
                                                          FullWidthOutlineButton(
                                                              text: Strings
                                                                  .noText(
                                                                      context),
                                                              fontsize: 15.0,
                                                              color: MyColors
                                                                  .themeRedColor,
                                                              onPressed: () {
                                                                Get.back();
                                                              }),
                                                    ),
                                                  ),
                                                  Expanded(
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              left: 8.0,
                                                              right: 8.0),
                                                      child:
                                                          FullWidthButtonPrimary(
                                                              text: Strings
                                                                  .yesText(
                                                                      context),
                                                              fontsize: 15.0,
                                                              color: MyColors
                                                                  .themeRedColor,
                                                              onPressed: () {
                                                                Get.back();
                                                                updateJobStatus(
                                                                    "completed");
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
                        ),
                      ),
                      Expanded(
                        flex: 15,
                        child: Padding(
                          padding: const EdgeInsets.only(
                              bottom: 8.0, left: 8.0, right: 8.0, top: 4.0),
                          child: Column(
                            children: [
                              Obx(() {
                                return Expanded(
                                  child: ListView.builder(
                                    padding: const EdgeInsets.all(10),
                                    itemCount: chatObj!.pagination!.hasMore!
                                        ? messagesList.length + 1
                                        : messagesList.length,
                                    reverse: true,
                                    controller: _scrollController,
                                    itemBuilder: (context, index) {
                                      if (index == messagesList.length) {
                                        return Obx(() {
                                          return isLoadMoreEnable.value
                                              ? const Center(
                                                  child:
                                                      CircularProgressIndicator(
                                                    color: Colors.red,
                                                  ),
                                                )
                                              : GestureDetector(
                                                  onTap: () {
                                                    try {
                                                      isLoadMoreEnable.value =
                                                          true;
                                                      getLastMessages(chatObj!
                                                          .pagination!
                                                          .nextCursor!);
                                                    } catch (e) {
                                                      throw Exception(e);
                                                    }
                                                  },
                                                  child: Card(
                                                    elevation: 0,
                                                    shape:
                                                        RoundedRectangleBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        6)),
                                                    color: const Color(MyColors
                                                        .cardColorGreen200),
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              5.0),
                                                      child: Text("Load More",
                                                          textAlign:
                                                              TextAlign.center,
                                                          style: TextStyle(
                                                              color: Colors
                                                                  .black
                                                                  .withOpacity(
                                                                      0.8),
                                                              fontSize: 14,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500,
                                                              fontFamily:
                                                                  'Poppins')),
                                                    ),
                                                  ),
                                                );
                                        });
                                      } else {
                                        final message = messagesList[index];
                                        return Align(
                                          alignment:
                                              message.senderId == clientId
                                                  ? Alignment.centerRight
                                                  : Alignment.centerLeft,
                                          child: Container(
                                            padding: const EdgeInsets.symmetric(
                                              vertical: 10,
                                              horizontal: 14,
                                            ),
                                            margin: const EdgeInsets.symmetric(
                                              vertical: 4,
                                            ),
                                            constraints: BoxConstraints(
                                              maxWidth: MediaQuery.of(
                                                    context,
                                                  ).size.width *
                                                  0.75,
                                            ),
                                            decoration: BoxDecoration(
                                              color:
                                                  message.senderId == clientId
                                                      ? Colors.blue[100]
                                                      : const Color(MyColors
                                                          .cardGrayColor100),
                                              borderRadius:
                                                  BorderRadius.circular(
                                                10,
                                              ),
                                            ),
                                            child: Text(message.message!),
                                          ),
                                        );
                                      }
                                    },
                                  ),
                                );
                              }),
                            ],
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 2,
                        child: Row(
                          children: [
                            Expanded(flex: 10, child: textfieldWidget()),
                            Expanded(
                              flex: 2,
                              child: GestureDetector(
                                onTap: () {
                                  try {
                                    if (conversationContoller.messageTextField
                                        .value.text.isNotEmpty) {
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
                                        MediaQuery.of(context).size.height / 10,
                                    width:
                                        MediaQuery.of(context).size.width / 8,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  );
                }),
              );
      })),
    );
  }

  void updateJobStatus(String status) async {
    try {
      Commons.showProgressDialog(context);
      bool res = await postedOrderDetailsController.pleaseUpdateRequestsStatus(
        jobId,
        requestId,
        status,
        context,
      );
      Commons.hideProgressDialog();
      backResults = "reload";
      if (res) {
        setState(() {
          if (option == "Start Contract Now") {
            option = "Mark as Complete";
            Fluttertoast.showToast(msg: "Your Job is started and Active Now");
          } else {
            option = "Job has been done";
            Fluttertoast.showToast(msg: "Your Job has Completed!");
            Get.offAllNamed(AppLinks.review_screen, arguments: {
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

  void sendMessage(String message) async {
    try {
      Message? messageObj = await conversationContoller.sendMessage(
        context,
        message,
        chatId,
      );
      if (messageObj != null) {
        messagesList.insert(0, messageObj);
        _scrollToBottom();
      }
    } catch (e) {
      throw Exception(e);
    }
  }

  Widget textfieldWidget() {
    return Padding(
      padding:
          const EdgeInsets.only(bottom: 14.0, right: 6.0, left: 14.0, top: 8.0),
      child: TextFormField(
        controller: conversationContoller.messageTextField(),
        keyboardType: TextInputType.text,
        enabled: option == "Chat is closed"
            ? false
            : option == "Job has been done"
                ? false
                : true,
        onChanged: (value) {},
        obscuringCharacter: "*",
        validator: (value) {
          if (value == null || value.isEmpty) {
            return "Field cannot be empty!";
          } else if (value.length < 3) {
            return "Must be at least 3 characters long!";
          }
          return null;
        },
        decoration: InputDecoration(
          hintText: "Type a Message...",
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.0),
            borderSide: BorderSide(
              width: 2.0,
              color: Colors.red.withOpacity(0.7),
            ),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.0),
            borderSide: BorderSide(
              width: 2.0,
              color: Colors.red.withOpacity(0.7),
            ),
          ),
          filled: true,
          fillColor: const Color(MyColors.lightSilverColor),
          hintStyle: const TextStyle(
            fontFamily: 'Poppins',
            fontSize: 14.0,
            color: Color(0x66000000),
            fontWeight: FontWeight.w400,
          ),
          prefixIcon: null,
          prefixIconColor: const Color(0x66000000),
          suffixIcon: null,
          suffixIconColor: const Color(0x66000000),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16.0,
            vertical: 14.0,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.0),
            borderSide: const BorderSide(
              width: 2.0,
              color: Color(MyColors.fieldBorderColor),
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.0),
            borderSide: const BorderSide(
              width: 2.0,
              color: Color(MyColors.fieldBorderColor),
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.0),
            borderSide: const BorderSide(
              width: 2.0,
              color: Color(MyColors.fieldBorderColor),
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
              messagesList.insert(0, messages.last);
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

      jobId = chat!.jobPostingId!;
      jobStatus = chat!.jobStatus!;
      requestId = chat!.jobApplicationId!;
      chatId = chat!.id!;
      status = chat!.applicationStatus!;
      if (jobStatus == "completed") {
        option = "Job has been done";
      } else if (jobStatus == "in_progress" && status == "in_progress") {
        option = "Mark as Complete";
      } else if (status == "rejected") {
        option = "Completeddd";
      } else {
        option = "Start Contract Now";
      }
      getUserInfo();
      getLastMessages("");
      _initializePusher();
    } catch (e) {
      throw Exception(e);
    }
  }
}
