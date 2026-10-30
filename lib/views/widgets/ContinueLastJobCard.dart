import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:workforceclientapp/Others/MyColors.dart';
import 'package:workforceclientapp/Others/Strings.dart';
import 'package:workforceclientapp/views/screens/ClientJobPosting/JobDraft.dart';

/// Home screen prompt for a job posting the user left half-way through.
/// Shows nothing when there is no draft.
class ContinueLastJobCard extends StatefulWidget {
  const ContinueLastJobCard({super.key});

  @override
  State<ContinueLastJobCard> createState() => _ContinueLastJobCardState();
}

class _ContinueLastJobCardState extends State<ContinueLastJobCard> {
  @override
  void initState() {
    super.initState();
    JobDraftService.load();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final draft = JobDraftService.current.value;
      if (draft == null) return const SizedBox();

      return Padding(
        padding: EdgeInsets.only(left: 15.0.w, right: 15.0.w, top: 8.0.h),
        child: Card(
          elevation: 0,
          color: Colors.red.shade50,
          child: Stack(
            children: [
              Padding(
                padding: EdgeInsets.all(12.0.r),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          width: 34.w,
                          height: 34.h,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withValues(alpha: 0.3),
                                blurRadius: 5,
                                spreadRadius: 2,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: const Center(
                              child: Icon(Icons.edit_note,
                                  color: Color(MyColors.themeRedColor),
                                  size: 24)),
                        ),
                        SizedBox(width: 10.0.r),
                        Expanded(
                          // Keeps a long service name clear of the X above.
                          child: Padding(
                            padding: EdgeInsets.only(right: 20.w),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                AutoSizeText(
                                  Strings.unFinishedJobText(
                                      context), //Unfinished job,
                                  maxFontSize: 15,
                                  minFontSize: 9,
                                  maxLines: 1,
                                  style: const TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w600,
                                      fontFamily: 'Poppins'),
                                ),
                                AutoSizeText(
                                  "${draft.serviceName} · ${Strings.step(context)} ${draft.step}/${draft.totalSteps}",
                                  maxFontSize: 14,
                                  minFontSize: 9,
                                  maxLines: 2,
                                  style: const TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w400,
                                      fontFamily: 'Poppins'),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 12.h),
                    Row(
                      children: [
                        Expanded(
                          child: SizedBox(
                            width: MediaQuery.of(context).size.width,
                            height: 36.h,
                            child: TextButton(
                              onPressed: () {
                                JobDraftService.restart(draft);
                              },
                              style: ButtonStyle(
                                backgroundColor: WidgetStateProperty.all<Color>(
                                    Colors.red.shade50),
                                side: WidgetStateProperty.all(
                                  BorderSide(
                                    color: const Color(MyColors.themeRedColor),
                                    width: 1.2.w,
                                  ),
                                ),
                                shape: WidgetStateProperty.all(
                                  RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10.r),
                                  ),
                                ),
                              ),
                              child: AutoSizeText(
                                Strings.restartText(context),
                                maxLines: 1,
                                minFontSize: 8,
                                maxFontSize: 14,
                                textAlign: TextAlign.center,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  color: Colors.black,
                                  fontSize: 14,
                                  fontFamily: 'Poppins',
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: 12.w),
                        Expanded(
                          child: SizedBox(
                              width: MediaQuery.of(context).size.width,
                              height: 36.h,
                              child: TextButton(
                                onPressed: () {
                                  JobDraftService.resume(draft);
                                },
                                style: ButtonStyle(
                                    backgroundColor: WidgetStateProperty.all<
                                            Color>(
                                        const Color(MyColors.themeRedColor)),
                                    shape: WidgetStateProperty.all(
                                        RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(10.r)))),
                                child: AutoSizeText(
                                  Strings.continueText(context),
                                  maxLines: 1,
                                  minFontSize: 8,
                                  maxFontSize: 14,
                                  textAlign: TextAlign.center,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 14,
                                      fontFamily: 'Poppins',
                                      fontWeight: FontWeight.w500),
                                ),
                              )),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // Top-right dismiss. Padding rather than a bare icon so the
              // 18px glyph still gets a ~34px tap target.
              Positioned(
                top: 0,
                right: 0,
                child: GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: () {
                    JobDraftService.clear();
                  },
                  child: Padding(
                    padding: EdgeInsets.all(8.r),
                    child: Icon(
                      Icons.close,
                      size: 18.sp,
                      color: const Color(MyColors.midGrayColor),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    });
  }
}
