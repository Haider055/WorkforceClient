import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:simple_flutter_reverb/simple_flutter_reverb.dart';
import 'package:simple_flutter_reverb/simple_flutter_reverb_options.dart';
import 'package:workforceclientapp/Controllers/AllChatsContoller.dart';
import 'package:workforceclientapp/Controllers/LoginContoller.dart';
import 'package:workforceclientapp/Controllers/NotificationScreenContoller.dart';
import 'package:workforceclientapp/Models/CheckBoxQuestion.dart';
import 'package:workforceclientapp/Models/Message.dart';
import 'package:workforceclientapp/Models/QuestionOption.dart';
import 'package:workforceclientapp/Models/RadioQuestion.dart';
import 'package:workforceclientapp/Models/Services.dart';
import 'package:workforceclientapp/Models/TextQuestion.dart';
import 'package:workforceclientapp/Others/Commons.dart';
import 'package:workforceclientapp/Others/Constants.dart';
import 'package:workforceclientapp/Others/MyColors.dart';
import 'package:workforceclientapp/Others/NewMessageController.dart';
import 'package:workforceclientapp/Others/Strings.dart';
import 'package:workforceclientapp/Others/routes.dart';
import 'package:workforceclientapp/views/screens/Chat/ConversationScreen.dart';

class SelectServiceController extends GetxController {
  final searchController = TextEditingController().obs;
  RxBool showServicesSuggestions = false.obs;
  RxList<Services> filteredOptions = <Services>[].obs;
  RxInt textFieldBorderColor = MyColors.lightGrayColor.obs;
  RxList<Services> allOptions = <Services>[].obs;
  RxList<Services> allListOptions = <Services>[].obs;
  RxBool isLoading = true.obs;
  late SharedPreferences _prefs;
  RxString isLoggedIn = "".obs;
  RxInt unreadMessagesCount = 0.obs;
  late final SimpleFlutterReverb reverb;
  final data = Get.arguments;
  String toWhere = "";
  RxBool isSearchingQuery = false.obs;
  late int searchMillis;
  RxString searchInput = "".obs;
  int selectedServiceId = -1;
  String selectedServiceName = "";
  final RxInt currentIndex = 0.obs;
  int chatLinstenerRetryCount = 0;
  RxBool isEnabled = true.obs;

  @override
  void onInit() {
    super.onInit();
    init();
  }

  void refreshData() async {
    // print("called refresh");
    isLoading.value = true;
    await getAllOptionsOfServices();
    isLoading.value = false;
  }

  void init() async {
    isEnabled.value = true;
    await getAllOptionsOfServices();
    await getNotificationsCount();
    manageIfFcmTokenNotSaved();
    await checkIsLoggedIn();
    AllChatsContoller controller = Get.put(AllChatsContoller());
    controller.dispose();

    if (data != null) {
      toWhere = data['toWhere'] ?? "";
      if (toWhere == "PostedJobs") {
        Get.find<SelectServiceController>().currentIndex.value = 1;
      }
    }
    ever<int>(Constants.unReadcount, (value) {
      print("New unread added: $value");
      if (isLoggedIn != "loggedOut") {
        unreadMessagesCount.value = value;
        // playSound();
      }
      updateUnredMessagesCount(value);
    });
  }

  // final player = AudioPlayer();
  // Future<void> playSound() async {
  //   await player.play(AssetSource('mp3/comingmessagetune.mp3'));
  // }

  Future<String?> getDeviceId() async {
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();

    if (Platform.isAndroid) {
      AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
      return androidInfo.id; // Android ID (may not be stable)
    } else if (Platform.isIOS) {
      IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
      return iosInfo.identifierForVendor; // iOS unique device ID
    }
    return null;
  }

  Future<void> getUnredMessagesCount() async {
    try {
      unreadMessagesCount.value = 0;
      unreadMessagesCount.value = await pleaseGetUnreadMessageCount();
      Constants.unReadcount = unreadMessagesCount;
    } catch (e) {
      throw Exception(e);
    }
  }

  Future<void> checkIsLoggedIn() async {
    _prefs = await SharedPreferences.getInstance();
    isLoggedIn.value = _prefs.getString("isLogin") ?? "loggedOut";
    print(isLoggedIn.value);
    if (isLoggedIn.value != "loggedOut") {
      await getUnredMessagesCount();
      startChatListener();
      manageIfComesFromNotificationClick();
    }
    isLoading.value = false;
    // manageIfComesFromNotificationClick();
  }

  Future<void> manageIfComesFromNotificationClick() async {
    try {
      if (isLoggedIn.value != "loggedOut") {
        RemoteMessage? initialMessage =
            await FirebaseMessaging.instance.getInitialMessage();
        if (initialMessage != null) {
          _handleNotificationTap(initialMessage.data);
        }
      }
    } catch (e) {
      print(e.toString());
    }
  }

  void _handleNotificationTap(Map<String, dynamic> data) {
    // Example: navigate based on type
    final String? type = data['type'];
    Fluttertoast.showToast(msg: type!);
    Fluttertoast.showToast(msg: "Notification tapped ${type.toString()}");
    print(data.toString());
    if (type == "View Job Details" ||
        type == "View Job Posting" ||
        type == "View Request Details" ||
        type == "Jobdetails anzeigen" ||
        type == "Anfragedetails anzeigen" ||
        type == "job_posted") {
      int jobPostingId = data['job_posting_id'] == null
          ? -1
          : int.parse(data['job_posting_id']);
      Get.toNamed(AppLinks.orders_details_screen,
          arguments: {'jobId': jobPostingId});
    } else if (type == "View Job Application" ||
        type == "Bewerbung anzeigen" ||
        type == "request_approved" ||
        type == "anfrage_genehmigt") {
      int jobPostingId = data['job_posting_id'] == null
          ? -1
          : int.parse(data['job_posting_id']);
      Get.toNamed(AppLinks.orders_details_screen,
          arguments: {'jobId': jobPostingId, 'section': "tradesmen"});
    } else if (type == "message_received") {
      Constants.fromNotifications.value = true;
      int chatId = data['chat_id'] == null ? -1 : int.parse(data['chat_id']);
      Get.to(
        const ConversationScreen(),
        arguments: {
          'chat': null,
          'chatId': chatId,
          'fromWhere': 'notification'
        },
        transition: Transition.rightToLeft, // Left-to-right animation
        duration:
            const Duration(milliseconds: 500), // Optional: animation duration
      );
    }
    print(type);
  }

  Future<void> manageIfFcmTokenNotSaved() async {
    try {
      _prefs = await SharedPreferences.getInstance();
      String token = _prefs.getString('fcm_token') ?? "";
      String isLogin = _prefs.getString('isLogin') ?? "";
      if (isLogin == "loggedIn" && token.isEmpty) {
        LoginContoller loginContoller = Get.put(LoginContoller());
        loginContoller.fCMSaveToken();
      }
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> getAllOptionsOfServices() async {
    allListOptions.value = await pleaseGetAllServices();
  }

  Future<void> getNotificationsCount() async {
    Get.put(NotificationScreenContoller());
    // NotificationList? notificationList = await notificationScreenContoller
    //     .getAllNotificationList(Get.context!, "");
    // if (notificationList != null) {
    //   for (var i = 0; i < notificationList.notificationsList!.length; i++) {
    //     if (!notificationList.notificationsList![i].isRead.value) {
    //       Constants.unreadNotificationsCount.value++;
    //     }
    //   }
    //   // unreadNotificationsCount.value =
    //   //     notificationList.notificationsList!.length;
    // }
  }

  Future<List<Services>> pleaseGetServices(String query) async {
    List<Services> list = [];

    try {
      final response = await http
          .get(Uri.parse('${Constants.baseUrl}/services?search=$query'),
              headers: await Commons.manageRequestHeader())
          .timeout(const Duration(seconds: 5));

      Map<String, dynamic> jsonData = json.decode(response.body);

      if (response.statusCode == 200) {
        if (jsonData['success']) {
          if (jsonData.keys.contains('data')) {
            Map<String, dynamic> dataObj = jsonData['data'];
            if (dataObj.keys.contains('services')) {
              // List<dynamic> servicesList = jsonData['services'];
              Iterable l = dataObj['services'];
              list = List<Services>.from(
                  l.map((model) => Services.fromJson(model)));
            }
          }

          return list;
        } else {
          Fluttertoast.showToast(msg: Strings.somethingWentWrong(Get.context!));
          return list;
        }
      } else if (response.statusCode == 403) {
        Fluttertoast.showToast(
            msg: Strings.accountBlockedMessage(Get.context!));
        Commons.logoutUser(true);
        return list;
      } else {
        Fluttertoast.showToast(msg: Strings.somethingWentWrong(Get.context!));
        return list;
      }
    } on TimeoutException {
      Fluttertoast.showToast(msg: Strings.somethingWentWrong(Get.context!));
      return list;
    } catch (e) {
      throw Exception(e);
    }
  }

  Future<List<Services>> pleaseGetAllServices() async {
    List<Services> list = [];

    try {
      final response = await http
          .get(Uri.parse('${Constants.baseUrl}/services'),
              headers: await Commons.manageRequestHeader())
          .timeout(const Duration(seconds: 5));

      Map<String, dynamic> jsonData = json.decode(response.body);
      print(response.body);

      if (response.statusCode == 200) {
        // If the server did return a 200 CREATED response,
        // then parse the JSON.

        if (jsonData['success']) {
          if (jsonData.keys.contains('data')) {
            Map<String, dynamic> dataObj = jsonData['data'];
            if (dataObj.keys.contains('services')) {
              Iterable l = dataObj['services'];
              list = List<Services>.from(
                  l.map((model) => Services.fromJson(model)));
            }
          }

          return list;
        } else {
          Fluttertoast.showToast(msg: Strings.somethingWentWrong(Get.context!));
          return list;
        }
      } else if (response.statusCode == 403) {
        Fluttertoast.showToast(
            msg: Strings.accountBlockedMessage(Get.context!));
        Commons.logoutUser(true);
        return list;
      } else {
        // If the server did not return a 200 CREATED response,
        // then throw an exception.
        Fluttertoast.showToast(msg: Strings.somethingWentWrong(Get.context!));
        return list;
      }
    } on TimeoutException {
      Fluttertoast.showToast(msg: Strings.somethingWentWrong(Get.context!));
      return list;
    } catch (e) {
      throw Exception(e);
    }
  }

  Future<String> pleaseGetAllServiceQuestions(int id, String name) async {
    List<RadioQuestion> radioQuestionsList = [];
    List<TextQuestion> textQuestionsList = [];
    List<CheckBoxQuestion> checkboxQuestionsList = [];
    List<QuestionOption> questionOptions = [];
    List<Map<String, dynamic>> qList = [];
    try {
      isEnabled.value = false;
      final response = await http
          .get(Uri.parse('${Constants.baseUrl}/services/$id/questions'),
              headers: await Commons.manageRequestHeader())
          .timeout(const Duration(seconds: 7));

      print(response.body.toString());

      Map<String, dynamic> jsonData = json.decode(response.body);

      if (response.statusCode == 200) {
        // If the server did return a 200 CREATED response,
        // then parse the JSON.

        Constants.selectedServiceId = id;
        Constants.selectedServiceName = name;

        if (jsonData['success']) {
          if (jsonData.keys.contains('data')) {
            Map<String, dynamic> dataObj = jsonData['data'];
            if (dataObj.keys.contains('questions')) {
              Map<String, dynamic> questionsObj = dataObj['questions'];
              if (questionsObj.keys.contains('questions')) {
                List<dynamic> questionsArray = questionsObj['questions'];
                if (questionsArray.isNotEmpty) {
                  for (var question in questionsArray) {
                    if (question['type'] == "radio") {
                      List<QuestionOption> questionOptions = [];
                      List<dynamic> options = question['options'];
                      if (options.isNotEmpty) {
                        for (var option in options) {
                          questionOptions.add(QuestionOption.fromJson(option));
                        }
                      }
                      radioQuestionsList.add(
                          RadioQuestion.fromJson(question, questionOptions));
                      qList.add({
                        "radio":
                            RadioQuestion.fromJson(question, questionOptions)
                      });
                    } else if (question['type'] == "checkbox") {
                      List<QuestionOption> questionOptions = [];
                      List<dynamic> options = question['options'];
                      if (options.isNotEmpty) {
                        for (var option in options) {
                          questionOptions.add(QuestionOption.fromJson(option));
                        }
                      }
                      checkboxQuestionsList.add(
                          CheckBoxQuestion.fromJson(question, questionOptions));
                      qList.add({
                        "checkbox":
                            CheckBoxQuestion.fromJson(question, questionOptions)
                      });
                    } else if (question['type'] == "text") {
                      textQuestionsList.add(TextQuestion.fromJson(question));
                      qList.add({"text": TextQuestion.fromJson(question)});
                    }
                  }
                }
              }
            }
          }
          Constants.questionsList = qList;

          if (qList.isNotEmpty) {
            isEnabled.value = false;
            Constants.jobPostingSteps = qList.length + 4;
            Constants.currentJobPostingStep.value = 1;
            Constants.jobTitle = "";
            Constants.jobDescription = "";
            Constants.jobPostingCity = "";
            Constants.jobPostingCountry = "";
            Constants.jobPostingPostcode = "";
            Constants.jobPostingState = "";
            Constants.jobPostingLat = "";
            Constants.jobPostingLng = "";
            Constants.jobPostingAddress = "";
            searchController.value.text = "";
            Commons.hideProgressDialog();
            Get.toNamed(AppLinks.job_title_screen);
            return "";
          } else {
            isEnabled.value = false;
            Constants.jobPostingSteps = 4;
            Constants.currentJobPostingStep.value = 1;
            Commons.hideProgressDialog();
            Get.toNamed(AppLinks.job_title_screen);
            return "error";
          }
        } else {
          isEnabled.value = true;
          String msg = jsonData['message'];
          Fluttertoast.showToast(msg: msg);
          return "error";
        }
      } else if (response.statusCode == 403) {
        Fluttertoast.showToast(
            msg: Strings.accountBlockedMessage(Get.context!));
        Commons.logoutUser(true);
        return '';
      } else {
        // If the server did not return a 200 CREATED response,
        // then throw an exception.
        isEnabled.value = true;
        String msg = jsonData['message'];
        Fluttertoast.showToast(msg: msg);
        return "error";
      }
    } on TimeoutException {
      isEnabled.value = true;
      Commons.hideProgressDialog();
      Fluttertoast.showToast(msg: Strings.somethingWentWrong(Get.context!));
      return "error";
    } catch (e) {
      isEnabled.value = true;
      throw Exception(e);
    }
  }

  Future<void> updateUnredMessagesCount(int count) async {
    try {
      _prefs = await SharedPreferences.getInstance();
      _prefs.setString("unreadCount", count.toString());
    } catch (e) {
      throw Exception(e);
    }
  }

  Future<int> pleaseGetUnreadMessageCount() async {
    int count = 0;

    try {
      final response = await http
          .get(Uri.parse('${Constants.baseUrl}/chats/unread-count'),
              headers: await Commons.manageRequestHeader())
          .timeout(const Duration(seconds: 5));

      Map<String, dynamic> jsonData = json.decode(response.body);
      print(response.body);

      if (response.statusCode == 200) {
        if (jsonData['success']) {
          if (jsonData.keys.contains('data')) {
            Map<String, dynamic> dataObj = jsonData['data'];
            if (dataObj.keys.contains('unread_count')) {
              count = dataObj['unread_count'];
            }
          }

          return count;
        } else {
          Fluttertoast.showToast(msg: Strings.somethingWentWrong(Get.context!));
          return count;
        }
      } else if (response.statusCode == 403) {
        Fluttertoast.showToast(
            msg: Strings.accountBlockedMessage(Get.context!));
        Commons.logoutUser(true);
        return 0;
      } else {
        Fluttertoast.showToast(msg: Strings.somethingWentWrong(Get.context!));
        return count;
      }
    } on TimeoutException {
      Fluttertoast.showToast(msg: Strings.somethingWentWrong(Get.context!));
      return count;
    } catch (e) {
      throw Exception(e);
    }
  }

  void filterSearchResults(String query) {
    if (query.isNotEmpty) {
      showServicesSuggestions.value = true;
      textFieldBorderColor.value = MyColors.lightGrayColor;
      filteredOptions.value = allListOptions
          .where(
              (item) => item.name!.toLowerCase().contains(query.toLowerCase()))
          .toList();
      allOptions = filteredOptions;
    } else {
      showServicesSuggestions.value = true;
      filteredOptions.value = allListOptions.toList();
      // filteredOptions.clear();
      allOptions = filteredOptions;
    }
  }

  Future<List<Services>> getListAsFutureList(List<Services> list) async {
    Iterable l = list;
    return list;
  }

  void startChatListener() async {
    try {
      final token = await Commons.getUserToken();
      _prefs = await SharedPreferences.getInstance();
      int clientId = _prefs.getInt('id')!;

      final options = SimpleFlutterReverbOptions(
        scheme: "wss",
        host: "auftragnow.com",
        port: "443",
        appKey: Constants.pusherAPIkey,
        authUrl: "${Constants.baseUrl}/broadcasting/auth",
        authToken: token,
        privatePrefix: "private-",
        usePrefix: true,
      );

      reverb = SimpleFlutterReverb(options: options);
      Constants.reverb = reverb;

      reverb.listen(
        (message) {
          if (message != null && message.event == "message.sent") {
            try {
              final newMessage = Message.fromJson(message.data['message']);
              if (isLoggedIn != "loggedOut") {
                NewMessageController controller =
                    Get.put(NewMessageController());
                controller.addMessage(newMessage);
                // playMessageSound();
              }
              Constants.unReadcount.value++;
              // if (mounted) {
              // }
              // setState(() {});
            } catch (e) {
              throw Exception(e);
            }
          }
          print("Received at: dashborad");
          print("Received: ${message.event}, Data: ${message.data}");
        },
        "chat.$clientId",
        isPrivate: true,
      );
    } catch (e) {
      print('Failed to initialize Pusher: $e');
      if (chatLinstenerRetryCount < 3) {
        chatLinstenerRetryCount++;
        Future.delayed(const Duration(seconds: 2), () {
          startChatListener();
        });
      }
    }
  }
}
