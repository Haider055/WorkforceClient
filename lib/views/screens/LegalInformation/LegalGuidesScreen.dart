import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:workforceclientapp/Controllers/LegalGuidesController.dart';
import 'package:workforceclientapp/Others/MyColors.dart';
import 'package:workforceclientapp/Others/Strings.dart';
import 'package:workforceclientapp/Others/routes.dart';
import 'package:workforceclientapp/views/widgets/HeadingTextW600.dart';
import 'package:workforceclientapp/views/widgets/Headingdescription.dart';

class LegalGuidesScreen extends GetView<LegalGuidesController> {
  const LegalGuidesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      bottom: false,
      child: Scaffold(
        backgroundColor: const Color(MyColors.lightSilverColor),
        appBar: AppBar(
          leadingWidth: MediaQuery.of(context).size.width.w,
          leading: Card(
            color: const Color(MyColors.lightSilverColor),
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
                    text: Strings.legalText(context),
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
        body: Obx(() {
          if (controller.isLoading.value) {
            return const Center(
              child: CircularProgressIndicator(
                color: Color(MyColors.themeRedColor),
              ),
            );
          }

          if (controller.hasError.value || controller.guides.isEmpty) {
            return ListView(
              physics: const AlwaysScrollableScrollPhysics(),
              children: [
                SizedBox(height: 120.h),
                Center(
                  child: Padding(
                    padding: EdgeInsets.all(20.0.r),
                    child: Column(
                      children: [
                        Headingdescription(
                          text: controller.hasError.value
                              ? Strings.somethingWentWrong(Get.context!)
                              : Strings.noDataFound(Get.context!),
                          centerAlign: true,
                          size: 14.sp,
                        ),
                        SizedBox(height: 12.h),
                        // TextButton(
                        //   onPressed: controller.loadGuides,
                        //   child: const Text("Retry"),
                        // ),
                      ],
                    ),
                  ),
                ),
              ],
            );
          }

          return ListView.separated(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: EdgeInsets.all(16.0.r),
            itemCount: controller.guides.length,
            separatorBuilder: (context, index) => SizedBox(height: 10.h),
            itemBuilder: (context, index) {
              final guide = controller.guides[index];
              return GestureDetector(
                onTap: () {
                  // TODO: open the document. Needs the detail response format.
                  Get.toNamed(AppLinks.legal_detail_screen, arguments: {
                    'slug': guide.slug,
                    'title': guide.title,
                    'url': guide.url,
                  });
                },
                child: Card(
                  elevation: 0,
                  margin: EdgeInsets.zero,
                  color: Colors.white,
                  shape: RoundedRectangleBorder(
                    side: const BorderSide(color: Colors.white),
                    borderRadius: BorderRadius.circular(9.r),
                  ),
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: 14.0.w, vertical: 16.0.h),
                    child: Row(
                      children: [
                        SizedBox(width: 12.w),
                        Expanded(
                          child: AutoSizeText(
                            minFontSize: 10,
                            maxLines: 1,
                            maxFontSize: 16,
                            guide.title ?? "",
                            style: TextStyle(
                              fontSize: 16.0.sp,
                              fontWeight: FontWeight.w500,
                              fontFamily: 'Poppins',
                            ),
                          ),
                        ),
                        const Icon(Icons.chevron_right,
                            color: Color(0x9C000000)),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        }),
      ),
    );
  }
}
