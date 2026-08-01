import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:workforceclientapp/Others/Commons.dart';
import 'package:workforceclientapp/Others/Constants.dart';
import 'package:workforceclientapp/Others/Strings.dart';
import 'package:workforceclientapp/Others/routes.dart';

class EndtheOrderController extends GetxController {
  final searchController = TextEditingController().obs;
  RxString selectedReason = "".obs;
  final RxList<String> reasons = <String>[].obs;
  RxInt jobId = 0.obs;
  final data = Get.arguments;

  @override
  void onInit() {
    super.onInit();
    jobId.value = data['jobId'];
    reasons.add(Strings.endOrderReason1(Get.context!));
    reasons.add(Strings.endOrderReason2(Get.context!));
    reasons.add(Strings.endOrderReason3(Get.context!));
    reasons.add(Strings.endOrderReason4(Get.context!));
    reasons.add(Strings.endOrderReason5(Get.context!));
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
// print(response.body);

      if (response.statusCode == 200) {
        if (jsonData['success']) {
          Fluttertoast.showToast(msg: Strings.jobHasRemoved(context));
          Get.offAllNamed(AppLinks.select_service_screen);
        } else {
          if (jsonData['message'] != null) {
            Fluttertoast.showToast(msg: jsonData['message']);
          } else {
            Fluttertoast.showToast(
                msg: Strings.somethingWentWrongRemovingJob(context));
          }
        }
      } else {
// If the server did not return a 200 CREATED response,
// then throw an exception.
        Fluttertoast.showToast(
            msg: Strings.somethingWentWrongRemovingJob(context));
      }
    } on TimeoutException {
      Fluttertoast.showToast(
          msg: Strings.somethingWentWrongRemovingJob(context));
    } catch (e) {
      throw Exception(e);
    }
  }
}
