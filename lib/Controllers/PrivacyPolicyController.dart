import 'dart:convert';

import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:workforceclientapp/Others/Constants.dart';

class PrivacyPolicyController extends GetxController {
  static const String _privacyPolicyUrl =
      '${Constants.baseUrl}/legal/privacy-policy';

  final RxBool isLoading = false.obs;
  final RxString privacyPolicyText = ''.obs;
  final RxString errorMessage = ''.obs;

  @override
  void onInit() {
    super.onInit();
    fetchPrivacyPolicy();
  }

  Future<void> fetchPrivacyPolicy() async {
    isLoading.value = true;
    errorMessage.value = '';

    try {
      final response = await http.get(
        Uri.parse(_privacyPolicyUrl),
        headers: {'Accept': 'application/json'},
      ).timeout(const Duration(seconds: 30));

      if (response.statusCode < 200 || response.statusCode >= 300) {
        throw Exception(
          'Request failed: ${response.statusCode}',
        );
      }

      final body = utf8.decode(response.bodyBytes);

      dynamic decoded;
      try {
        decoded = jsonDecode(body);
      } catch (_) {
        decoded = body;
      }

      final policy = _extractPolicy(decoded);

      if (policy.trim().isEmpty) {
        throw Exception('Privacy policy content is empty.');
      }

      privacyPolicyText.value = policy;
    } catch (_) {
      errorMessage.value =
          'Unable to load the privacy policy. Please try again.';
    } finally {
      isLoading.value = false;
    }
  }

  String _extractPolicy(dynamic response) {
    if (response is Map &&
        response['data'] is Map &&
        response['data']['content'] is String) {
      return response['data']['content'] as String;
    }

    return '';
  }
}
