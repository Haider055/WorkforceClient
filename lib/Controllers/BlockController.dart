import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:workforceclientapp/Controllers/AllChatsContoller.dart';
import 'package:workforceclientapp/Models/ReportOption.dart';
import 'package:workforceclientapp/Others/Commons.dart';
import 'package:workforceclientapp/Others/Constants.dart';
import 'package:workforceclientapp/Others/Strings.dart';

class BlockController extends GetxController {
  final data = Get.arguments;

  RxInt userId = 0.obs;

  RxBool isLoading = true.obs;
  RxBool isSubmitting = false.obs;
  Rx<ReportOptions?> options = Rx<ReportOptions?>(null);
  RxString selectedReason = "".obs;
  TextEditingController otherDetailsController = TextEditingController();

  @override
  void onInit() {
    super.onInit();
    _initFromArguments();
  }

  Future<void> _initFromArguments() async {
    try {
      if (data == null) {
        Fluttertoast.showToast(msg: Strings.somethingWentWrong(Get.context!));
        isLoading.value = false;
        return;
      }
      userId.value = data['user_id'] ?? 0;

      // Block reasons are the same 9 values used for reports.
      final result = await pleaseGetReportOptions(Get.context!);
      options.value = result;
    } catch (e) {
      Fluttertoast.showToast(msg: Strings.somethingWentWrong(Get.context!));
    } finally {
      isLoading.value = false;
    }
  }

  bool isOtherOption(ReportOption reason, int index) {
    if (options.value == null) return false;
    final isLastItem = index == options.value!.reasons.length - 1;
    final labelSuggestsOther =
        (reason.label ?? "").toLowerCase().contains("else");
    return isLastItem || labelSuggestsOther;
  }

  Future<void> submitBlock() async {
    if (selectedReason.value.isEmpty) {
      Fluttertoast.showToast(msg: Strings.pleaseselectareason(Get.context!));
      return;
    }

    isSubmitting.value = true;
    final result = await pleaseBlockUser(
      context: Get.context!,
    );
    isSubmitting.value = false;

    Get.back(result: result);
    if (result) {
      Get.find<AllChatsContoller>().refreshData();
    }
    Get.back();
  }

  Future<ReportOptions?> pleaseGetReportOptions(BuildContext context) async {
    try {
      final response = await http
          .get(
            Uri.parse('${Constants.baseUrl}/reports/options'),
            headers: await Commons.manageRequestHeader(),
          )
          .timeout(const Duration(seconds: 5));

      Map<String, dynamic> jsonData = jsonDecode(response.body);

      if (response.statusCode == 200) {
        if (jsonData['success'] == true) {
          if (jsonData.keys.contains('data')) {
            return ReportOptions.fromJson(jsonData['data']);
          } else {
            Fluttertoast.showToast(msg: Strings.somethingWentWrong(context));
            return null;
          }
        } else {
          Fluttertoast.showToast(msg: Strings.somethingWentWrong(context));
          return null;
        }
      } else if (response.statusCode == 403) {
        Fluttertoast.showToast(
            msg: Strings.accountBlockedMessage(Get.context!));
        Commons.logoutUser(true);
        return null;
      } else {
        Fluttertoast.showToast(msg: Strings.somethingWentWrong(context));
        return null;
      }
    } on TimeoutException {
      Fluttertoast.showToast(msg: Strings.somethingWentWrong(context));
      return null;
    } catch (e) {
      Fluttertoast.showToast(msg: Strings.somethingWentWrong(context));
      debugPrint('pleaseGetReportOptions error: $e');
      return null;
    }
  }

  Future<bool> pleaseBlockUser({required BuildContext context}) async {
    try {
      final response = await http
          .post(
            Uri.parse('${Constants.baseUrl}/blocks'),
            headers: await Commons.manageRequestHeader(),
            body: jsonEncode(<String, dynamic>{
              'user_id': userId.value,
              'reason': selectedReason.value,
              'details': otherDetailsController.value.text.isEmpty
                  ? ''
                  : otherDetailsController.value.text.trim(),
            }),
          )
          .timeout(const Duration(seconds: 5));

      print(response.body);
      Map<String, dynamic> jsonData = jsonDecode(response.body);

      if (response.statusCode == 200 || response.statusCode == 201) {
        if (jsonData['success'] == true) {
          Fluttertoast.showToast(
              msg: jsonData['message'] ?? "User blocked successfully");
          return true;
        } else {
          Fluttertoast.showToast(msg: Strings.somethingWentWrong(context));
          return false;
        }
      } else if (response.statusCode == 403) {
        Fluttertoast.showToast(
            msg: Strings.accountBlockedMessage(Get.context!));
        Commons.logoutUser(true);
        return false;
      } else {
        String msg = jsonData['message'] ?? Strings.somethingWentWrong(context);
        Fluttertoast.showToast(msg: msg);
        return false;
      }
    } on TimeoutException {
      Fluttertoast.showToast(msg: Strings.somethingWentWrong(context));
      return false;
    } catch (e) {
      Fluttertoast.showToast(msg: Strings.somethingWentWrong(context));
      debugPrint('pleaseBlockUser error: $e');
      return false;
    }
  }

  @override
  void onClose() {
    otherDetailsController.dispose();
    super.onClose();
  }
}
