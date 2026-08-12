import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:workforceclientapp/Models/ReportOption.dart';
import 'package:workforceclientapp/Others/Commons.dart';
import 'package:workforceclientapp/Others/Constants.dart';
import 'package:workforceclientapp/Others/Strings.dart';

class ReportController extends GetxController {
  final data = Get.arguments;

  RxString reportableType = "".obs;
  RxInt reportableId = 0.obs;

  RxBool isLoading = true.obs;
  RxBool isSubmitting = false.obs;
  Rx<ReportOptions?> options = Rx<ReportOptions?>(null);
  RxString selectedReason = "".obs;
  TextEditingController otherDetailsController = TextEditingController();
  ReportOptions? reportOptions;

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
      reportableType.value = data['reportableType'] ?? "";
      reportableId.value = data['reportableId'] ?? 0;

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

  bool get showDetailsField {
    if (selectedReason.value.isEmpty || options.value == null) return false;
    final index = options.value!.reasons
        .indexWhere((r) => r.value == selectedReason.value);
    if (index == -1) return false;
    return isOtherOption(options.value!.reasons[index], index);
  }

  Future<void> submitReport() async {
    if (selectedReason.value.isEmpty) {
      Fluttertoast.showToast(msg: "Please select a reason");
      return;
    }
    if (showDetailsField && otherDetailsController.text.trim().isEmpty) {
      Fluttertoast.showToast(msg: "Please describe the issue");
      return;
    }

    isSubmitting.value = true;
    final success = await pleaseSubmitReport(
      context: Get.context!,
      reportableType: reportableType.value,
      reportableId: reportableId.value,
      reason: selectedReason.value,
      details: showDetailsField ? otherDetailsController.text.trim() : null,
    );
    isSubmitting.value = false;

    if (success) {
      Fluttertoast.showToast(msg: Strings.reportSubmittedText(Get.context!));
      Get.back();
    }
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
        Commons.logoutUser();
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

  Future<bool> pleaseSubmitReport({
    required BuildContext context,
    required String reportableType,
    required int reportableId,
    required String reason,
    String? details,
  }) async {
    try {
      final response = await http
          .post(
            Uri.parse('${Constants.baseUrl}/reports'),
            headers: await Commons.manageRequestHeader(),
            body: jsonEncode(<String, dynamic>{
              'reportable_type': reportableType,
              'reportable_id': reportableId,
              'reason': reason,
              if (details != null && details.isNotEmpty) 'details': details,
            }),
          )
          .timeout(const Duration(seconds: 5));

      Map<String, dynamic> jsonData = jsonDecode(response.body);

      if (response.statusCode == 200 || response.statusCode == 201) {
        if (jsonData['success'] == true) {
          return true;
        } else {
          Fluttertoast.showToast(msg: Strings.somethingWentWrong(context));
          return false;
        }
      } else if (response.statusCode == 403) {
        Fluttertoast.showToast(
            msg: Strings.accountBlockedMessage(Get.context!));
        Commons.logoutUser();
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
      debugPrint('pleaseSubmitReport error: $e');
      return false;
    }
  }

  @override
  void onClose() {
    otherDetailsController.dispose();
    super.onClose();
  }
}
