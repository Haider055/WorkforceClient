import 'dart:io';

import 'package:flutter/material.dart';
import 'package:workforceclientapp/Controllers/PasswordUpdatedController.dart';
import 'package:workforceclientapp/Others/MyColors.dart';
import 'package:workforceclientapp/Others/Strings.dart';
import 'package:workforceclientapp/Others/routes.dart';
import 'package:workforceclientapp/views/widgets/Headingdescription.dart';
import 'package:workforceclientapp/views/widgets/FullWidthButton.dart';
import 'package:get/get.dart';

class PasswordUpdatedScreen extends GetView<PasswordUpdatedController> {
  const PasswordUpdatedScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (Platform.isAndroid) {
          Get.offAllNamed(AppLinks.login_screen);
        } else if (Platform.isIOS) {
          Get.offAllNamed(AppLinks.login_screen);
        }
        return false;
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 50.0),
                    child: Align(
                        alignment: Alignment.topCenter,
                        child: Image.asset(
                          "lib/assets/images/passwordupdatedicon.png",
                          fit: BoxFit.fill,
                          height: 142.27,
                          width: 109.0,
                        )),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 12.0),
                    child: Text(
                      Strings.passwordUpdated(context),
                      style: const TextStyle(
                          color: Colors.black,
                          fontSize: 28.0,
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w600),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 16.0),
                    child: Headingdescription(
                      text: Strings.congratulations(context),
                      centerAlign: true,
                      size: 16.0,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 4.0),
                    child: Headingdescription(
                      text: Strings.passwordHasBeenUpdated(context),
                      centerAlign: true,
                      size: 16.0,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 40.0),
                    child: FullWidthButton(
                      text: Strings.signInText(context),
                      color: MyColors.themeRedColor,
                      onPressed: () {
                        Get.offAllNamed(AppLinks.login_screen);
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
