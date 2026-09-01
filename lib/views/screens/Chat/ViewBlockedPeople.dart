import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:workforceclientapp/Controllers/BlockPeopleController.dart';
import 'package:workforceclientapp/Models/BlockedUser.dart';
import 'package:workforceclientapp/Others/MyColors.dart';
import 'package:workforceclientapp/Others/Strings.dart';
import 'package:workforceclientapp/views/widgets/HeadingTextW600.dart';
import 'package:workforceclientapp/views/widgets/Headingdescription.dart';

class ViewBlockedPeople extends GetView<BlockPeopleController> {
  const ViewBlockedPeople({super.key});

  void _showUnblockDialog(BuildContext context, BlockedChat blocked) {
    Get.dialog(
      Dialog(
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(14.r)),
        insetPadding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 24.h),
        child: Padding(
          padding: EdgeInsets.all(18.0.r),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "${Strings.unblockText(context)} ${blocked.user?.name ?? {
                      Strings.userText(context)
                    }}?",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w600,
                  fontFamily: 'Poppins',
                ),
              ),
              SizedBox(height: 8.h),
              Text(
                Strings.unBlockMsg(context),
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 13.sp,
                  color: Colors.grey[600],
                  fontFamily: 'Poppins',
                ),
              ),
              SizedBox(height: 20.h),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.r),
                        ),
                        padding: EdgeInsets.symmetric(vertical: 12.h),
                      ),
                      onPressed: () => Get.back(),
                      child: Text(
                        Strings.cancelText(context),
                        style: TextStyle(fontSize: 14.sp),
                      ),
                    ),
                  ),
                  SizedBox(width: 12.w),
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(MyColors.themeRedColor),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.r),
                        ),
                        padding: EdgeInsets.symmetric(vertical: 12.h),
                      ),
                      onPressed: () async {
                        Get.back();
                        await controller.unblockAndRemove(context, blocked);
                      },
                      child: Text(
                        Strings.unblockText(context),
                        style: TextStyle(fontSize: 14.sp, color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      barrierDismissible: true,
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      bottom: true,
      child: Scaffold(
        backgroundColor: const Color(MyColors.whiteColor),
        appBar: AppBar(
          leadingWidth: MediaQuery.of(context).size.width.w,
          leading: Card(
            color: const Color(MyColors.whiteColor),
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
                    text: Strings.blockusersText(context),
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

          if (controller.blockedList.isEmpty) {
            return Center(
              child: Padding(
                padding: EdgeInsets.all(20.0.r),
                child: Headingdescription(
                  text: Strings.youhavenotblockeduser(context),
                  centerAlign: true,
                  size: 14.sp,
                ),
              ),
            );
          }

          final bool hasMore = controller.pagination?.hasMore ?? false;

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding:
                    EdgeInsets.only(left: 15.0.w, top: 5.0.h, right: 15.0.w),
                child: Headingdescription(
                    text:
                        "${Strings.noteText(context)}: ${Strings.blocktradesmanwouldnotbeableto(context)}.",
                    centerAlign: false,
                    size: 12.5.r),
              ),
              Padding(
                padding:
                    EdgeInsets.only(left: 15.0.w, top: 5.0.h, right: 15.0.w),
                child: Headingdescription(
                    text: Strings.taptounblock(context),
                    centerAlign: false,
                    size: 12.5.r),
              ),
              Expanded(
                child: ListView.builder(
                  padding: EdgeInsets.symmetric(vertical: 12.h),
                  itemCount: controller.blockedList.length + (hasMore ? 1 : 0),
                  itemBuilder: (context, index) {
                    if (index == controller.blockedList.length) {
                      return Center(
                        child: Padding(
                          padding: EdgeInsets.all(12.0.r),
                          child: controller.isLoadingMore.value
                              ? const CircularProgressIndicator(
                                  color: Color(MyColors.themeRedColor),
                                )
                              : TextButton(
                                  onPressed: () {
                                    controller.loadMore();
                                  },
                                  child: Text(Strings.loadMoreText(context)),
                                ),
                        ),
                      );
                    }

                    final blocked = controller.blockedList[index];
                    return GestureDetector(
                      onTap: () {
                        _showUnblockDialog(
                            context, controller.blockedList.elementAt(index));
                      },
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: 14.0.w, vertical: 6.0.h),
                        child: Card(
                          elevation: 0,
                          color: const Color(MyColors.cardGrayColor100),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.r),
                          ),
                          child: Padding(
                            padding: EdgeInsets.all(10.0.r),
                            child: Row(
                              children: [
                                CircleAvatar(
                                  radius: 24.r,
                                  backgroundImage: blocked.user?.profileImg !=
                                          null
                                      ? NetworkImage(blocked.user!.profileImg!)
                                      : null,
                                  child: blocked.user?.profileImg == null
                                      ? const Icon(Icons.person)
                                      : null,
                                ),
                                SizedBox(width: 12.w),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        blocked.user?.name ?? "N/A",
                                        style: TextStyle(
                                          fontSize: 15.sp,
                                          fontWeight: FontWeight.w600,
                                          fontFamily: 'Poppins',
                                        ),
                                      ),
                                      SizedBox(height: 2.h),
                                      Text(
                                        "${Strings.blockedonText(context)} ${blocked.blockedAt ?? "N/A"}",
                                        style: TextStyle(
                                          fontSize: 12.sp,
                                          color: Colors.grey[600],
                                          fontFamily: 'Poppins',
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              )
            ],
          );
        }),
      ),
    );
  }
}
