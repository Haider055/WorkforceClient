import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:workforceclientapp/Others/MyColors.dart';
import 'package:workforceclientapp/Others/Strings.dart';
import 'package:workforceclientapp/Others/routes.dart';
import 'package:workforceclientapp/views/widgets/CommonTextFieldWhite.dart';
import 'package:workforceclientapp/views/widgets/FullWidthElevatedButton.dart';
import 'package:workforceclientapp/views/widgets/HeadingTextW500.dart';
import 'package:workforceclientapp/views/widgets/HeadingTextW600.dart';

class EnterPreviousPassword extends StatefulWidget {
  const EnterPreviousPassword({super.key});

  @override
  State<EnterPreviousPassword> createState() => _EnterPreviousPasswordState();
}

class _EnterPreviousPasswordState extends State<EnterPreviousPassword> {
  String pass = "";
  late SharedPreferences _prefs;
  final passwordTextField = TextEditingController().obs;

  @override
  void initState() {
    super.initState();
    getSavedPass();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(Get.context!).unfocus();
      },
      child: Scaffold(
        appBar: AppBar(
          leadingWidth: MediaQuery.of(context).size.width,
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
                    text: Strings.updatePassword(context),
                    centerAlign: false,
                    size: 16.0.sp,
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
        body: Column(
          children: [
            Padding(
              padding: EdgeInsets.all(12.0.r),
              child: Card(
                elevation: 0,
                color: const Color(MyColors.cardGrayColor100),
                child: Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.only(left: 20.0.w, top: 12.h),
                      child: Align(
                        alignment: Alignment.topLeft,
                        child: HeadingTextW500(
                            text: Strings.currentPasswordText(context),
                            centerAlign: false,
                            size: 16.sp),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 12.0.h),
                      child: CommonTextFieldWhite(
                          hint: Strings.currentPasswordText(context),
                          errorText: "",
                          controller: passwordTextField(),
                          inputType: TextInputType.text,
                          prefixIcon: const Icon(Icons.lock_outline),
                          needPasswordSuffixIcon: true,
                          needprefixIcon: true,
                          onChanged: (value) {}),
                    ),
                    Padding(
                      padding: EdgeInsets.all(20.0.r),
                      child: FullWidthElevatedButton(
                          text: Strings.next(Get.context!),
                          color: MyColors.themeRedColor,
                          onPressed: () {
                            try {
                              if (pass == passwordTextField.value.text) {
                                Get.toNamed(AppLinks.update_password_screen,
                                    arguments: {'password': pass});
                              } else {
                                FocusScope.of(Get.context!).unfocus();
                                Fluttertoast.showToast(
                                    msg: Strings.passwordIsWrong(context));
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
    );
  }

  void getSavedPass() async {
    try {
      _prefs = await SharedPreferences.getInstance();
      pass = _prefs.getString('password') ?? "";
    } catch (e) {
      throw Exception(e);
    }
  }
}
