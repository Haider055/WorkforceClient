import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:workforceclientapp/Controllers/ProfileController.dart';
import 'package:workforceclientapp/Others/Commons.dart';
import 'package:workforceclientapp/Others/MyColors.dart';
import 'package:workforceclientapp/Others/Strings.dart';
import 'package:workforceclientapp/views/widgets/FullWidthElevatedButton.dart';
import 'package:workforceclientapp/views/widgets/HeadingTextW500.dart';
import 'package:workforceclientapp/views/widgets/HeadingTextW600.dart';

class DeleteAccountScreen extends GetView<ProfileController> {
  const DeleteAccountScreen({super.key});

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
                  text: Strings.deleteAccount(context),
                  centerAlign: false,
                  size: 16.0.sp,
                )),
                GestureDetector(
                  onTap: () {
                    Get.back();
                  },
                  child: Padding(
                    padding: EdgeInsets.only(left: 12.0.r),
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
                    padding: EdgeInsets.all(16.r),
                    child: HeadingTextW500(
                        text: Strings.deleteAccountDescText(context),
                        centerAlign: false,
                        size: 16),
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                        left: 16.w, top: 8.h, right: 16.w, bottom: 16.h),
                    child: FullWidthElevatedButton(
                        text: Strings.deleteMyAccount(context),
                        color: MyColors.themeRedColor,
                        onPressed: () async {
                          try {
                            Commons.showProgressDialog(context);
                            var res =
                                await controller.pleaseDeleteAccount(context);
                            if (res) {
                              controller.logoutUser();
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
    );
  }
}
