import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:workforceclientapp/Others/MyColors.dart';
import 'package:workforceclientapp/Others/Strings.dart';
import 'package:workforceclientapp/views/widgets/HeadingTextW600.dart';
import 'package:workforceclientapp/views/widgets/Headingdescription.dart';

class PrivacyPolicy extends GetView<PrivacyPolicyController> {
  const PrivacyPolicy({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(MyColors.cardGrayColor100),
      appBar: AppBar(
        leadingWidth: MediaQuery.of(context).size.width.w,
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
                  size: 18.0.sp,
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
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(12.0.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Intro paragraph — kept plain, not bulleted
              Headingdescription(
                  text: Strings.privacyPolicyText(Get.context!),
                  centerAlign: false,
                  size: 13.5.sp),
              SizedBox(height: 12.h),

              ..._buildSection(
                Strings.privacyPolicyHeading1Text(Get.context!),
                Strings.privacyPolicyPoint1Text(Get.context!),
              ),
              ..._buildSection(
                Strings.privacyPolicyHeading2Text(Get.context!),
                Strings.privacyPolicyPoint2Text(Get.context!),
              ),
              ..._buildSection(
                Strings.privacyPolicyHeading3Text(Get.context!),
                Strings.privacyPolicyPoint3Text(Get.context!),
              ),
              ..._buildSection(
                Strings.privacyPolicyHeading4Text(Get.context!),
                Strings.privacyPolicyPoint4Text(Get.context!),
              ),
              ..._buildSection(
                Strings.privacyPolicyHeading5Text(Get.context!),
                Strings.privacyPolicyPoint5Text(Get.context!),
              ),
              ..._buildSection(
                Strings.privacyPolicyHeading6Text(Get.context!),
                Strings.privacyPolicyPoint6Text(Get.context!),
              ),
              ..._buildSection(
                Strings.privacyPolicyHeading7Text(Get.context!),
                Strings.privacyPolicyPoint7Text(Get.context!),
              ),
              ..._buildSection(
                Strings.privacyPolicyHeading8Text(Get.context!),
                Strings.privacyPolicyPoint8Text(Get.context!),
              ),
              ..._buildSection(
                Strings.privacyPolicyHeading9Text(Get.context!),
                Strings.privacyPolicyPoint9Text(Get.context!),
              ),
              ..._buildSection(
                Strings.privacyPolicyHeading10Text(Get.context!),
                Strings.privacyPolicyPoint10Text(Get.context!),
              ),
              SizedBox(
                height: MediaQuery.of(context).padding.bottom,
              )
            ],
          ),
        ),
      ),
    );
  }

  // Helper to avoid repeating heading + bullet + spacing 10 times
  List<Widget> _buildSection(String heading, String body) {
    return [
      HeadingTextW600(text: heading, centerAlign: false, size: 14.sp),
      SizedBox(height: 6.h),
      BulletList(text: body, fontSize: 14),
      SizedBox(height: 12.h),
    ];
  }
}

class PrivacyPolicyController extends GetxController {}

class BulletList extends StatelessWidget {
  final String text; // splits on '\n' to form separate bullet points
  final double fontSize;
  final Color? textColor;
  final FontWeight fontWeight;
  final double bulletSize;

  const BulletList({
    super.key,
    required this.text,
    this.fontSize = 12.5,
    this.textColor,
    this.fontWeight = FontWeight.normal,
    this.bulletSize = 8.0,
  });

  @override
  Widget build(BuildContext context) {
    final points = text
        .split('\n')
        .map((e) => e.trim())
        .where((e) => e.isNotEmpty)
        .toList();

    // Fallback: no line breaks found -> treat whole text as one bullet
    final safePoints = points.isEmpty ? [text.trim()] : points;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: safePoints.map((point) {
        return Padding(
          padding: EdgeInsets.only(bottom: 8.0.h),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.only(right: 8.0.w, top: 6.0),
                child: Icon(
                  Icons.circle,
                  size: bulletSize,
                  color: textColor ?? Colors.black87,
                ),
              ),
              Expanded(
                child: Text(
                  point,
                  style: TextStyle(
                    fontSize: fontSize.sp,
                    fontWeight: fontWeight,
                    color: textColor,
                    height: 1.4,
                  ),
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }
}
