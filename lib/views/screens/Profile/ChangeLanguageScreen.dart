import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:workforceclientapp/Others/Commons.dart';
import 'package:workforceclientapp/Others/MyColors.dart';
import 'package:workforceclientapp/Others/Strings.dart';
import 'package:workforceclientapp/views/widgets/HeadingTextW500.dart';
import 'package:workforceclientapp/views/widgets/HeadingTextW600.dart';
import 'package:workforceclientapp/views/widgets/Headingdescription.dart';

class ChangeLanguageScreen extends StatefulWidget {
  const ChangeLanguageScreen({super.key});

  @override
  State<ChangeLanguageScreen> createState() => _ChangeLanguageScreenState();
}

class _ChangeLanguageScreenState extends State<ChangeLanguageScreen> {
  String? selectedLang;
  late SharedPreferences _prefs;

  @override
  void initState() {
    super.initState();
    getSelecedLang();
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
            elevation: 0,
            shape: const Border(
                bottom: BorderSide(
                    color: Color.fromARGB(147, 203, 203, 203),
                    style: BorderStyle.solid)),
            child: Center(
              child: Stack(
                children: [
                  Center(
                      child: HeadingTextW600(
                    text: Strings.changeLanguageText(context),
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
                  mainAxisAlignment: MainAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(left: 20.0.w, top: 12.h),
                      child: Align(
                        alignment: Alignment.topLeft,
                        child: HeadingTextW500(
                            text: Strings.selectLanguageText(context),
                            centerAlign: false,
                            size: 16.sp),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                          left: 16.0.w, right: 16.0.w, top: 8.0.h),
                      child: Card(
                        elevation: 0,
                        color: selectedLang == 'en'
                            ? Colors.red.shade50
                            : const Color(MyColors.whiteColor),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0.r),
                          side: BorderSide(
                            color: selectedLang == 'en'
                                ? const Color(MyColors.themeRedColor)
                                : const Color(MyColors.darkGrayColor),
                          ),
                        ),
                        child: RadioListTile(
                          title: Headingdescription(
                              text: 'English', centerAlign: false, size: 14.sp),
                          value: 'en',
                          groupValue: selectedLang,
                          selected: selectedLang == 'en' ? true : false,
                          activeColor: const Color(MyColors.themeRedColor),
                          tileColor: Colors.white,
                          onChanged: (value) {
                            setState(() {
                              selectedLang = 'en';
                              setLanguage();
                            });
                          },
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                          left: 16.0.w,
                          right: 16.0.w,
                          top: 5.0.h,
                          bottom: 8.0.h),
                      child: Card(
                        elevation: 0,
                        color: selectedLang == 'de'
                            ? Colors.red.shade50
                            : const Color(MyColors.whiteColor),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0.r),
                          side: BorderSide(
                            color: selectedLang == 'de'
                                ? const Color(MyColors.themeRedColor)
                                : const Color(MyColors.darkGrayColor),
                          ),
                        ),
                        child: RadioListTile(
                          title: Headingdescription(
                              text: 'German', centerAlign: false, size: 14.sp),
                          value: 'de',
                          groupValue: selectedLang,
                          selected: selectedLang == 'de' ? true : false,
                          activeColor: const Color(MyColors.themeRedColor),
                          tileColor: Colors.white,
                          onChanged: (value) {
                            setState(() {
                              selectedLang = 'de';
                              setLanguage();
                            });
                          },
                        ),
                      ),
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

  void setLanguage() async {
    try {
      Commons.showProgressDialog(context);
      Future.delayed(const Duration(seconds: 1), () async {
        if (selectedLang == "en") {
          await _prefs.setString("language", "en");
          Get.updateLocale(const Locale('en'));
        } else {
          await _prefs.setString("language", "de");
          Get.updateLocale(const Locale('de'));
        }
        Commons.hideProgressDialog();
      });
    } catch (e) {
      throw Exception(e);
    }
  }

  void getSelecedLang() async {
    _prefs = await SharedPreferences.getInstance();
    selectedLang = _prefs.getString("language") ?? "en";
    setState(() {});
  }
}
