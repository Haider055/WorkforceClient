import 'dart:convert';
import 'dart:io';

import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:workforceclientapp/Others/Constants.dart';
import 'package:workforceclientapp/Others/Strings.dart';
import 'package:workforceclientapp/Others/routes.dart';

class EulaController extends GetxController {
  static const String _agreementUrl =
      '${Constants.baseUrl}/legal/user-agreement';

  final RxBool isLoading = false.obs;
  final RxBool isAccepting = false.obs;
  final RxString agreementText = ''.obs;
  final RxString errorMessage = ''.obs;

  @override
  void onInit() {
    super.onInit();
    fetchEula();
  }

  Future<void> fetchEula() async {
    isLoading.value = true;
    errorMessage.value = '';

    try {
      final response = await http.get(
        Uri.parse(_agreementUrl),
        headers: {'Accept': 'application/json', 'Accept-Language': 'de'},
      ).timeout(const Duration(seconds: 30));

      if (response.statusCode < 200 || response.statusCode >= 300) {
        throw Exception(
          'Failed to load agreement (${response.statusCode}).',
        );
      }

      final String responseBody = utf8.decode(response.bodyBytes);
      final dynamic decoded = jsonDecode(responseBody);

      final String extractedText = _extractAgreement(decoded);

      if (extractedText.trim().isEmpty) {
        throw Exception(
          'The agreement was empty or its response format was unexpected.',
        );
      }

      agreementText.value = extractedText;
    } catch (e) {
      errorMessage.value =
          'Unable to load the user agreement. Please check your connection and try again.';
    } finally {
      isLoading.value = false;
    }
  }

  String _extractAgreement(dynamic data) {
    if (data is String) {
      return data;
    }

    if (data is List) {
      return data
          .map(_extractAgreement)
          .where((s) => s.isNotEmpty)
          .join('\n\n');
    }

    if (data is Map) {
      // Check likely agreement fields first.
      const fields = [
        'agreement',
        'content',
        'terms',
        'text',
        'user_agreement',
        'userAgreement',
        'description',
        'html',
        'body',
      ];

      for (final key in fields) {
        final value = data[key];

        if (value is String && value.trim().isNotEmpty) {
          return value;
        }
      }

      // Some APIs wrap the result inside data or result.
      for (final key in ['data', 'result', 'agreement_data']) {
        if (data.containsKey(key)) {
          final result = _extractAgreement(data[key]);
          if (result.trim().isNotEmpty) {
            return result;
          }
        }
      }
    }

    return '';
  }

  Future<void> agreeToEula() async {
    if (isAccepting.value || agreementText.value.trim().isEmpty) {
      return;
    }

    isAccepting.value = true;

    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('eula_accepted', true);

      Get.offAllNamed(AppLinks.select_language_screen);
    } catch (e) {
      Get.snackbar(
        Strings.failedText(Get.context!),
        Strings.somethingWentWrong(Get.context!),
      );
    } finally {
      isAccepting.value = false;
    }
  }

  void cancelEula() {
    if (Platform.isAndroid) {
      SystemNavigator.pop();
    } else if (Platform.isIOS) {
      exit(0);
    }
  }
}
