import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:workforceclientapp/Controllers/EulaController.dart';
import 'package:workforceclientapp/Others/MyColors.dart';
import 'package:workforceclientapp/Others/Strings.dart';
import 'package:workforceclientapp/views/widgets/FullWidthButtonPrimary.dart';

class EulaScreen extends GetView<EulaController> {
  const EulaScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        // Block system back — user must explicitly Agree or Cancel.
      },
      child: Scaffold(
        backgroundColor: const Color(MyColors.cardGrayColor100),
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: const Color(MyColors.cardGrayColor100),
          elevation: 0.5,
          shadowColor: const Color.fromARGB(158, 219, 219, 219),
          shape: const Border(
              bottom: BorderSide(
                  color: Color.fromARGB(147, 203, 203, 203),
                  style: BorderStyle.solid)),
          centerTitle: true,
          title: AutoSizeText(
            Strings.eulaHeading(context),
            maxLines: 2,
            textAlign: TextAlign.center,
            minFontSize: 9,
            maxFontSize: 18,
            overflow: TextOverflow.visible,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
          ),
        ),
        body: SafeArea(
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  padding: EdgeInsets.all(16.0.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildAgreementContent(context),
                    ],
                  ),
                ),
              ),
              Obx(() {
                return Padding(
                  padding: EdgeInsets.only(
                    left: 16.0.w,
                    right: 16.0.w,
                    bottom: 12.0.h,
                    top: 8.0.h,
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: controller.isAccepting.value
                            ? const Center(
                                child: CircularProgressIndicator(
                                  color: Color(MyColors.themeRedColor),
                                ),
                              )
                            : FullWidthButtonPrimary(
                                text: Strings.agreeText(context),
                                fontsize: 15.0,
                                color: MyColors.themeRedColor,
                                onPressed: controller.isLoading.value ||
                                        controller.agreementText.value
                                            .trim()
                                            .isEmpty ||
                                        controller.errorMessage.value.isNotEmpty
                                    ? () {}
                                    : () {
                                        controller.agreeToEula();
                                      },
                              ),
                      ),
                    ],
                  ),
                );
              }),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAgreementContent(BuildContext context) {
    return Obx(() {
      if (controller.isLoading.value) {
        return const Center(
          child: Padding(
            padding: EdgeInsets.all(32),
            child: CircularProgressIndicator(
              color: Color(MyColors.themeRedColor),
            ),
          ),
        );
      }

      if (controller.errorMessage.value.isNotEmpty) {
        return Center(
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 32.h),
            child: Column(
              children: [
                const Icon(
                  Icons.error_outline,
                  color: Color(MyColors.themeRedColor),
                  size: 40,
                ),
                SizedBox(height: 12.h),
                Text(
                  controller.errorMessage.value,
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 16.h),
                ElevatedButton(
                  onPressed: controller.fetchEula,
                  child: Text(Strings.retryText(Get.context!)),
                ),
              ],
            ),
          ),
        );
      }

      // Was SelectableText, which printed the raw "##", "**" and "-"
      // markers as literal characters. Same source string, rendered.
      return MarkdownBody(
        data: controller.agreementText.value,
        selectable: true,
        // The parent SingleChildScrollView does the scrolling.
        shrinkWrap: true,
        styleSheet: _markdownStyle(context),
        onTapLink: (text, href, title) => _openLink(href),
      );
    });
  }

  MarkdownStyleSheet _markdownStyle(BuildContext context) {
    final body = TextStyle(
      fontSize: 14.sp,
      height: 1.6,
      color: Colors.black87,
      fontFamily: 'Poppins',
      fontWeight: FontWeight.w400,
    );

    TextStyle heading(double size) => TextStyle(
          fontSize: size.sp,
          height: 1.35,
          color: const Color(MyColors.themeRedColor),
          fontFamily: 'Poppins',
          fontWeight: FontWeight.w600,
        );

    return MarkdownStyleSheet(
      p: body,
      pPadding: EdgeInsets.only(bottom: 10.h),
      h1: heading(20),
      h1Padding: EdgeInsets.only(top: 18.h, bottom: 6.h),
      h2: heading(17),
      h2Padding: EdgeInsets.only(top: 16.h, bottom: 6.h),
      h3: heading(15.5),
      h3Padding: EdgeInsets.only(top: 14.h, bottom: 4.h),
      h4: heading(14.5),
      h5: heading(14),
      h6: heading(13.5),
      strong: body.copyWith(fontWeight: FontWeight.w600, color: Colors.black),
      em: body.copyWith(fontStyle: FontStyle.italic),
      a: body.copyWith(
        color: const Color(MyColors.themeRedColor),
        decoration: TextDecoration.underline,
        decorationColor: const Color(MyColors.themeRedColor),
      ),
      listBullet: body,
      listIndent: 18.w,
      listBulletPadding: EdgeInsets.only(right: 6.w),
      blockquote: body.copyWith(color: const Color(MyColors.darkGrayColor)),
      blockquotePadding: EdgeInsets.all(12.r),
      blockquoteDecoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8.r),
        border: Border(
          left: BorderSide(
            color: const Color(MyColors.themeRedColor),
            width: 3.w,
          ),
        ),
      ),
      code: TextStyle(
        fontSize: 13.sp,
        fontFamily: 'monospace',
        color: Colors.black87,
        backgroundColor: Colors.white,
      ),
      codeblockPadding: EdgeInsets.all(12.r),
      codeblockDecoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8.r),
      ),
      horizontalRuleDecoration: BoxDecoration(
        border: Border(
          top: BorderSide(
            width: 1.h,
            color: const Color(MyColors.lightSilverColor),
          ),
        ),
      ),
      tableHead: body.copyWith(fontWeight: FontWeight.w600),
      tableBody: body,
      tableBorder: TableBorder.all(
        color: const Color(MyColors.lightSilverColor),
        width: 1,
      ),
      tableCellsPadding: EdgeInsets.all(6.r),
      blockSpacing: 8.h,
    );
  }

  Future<void> _openLink(String? href) async {
    if (href == null || href.trim().isEmpty) return;
    final uri = Uri.tryParse(href.trim());
    if (uri == null) return;

    try {
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      }
    } catch (e) {
      debugPrint('could not open $href: $e');
    }
  }
}
