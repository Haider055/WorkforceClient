import 'dart:convert';

import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:workforceclientapp/Others/Constants.dart';

class TermsandconditionController extends GetxController {
  static const String _termsUrl =
      '${Constants.baseUrl}/legal/terms-and-conditions';

  final RxBool isLoading = false.obs;
  final RxString termsText = ''.obs;
  final RxString errorMessage = ''.obs;

  @override
  void onInit() {
    super.onInit();
    fetchTermsAndConditions();
  }

  Future<void> fetchTermsAndConditions() async {
    isLoading.value = true;
    errorMessage.value = '';

    try {
      final response = await http.get(
        Uri.parse(_termsUrl),
        headers: {'Accept': 'application/json'},
      ).timeout(const Duration(seconds: 30));

      if (response.statusCode < 200 || response.statusCode >= 300) {
        throw Exception(
          'Failed to load terms (${response.statusCode}).',
        );
      }

      final body = utf8.decode(response.bodyBytes);

      dynamic decoded;
      try {
        decoded = jsonDecode(body);
      } catch (_) {
        // The API may return plain text.
        decoded = body;
      }

      final terms = _extractTerms(decoded);

      if (terms.trim().isEmpty) {
        throw Exception('Terms and conditions are empty.');
      }

      termsText.value = terms;
    } catch (_) {
      errorMessage.value =
          'Unable to load Terms and Conditions. Please try again.';
    } finally {
      isLoading.value = false;
    }
  }

  String _extractTerms(dynamic response) {
    if (response is Map &&
        response['data'] is Map &&
        response['data']['content'] is String) {
      return response['data']['content'] as String;
    }

    return '';
  }
}
