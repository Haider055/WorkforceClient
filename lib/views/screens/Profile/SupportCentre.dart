import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:workforceclientapp/Controllers/SupportCentreController.dart';
import 'package:workforceclientapp/Others/MyColors.dart';
import 'package:workforceclientapp/views/widgets/HeadingTextW600.dart';

class SupportCentre extends GetView<SupportCentreController> {
  const SupportCentre({super.key});

  Future<void> _launchEmail(String email) async {
    if (email.isEmpty) return;
    final uri = Uri(
      scheme: 'mailto',
      path: email,
      queryParameters: {'subject': 'Support Request'},
    );
    if (!await launchUrl(uri)) {
      Get.snackbar('Error', 'Could not open email app');
    }
  }

  // Future<void> _launchPhone(String phone) async {
  //   if (phone.isEmpty) return;
  //   final uri = Uri(scheme: 'tel', path: phone);
  //   if (!await launchUrl(uri)) {
  //     Get.snackbar('Error', 'Could not open dialer');
  //   }
  // }

  // Future<void> _launchWhatsApp(String phone) async {
  //   if (phone.isEmpty) return;
  //   // Strip spaces, dashes, parentheses and leading '+' for the wa.me link
  //   final cleaned = phone.replaceAll(RegExp(r'[^\d]'), '');
  //   final uri = Uri.parse('https://wa.me/$cleaned');
  //   if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
  //     Get.snackbar('Error', 'Could not open WhatsApp');
  //   }
  // }

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
                  Center(
                      child: HeadingTextW600(
                    text: "Support Centre",
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
        body: Padding(
          padding: EdgeInsets.all(16.0.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              HeadingTextW600(
                text: "Need help? Reach out to us",
                centerAlign: false,
                size: 16.sp,
              ),
              SizedBox(height: 4.h),
              Text(
                "We're available to answer your questions and support you.",
                style: TextStyle(fontSize: 13.sp, color: Colors.grey[600]),
              ),
              SizedBox(height: 20.h),
              Obx(() {
                if (controller.isLoading.value) {
                  return const Padding(
                    padding: EdgeInsets.only(top: 40),
                    child: Center(child: CircularProgressIndicator()),
                  );
                }
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _ContactTile(
                      icon: Icons.email_outlined,
                      iconColor: Colors.blueAccent,
                      title: "Email us",
                      subtitle: controller.supportEmail.value,
                      onTap: () => _launchEmail(controller.supportEmail.value),
                    ),
                    SizedBox(height: 12.h),
                    // _ContactTile(
                    //   icon: Icons.call_outlined,
                    //   iconColor: Colors.green,
                    //   title: "Call us",
                    //   subtitle: controller.supportPhone.value,
                    //   onTap: () => _launchPhone(controller.supportPhone.value),
                    // ),
                    // SizedBox(height: 12.h),
                    // _ContactTile(
                    //   icon: Icons.chat_bubble_outline,
                    //   iconColor: const Color(0xFF25D366), // WhatsApp green
                    //   title: "WhatsApp us",
                    //   subtitle: controller.supportWhatsApp.value,
                    //   onTap: () =>
                    //       _launchWhatsApp(controller.supportWhatsApp.value),
                    // ),
                    // SizedBox(height: 12.h),
                    // _ContactTile(
                    //   icon: Icons.home,
                    //   iconColor: const Color(0xFF25D366), // WhatsApp green
                    //   title: "Address",
                    //   subtitle: controller.supportAddress.value,
                    //   onTap: () {},
                    // ),
                  ],
                );
              }),
            ],
          ),
        ),
      ),
    );
  }
}

class _ContactTile extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const _ContactTile({
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(12.r),
      child: InkWell(
        borderRadius: BorderRadius.circular(12.r),
        onTap: onTap,
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 14.h),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12.r),
            border: Border.all(color: const Color.fromARGB(147, 203, 203, 203)),
          ),
          child: Row(
            children: [
              Container(
                padding: EdgeInsets.all(10.w),
                decoration: BoxDecoration(
                  color: iconColor.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, color: iconColor, size: 22),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(height: 2.h),
                    Text(
                      subtitle,
                      style: TextStyle(
                        fontSize: 12.5.sp,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),
              Icon(Icons.arrow_forward_ios, size: 14, color: Colors.grey[400]),
            ],
          ),
        ),
      ),
    );
  }
}
