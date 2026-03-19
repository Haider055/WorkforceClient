import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:workforceclientapp/Others/MyColors.dart';
import 'package:workforceclientapp/Others/Strings.dart';
import 'package:workforceclientapp/views/widgets/HeadingTextW600.dart';
import 'package:workforceclientapp/views/widgets/Headingdescription.dart';

class PrivacyPolicy extends GetView<PrivacyPolicyController> {
  const PrivacyPolicy({super.key});
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: const Color(MyColors.cardGrayColor100),
        appBar: AppBar(
          leadingWidth: MediaQuery.of(context).size.width,
          leading: Card(
            color: const Color(MyColors.cardGrayColor100),
            shadowColor: const Color.fromARGB(158, 219, 219, 219),
            elevation: 0.5,
            shape: const Border(
                bottom: BorderSide(
                    color: Color.fromARGB(147, 203, 203, 203),
                    style: BorderStyle.solid)),
            child: Center(
              child: Stack(
                children: [
                  Center(
                      child: HeadingTextW600(
                    text: Strings.privacyPolicy(context),
                    centerAlign: false,
                    size: 18.0,
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
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Headingdescription(
                    text: Strings.privacyPolicyText(Get.context!),
                    centerAlign: false,
                    size: 14),
                HeadingTextW600(
                    text: Strings.privacyPolicyHeading1Text(Get.context!),
                    centerAlign: false,
                    size: 15),
                Headingdescription(
                    text: Strings.privacyPolicyPoint1Text(Get.context!),
                    centerAlign: false,
                    size: 14),
                HeadingTextW600(
                    text: Strings.privacyPolicyHeading2Text(Get.context!),
                    centerAlign: false,
                    size: 15),
                Headingdescription(
                    text: Strings.privacyPolicyPoint2Text(Get.context!),
                    centerAlign: false,
                    size: 14),
                HeadingTextW600(
                    text: Strings.privacyPolicyHeading3Text(Get.context!),
                    centerAlign: false,
                    size: 15),
                Headingdescription(
                    text: Strings.privacyPolicyPoint3Text(Get.context!),
                    centerAlign: false,
                    size: 14),
                HeadingTextW600(
                    text: Strings.privacyPolicyHeading4Text(Get.context!),
                    centerAlign: false,
                    size: 15),
                Headingdescription(
                    text: Strings.privacyPolicyPoint4Text(Get.context!),
                    centerAlign: false,
                    size: 14),
                HeadingTextW600(
                    text: Strings.privacyPolicyHeading5Text(Get.context!),
                    centerAlign: false,
                    size: 15),
                Headingdescription(
                    text: Strings.privacyPolicyPoint5Text(Get.context!),
                    centerAlign: false,
                    size: 14),
                HeadingTextW600(
                    text: Strings.privacyPolicyHeading6Text(Get.context!),
                    centerAlign: false,
                    size: 15),
                Headingdescription(
                    text: Strings.privacyPolicyPoint6Text(Get.context!),
                    centerAlign: false,
                    size: 14),
                HeadingTextW600(
                    text: Strings.privacyPolicyHeading7Text(Get.context!),
                    centerAlign: false,
                    size: 15),
                Headingdescription(
                    text: Strings.privacyPolicyPoint7Text(Get.context!),
                    centerAlign: false,
                    size: 14),
                HeadingTextW600(
                    text: Strings.privacyPolicyHeading8Text(Get.context!),
                    centerAlign: false,
                    size: 15),
                Headingdescription(
                    text: Strings.privacyPolicyPoint8Text(Get.context!),
                    centerAlign: false,
                    size: 14),
                HeadingTextW600(
                    text: Strings.privacyPolicyHeading9Text(Get.context!),
                    centerAlign: false,
                    size: 15),
                Headingdescription(
                    text: Strings.privacyPolicyPoint9Text(Get.context!),
                    centerAlign: false,
                    size: 14),
                HeadingTextW600(
                    text: Strings.privacyPolicyHeading10Text(Get.context!),
                    centerAlign: false,
                    size: 15),
                Headingdescription(
                    text: Strings.privacyPolicyPoint10Text(Get.context!),
                    centerAlign: false,
                    size: 14),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class PrivacyPolicyController extends GetxController {}
