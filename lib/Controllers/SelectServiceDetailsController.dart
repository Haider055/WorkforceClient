import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:workforceclientapp/Models/Services.dart';
import 'package:workforceclientapp/Others/Commons.dart';
import 'package:workforceclientapp/Others/Constants.dart';

class SelectServiceDetailsController extends GetxController {
  final searchController = TextEditingController().obs;

  Future<List<Services>> pleaseGetAllServiceQuestions(int id) async {
    List<Services> list = [];

    try {
      String lang = await Commons.getPrefLanguageValue();
      final response = await http.get(
        Uri.parse('${Constants.baseUrl}/service-questions/$id'),
        headers: await Commons.manageRequestHeader(),
      );

      Map<String, dynamic> jsonData = json.decode(response.body);
      // print(response.body);

      if (response.statusCode == 200) {
        // If the server did return a 200 CREATED response,
        // then parse the JSON.

        if (jsonData['success'] == true) {
          if (jsonData.keys.contains('data')) {
            Map<String, dynamic> dataObj = jsonData['data'];
            if (dataObj.keys.contains('services')) {
              // List<dynamic> servicesList = jsonData['services'];
              Iterable l = dataObj['services'];
              list = List<Services>.from(
                  l.map((model) => Services.fromJson(model)));
            }
          }

          return list;
        } else {
          Fluttertoast.showToast(msg: "Something went wrong");
          return list;
        }
      } else {
        // If the server did not return a 200 CREATED response,
        // then throw an exception.
        Fluttertoast.showToast(msg: "Something went wrong");
        return list;
      }
    } catch (e) {
      throw Exception(e);
    }
  }
}
