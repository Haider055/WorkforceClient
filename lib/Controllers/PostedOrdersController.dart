import 'dart:async';
import 'dart:convert';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:workforceclientapp/Models/Pagination.dart';
import 'package:workforceclientapp/Models/PostedJobDetail.dart';
import 'package:workforceclientapp/Models/PostedOrders.dart';
import 'package:workforceclientapp/Others/Commons.dart';
import 'package:workforceclientapp/Others/Constants.dart';
import 'package:workforceclientapp/Others/Strings.dart';

class PostedOrdersController extends GetxController {
  RxBool isLoading = true.obs;
  RxString isLoggedin = "".obs;
  RxList<PostedJobDetail> postedOrdersList = <PostedJobDetail>[].obs;
  RxString selectedTabName = "all".obs;
  PostedOrders? postedOrders;
  RxInt totalpostedOrders = 0.obs;
  RxString status = "".obs;
  RxBool isLoadingMore = false.obs;
  late SharedPreferences _prefs;

  @override
  void onInit() {
    super.onInit();
    checkIsLoggedIn();
  }

  int getRemainingTrademenRequests(int? count) {
    if (count != null) {
      return 10 - count;
    }
    return 0;
  }

  void getPostedOrdersList(int page, String status) async {
    try {
      // postedOrders!.postedJobsList.clear();
      postedOrders = await pleaseGetMyPostedOrdersList(page, status);
      if (postedOrders != null) {
        if (postedOrders!.postedJobsList != null) {
          if (!isLoadingMore.value) {
            postedOrdersList.clear();
          }
          postedOrdersList.addAll(postedOrders!.postedJobsList!);
          if (postedOrders!.pagination != null) {
            totalpostedOrders.value = postedOrders!.pagination!.total ?? 0;
          }
          isLoadingMore.value = false;
          isLoading.value = false;
        }
      }
    } catch (e) {
      throw Exception(e);
    }
  }

  void updateJobObject(int id, int index) async {
    try {
      PostedJobDetail? postedJobDetail;
      postedJobDetail = await pleaseGetOrderDetail(id);
      Commons.hideProgressDialog();
      if (postedJobDetail != null) {
        postedOrdersList.elementAt(index).status!.value =
            postedJobDetail.status!.value;
        postedOrdersList.elementAt(index).tradespersonRequestsCount!.value =
            postedJobDetail.tradespersonRequestsCount!.value;
        postedOrdersList.elementAt(index).tradespersonApplicationsCount!.value =
            postedJobDetail.tradespersonApplicationsCount!.value;
        postedOrdersList.elementAt(index).inContactTradesmenCount!.value =
            postedJobDetail.inContactTradesmenCount!.value;
      }
    } catch (e) {
      Commons.hideProgressDialog();
      throw Exception(e);
    }
  }

  void refreshData() async {
    isLoading.value = true;
    postedOrdersList.value = <PostedJobDetail>[];
    postedOrdersList.clear();
    selectedTabName.value = "all";
    checkIsLoggedIn();
  }

  void checkIsLoggedIn() async {
    print("object");
    // print(widget.isLoggedin);
    _prefs = await SharedPreferences.getInstance();
    isLoggedin.value = _prefs.getString("isLogin") ?? "loggedOut";

    if (isLoggedin.value == "loggedOut") {
      isLoading.value = false;
    } else {
      getPostedOrdersList(1, "");
    }
  }

  Future<PostedOrders?> pleaseGetMyPostedOrdersList(
      int page, String status) async {
    PostedOrders? postedOrders;
    List<PostedJobDetail> jobsList = [];

    Pagination pagination = Pagination();
    String url = "";

    try {
      if (status.isEmpty) {
        url = "${Constants.baseUrl}/jobs/my-jobs?page=$page";
      } else {
        url = "${Constants.baseUrl}/jobs/my-jobs?page=$page&status=$status";
      }
      final response = await http
          .get(
            Uri.parse(url),
            headers: await Commons.manageRequestHeader(),
          )
          .timeout(const Duration(seconds: 5));

      Map<String, dynamic> jsonData = json.decode(response.body);
      print(response.body);

      if (response.statusCode == 200) {
        if (jsonData['success'] == true) {
          if (jsonData.keys.contains('data')) {
            List<dynamic> dataList = jsonData['data'];
            for (var item in dataList) {
              jobsList.add(PostedJobDetail.fromJson(item));
            }
            if (jsonData.keys.contains('pagination')) {
              pagination = Pagination.fromJson(jsonData['pagination']);
            }
            postedOrders =
                PostedOrders(postedJobsList: jobsList, pagination: pagination);
          }
          return postedOrders;
        } else {
          Fluttertoast.showToast(msg: Strings.somethingWentWrong(Get.context!));
          return postedOrders;
        }
      } else if (response.statusCode == 403) {
        Fluttertoast.showToast(
            msg: Strings.accountBlockedMessage(Get.context!));
        Commons.logoutUser();
        return null;
      } else {
        // If the server did not return a 200 CREATED response,
        // then throw an exception.
        Fluttertoast.showToast(msg: Strings.somethingWentWrong(Get.context!));
        return postedOrders;
      }
    } on TimeoutException {
      Fluttertoast.showToast(msg: Strings.somethingWentWrong(Get.context!));
      return postedOrders;
    } catch (e) {
      throw Exception(e);
    }
  }

  Future<PostedJobDetail?> pleaseGetOrderDetail(int id) async {
    PostedJobDetail? postedJobDetail;

    String url = "";
    url = "${Constants.baseUrl}/jobs/$id";

    try {
      final response = await http
          .get(
            Uri.parse(url),
            headers: await Commons.manageRequestHeader(),
          )
          .timeout(const Duration(seconds: 5));

      Map<String, dynamic> jsonData = json.decode(response.body);

      if (response.statusCode == 200) {
        if (jsonData['success'] == true) {
          if (jsonData.keys.contains('data')) {
            Map<String, dynamic> dataObj = jsonData['data'];
            if (dataObj.keys.contains('job_posting')) {
              if (dataObj['job_posting'] != null) {
                postedJobDetail =
                    PostedJobDetail.fromJson(dataObj['job_posting']);
              }
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
        Commons.logoutUser();
        return null;
      } else {
        Fluttertoast.showToast(msg: Strings.somethingWentWrong(Get.context!));
        return postedJobDetail;
      }
    } on TimeoutException {
      Fluttertoast.showToast(msg: Strings.somethingWentWrong(Get.context!));
      return postedJobDetail;
    } catch (e) {
      throw Exception(e);
    }
  }
}
