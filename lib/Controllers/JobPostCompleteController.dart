import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:workforceclientapp/Models/CheckBoxQuestion.dart';
import 'package:workforceclientapp/Models/RadioQuestion.dart';
import 'package:workforceclientapp/Models/TextQuestion.dart';
import 'package:workforceclientapp/Others/Commons.dart';
import 'package:workforceclientapp/Others/Constants.dart';
import 'dart:convert';

import 'package:http/http.dart' as http;

import 'package:fluttertoast/fluttertoast.dart';
import 'package:workforceclientapp/Others/MyColors.dart';
import 'package:workforceclientapp/Others/Strings.dart';
import 'package:workforceclientapp/Others/routes.dart';
import 'package:workforceclientapp/views/widgets/HeadingText.dart';
import 'package:workforceclientapp/views/widgets/Headingdescription.dart';

class JobPostCompleteController extends GetxController {
  late SharedPreferences _prefs;
  RxString dialogIconsUrl = "lib/assets/images/signuperrorimage.png".obs;
  RxList<Map<String, dynamic>> questionsList = Constants.questionsList.obs;

  RxBool isLoading = true.obs;

  @override
  void onInit() {
    postJob();
    super.onInit();
  }

  Future<String> pleasePostJob() async {
    try {
      String lang = await _getPrefLanguageValue();
      List<File> imageFiles = Constants.selectedImages;
      List<Map<String, dynamic>> questionsList = Constants.questionsList;
      var url = Uri.parse('${Constants.baseUrl}/jobs/create');

      var request = http.MultipartRequest("POST", url);
      print(await Commons.getUserToken());

      // Add headers
      request.headers.addAll({
        'Accept-Language': lang,
        'Authorization': 'Bearer ${await Commons.getUserToken()}',
      });

      // Add form fields
      request.fields['service_id'] = Constants.selectedServiceId.toString();
      request.fields['title'] = Constants.jobTitle;
      request.fields['description'] = Constants.jobDescription;
      request.fields['location'] = Constants.jobPostingAddress;
      request.fields['lat'] = Constants.jobPostingLat.toString();
      request.fields['lng'] = Constants.jobPostingLng.toString();
      request.fields['city'] = Constants.jobPostingCity;
      request.fields['state'] = Constants.jobPostingState;
      request.fields['country'] = Constants.jobPostingCountry;
      request.fields['postcode'] = Constants.jobPostingPostcode;
      request.fields['show_attachments'] = "1";

      for (var i = 0; i < questionsList.length; i++) {
        if (questionsList.elementAt(i).entries.first.key == "checkbox") {
          CheckBoxQuestion ques = questionsList.elementAt(i).values.first;
          request.fields['answers[$i][question_id]'] = ques.id.toString();
          request.fields['answers[$i][type]'] = 'checkbox';
          request.fields['answers[$i][answer]'] = '';
          for (var j = 0; j < ques.selectedOptionsIds.length; j++) {
            request.fields['answers[$i][option_ids][$j]'] =
                ques.selectedOptionsIds.elementAt(j).toString();
          }
        } else if (questionsList.elementAt(i).entries.first.key == "radio") {
          RadioQuestion ques = questionsList.elementAt(i).values.first;
          request.fields['answers[$i][question_id]'] = ques.id.toString();
          request.fields['answers[$i][type]'] = 'radio';
          request.fields['answers[$i][answer]'] =
              ques.selectedOption.toString();
          request.fields['answers[$i][option_id]'] =
              ques.selectedOptionId.toString();
        } else {
          TextQuestion ques = questionsList.elementAt(i).values.first;
          request.fields['answers[$i][question_id]'] = ques.id.toString();
          request.fields['answers[$i][type]'] = 'text';
          request.fields['answers[$i][answer]'] = ques.answer.toString();
        }
      }

      // Attach multiple images
      for (var i = 0; i < imageFiles.length; i++) {
        var stream = http.ByteStream(imageFiles.elementAt(i).openRead());
        var length = await imageFiles.elementAt(i).length();
        var multipartFile = http.MultipartFile(
          'attachments[$i]', // Make sure this matches the API field name
          stream,
          length,
          filename: imageFiles.elementAt(i).path,
        );
        request.files.add(multipartFile);
      }

      // Send request
      var response = await request.send();

      // Get response
      var responseData = await response.stream.bytesToString();
      Map<String, dynamic> jsonData = jsonDecode(responseData);

      // print("response:  " + responseData);

      if (response.statusCode == 200) {
        if (jsonData['success']) {
          String msg = jsonData['message'];
          if (jsonData.keys.contains("data")) {
            Map<String, dynamic> dataObj = jsonData['data'];
            if (dataObj.keys.contains('job_posting')) {
              Map<String, dynamic> jobPostingObj = dataObj['job_posting'];
              if (jobPostingObj.keys.contains('id')) {
                if (jobPostingObj['id'] != null) {
                  Constants.selectedServiceId = 0;
                  Constants.jobTitle = "";
                  Constants.jobDescription = "";
                  Constants.jobPostingAddress = "";
                  Constants.jobPostingCountry = "";
                  Constants.jobPostingCity = "";
                  Constants.jobPostingState = "";
                  Constants.jobPostingPostcode = "";
                  Constants.jobPostingLat = "";
                  Constants.jobPostingLng = "";
                  Constants.selectedServiceName = "";
                  Constants.lastPostedJobId = jobPostingObj['id'];
                }
              }
            }
          }
          // print(msg);
          Fluttertoast.showToast(msg: msg);
          return "ok";
        } else {
          String msg = jsonData['message'];
          return msg;
        }
      } else {
        String msg = jsonData['message'];
        Fluttertoast.showToast(msg: msg);
        return msg;
      }
    } catch (e) {
      print("Error: $e");
      throw Exception(e);
    }
  }

  Future<String> _getPrefLanguageValue() async {
    String value = "";
    _prefs = await SharedPreferences.getInstance();
    value = _prefs.getString("language") ?? "en";

    return value;
  }

  void postJob() async {
    try {
      String value = "";
      _prefs = await SharedPreferences.getInstance();
      value = _prefs.getString("isLogin") ?? "loggedOut";
      if (value == "loggedIn") {
        // showLoginDialogPlease();
        String res = await pleasePostJob();
        if (res == "ok") {
          isLoading.value = false;
        } else {
          isLoading.value = false;

          Get.defaultDialog(
            titleStyle: null,
            title: "",
            content: Column(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(top: 0.0),
                  child: Align(
                      alignment: Alignment.topCenter,
                      child: Image.asset(
                        dialogIconsUrl.value,
                        fit: BoxFit.contain,
                        height: 136.92,
                        width: 123.72,
                      )),
                ),
                HeadingText(
                    text: Strings.failedText(Get.context!), centerAlign: true),
                Headingdescription(
                    text: Strings.somethingWentWrong(Get.context!),
                    centerAlign: true,
                    size: 15.0),
                Headingdescription(text: res, centerAlign: true, size: 15.0),
                Padding(
                  padding: const EdgeInsets.only(top: 18.0),
                  child: ElevatedButton(
                      style: ButtonStyle(
                          backgroundColor: const WidgetStatePropertyAll(
                              Color(MyColors.themeRedColor)),
                          shape: WidgetStatePropertyAll(RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12)))),
                      onPressed: () {
                        Get.back();
                      },
                      child: Padding(
                        padding: const EdgeInsets.only(left: 50.0, right: 50.0),
                        child: Center(
                            child: Text(
                          Strings.tryAgain(Get.context!),
                          style: const TextStyle(color: Colors.white),
                        )),
                      )),
                ),
                const SizedBox(height: 16.0)
              ],
            ),
          );
        }
      } else {
        showLoginDialogPlease();
      }
    } catch (e) {
      e.printError();
      e.printInfo();
    }
  }

  void showLoginDialogPlease() {
    Get.dialog(
      AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0),
        ),
        title: const Center(
          child: Text(
            "Login Required",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(MyColors.themeRedColor),
            ),
          ),
        ),
        content: const Text(
          "You are not logged in. Please log in to post your job. Once logged in, your post will be published.",
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 14),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Constants.fromWhere = "JobPostCompletedScreen";
                  Get.offAllNamed(AppLinks.login_screen);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(MyColors.themeRedColor),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
                child: const Text(
                  "Login",
                  style: TextStyle(fontSize: 16, color: Colors.white),
                ),
              ),
            ),
          ),
        ],
      ),
      barrierDismissible: false, // Prevent dismissing by tapping outside
    );
  }
}
