import 'dart:async';
import 'dart:io';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:workforceclientapp/Controllers/NetworkController.dart';
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
import 'package:workforceclientapp/views/screens/ClientJobPosting/JobDraft.dart';

class JobPostCompleteController extends GetxController {
  late SharedPreferences _prefs;
  RxString dialogIconsUrl = "lib/assets/images/signuperrorimage.png".obs;
  RxList<Map<String, dynamic>> questionsList = Constants.questionsList.obs;

  RxBool isLoading = true.obs;
  RxBool jobPostingFailed = false.obs;
  RxBool showLoginDialog = false.obs;
  RxString validationMessage = ''.obs;

  @override
  void onInit() {
    postJob();
    super.onInit();
  }

  Future<String> pleasePostJob() async {
    try {
      if (!Get.find<NetworkController>().isOnline.value) {
        showNoInternetDialog();
        return 'error';
      }

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
      if (questionsList.isEmpty) {
        request.fields['answers[]'] = '';
      }
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
          request.fields['answers[$i][option_id]'] = ques.selectedOptionId == 0
              ? ''
              : ques.selectedOptionId.toString();
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

      // debugPrint(request.fields.toString());
      debugPrint(request.fields.toString(), wrapWidth: 1024);

      var response = await request.send().timeout(const Duration(seconds: 7));
      // print(response);

      var responseData = await response.stream.bytesToString();
      Map<String, dynamic> jsonData = jsonDecode(responseData);

      // print("response:  $responseData");

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
                  Constants.selectedImages.clear();
                  JobDraftService.clear();
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
      } else if (response.statusCode == 403) {
        Fluttertoast.showToast(
            msg: Strings.accountBlockedMessage(Get.context!));
        Commons.logoutUser(true);
        return '';
      } else {
        String msg = jsonData['message'];
        Fluttertoast.showToast(msg: msg);
        return msg;
      }
    } on TimeoutException {
      Commons.hideProgressDialog();
      Fluttertoast.showToast(msg: Strings.somethingWentWrong(Get.context!));
      print("Error: request timed out");
      // showErrorDialog(Strings.somethingWentWrong(Get.context!));
      throw Exception('Request timed out');
    } catch (e) {
      Commons.hideProgressDialog();
      // showErrorDialog(Strings.somethingWentWrong(Get.context!));
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
        if (res == 'error') {
          return;
        }
        if (res == "ok") {
          isLoading.value = false;
        } else {
          showErrorDialog(res);
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
    showLoginDialog.value = true;
    jobPostingFailed.value = true;
    if (Get.isDialogOpen ?? false) return;

    Get.dialog(
      PopScope(
        canPop: false,
        child: Dialog(
          backgroundColor: Colors.white,
          insetPadding: EdgeInsets.symmetric(horizontal: 28.w),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18.r),
          ),
          child: Padding(
            padding: EdgeInsets.fromLTRB(20.w, 24.h, 20.w, 18.h),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: EdgeInsets.all(14.r),
                  decoration: BoxDecoration(
                    color:
                        const Color(MyColors.themeRedColor).withOpacity(0.10),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.lock_person_outlined,
                    color: const Color(MyColors.themeRedColor),
                    size: 26.sp,
                  ),
                ),
                SizedBox(height: 16.h),
                Text(
                  Strings.loginRequiredText(Get.context!),
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 17.5.sp,
                    fontWeight: FontWeight.w600,
                    fontFamily: 'Poppins',
                    color: const Color(MyColors.blackColor),
                  ),
                ),
                SizedBox(height: 8.h),
                Text(
                  Strings.pleaseLoginToPostJobDescText(Get.context!),
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 13.5.sp,
                    height: 1.45,
                    fontFamily: 'Poppins',
                    color: const Color(MyColors.darkGrayColor),
                  ),
                ),
                SizedBox(height: 22.h),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      Constants.fromWhere = "JobPostCompletedScreen";
                      // Close FIRST — otherwise the dialog stays mounted
                      // over the login screen.
                      Get.back();
                      Get.toNamed(AppLinks.login_screen);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(MyColors.themeRedColor),
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                      padding: EdgeInsets.symmetric(vertical: 13.h),
                    ),
                    child: Text(
                      Strings.loginText(Get.context!),
                      style: TextStyle(
                        fontSize: 15.sp,
                        fontWeight: FontWeight.w600,
                        fontFamily: 'Poppins',
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 10.h),
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton(
                    onPressed: () {
                      Get.back();
                      Get.offAllNamed(AppLinks.select_service_screen);
                    },
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(
                          color: Color(MyColors.lightSilverColor)),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                      padding: EdgeInsets.symmetric(vertical: 13.h),
                    ),
                    child: Text(
                      Strings.cancelText(Get.context!),
                      style: TextStyle(
                        fontSize: 15.sp,
                        fontWeight: FontWeight.w600,
                        fontFamily: 'Poppins',
                        color: const Color(MyColors.darkGrayColor),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      barrierDismissible: false,
    );
  }

  void showErrorDialog(String res) {
    isLoading.value = false;
    jobPostingFailed.value = true;

    Get.dialog(
      PopScope(
        canPop: false, // still blocking, but Cancel is now a real exit
        child: Dialog(
          backgroundColor: Colors.white,
          insetPadding: EdgeInsets.symmetric(horizontal: 28.w),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18.r),
          ),
          child: Padding(
            padding: EdgeInsets.fromLTRB(20.w, 24.h, 20.w, 18.h),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Image.asset(
                  dialogIconsUrl.value,
                  fit: BoxFit.contain,
                  height: 112.h,
                  width: 102.w,
                ),
                SizedBox(height: 18.h),
                Text(
                  Strings.failedText(Get.context!),
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.w600,
                    fontFamily: 'Poppins',
                    color: const Color(MyColors.blackColor),
                  ),
                ),
                SizedBox(height: 8.h),
                Text(
                  res,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 13.5.sp,
                    height: 1.45,
                    fontFamily: 'Poppins',
                    color: const Color(MyColors.darkGrayColor),
                  ),
                ),
                SizedBox(height: 22.h),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(
                              color: Color(MyColors.lightSilverColor)),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12.r),
                          ),
                          padding: EdgeInsets.symmetric(vertical: 13.h),
                        ),
                        onPressed: () => Get.back(),
                        child: Text(
                          Strings.cancelText(Get.context!),
                          style: TextStyle(
                            fontSize: 14.sp,
                            fontFamily: 'Poppins',
                            color: const Color(MyColors.darkGrayColor),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 12.w),
                    Expanded(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(MyColors.themeRedColor),
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12.r),
                          ),
                          padding: EdgeInsets.symmetric(vertical: 13.h),
                        ),
                        onPressed: () async {
                          // Close FIRST — otherwise postJob's progress dialog
                          // opens on top of this one and they stack.
                          Get.back();
                          await Future.delayed(
                              const Duration(milliseconds: 150));
                          postJob();
                        },
                        child: Text(
                          Strings.tryAgain(Get.context!),
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 14.sp,
                            fontFamily: 'Poppins',
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
      barrierDismissible: false,
    );
  }

  void showNoInternetDialog() {
    Get.dialog(
      Dialog(
        backgroundColor: Colors.white,
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(14.r)),
        insetPadding: EdgeInsets.symmetric(horizontal: 24.w),
        child: Padding(
          padding: EdgeInsets.all(18.0.r),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: EdgeInsets.all(12.r),
                decoration: BoxDecoration(
                  color: const Color(MyColors.themeRedColor).withOpacity(0.10),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.wifi_off_rounded,
                  color: const Color(MyColors.themeRedColor),
                  size: 24.sp,
                ),
              ),
              SizedBox(height: 14.h),
              AutoSizeText(Strings.noInternetText(Get.context!),
                  textAlign: TextAlign.center,
                  maxFontSize: 16,
                  maxLines: 1,
                  minFontSize: 9,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    fontFamily: 'Poppins',
                    color: Colors.black,
                  )),
              SizedBox(height: 8.h),
              AutoSizeText(
                Strings.offlineSnackbarDescText(Get.context!),
                textAlign: TextAlign.center,
                maxFontSize: 13,
                minFontSize: 9,
                maxLines: 2,
                style: TextStyle(
                  fontSize: 13,
                  height: 1.4,
                  color: Colors.grey[600],
                  fontFamily: 'Poppins',
                ),
              ),
              SizedBox(height: 20.h),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(
                            color: Color(MyColors.lightSilverColor)),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.r),
                        ),
                        padding: EdgeInsets.symmetric(vertical: 12.h),
                      ),
                      onPressed: () {
                        Get.back();
                        Get.back();
                      },
                      child: Text(
                        Strings.cancelText(Get.context!),
                        style: TextStyle(
                          fontSize: 14.sp,
                          fontFamily: 'Poppins',
                          color: const Color(MyColors.darkGrayColor),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 12.w),
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(MyColors.themeRedColor),
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.r),
                        ),
                        padding: EdgeInsets.symmetric(vertical: 12.h),
                      ),
                      onPressed: () async {
                        // Close first so a progress dialog opened by the
                        // retry cannot collide with this one.
                        Get.back();
                        await Future.delayed(const Duration(milliseconds: 100));
                        postJob();
                      },
                      child: Text(
                        Strings.tryAgain(Get.context!),
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 14.sp,
                          fontFamily: 'Poppins',
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      barrierDismissible: true,
    );
  }
}
