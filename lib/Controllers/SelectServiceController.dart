import 'dart:convert';
import 'dart:io';
import 'package:audioplayers/audioplayers.dart';
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
    await getAllOptionsOfServices();
    await getNotificationsCount();
    await manageFirebaseThings(Get.context!);
    await checkIsLoggedIn();
    AllChatsContoller controller = Get.put(AllChatsContoller());
    controller.dispose();

    final token = await FirebaseMessaging.instance.getToken();
    final deviceId = await getDeviceId();
    print(token);
    print(deviceId);
    if (token != null) {
      print(token);
      print(deviceId);
    } else {
      print("token");
    }

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
        playSound();
      }
      updateUnredMessagesCount(value);
    });
  }

  final player = AudioPlayer();
  Future<void> playSound() async {
    await player.play(AssetSource('mp3/comingmessagetune.mp3'));
  }

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
    }
    isLoading.value = false;
  }

  Future<void> manageFirebaseThings(BuildContext context) async {
    FirebaseMessaging.instance.onTokenRefresh.listen((fcmToken) async {
      // TODO: If necessary send token to application server.
      LoginContoller loginContoller = Get.put(LoginContoller());
      await loginContoller.fCMSaveToken();

      // Note: This callback is fired at each app startup and whenever a new
      // token is generated.
    }).onError((err) {
      // Error getting token.
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      _handleNotificationClick(message);
    });
  }

  void _handleNotificationClick(RemoteMessage message) {
    if (message.data.containsKey('actionText')) {
      final action = message.data['actionText'];
      print(action);
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
      final response = await http.get(
          Uri.parse('${Constants.baseUrl}/services?search=$query'),
          headers: await Commons.manageRequestHeader());

      Map<String, dynamic> jsonData = json.decode(response.body);

      if (response.statusCode == 200) {
        // If the server did return a 200 CREATED response,
        // then parse the JSON.

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
      } else {
        // If the server did not return a 200 CREATED response,
        // then throw an exception.
        Fluttertoast.showToast(msg: Strings.somethingWentWrong(Get.context!));
        return list;
      }
    } catch (e) {
      throw Exception(e);
    }
  }

  Future<List<Services>> pleaseGetAllServices() async {
    List<Services> list = [];

    try {
      final response = await http.get(
          Uri.parse('${Constants.baseUrl}/services'),
          headers: await Commons.manageRequestHeader());

      Map<String, dynamic> jsonData = json.decode(response.body);
      print(response.body);

      if (response.statusCode == 200) {
        // If the server did return a 200 CREATED response,
        // then parse the JSON.

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
      } else {
        // If the server did not return a 200 CREATED response,
        // then throw an exception.
        Fluttertoast.showToast(msg: Strings.somethingWentWrong(Get.context!));
        return list;
      }
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
      final response = await http.get(
          Uri.parse('${Constants.baseUrl}/services/$id/questions'),
          headers: await Commons.manageRequestHeader());

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
            Constants.jobPostingSteps = qList.length + 4;
            Constants.currentJobPostingStep = 1;
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
            Constants.jobPostingSteps = 4;
            Constants.currentJobPostingStep = 1;
            Commons.hideProgressDialog();
            Get.toNamed(AppLinks.job_title_screen);
            return "error";
          }
        } else {
          String msg = jsonData['message'];
          Fluttertoast.showToast(msg: msg);
          return "error";
        }
      } else {
        // If the server did not return a 200 CREATED response,
        // then throw an exception.
        String msg = jsonData['message'];
        Fluttertoast.showToast(msg: msg);
        return "error";
      }
    } catch (e) {
      throw Exception(e);
    }
  }

  // Future<void> playMessageSound() async {
  //   await _player.play(AssetSource('mp3/comingmessagetune.mp3'));
  // }

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
      final response = await http.get(
          Uri.parse('${Constants.baseUrl}/chats/unread-count'),
          headers: await Commons.manageRequestHeader());

      Map<String, dynamic> jsonData = json.decode(response.body);
      print(response.body);

      if (response.statusCode == 200) {
        // If the server did return a 200 CREATED response,
        // then parse the JSON.

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
      } else {
        // If the server did not return a 200 CREATED response,
        // then throw an exception.
        Fluttertoast.showToast(msg: Strings.somethingWentWrong(Get.context!));
        return count;
      }
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
      filteredOptions = allOptions;
      // filteredOptions.clear();
      // allOptions = filteredOptions;
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
        appKey: Constants.pusherAPIkey, // Reverb app key
        authUrl:
            "${Constants.baseUrl}/broadcasting/auth", // optional, needed for private channels
        authToken: token, // optional
        privatePrefix: "private-", // default: "private-"
        usePrefix: true,
      );

      reverb = SimpleFlutterReverb(options: options);
      Constants.reverb = reverb;

      // Private channel
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
    }
  }
}
