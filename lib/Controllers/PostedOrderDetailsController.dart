import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:workforceclientapp/Models/JobContact.dart';
import 'package:workforceclientapp/Models/Pagination.dart';
import 'package:workforceclientapp/Models/PostedJobDetail.dart';
import 'package:workforceclientapp/Models/RequestedTradesmen.dart';
import 'package:workforceclientapp/Models/TradesmenRequest.dart';
import 'package:workforceclientapp/Others/Commons.dart';
import 'package:workforceclientapp/Others/Constants.dart';
import 'package:workforceclientapp/Others/MyColors.dart';
import 'package:workforceclientapp/Others/Strings.dart';
import 'package:workforceclientapp/Others/routes.dart';
import 'package:workforceclientapp/views/screens/DashBoard/SelectServiceScreen.dart';

class PostedOrderDetailsController extends GetxController {
  final searchController = TextEditingController().obs;

  RxInt orderDetailTabColor = MyColors.themeRedColor.obs;
  RxInt tradesmenTabColor = MyColors.silverColor.obs;
  RxInt chatTabColor = MyColors.silverColor.obs;
  RxInt recommendedTabColor = MyColors.silverColor.obs;
  RxString selectedTabName = "orderDetail".obs;
  RxInt interesedTradesmen = 0.obs;
  RxInt recommendedTradesmen = 0.obs;
  RxInt chatListSize = 0.obs;
  RxInt jobId = 0.obs;
  final data = Get.arguments;
  RxBool isLoading = true.obs;
  late PostedJobDetail postedJobDetail;
  Rx<LatLng> currentPosition = const LatLng(43.413029, 34.299316).obs;
  RxBool loadingInterestedTradesmen = true.obs;
  RxList<String> tradesmenImages = <String>[].obs;
  int jobIndex = 0;
  Rxn<JobContact> jobContact = Rxn<JobContact>();
  RxBool loadingJobContact = false.obs;

  @override
  void onInit() {
    super.onInit();
    if (data['jobId'] != null) {
      if (data['section'] != null && data['section'] == 'tradesmen') {
        chatTabColor.value = MyColors.silverColor;
        recommendedTabColor.value = MyColors.silverColor;
        tradesmenTabColor.value = MyColors.themeRedColor;
        orderDetailTabColor.value = MyColors.silverColor;
        selectedTabName.value = "tradesmen";
      }
      if (data.containsKey('index')) {
        jobIndex = data['index'];
      }
      jobId.value = data['jobId'];
      if (jobId == -1) {
        Fluttertoast.showToast(msg: Strings.somethingWentWrong(Get.context!));
        return;
      }
      getJobDetails(jobId.value);
    }
  }

  int getRemainingTrademenRequests(int? count) {
    if (count != null) {
      return 10 - count;
    }
    return 0;
  }

  Future<PostedJobDetail> pleaseGetPostedOrderDetails(
      int id, BuildContext context) async {
    PostedJobDetail postedJobDetail = PostedJobDetail();

    try {
      final response = await http
          .get(
            Uri.parse('${Constants.baseUrl}/jobs/$id'),
            headers: await Commons.manageRequestHeader(),
          )
          .timeout(const Duration(seconds: 5));

      Map<String, dynamic> jsonData = json.decode(response.body);
      //print(response.body);

      if (response.statusCode == 200) {
        if (jsonData['success'] == true) {
          if (jsonData.keys.contains('data')) {
            Map<String, dynamic> dataObj = jsonData['data'];
            if (dataObj.keys.contains('job_posting')) {
              postedJobDetail =
                  PostedJobDetail.fromJson(dataObj['job_posting']);
            }
          }

          return postedJobDetail;
        } else {
          Fluttertoast.showToast(msg: Strings.somethingWentWrong(Get.context!));
          return postedJobDetail;
        }
      } else if (response.statusCode == 403) {
        Fluttertoast.showToast(
            msg: Strings.accountBlockedMessage(Get.context!));
        Commons.logoutUser(true);
        return postedJobDetail;
      } else {
        Fluttertoast.showToast(msg: Strings.somethingWentWrong(Get.context!));
        return postedJobDetail;
      }
    } on TimeoutException {
      Commons.hideProgressDialog();
      Fluttertoast.showToast(msg: Strings.somethingWentWrong(Get.context!));
      return postedJobDetail;
    } catch (e) {
      Commons.hideProgressDialog();
      throw Exception(e);
    }
  }

  Future<RequestedTradesmen?> pleaseGetTradesmenRequestsList(
      int jobId, String appStatus, BuildContext context) async {
    RequestedTradesmen? requestedTradesmen;
    List<TradesmenRequest> list = [];
    Pagination pagination = Pagination();
    String url = "";

    try {
      if (appStatus == "All") {
        url = '${Constants.baseUrl}/jobs/$jobId/applications';
      } else {
        url = '${Constants.baseUrl}/jobs/$jobId/applications?status=$appStatus';
      }
      final response = await http
          .get(
            Uri.parse(url),
            headers: await Commons.manageRequestHeader(),
          )
          .timeout(const Duration(seconds: 5));

      Map<String, dynamic> jsonData = json.decode(response.body);
      // //print(response.body);

      if (response.statusCode == 200) {
        if (jsonData['success'] == true) {
          if (jsonData.keys.contains('data')) {
            List<dynamic> dataList = jsonData['data'];
            for (var item in dataList) {
              list.add(TradesmenRequest.fromJson(item));
            }
            if (jsonData.keys.contains('pagination')) {
              pagination = Pagination.fromJson(jsonData['pagination']);
            }
            requestedTradesmen = RequestedTradesmen(
                tradesmenRequestList: list, pagination: pagination);
          }

          return requestedTradesmen;
        } else {
          Fluttertoast.showToast(msg: Strings.somethingWentWrong(Get.context!));
          return requestedTradesmen;
        }
      } else if (response.statusCode == 403) {
        Fluttertoast.showToast(
            msg: Strings.accountBlockedMessage(Get.context!));
        Commons.logoutUser(true);
        return requestedTradesmen;
      } else {
        Fluttertoast.showToast(msg: Strings.somethingWentWrong(Get.context!));
        return requestedTradesmen;
      }
    } on TimeoutException {
      Commons.hideProgressDialog();
      Fluttertoast.showToast(msg: Strings.somethingWentWrong(Get.context!));
      return requestedTradesmen;
    } catch (e) {
      Commons.hideProgressDialog();
      throw Exception(e);
    }
  }

  Future<RxList<String>> pleaseGetTradesmenRequestsImagesList(
      int jobId, BuildContext context) async {
    RxList<String> list = <String>[].obs;

    try {
      final response = await http
          .get(
            Uri.parse("${Constants.baseUrl}/jobs/$jobId/applications"),
            headers: await Commons.manageRequestHeader(),
          )
          .timeout(const Duration(seconds: 5));

      Map<String, dynamic> jsonData = json.decode(response.body);
      //print(response.body);

      if (response.statusCode == 200) {
        if (jsonData['success'] == true) {
          if (jsonData.keys.contains('data')) {
            List<dynamic> dataList = jsonData['data'];
            for (var item in dataList) {
              if (item['user']['profile_img'] != null) {
                list.add(item['user']['profile_img']);
              }
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
      Commons.hideProgressDialog();
      Fluttertoast.showToast(msg: Strings.somethingWentWrong(Get.context!));
      return list;
    } catch (e) {
      Commons.hideProgressDialog();
      throw Exception(e);
    }
  }

  Future<int> pleaseUpdateRequestsStatus(
      int jobId, int requestId, String status, BuildContext context) async {
    RequestedTradesmen? requestedTradesmen;
    List<TradesmenRequest> list = [];
    Pagination pagination = Pagination();
    String url = "";
    int chatid = -1;

    try {
      final response = await http
          .put(
            Uri.parse(
                '${Constants.baseUrl}/jobs/$jobId/applications/$requestId/status'),
            headers: await Commons.manageRequestHeader(),
            body: jsonEncode({
              'status': status,
            }),
          )
          .timeout(const Duration(seconds: 5));

      // print(response.body);
      Map<String, dynamic> jsonData = json.decode(response.body);
      Commons.hideProgressDialog();

      if (response.statusCode == 200) {
        if (jsonData['success']) {
          if (jsonData.keys.contains('data')) {
            Map<String, dynamic> dataObj = jsonData['data'];
            if (dataObj.keys.contains('job_application')) {
              Map<String, dynamic> jobApplicationObj =
                  dataObj['job_application'];
              if (jobApplicationObj.keys.contains('chat')) {
                Map<String, dynamic> chatObj = jobApplicationObj['chat'];
                if (chatObj['id'] != null) {
                  chatid = chatObj['id'];
                  return chatid;
                } else {
                  return -2;
                }
              } else {
                return -2;
              }
            } else {
              return -2;
            }
          } else {
            Fluttertoast.showToast(
                msg: Strings.somethingWentWrong(Get.context!));
            return chatid;
          }
        } else {
          if (jsonData.containsKey('message')) {
            String message =
                jsonData['message'] ?? Strings.somethingWentWrong(context);
            Fluttertoast.showToast(msg: message);
            return chatid;
          } else {
            Fluttertoast.showToast(msg: Strings.somethingWentWrong(context));
            return chatid;
          }
        }
      } else if (response.statusCode == 403) {
        Fluttertoast.showToast(
            msg: Strings.accountBlockedMessage(Get.context!));
        Commons.logoutUser(true);
        return chatid;
      } else {
        if (jsonData.containsKey('message')) {
          String message =
              jsonData['message'] ?? Strings.somethingWentWrong(context);
          Fluttertoast.showToast(msg: message);
          return chatid;
        } else {
          Fluttertoast.showToast(msg: Strings.somethingWentWrong(context));
          return chatid;
        }
      }
    } on TimeoutException {
      Commons.hideProgressDialog();
      Fluttertoast.showToast(msg: Strings.somethingWentWrong(Get.context!));
      return chatid;
    } catch (e) {
      Commons.hideProgressDialog();
      throw Exception(e);
    }
  }

  Future<void> pleaseCancelTheOrder(
      int jobId, String reason, BuildContext context) async {
    try {
      final response = await http
          .post(
            Uri.parse('${Constants.baseUrl}/jobs/cancel'),
            headers: await Commons.manageRequestHeader(),
            body: jsonEncode({'job_posting_id': jobId, 'reason': reason}),
          )
          .timeout(const Duration(seconds: 5));

      Map<String, dynamic> jsonData = json.decode(response.body);
      // //print(response.body);

      if (response.statusCode == 200) {
        if (jsonData['success']) {
          Fluttertoast.showToast(msg: Strings.jobHasRemoved(Get.context!));
          Get.to(
            const SelectServiceScreen(),
            transition: Transition.rightToLeft, // Left-to-right animation
            duration: const Duration(
                milliseconds: 500), // Optional: animation duration
          );
        } else {
          if (jsonData['message'] != null) {
            Fluttertoast.showToast(msg: jsonData['message']);
          } else {
            Fluttertoast.showToast(
                msg: Strings.somethingWentWrongRemovingJob(Get.context!));
          }
        }
      } else if (response.statusCode == 403) {
        Fluttertoast.showToast(
            msg: Strings.accountBlockedMessage(Get.context!));
        Commons.logoutUser(true);
      } else {
        // If the server did not return a 200 CREATED response,
        // then throw an exception.
        Fluttertoast.showToast(
            msg: Strings.somethingWentWrongRemovingJob(Get.context!));
      }
    } on TimeoutException {
      Commons.hideProgressDialog();
      Fluttertoast.showToast(
          msg: Strings.somethingWentWrongRemovingJob(Get.context!));
    } catch (e) {
      Commons.hideProgressDialog();
      throw Exception(e);
    }
  }

  Future<JobContact?> pleaseGetJobContact(int jobId, String jobStatus) async {
    try {
      final response = await http
          .get(
            Uri.parse('${Constants.baseUrl}/jobs/$jobId/contacts'),
            headers: await Commons.manageRequestHeader(),
          )
          .timeout(const Duration(seconds: 5));

      Map<String, dynamic> jsonData = json.decode(response.body);

      if (response.statusCode == 200 && jsonData['success'] == true) {
        List<dynamic> dataList = jsonData['data'] ?? [];
        List<JobContact> contacts =
            dataList.map((e) => JobContact.fromJson(e)).toList();
        if (contacts.isEmpty) return null;
        // Prefer the contact whose status matches the job's current status.
        return contacts.firstWhereOrNull((c) => c.status == jobStatus) ??
            contacts.first;
      }
      return null;
    } catch (e) {
      e.printError();
      return null;
    }
  }

  void getJobContact(int jobId) async {
    final status = postedJobDetail.status?.value;
    if (status != "completed" && status != "in_progress") return;
    loadingJobContact.value = true;
    jobContact.value = await pleaseGetJobContact(jobId, status!);
    loadingJobContact.value = false;
  }

  void getJobDetails(int jobId) async {
    try {
      postedJobDetail = await pleaseGetPostedOrderDetails(jobId, Get.context!);
      currentPosition.value = LatLng(double.parse(postedJobDetail.lat!),
          double.parse(postedJobDetail.lng!));
      isLoading.value = false;
      getJobContact(jobId);
      tradesmenImages.value =
          await pleaseGetTradesmenRequestsImagesList(jobId, Get.context!);
      loadingInterestedTradesmen.value = false;
      // setState(() {});
    } catch (e) {
      e.printError();
    }
  }

  void updateJobStatus(
      String status, int jobId, int requestId, int tradesmanId) async {
    try {
      Commons.showProgressDialog(Get.context!);
      int chatId = await pleaseUpdateRequestsStatus(
        jobId,
        requestId,
        status,
        Get.context!,
      );
      Commons.hideProgressDialog();
      if (chatId != -1) {
        Fluttertoast.showToast(
            msg: Strings.jobhasbeenCompletedText(Get.context!));
        Get.toNamed(AppLinks.review_screen,
            arguments: {'jobPostingId': jobId, 'tradesmenId': tradesmanId});
      }
    } catch (e) {
      throw Exception(e);
    }
  }
}
