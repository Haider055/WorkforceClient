import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:workforceclientapp/Others/MyColors.dart';
import 'package:workforceclientapp/Others/Strings.dart';
import 'package:workforceclientapp/views/widgets/HeadingTextW600.dart';
import 'package:workforceclientapp/views/widgets/Headingdescription.dart';

class TermsAndConditions extends GetView<TermsandconditionController> {
  const TermsAndConditions({super.key});
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
                    text: Strings.termsAndConditionText(context),
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
                const HeadingTextW600(
                    text: "EULA", centerAlign: true, size: 16),
                Headingdescription(
                    text: Strings.eULAText(Get.context!),
                    centerAlign: false,
                    size: 14),
                const HeadingTextW600(
                    text: "Liscense", centerAlign: true, size: 16),
                Headingdescription(
                    text: Strings.lisenceText(Get.context!),
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

class TermsandconditionController extends GetxController {}
