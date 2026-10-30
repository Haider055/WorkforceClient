import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:workforceclientapp/Controllers/LegalDetailController.dart.dart';
import 'package:workforceclientapp/Others/MyColors.dart';
import 'package:workforceclientapp/Others/Strings.dart';
import 'package:workforceclientapp/views/widgets/HeadingTextW600.dart';
import 'package:workforceclientapp/views/widgets/Headingdescription.dart';
import 'package:markdown/markdown.dart' as md;

class LegalDetailScreen extends GetView<LegalDetailController> {
  const LegalDetailScreen({super.key});

  Future<void> _openLink(String? href) async {
    if (href == null || href.isEmpty) return;
    Uri uri = Uri.parse(href);
    // Plain emails get auto-linked without a scheme.
    if (!uri.hasScheme && href.contains('@')) {
      uri = Uri(scheme: 'mailto', path: href);
    }
    await launchUrl(uri, mode: LaunchMode.externalApplication);
  }

  MarkdownStyleSheet _styleSheet(BuildContext context) {
    final base = TextStyle(
      fontFamily: 'Poppins',
      fontSize: 14.sp,
      height: 1.5,
      color: Colors.black87,
    );
    TextStyle heading(double size) => base.copyWith(
          fontSize: size.sp,
          fontWeight: FontWeight.w600,
          color: const Color(MyColors.themeRedColor),
        );
    return MarkdownStyleSheet.fromTheme(Theme.of(context)).copyWith(
      p: base,
      listBullet: base,
      strong: base.copyWith(fontWeight: FontWeight.w600),
      a: base.copyWith(
        color: const Color(MyColors.themeRedColor),
        decoration: TextDecoration.underline,
      ),
      h1: heading(16),
      h2: heading(16),
      h3: heading(16),
      h4: heading(16),
      h5: heading(16),
      h6: heading(16),
      h1Padding: EdgeInsets.only(bottom: 8.h),
      h2Padding: EdgeInsets.only(top: 16.h, bottom: 4.h),
      h3Padding: EdgeInsets.only(top: 12.h, bottom: 4.h),
      pPadding: EdgeInsets.only(bottom: 8.h),
      blockSpacing: 10.h,
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      bottom: true,
      child: Scaffold(
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
                  Obx(() => Center(
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 48.w),
                          child: HeadingTextW600(
                            text: controller.title.value,
                            centerAlign: false,
                            size: 18.0.sp,
                          ),
                        ),
                      )),
                  GestureDetector(
                    onTap: () => Get.back(),
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

          if (controller.hasError.value) {
            return Center(
              child: Padding(
                padding: EdgeInsets.all(20.0.r),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Headingdescription(
                      text: Strings.somethingWentWrong(Get.context!),
                      centerAlign: true,
                      size: 14.sp,
                    ),
                    SizedBox(height: 12.h),
                    TextButton(
                      onPressed: controller.loadDocument,
                      child: Text(Strings.retryText(Get.context!)),
                    ),
                  ],
                ),
              ),
            );
          }

          return RefreshIndicator(
            color: const Color(MyColors.themeRedColor),
            onRefresh: controller.loadDocument,
            child: Markdown(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: EdgeInsets.all(16.0.r),
              data: controller.content.value,
              styleSheet: _styleSheet(context),
              // GitHub-flavored: autolinks emails/URLs, supports tables.
              extensionSet: md.ExtensionSet.gitHubFlavored,
              onTapLink: (text, href, title) => _openLink(href),
            ),
          );
        }),
      ),
    );
  }
}
