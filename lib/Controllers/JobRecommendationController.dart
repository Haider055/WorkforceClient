import 'dart:convert';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:workforceclientapp/Models/Tradesmen.dart';
import 'package:workforceclientapp/Others/Commons.dart';
import 'package:workforceclientapp/Others/Constants.dart';

class JobRecommendationController extends GetxController {
  RxString bubbleInfoText = "".obs;
  RxList<Tradesmen> tradesmenList = <Tradesmen>[].obs;
  RxInt currentIndex = 0.obs;
  RxInt jobId = 0.obs;
  final data = Get.arguments;
  RxBool isLoading = true.obs;

  RxInt remainingRequestsCount = 0.obs;
  RxString fromWhere = "".obs;

  @override
  void onInit() async {
    super.onInit();
    jobId.value = data['jobId'];
    remainingRequestsCount.value = data['remainingRequeststoSend'];
    fromWhere.value = data['fromWhere'];
    tradesmenList.value = await pleaseGetRecommendedTradesmen(jobId.value);
    isLoading.value = false;
  }

  Future<List<Tradesmen>> pleaseGetRecommendedTradesmen(int id) async {
    List<Tradesmen> list = [];

    try {
      final response = await http.get(
        Uri.parse(
            '${Constants.baseUrl}/tradeperson/recommended?job_posting_id=$id'),
        headers: await Commons.manageRequestHeader(),
      );

      Map<String, dynamic> jsonData = json.decode(response.body);
      print(response.body);

      if (response.statusCode == 200) {
        // If the server did return a 200 CREATED response,
        // then parse the JSON.

        if (jsonData['success'] == true) {
          if (jsonData.keys.contains('data')) {
            Iterable l = jsonData['data'];
            list = List<Tradesmen>.from(
                l.map((model) => Tradesmen.fromJson(model)));
          }
          // Constants.remainingRequestsCount = [];

          return list;
        } else {
          Fluttertoast.showToast(
              msg: "Something went wrong, while loading data!");
          return list;
        }
      } else {
        // If the server did not return a 200 CREATED response,
        // then throw an exception.
        Fluttertoast.showToast(
            msg: "Something went wrong, while loading data!");
        return list;
      }
    } catch (e) {
      throw Exception(e);
    }
  }

  Future<String> pleaseSendRequestToTradesmen(
      int tradespersonId, int jobId) async {
    try {
      final response = await http.post(
        Uri.parse('${Constants.baseUrl}/tradesperson-requests'),
        headers: await Commons.manageRequestHeader(),
        body: jsonEncode(<String, String>{
          'tradeperson_id': tradespersonId.toString(),
          'job_posting_id': jobId.toString(),
          'message':
              "I saw your profile and was impressed with your previous work. Would you be interested in helping with my kitchen renovation project?",
        }),
      );

      Map<String, dynamic> jsonData = json.decode(response.body);
      print(response.body);
      String msg = "";

      if (response.statusCode == 200) {
        // If the server did return a 200 CREATED response,
        // then parse the JSON.

        if (jsonData['success'] == true) {
          if (jsonData.keys.contains('message')) {
            msg = jsonData['message'];
            if (msg == "Request sent to tradesperson successfully") {
              Fluttertoast.showToast(msg: msg);
              if (jsonData['data']['remaining_requests'] != null) {
                return jsonData['data']['remaining_requests'].toString();
              }
            }
          }
          return "";
        } else {
          Fluttertoast.showToast(
              msg: "Something went wrong, while sending request!");
          return "";
        }
      } else {
        // If the server did not return a 200 CREATED response,
        // then throw an exception.
        msg = jsonData['message'];
        Fluttertoast.showToast(msg: msg);
        return "";
      }
    } catch (e) {
      throw Exception(e);
    }
  }
}
