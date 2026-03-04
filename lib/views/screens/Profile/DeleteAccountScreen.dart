import 'package:flutter/material.dart';
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
    return SafeArea(
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
                    text: Strings.deleteAccount(context),
                    centerAlign: false,
                    size: 16.0,
                  )),
                  GestureDetector(
                    onTap: () {
                      Get.back();
                    },
                    child: const Padding(
                      padding: EdgeInsets.only(left: 12.0),
                      child: Align(
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
              padding: const EdgeInsets.all(12.0),
              child: Card(
                elevation: 0,
                color: const Color(MyColors.cardGrayColor100),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: HeadingTextW500(
                          text: Strings.deleteAccountDescText(context),
                          centerAlign: false,
                          size: 16),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                          left: 16, top: 8, right: 16, bottom: 16),
                      child: FullWidthElevatedButton(
                          text: Strings.deleteMyAccount(context),
                          color: MyColors.themeRedColor,
                          onPressed: () {
                            try {
                              Commons.showProgressDialog(context);
                              controller.pleaseDeleteAccount(context);
                              controller.logoutUser();
                              Commons.hideProgressDialog();
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
}
