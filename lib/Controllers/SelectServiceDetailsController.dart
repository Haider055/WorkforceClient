import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:workforceclientapp/Models/Services.dart';
import 'package:workforceclientapp/Others/Commons.dart';
import 'package:workforceclientapp/Others/Constants.dart';
import 'package:workforceclientapp/Others/Strings.dart';

class SelectServiceDetailsController extends GetxController {
  final searchController = TextEditingController().obs;

  Future<List<Services>> pleaseGetAllServiceQuestions(int id) async {
    List<Services> list = [];

    try {
      String lang = await Commons.getPrefLanguageValue();
      final response = await http
          .get(
            Uri.parse('${Constants.baseUrl}/service-questions/$id'),
            headers: await Commons.manageRequestHeader(),
          )
          .timeout(const Duration(seconds: 5));

      Map<String, dynamic> jsonData = json.decode(response.body);
      // print(response.body);

      if (response.statusCode == 200) {
        if (jsonData['success']) {
          if (jsonData.keys.contains('data')) {
            Map<String, dynamic> dataObj = jsonData['data'];
            if (dataObj.keys.contains('services')) {
              Iterable l = dataObj['services'];
              list = List<Services>.from(
                  l.map((model) => Services.fromJson(model)));
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
        Commons.logoutUser();
        return list;
      } else {
        Fluttertoast.showToast(msg: Strings.somethingWentWrong(Get.context!));
        return list;
      }
    } on TimeoutException {
      Fluttertoast.showToast(msg: Strings.somethingWentWrong(Get.context!));
      return list;
    } catch (e) {
      throw Exception(e);
    }
  }
}
