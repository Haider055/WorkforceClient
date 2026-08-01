import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:workforceclientapp/Controllers/ContactInformationCotroller.dart';
import 'package:workforceclientapp/Others/Commons.dart';
import 'package:workforceclientapp/Others/MyColors.dart';
import 'package:workforceclientapp/Others/Strings.dart';
import 'package:workforceclientapp/views/widgets/CommonTextFieldWhite.dart';
import 'package:workforceclientapp/views/widgets/FullWidthElevatedButton.dart';
import 'package:workforceclientapp/views/widgets/HeadingTextW500.dart';
import 'package:workforceclientapp/views/widgets/HeadingTextW600.dart';

class ContactInformationScreen extends StatefulWidget {
  const ContactInformationScreen({super.key});

  @override
  State<ContactInformationScreen> createState() =>
      _ContactInformationScreenState();
}

class _ContactInformationScreenState extends State<ContactInformationScreen> {
  String nameErrorText = "";
  String phoneErrorText = "";
  late SharedPreferences _prefs;

  String name = "";
  String phone = "";
  ContactInformationCotroller controller =
      Get.put(ContactInformationCotroller());

  @override
  void initState() {
    super.initState();
    getSavedValues();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: true,
      onPopInvoked: (didPop) {
        if (didPop) {
          Get.back(result: '');
        }
      },
      child: GestureDetector(
        onTap: () {
          FocusScope.of(Get.context!).unfocus();
        },
        child: Scaffold(
          appBar: AppBar(
            leadingWidth: MediaQuery.of(context).size.width.w,
            leading: Card(
              color: const Color(MyColors.whiteColor),
              shadowColor: const Color.fromARGB(158, 219, 219, 219),
              elevation: 2,
              shape: const Border(
                  bottom: BorderSide(
                      color: Color.fromARGB(147, 203, 203, 203),
                      style: BorderStyle.solid)),
              child: Center(
                child: Stack(
                  children: [
                    Center(
                        child: HeadingTextW600(
                      text: Strings.contactInformation(context),
                      centerAlign: false,
                      size: 16.0..sp,
                    )),
                    GestureDetector(
                      onTap: () {
                        Get.back();
                      },
                      child: Padding(
                        padding: EdgeInsets.only(left: 12.0.w),
                        child: const Align(
                            alignment: Alignment.centerLeft,
                            child: Icon(Icons.arrow_back_ios)),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          backgroundColor: const Color(MyColors.whiteColor),
          body: GestureDetector(
            onTap: () {
              FocusScope.of(Get.context!).unfocus();
            },
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.all(12.0.r),
                  child: Card(
                    elevation: 0,
                    color: const Color(MyColors.cardGrayColor100),
                    child: Column(
                      children: [
                        Padding(
                          padding: EdgeInsets.only(left: 10.0.w, top: 12.h),
                          child: Align(
                            alignment: Alignment.topLeft,
                            child: HeadingTextW500(
                                text: Strings.fullNameAddressText(context),
                                centerAlign: false,
                                size: 16.sp),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(top: 12.0.h),
                          child: CommonTextFieldWhite(
                              hint: Strings.fullNameAddressText(context),
                              errorText: nameErrorText,
                              controller: controller.nameTextField(),
                              inputType: TextInputType.text,
                              prefixIcon: const Icon(Icons.person),
                              needPasswordSuffixIcon: false,
                              needprefixIcon: false,
                              onChanged: (value) {
                                setState(() {
                                  phoneErrorText = '';
                                });
                              }),
                        ),
                        Padding(
                          padding: EdgeInsets.only(left: 10.0.w, top: 12.h),
                          child: Align(
                            alignment: Alignment.topLeft,
                            child: HeadingTextW500(
                                text: Strings.phoneText(context),
                                centerAlign: false,
                                size: 16.sp),
                          ),
                        ),
                        Padding(
                            padding: EdgeInsets.only(top: 12.0.h),
                            child: Padding(
                              padding: EdgeInsets.symmetric(horizontal: 19.w),
                              child: TextFormField(
                                controller: controller.phoneTextField(),
                                keyboardType: TextInputType.phone,
                                maxLines: 1,
                                maxLength: 13,
                                onChanged: (value) {
                                  setState(() {
                                    phoneErrorText = '';
                                  });
                                },
                                obscureText: false,
                                obscuringCharacter: "*",
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return "Field cannot be empty!";
                                  } else if (value.length < 3) {
                                    return "Must be at least 3 characters long!";
                                  }
                                  return null;
                                },
                                decoration: InputDecoration(
                                  hintText: "e.g. +490123456789",
                                  errorText: phoneErrorText,
                                  errorBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10.r),
                                    borderSide: BorderSide(
                                      width: 2.w,
                                      color: phoneErrorText.isEmpty
                                          ? const Color(MyColors.fieldBorderColor)
                                          : Colors.red.withOpacity(0.7),
                                    ),
                                  ),
                                  focusedErrorBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10.r),
                                    borderSide: BorderSide(
                                      width: 2.w,
                                      color: phoneErrorText.isEmpty
                                          ? const Color(MyColors.fieldBorderColor)
                                          : Colors.red.withOpacity(0.7),
                                    ),
                                  ),

                                  filled: true,
                                  fillColor: phoneErrorText.isEmpty
                                      ? const Color(MyColors.whiteColor)
                                      : Colors.red.withOpacity(0.12),

                                  hintStyle: TextStyle(
                                    fontFamily: 'Poppins',
                                    fontSize: 16.sp,
                                    color: const Color(0x66000000),
                                    fontWeight: FontWeight.w400,
                                  ),

                                  prefixIcon: null,
                                  prefixIconColor: const Color(0x66000000),

                                  suffixIcon: null,
                                  suffixIconColor: const Color(0x66000000),

                                  // INNER PADDING
                                  contentPadding: EdgeInsets.symmetric(
                                    horizontal: 16.w,
                                    vertical: 14.h,
                                  ),

                                  // NORMAL BORDER
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10.r),
                                    borderSide: BorderSide(
                                      width: 2.w,
                                      color: const Color(
                                          MyColors.fieldBorderColor),
                                    ),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10.r),
                                    borderSide: BorderSide(
                                      width: 2.w,
                                      color: const Color(
                                          MyColors.fieldBorderColor),
                                    ),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10.r),
                                    borderSide: BorderSide(
                                      width: 2.w,
                                      color: const Color(
                                          MyColors.fieldBorderColor),
                                    ),
                                  ),
                                ),
                              ),
                            )
                            //  CommonTextFieldWhite(
                            //                           hint: phoneErrorText,
                            //                           errorText: phoneErrorText,
                            //                           controller: controller.phoneTextField(),
                            //                           inputType: TextInputType.number,
                            //                           prefixIcon: const Icon(Icons.phone),
                            //                           needPasswordSuffixIcon: false,
                            //                           needprefixIcon: false,
                            //                           onChanged: (value) {
                            // setState(() {
                            //   emailAddressErrorText = "";
                            // });
                            //                           }),
                            ),
                        Padding(
                          padding: EdgeInsets.all(20.0.sp),
                          child: FullWidthElevatedButton(
                              text: "Save",
                              color: MyColors.themeRedColor,
                              onPressed: () async {
                                try {
                                  if (controller.nameTextField.value.text
                                          .isNotEmpty &&
                                      controller.phoneTextField.value.text
                                          .isNotEmpty) {
                                    if (controller.nameTextField.value.text
                                            .toString()
                                            .length <
                                        4) {
                                      setState(() {
                                        nameErrorText =
                                            Strings.nameMustBeAtLeast(context);
                                      });
                                      return;
                                    }

                                    if (!controller.phoneTextField.value.text
                                        .toString()
                                        .isPhoneNumber) {
                                      setState(() {
                                        phoneErrorText =
                                            Strings.pleaseEnterValidPhoneText(
                                                Get.context!);
                                      });
                                      return;
                                    }
                                    if (controller.phoneTextField.value.text
                                            .toString()
                                            .length >
                                        13) {
                                      setState(() {
                                        phoneErrorText = Strings
                                            .phoneNumberCannotbemorethan13digit(
                                                Get.context!);
                                      });
                                      return;
                                    }
                                    Commons.showProgressDialog(context);
                                    var res = await controller
                                        .pleaseUpdateNameAndPhone();
                                  } else {
                                    Fluttertoast.showToast(
                                        msg: Strings.cannotBeEmpty(context));
                                  }
                                } catch (e) {
                                  throw Exception(e);
                                }
                              },
                              textColor: MyColors.whiteColor),
                        )
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  void getSavedValues() async {
    try {
      _prefs = await SharedPreferences.getInstance();
      name = _prefs.getString('name') ?? "";
      phone = _prefs.getString('phone') ?? "";
      controller.nameTextField.value.text = name;
      controller.phoneTextField.value.text = phone;
    } catch (e) {
      throw Exception(e);
    }
  }
}
