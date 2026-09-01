import 'dart:async';
import 'dart:convert';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:workforceclientapp/Models/Pagination.dart';
import 'package:workforceclientapp/Models/RecommendedTradesman.dart';
import 'package:workforceclientapp/Models/Tradesmen.dart';
import 'package:workforceclientapp/Others/Commons.dart';
import 'package:workforceclientapp/Others/Constants.dart';
import 'package:workforceclientapp/Others/Strings.dart';

class JobRecommendationController extends GetxController {
  RxString bubbleInfoText = "".obs;
  RxList<Tradesmen> tradesmenList = <Tradesmen>[].obs;
  Pagination? pagination;
  RxInt currentIndex = 0.obs;
  RxInt jobId = 0.obs;
  final data = Get.arguments;
  RxBool isLoading = true.obs;
  RxInt remainingRequestsCount = 0.obs;
  RxString fromWhere = "".obs;
  RxBool isLoadingMore = false.obs;
  int jobIndex = 0;

  @override
  void onInit() async {
    super.onInit();
    jobId.value = data['jobId'];
    remainingRequestsCount.value = data['remainingRequeststoSend'];
    fromWhere.value = data['fromWhere'];
    if (data.containsKey('index')) {
      jobIndex = data['index'];
    }
    await loadTradesmen(jobId.value, 1);
  }

  Future<void> loadTradesmen(int id, int page) async {
    try {
      if (page == 1) {
        isLoading.value = true;
      }
      isLoadingMore.value = true;
      final result = await pleaseGetRecommendedTradesmen(id, page);
      print(result.tradesmenList.length);
      if (page == 1) {
        tradesmenList.value = result.tradesmenList;
      } else {
        tradesmenList.addAll(result.tradesmenList);
      }
      pagination = result.pagination;
    } finally {
      isLoading.value = false;
      isLoadingMore.value = false;
    }
  }

  Future<RecommendedTradesman> pleaseGetRecommendedTradesmen(
      int id, int page) async {
    try {
      final response = await http
          .get(
            Uri.parse(
                '${Constants.baseUrl}/tradeperson/recommended?job_posting_id=$id&page=$page'),
            headers: await Commons.manageRequestHeader(),
          )
          .timeout(const Duration(seconds: 5));
      print(response.body);

      Map<String, dynamic> jsonData = json.decode(response.body);

      if (response.statusCode == 200 && jsonData['success'] == true) {
        List<Tradesmen> list = [];
        if (jsonData.containsKey('data')) {
          list = List<Tradesmen>.from(
            (jsonData['data'] as List)
                .map((model) => Tradesmen.fromJson(model)),
          );
        }

        Pagination? pagination;
        if (jsonData.containsKey('pagination')) {
          pagination = Pagination.fromJson(jsonData['pagination']);
        }

        return RecommendedTradesman(
            tradesmenList: list, pagination: pagination);
      } else if (response.statusCode == 403) {
        Fluttertoast.showToast(
            msg: Strings.accountBlockedMessage(Get.context!));
        Commons.logoutUser(true);
        return RecommendedTradesman(tradesmenList: [], pagination: null);
      } else {
        Fluttertoast.showToast(msg: Strings.somethingWentWrong(Get.context!));
        return RecommendedTradesman(tradesmenList: [], pagination: null);
      }
    } on TimeoutException {
      Fluttertoast.showToast(msg: Strings.somethingWentWrong(Get.context!));
      return RecommendedTradesman(tradesmenList: [], pagination: null);
    } catch (e) {
      throw Exception(e);
    }
  }

  Future<void> loadMore() async {
    if (pagination == null) return;
    if (!pagination!.hasMore!) return;
    if (isLoadingMore.value) return;
    await loadTradesmen(jobId.value, pagination!.currentPage! + 1);
  }

  Future<String> pleaseSendRequestToTradesmen(
      int tradespersonId, int jobId) async {
    try {
      final response = await http
          .post(
            Uri.parse('${Constants.baseUrl}/tradesperson-requests'),
            headers: await Commons.manageRequestHeader(),
            body: jsonEncode(<String, String>{
              'tradeperson_id': tradespersonId.toString(),
              'job_posting_id': jobId.toString(),
              'message': Strings.customRequestMessageText(Get.context!),
            }),
          )
          .timeout(const Duration(seconds: 5));
      Map<String, dynamic> jsonData = json.decode(response.body);
      print(response.body);
      String msg = "";
      if (response.statusCode == 200) {
        if (jsonData['success']) {
          if (jsonData.keys.contains('message')) {
            msg = jsonData['message'];
            Fluttertoast.showToast(msg: msg);
            if (jsonData['data']['remaining_requests'] != null) {
              return jsonData['data']['remaining_requests'].toString();
            }
          }
          return "";
        } else {
          Fluttertoast.showToast(msg: Strings.somethingWentWrong(Get.context!));
          return "";
        }
      } else if (response.statusCode == 403) {
        Fluttertoast.showToast(
            msg: Strings.accountBlockedMessage(Get.context!));
        Commons.logoutUser(true);
        return '';
      } else {
        msg = jsonData['message'];
        Fluttertoast.showToast(msg: msg);
        return "";
      }
    } on TimeoutException {
      Fluttertoast.showToast(msg: Strings.somethingWentWrong(Get.context!));
      return "";
    } catch (e) {
      throw Exception(e);
    }
  }
}
