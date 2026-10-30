import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:workforceclientapp/Controllers/ManageAccountController.dart';
import 'package:workforceclientapp/Others/Commons.dart';
import 'package:workforceclientapp/Others/MyColors.dart';
import 'package:workforceclientapp/Others/Strings.dart';
import 'package:workforceclientapp/views/screens/Profile/EnterPreviousPassword.dart';
import 'package:workforceclientapp/views/widgets/HeadingTextW600.dart';

class ManageAccountScreen extends GetView<ManageAccountController> {
  const ManageAccountScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                  text: Strings.manageAccount(context),
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
      body: Obx(() {
        return GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
          },
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.only(
                    left: 16.0.w, right: 16.0.w, bottom: 16.0.h, top: 16.0.h),
                child: Card(
                  elevation: 0,
                  color: const Color(MyColors.cardGrayColor100),
                  child: Column(
                    children: [
                      // Manage Password
                      Padding(
                        padding: EdgeInsets.only(
                            left: 16.0.w, right: 16.0.w, top: 16.0.h),
                        child: GestureDetector(
                          onTap: () {
                            Get.to(
                              const EnterPreviousPassword(),
                              transition: Transition
                                  .rightToLeft, // Left-to-right animation
                              duration: const Duration(
                                  milliseconds:
                                      500), // Optional: animation duration
                            );
                          },
                          child: Card(
                            elevation: 0,
                            color: const Color(MyColors.whiteColor),
                            child: Padding(
                              padding: EdgeInsets.all(14.0.r),
                              child: Row(
                                children: [
                                  SvgPicture.asset(
                                    "lib/assets/icons/keyIcon.svg",
                                    height: 18,
                                    width: 18,
                                    fit: BoxFit.contain,
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(left: 8.0.w),
                                    child: AutoSizeText(
                                      minFontSize: 11.0,
                                      maxFontSize: 16.0,
                                      Strings.updatePassword(context),
                                      textAlign: TextAlign.start,
                                      style: const TextStyle(
                                        color: Colors.black,
                                        fontSize: 16.0, // responsive font size
                                        fontWeight: FontWeight.w400,
                                        fontFamily: 'Poppins',
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: Align(
                                      alignment: Alignment.centerRight,
                                      child: Icon(
                                        Icons.arrow_forward_ios,
                                        color:
                                            const Color(MyColors.blackColor80),
                                        size: 16.sp,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),

                      Padding(
                        padding: EdgeInsets.only(
                            left: 16.0.w,
                            right: 16.0.w,
                            bottom: 8.0.h,
                            top: 8.0.h),
                        child: Card(
                          elevation: 0,
                          color: const Color(MyColors.whiteColor),
                          child: Padding(
                            padding: EdgeInsets.only(
                                left: 14.0.r,
                                top: 14.0.h,
                                bottom: 14.0.h,
                                right: 3.0.r),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.verified_user_outlined,
                                  size: 18.sp,
                                  color: const Color(MyColors.blackColor80),
                                ),
                                Expanded(
                                  flex: 7,
                                  child: Padding(
                                    padding: EdgeInsets.only(
                                        left: 8.0.w, right: 2.0.w),
                                    child: AutoSizeText(
                                      Strings.enable2FAText(Get.context!),
                                      maxLines: 2,
                                      minFontSize: 10,
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(fontSize: 15),
                                    ),
                                  ),
                                ),
                                Expanded(
                                  flex: 3,
                                  child: Align(
                                    alignment: Alignment.centerRight,
                                    child: Switch(
                                      value: controller.isTwoFAEnabled.value,
                                      activeThumbColor:
                                          const Color(MyColors.themeRedColor),
                                      onChanged: (value) async {
                                        showPasswordDialog(
                                          onConfirm: (password) async {
                                            if (password !=
                                                controller.pass.value) {
                                              Fluttertoast.showToast(
                                                  msg: Strings.passwordIsWrong(
                                                      Get.context!));
                                              return;
                                            }
                                            Commons.showProgressDialog(
                                                Get.context!);
                                            bool res = false;
                                            try {
                                              // The controller hides the progress
                                              // dialog itself on every normal path.
                                              res = await controller
                                                  .pleaseChange2FAStatus(
                                                      value, password);
                                            } catch (e) {
                                              Commons.hideProgressDialog();
                                            }
                                            if (res) {
                                              controller.isTwoFAEnabled.value =
                                                  value;
                                            } else {
                                              Fluttertoast.showToast(
                                                  msg: Strings.failedText(
                                                      Get.context!));
                                            }
                                          },
                                        );
                                      },
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        );
      }),
    );
  }

  void showPasswordDialog({
    required Future<void> Function(String password) onConfirm,
    IconData icon = Icons.lock_outline,
  }) {
    // Local to this dialog. Not disposed manually: the dialog's Future
    // completes before its exit animation ends, so disposing in .then()
    // crashes the TextField that is still on screen.
    final TextEditingController passwordField = TextEditingController();
    bool obscure = true;
    String error = "";

    Get.dialog(
      StatefulBuilder(
        builder: (context, setLocalState) {
          void confirm() {
            final password = passwordField.text.trim();

            if (password.isEmpty) {
              setLocalState(
                  () => error = Strings.passwordCannotBeEmptyText(context));
              return;
            }

            FocusManager.instance.primaryFocus?.unfocus();
            Get.back();
            onConfirm(password);
          }

          void cancel() {
            Get.back();
          }

          return Dialog(
            backgroundColor: Colors.white,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14.r)),
            insetPadding:
                EdgeInsets.symmetric(horizontal: 24.w, vertical: 24.h),
            child: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.all(18.0.r),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      padding: EdgeInsets.all(12.r),
                      decoration: BoxDecoration(
                        color: const Color(MyColors.themeRedColor)
                            .withOpacity(0.10),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        icon,
                        color: const Color(MyColors.themeRedColor),
                        size: 24.sp,
                      ),
                    ),
                    SizedBox(height: 14.h),
                    Text(
                      Strings.enable2FAText(context),
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w600,
                        fontFamily: 'Poppins',
                        color: Colors.black,
                      ),
                    ),
                    SizedBox(height: 8.h),
                    AutoSizeText(
                        maxFontSize: 13,
                        maxLines: 2,
                        minFontSize: 8,
                        Strings.pleaseEntercurrentPasswordText(context),
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.grey[600],
                          fontFamily: 'Poppins',
                        )),
                    SizedBox(height: 16.h),
                    TextField(
                      controller: passwordField,
                      autofocus: true,
                      obscureText: obscure,
                      obscuringCharacter: "*",
                      keyboardType: TextInputType.visiblePassword,
                      textInputAction: TextInputAction.done,
                      onSubmitted: (_) => confirm(),
                      onChanged: (_) {
                        if (error.isNotEmpty) {
                          setLocalState(() => error = "");
                        }
                      },
                      style: TextStyle(fontSize: 14.sp, fontFamily: 'Poppins'),
                      decoration: InputDecoration(
                        hintText: Strings.passwordText(context),
                        errorText: error.isEmpty ? null : error,
                        isDense: true,
                        filled: true,
                        fillColor: const Color(MyColors.lightSilverColor),
                        hintStyle: TextStyle(
                          fontSize: 14.sp,
                          fontFamily: 'Poppins',
                          color: const Color(0x66000000),
                        ),
                        prefixIcon: Icon(Icons.lock_outline, size: 19.sp),
                        prefixIconColor: const Color(0x66000000),
                        suffixIcon: IconButton(
                          icon: Icon(
                            obscure
                                ? Icons.visibility_off_outlined
                                : Icons.visibility_outlined,
                            size: 19.sp,
                          ),
                          onPressed: () =>
                              setLocalState(() => obscure = !obscure),
                        ),
                        suffixIconColor: const Color(0x66000000),
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 14.w,
                          vertical: 14.h,
                        ),
                        border: passwordDialogBorder(
                            const Color(MyColors.fieldBorderColor)),
                        enabledBorder: passwordDialogBorder(
                            const Color(MyColors.fieldBorderColor)),
                        focusedBorder: passwordDialogBorder(
                            const Color(MyColors.themeRedColor)),
                        errorBorder:
                            passwordDialogBorder(Colors.red.withOpacity(0.7)),
                        focusedErrorBorder:
                            passwordDialogBorder(Colors.red.withOpacity(0.7)),
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
                            onPressed: cancel,
                            child: AutoSizeText(
                                maxFontSize: 14,
                                minFontSize: 8,
                                maxLines: 1,
                                Strings.cancelText(context),
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontFamily: 'Poppins',
                                  color: Color(MyColors.darkGrayColor),
                                )),
                          ),
                        ),
                        SizedBox(width: 12.w),
                        Expanded(
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor:
                                  const Color(MyColors.themeRedColor),
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.r),
                              ),
                              padding: EdgeInsets.symmetric(vertical: 12.h),
                            ),
                            onPressed: confirm,
                            child: AutoSizeText(
                              maxFontSize: 14,
                              minFontSize: 8,
                              maxLines: 1,
                              Strings.continueText(context),
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                fontSize: 14,
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
          );
        },
      ),
      // A stray tap outside should not silently abort a security prompt.
      barrierDismissible: false,
    );
  }

  OutlineInputBorder passwordDialogBorder(Color color) => OutlineInputBorder(
        borderRadius: BorderRadius.circular(10.r),
        borderSide: BorderSide(width: 1.5.w, color: color),
      );
}
