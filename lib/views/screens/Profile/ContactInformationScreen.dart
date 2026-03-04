import 'package:flutter/material.dart';
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
                    text: Strings.contactInformation(context),
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
                      padding: const EdgeInsets.only(left: 10.0, top: 12),
                      child: Align(
                        alignment: Alignment.topLeft,
                        child: HeadingTextW500(
                            text: Strings.fullNameAddressText(context),
                            centerAlign: false,
                            size: 16),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 12.0),
                      child: CommonTextFieldWhite(
                          hint: Strings.fullNameAddressText(context),
                          errorText: nameErrorText,
                          controller: controller.nameTextField(),
                          inputType: TextInputType.text,
                          prefixIcon: const Icon(Icons.person),
                          needPasswordSuffixIcon: false,
                          needprefixIcon: false,
                          onChanged: (value) {
                            // setState(() {
                            //   emailAddressErrorText = "";
                            // });
                          }),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 10.0, top: 12),
                      child: Align(
                        alignment: Alignment.topLeft,
                        child: HeadingTextW500(
                            text: Strings.phoneText(context),
                            centerAlign: false,
                            size: 16),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 12.0),
                      child: CommonTextFieldWhite(
                          hint: phoneErrorText,
                          errorText: phoneErrorText,
                          controller: controller.phoneTextField(),
                          inputType: TextInputType.number,
                          prefixIcon: const Icon(Icons.phone),
                          needPasswordSuffixIcon: false,
                          needprefixIcon: false,
                          onChanged: (value) {
                            // setState(() {
                            //   emailAddressErrorText = "";
                            // });
                          }),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: FullWidthElevatedButton(
                          text: "Save",
                          color: MyColors.themeRedColor,
                          onPressed: () async {
                            try {
                              if (controller
                                      .nameTextField.value.text.isNotEmpty &&
                                  controller
                                      .phoneTextField.value.text.isNotEmpty) {
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
                                        "Please enter valid Phone!";
                                  });
                                  return;
                                }
                                Commons.showProgressDialog(context);
                                await controller.pleaseUpdateNameAndPhone();
                                Commons.hideProgressDialog();
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
