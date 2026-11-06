import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:workforceclientapp/Others/MyColors.dart';
import 'package:workforceclientapp/Others/Strings.dart';
import 'package:workforceclientapp/Others/routes.dart';
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

  // Drives the show/hide eye on the suffix icon.
  bool _obscurePassword = true;

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
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 19.w),
                        child: TextFormField(
                          controller: passwordTextField.value,
                          keyboardType: TextInputType.visiblePassword,
                          maxLines: 1,
                          onChanged: (value) {},
                          onFieldSubmitted: (value) {
                            submit();
                          },
                          obscureText: _obscurePassword,
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
                            hintText: Strings.currentPasswordText(context),

                            // ERROR BORDER
                            errorBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.r),
                              borderSide: BorderSide(
                                width: 2.w,
                                color: Colors.red.withValues(alpha: 0.7),
                              ),
                            ),
                            focusedErrorBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.r),
                              borderSide: BorderSide(
                                width: 2.w,
                                color: Colors.red.withValues(alpha: 0.7),
                              ),
                            ),

                            filled: true,
                            fillColor: const Color(MyColors.whiteColor),

                            // TEXT STYLE
                            hintStyle: TextStyle(
                              fontFamily: 'Poppins',
                              fontSize: 16.sp,
                              color: const Color(0x66000000),
                              fontWeight: FontWeight.w400,
                            ),

                            prefixIcon: null,
                            prefixIconColor: const Color(0x66000000),

                            // Was `suffixIcon: Icon` — that passes the Icon
                            // CLASS, not a widget, so it would not compile.
                            suffixIcon: IconButton(
                              icon: Icon(
                                _obscurePassword
                                    ? Icons.visibility_off_outlined
                                    : Icons.visibility_outlined,
                                size: 20.sp,
                              ),
                              onPressed: () {
                                setState(() {
                                  _obscurePassword = !_obscurePassword;
                                });
                              },
                            ),
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
                                color: const Color(MyColors.fieldBorderColor),
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.r),
                              borderSide: BorderSide(
                                width: 2.w,
                                color: const Color(MyColors.fieldBorderColor),
                              ),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.r),
                              borderSide: BorderSide(
                                width: 2.w,
                                color: const Color(MyColors.fieldBorderColor),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(20.0.r),
                      child: FullWidthElevatedButton(
                          text: Strings.next(Get.context!),
                          color: MyColors.themeRedColor,
                          onPressed: () {
                            submit();
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

  void submit() {
    try {
      print(pass);
      if (pass == passwordTextField.value.text) {
        Get.toNamed(AppLinks.update_password_screen,
            arguments: {'password': pass});
      } else {
        FocusScope.of(Get.context!).unfocus();
        Fluttertoast.showToast(msg: Strings.passwordIsWrong(context));
      }
    } catch (e) {
      throw Exception(e);
    }
  }

  @override
  void dispose() {
    passwordTextField.value.dispose();
    super.dispose();
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
