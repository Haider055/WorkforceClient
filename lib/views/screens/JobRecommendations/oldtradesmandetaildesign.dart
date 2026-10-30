// import 'package:auto_size_text/auto_size_text.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_rating_bar/flutter_rating_bar.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:flutter_svg/flutter_svg.dart';
// import 'package:get/get.dart';
// import 'package:intl/intl.dart';
// import 'package:photo_viewer/photo_viewer.dart';
// import 'package:workforceclientapp/Controllers/TradesmenDetailController.dart';
// import 'package:workforceclientapp/Models/Portfolio.dart';
// import 'package:workforceclientapp/Models/Reviews.dart';
// import 'package:workforceclientapp/Others/MyColors.dart';
// import 'package:workforceclientapp/Others/Strings.dart';
// import 'package:workforceclientapp/Others/routes.dart';
// import 'package:workforceclientapp/views/widgets/HeadingTextW500.dart';
// import 'package:workforceclientapp/views/widgets/HeadingTextW600.dart';
// import 'package:workforceclientapp/views/widgets/Headingdescription.dart';

// class TradesmenDetailScreen extends GetView<TradesmenDetailController> {
//   const TradesmenDetailScreen({super.key});

//   String _shortRating(String? rating) {
//     final r = rating ?? "0";
//     return r.length > 3 ? r.substring(0, 3) : r;
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//       appBar: AppBar(
//         leadingWidth: MediaQuery.of(context).size.width.w,
//         leading: Card(
//           color: const Color(MyColors.appbackgroundColor),
//           shadowColor: const Color.fromARGB(158, 219, 219, 219),
//           elevation: 2,
//           shape: const Border(
//               bottom: BorderSide(
//                   color: Color.fromARGB(147, 203, 203, 203),
//                   style: BorderStyle.solid)),
//           child: Center(
//             child: Stack(
//               children: [
//                 Center(
//                     child: HeadingTextW600(
//                   text: Strings.overview(context),
//                   centerAlign: false,
//                   size: 19.0.sp,
//                 )),
//                 GestureDetector(
//                   onTap: () {
//                     Get.back();
//                   },
//                   child: Padding(
//                     padding: EdgeInsets.only(left: 10.0.w),
//                     child: const Align(
//                         alignment: Alignment.centerLeft,
//                         child: Icon(Icons.arrow_back_ios)),
//                   ),
//                 ),
//                 // Right-side menu
//                 Positioned(
//                   right: 0,
//                   child: PopupMenuButton<String>(
//                     color: Colors.white,
//                     icon: const Icon(Icons.more_vert, color: Colors.black),
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(12.r),
//                     ),
//                     onSelected: (value) {
//                       if (value == "report") {
//                         Get.toNamed(
//                           AppLinks.report_screen,
//                           arguments: {
//                             'reportableType': "user",
//                             'reportableId': controller.tradesmenId.value,
//                           },
//                         );
//                       }
//                     },
//                     itemBuilder: (context) => [
//                       PopupMenuItem(
//                         value: "report",
//                         child: Row(
//                           children: [
//                             const Icon(Icons.flag_outlined,
//                                 size: 18, color: Colors.black87),
//                             const SizedBox(width: 8),
//                             Headingdescription(
//                                 text: Strings.reportText(Get.context!),
//                                 centerAlign: false,
//                                 size: 13),
//                           ],
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//       body: Obx(() {
//         // Fix 6: loading / error guards before touching controller.tradesmen!
//         if (controller.loading.value) {
//           return const Center(
//             child: CircularProgressIndicator(
//               color: Color(MyColors.themeRedColor),
//             ),
//           );
//         }
//         if (controller.tradesmen == null) {
//           return Center(
//             child: Padding(
//               padding: EdgeInsets.all(16.0.r),
//               child: Headingdescription(
//                   text: Strings.somethingWentWrong(context),
//                   centerAlign: true,
//                   size: 14.sp),
//             ),
//           );
//         }
//         return _buildContent(context);
//       }),
//     );
//   }

//   Widget _buildContent(BuildContext context) {
//     return SingleChildScrollView(
//       child: Column(
//         children: [
//           Padding(
//             padding: EdgeInsets.all(11.0.r),
//             child: Card(
//               shape: RoundedRectangleBorder(
//                   side:
//                       const BorderSide(color: Color(MyColors.cardGrayColor200)),
//                   borderRadius: BorderRadius.circular(12.r)),
//               elevation: 0,
//               color: const Color(MyColors.cardGrayColor100),
//               child: Padding(
//                 padding: EdgeInsets.all(10.0.r),
//                 child: Row(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     // Profile image
//                     Expanded(
//                       flex: 2,
//                       child: controller.tradesmen!.profileImg != null
//                           ? Card(
//                               elevation: 0,
//                               shape: RoundedRectangleBorder(
//                                   borderRadius: BorderRadius.circular(9.r)),
//                               child: ClipRRect(
//                                 borderRadius: BorderRadius.circular(9.r),
//                                 child: PhotoViewerImage(
//                                   imageUrl: controller.tradesmen!.profileImg!
//                                       .toString(),
//                                   errorWidget: (p0, p1, p2) {
//                                     return Center(
//                                         child: SvgPicture.asset(
//                                       "lib/assets/images/tradesmenplaceholdericon.svg",
//                                       fit: BoxFit.fill,
//                                       height: 20.h,
//                                       width: 20.w,
//                                     ));
//                                   },
//                                 ),
//                               ),
//                             )
//                           : SizedBox(
//                               height: MediaQuery.of(context).size.height.h / 8,
//                               // Fix 1: the placeholder is an SVG, so it needs
//                               // SvgPicture, not Image.asset.
//                               child: SvgPicture.asset(
//                                 "lib/assets/images/tradesmenplaceholdericon.svg",
//                                 fit: BoxFit.contain,
//                               ),
//                             ),
//                     ),
//                     SizedBox(width: 12.w),
//                     // Tradesman details
//                     Expanded(
//                       flex: 6,
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Text.rich(TextSpan(
//                             text: controller.tradesmen!.name ?? "N/A",
//                             style: TextStyle(
//                                 fontSize: 16.sp,
//                                 color: Colors.black,
//                                 fontWeight: FontWeight.w600),
//                             children: [
//                               WidgetSpan(
//                                 alignment: PlaceholderAlignment.middle,
//                                 child: Padding(
//                                   padding: EdgeInsets.only(left: 4.r),
//                                   child: (controller.tradesmen!.tradesmenProfile
//                                               ?.isVerified ??
//                                           false)
//                                       ? SvgPicture.asset(
//                                           "lib/assets/icons/verifiedIcon.svg",
//                                           height: 14.0.h,
//                                           width: 14.0.w)
//                                       : const SizedBox(),
//                                 ),
//                               ),
//                             ],
//                           )),
//                           SizedBox(height: 6.h),
//                           Row(
//                             children: [
//                               SvgPicture.asset("lib/assets/icons/thumbIcon.svg",
//                                   height: 16.h, width: 16.w),
//                               SizedBox(width: 10.w),
//                               Expanded(
//                                 child: Text.rich(
//                                   maxLines: 2,
//                                   TextSpan(
//                                     text: "${Strings.totalJobText(context)} ",
//                                     style: TextStyle(fontSize: 14.sp),
//                                     children: [
//                                       TextSpan(
//                                         text:
//                                             "${controller.tradesmen!.jobsCompleted ?? 0}",
//                                         style: const TextStyle(
//                                           fontWeight: FontWeight.w500,
//                                           color: Colors.black,
//                                         ),
//                                       ),
//                                     ],
//                                   ),
//                                 ),
//                               ),
//                             ],
//                           ),
//                           SizedBox(height: 6.h),
//                           Row(
//                             children: [
//                               SvgPicture.asset("lib/assets/icons/starIcon.svg",
//                                   height: 16.h, width: 13.w),
//                               SizedBox(width: 10.w),
//                               Text.rich(
//                                 TextSpan(
//                                   // Fix 3: null-safe rating
//                                   text:
//                                       "${_shortRating(controller.tradesmen!.rating)}/5",
//                                   style: TextStyle(
//                                     fontWeight: FontWeight.w500,
//                                     fontSize: 14.sp,
//                                   ),
//                                   children: [
//                                     TextSpan(
//                                       text:
//                                           " (${controller.tradesmen!.reviewsCount ?? 0} ${Strings.reviews(Get.context!)})",
//                                       style: TextStyle(
//                                           color: Colors.grey, fontSize: 14.sp),
//                                     ),
//                                   ],
//                                 ),
//                               ),
//                             ],
//                           ),
//                           SizedBox(height: 6.h),
//                           Row(
//                             children: [
//                               SvgPicture.asset(
//                                   "lib/assets/icons/locationIcon.svg",
//                                   height: 16.h,
//                                   width: 16.w),
//                               SizedBox(width: 12.w),
//                               Expanded(
//                                 child: Text.rich(
//                                   overflow: TextOverflow.ellipsis,
//                                   softWrap: true,
//                                   maxLines: 2,
//                                   TextSpan(
//                                     text: Strings.activeWithinText(context),
//                                     style: TextStyle(
//                                         fontSize: 14.sp, color: Colors.black),
//                                     children: [
//                                       controller.tradesmen!.serviceArea != null
//                                           ? TextSpan(
//                                               text:
//                                                   " ${controller.tradesmen?.serviceArea?.radius ?? 'N/A'} KM ${Strings.activeWithinOfText(Get.context!)} ${controller.tradesmen?.serviceArea?.city ?? 'N/A'}",
//                                               style: const TextStyle(
//                                                   color: Colors.black,
//                                                   fontWeight: FontWeight.w500),
//                                             )
//                                           : const TextSpan(
//                                               text: "N/A",
//                                               style: TextStyle(
//                                                   fontWeight: FontWeight.w500),
//                                             ),
//                                     ],
//                                   ),
//                                 ),
//                               ),
//                             ],
//                           ),
//                           SizedBox(height: 6.h),
//                           Row(
//                             children: [
//                               SvgPicture.asset(
//                                   "lib/assets/icons/member_since_icon.svg",
//                                   height: 16.h,
//                                   width: 16.w),
//                               SizedBox(width: 12.w),
//                               Expanded(
//                                 child: Text.rich(
//                                   overflow: TextOverflow.ellipsis,
//                                   softWrap: true,
//                                   maxLines: 1,
//                                   TextSpan(
//                                     text: Strings.memberSinceText(context),
//                                     style: TextStyle(fontSize: 14.sp),
//                                     children: [
//                                       controller.tradesmen!.memberSince != null
//                                           ? TextSpan(
//                                               text:
//                                                   " ${controller.tradesmen?.memberSince ?? 'N/A'}",
//                                               style: const TextStyle(
//                                                   fontWeight: FontWeight.w500),
//                                             )
//                                           : const TextSpan(
//                                               text: " N/A",
//                                               style: TextStyle(
//                                                   fontWeight: FontWeight.w500),
//                                             ),
//                                     ],
//                                   ),
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ],
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           ),
//           // Services card
//           Padding(
//             padding: EdgeInsets.only(left: 11.0.w, right: 11.0.w),
//             child: Row(
//               children: [
//                 Expanded(
//                   child: Card(
//                     shape: RoundedRectangleBorder(
//                         side: const BorderSide(
//                             color: Color(MyColors.cardGrayColor200)),
//                         borderRadius: BorderRadius.circular(12.r)),
//                     elevation: 0,
//                     color: const Color(MyColors.cardGrayColor100),
//                     child: Padding(
//                       padding: EdgeInsets.all(9.0.r),
//                       child: Column(
//                         children: [
//                           Padding(
//                             padding: EdgeInsets.only(top: 2.0.h),
//                             child: Row(
//                               mainAxisAlignment: MainAxisAlignment.center,
//                               children: [
//                                 Container(
//                                   width: 25.w,
//                                   height: 25.h,
//                                   decoration: BoxDecoration(
//                                     color: Colors.white,
//                                     shape: BoxShape.circle,
//                                     boxShadow: [
//                                       BoxShadow(
//                                         color: Colors.grey.withOpacity(0.3),
//                                         blurRadius: 1.r,
//                                         spreadRadius: 1.r,
//                                         offset: const Offset(0, 1),
//                                       ),
//                                     ],
//                                   ),
//                                   child: Center(
//                                     child: SvgPicture.asset(
//                                       "lib/assets/icons/workerIcon.svg",
//                                       height: 16.h,
//                                       width: 16.w,
//                                     ),
//                                   ),
//                                 ),
//                                 SizedBox(width: 5.w),
//                                 HeadingTextW500(
//                                     text: Strings.servicesText(context),
//                                     centerAlign: false,
//                                     size: 17.sp),
//                               ],
//                             ),
//                           ),
//                           SizedBox(height: 12.h),
//                           ListView.builder(
//                             shrinkWrap: true,
//                             physics: const NeverScrollableScrollPhysics(),
//                             itemCount: controller.professionsList.length,
//                             itemBuilder: (context, index) {
//                               final profession =
//                                   controller.professionsList.elementAt(index);
//                               return Container(
//                                 margin: EdgeInsets.only(bottom: 5.h),
//                                 padding: EdgeInsets.symmetric(
//                                     horizontal: 8.w, vertical: 6.h),
//                                 decoration: BoxDecoration(
//                                   color: Colors.white,
//                                   borderRadius: BorderRadius.circular(8.r),
//                                   border: Border.all(
//                                       color: const Color(
//                                           MyColors.cardGrayColor200)),
//                                   boxShadow: [
//                                     BoxShadow(
//                                       color:
//                                           Colors.black.withValues(alpha: 0.04),
//                                       blurRadius: 4.r,
//                                       offset: const Offset(0, 1),
//                                     ),
//                                   ],
//                                 ),
//                                 child: Row(
//                                   children: [
//                                     Container(
//                                       width: 28.r,
//                                       height: 28.r,
//                                       decoration: BoxDecoration(
//                                         color:
//                                             const Color(MyColors.themeRedColor)
//                                                 .withValues(alpha: 0.08),
//                                         borderRadius:
//                                             BorderRadius.circular(6.r),
//                                       ),
//                                       child: Center(
//                                         child: profession.icon?.url != null
//                                             ? SvgPicture.network(
//                                                 profession.icon!.url!,
//                                                 height: 16.r,
//                                                 width: 16.r,
//                                                 fit: BoxFit.contain)
//                                             : Icon(
//                                                 Icons.handyman_outlined,
//                                                 size: 15.r,
//                                                 color: const Color(
//                                                     MyColors.themeRedColor),
//                                               ),
//                                       ),
//                                     ),
//                                     SizedBox(width: 8.w),
//                                     Expanded(
//                                       child: Text(
//                                         profession.name ?? "N/A",
//                                         softWrap: true,
//                                         style: TextStyle(
//                                           color: Colors.black,
//                                           fontSize: 13.sp,
//                                           fontWeight: FontWeight.w500,
//                                           fontFamily: 'Poppins',
//                                         ),
//                                       ),
//                                     ),
//                                     SizedBox(width: 6.w),
//                                     Icon(
//                                       Icons.check_circle_rounded,
//                                       size: 14.r,
//                                       color:
//                                           const Color(MyColors.themeRedColor),
//                                     ),
//                                   ],
//                                 ),
//                               );
//                             },
//                           )
//                         ],
//                       ),
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//           // About card
//           Padding(
//             padding: EdgeInsets.all(11.0.r),
//             child: Card(
//               shape: RoundedRectangleBorder(
//                   side:
//                       const BorderSide(color: Color(MyColors.cardGrayColor200)),
//                   borderRadius: BorderRadius.circular(12.r)),
//               elevation: 0,
//               color: const Color(MyColors.cardGrayColor100),
//               child: Padding(
//                   padding: EdgeInsets.all(12.0.r),
//                   child: Column(
//                     children: [
//                       Padding(
//                         padding: EdgeInsets.all(8.0.r),
//                         child: Align(
//                           alignment: Alignment.topLeft,
//                           child: Row(
//                             children: [
//                               HeadingTextW500(
//                                   text: Strings.aboutText(context),
//                                   centerAlign: false,
//                                   size: 18.sp),
//                             ],
//                           ),
//                         ),
//                       ),
//                       Align(
//                         alignment: Alignment.topLeft,
//                         child: Padding(
//                           padding: EdgeInsets.only(
//                               left: 8.0.w, right: 8.0.w, bottom: 8.0.w),
//                           child: Headingdescription(
//                               text:
//                                   controller.tradesmen!.tradesmenProfile?.bio ??
//                                       "N/A",
//                               centerAlign: false,
//                               size: 14),
//                         ),
//                       )
//                     ],
//                   )),
//             ),
//           ),
//           // Portfolio / Reviews tabs
//           Padding(
//             padding: EdgeInsets.only(left: 11.0.w, right: 11.0.w),
//             child: Card(
//               shape: RoundedRectangleBorder(
//                   side:
//                       const BorderSide(color: Color(MyColors.cardGrayColor200)),
//                   borderRadius: BorderRadius.circular(12.r)),
//               elevation: 0,
//               color: const Color(MyColors.cardGrayColor100),
//               child: Padding(
//                   padding: EdgeInsets.all(5.0.r),
//                   child: Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: [
//                       Expanded(
//                         child: Padding(
//                           padding: EdgeInsets.only(left: 8.0.w, right: 8.0.w),
//                           child: SizedBox(
//                             width: MediaQuery.of(context).size.width,
//                             child: ElevatedButton(
//                               onPressed: () {
//                                 if (controller.selectedOption.value !=
//                                     "portfolio") {
//                                   controller.selectedOption.value = "portfolio";
//                                   controller.portfolioBackColor.value =
//                                       MyColors.themeRedColor;
//                                   controller.reviewsBackColor.value =
//                                       MyColors.silverColor;
//                                   controller.reviewsTextColor.value =
//                                       MyColors.darkGrayColor;
//                                   controller.portfolioTextColor.value =
//                                       MyColors.whiteColor;
//                                 }
//                               },
//                               style: ElevatedButton.styleFrom(
//                                 backgroundColor:
//                                     Color(controller.portfolioBackColor.value),
//                                 shape: RoundedRectangleBorder(
//                                   borderRadius: BorderRadius.circular(10.r),
//                                 ),
//                                 padding: EdgeInsets.symmetric(
//                                     vertical: 2.r, horizontal: 2.r),
//                               ),
//                               child: AutoSizeText(
//                                   maxFontSize: 14,
//                                   minFontSize: 9,
//                                   maxLines: 1,
//                                   Strings.portfolioText(context),
//                                   textAlign: TextAlign.center,
//                                   style: TextStyle(
//                                       color: Color(
//                                           controller.portfolioTextColor.value),
//                                       fontSize: 14,
//                                       fontWeight: FontWeight.w500,
//                                       fontFamily: 'Poppins')),
//                             ),
//                           ),
//                         ),
//                       ),
//                       Expanded(
//                         child: Padding(
//                           padding: EdgeInsets.only(left: 8.0.w, right: 8.0.w),
//                           child: SizedBox(
//                             width: MediaQuery.of(context).size.width,
//                             child: ElevatedButton(
//                               onPressed: () {
//                                 if (controller.selectedOption.value !=
//                                     "reviews") {
//                                   controller.selectedOption.value = "reviews";
//                                   controller.portfolioBackColor.value =
//                                       MyColors.silverColor;
//                                   controller.reviewsBackColor.value =
//                                       MyColors.themeRedColor;
//                                   controller.reviewsTextColor.value =
//                                       MyColors.whiteColor;
//                                   controller.portfolioTextColor.value =
//                                       MyColors.darkGrayColor;
//                                 }
//                                 if (controller.tradesmenReview == null) {
//                                   controller.loadingReviews.value = true;
//                                   controller.getTradesmenReviews(1);
//                                 }
//                               },
//                               style: ElevatedButton.styleFrom(
//                                 backgroundColor:
//                                     Color(controller.reviewsBackColor.value),
//                                 shape: RoundedRectangleBorder(
//                                   borderRadius: BorderRadius.circular(10.r),
//                                 ),
//                                 padding: EdgeInsets.symmetric(
//                                     vertical: 2.r, horizontal: 2.r),
//                               ),
//                               child: AutoSizeText(Strings.reviews(context),
//                                   maxFontSize: 14,
//                                   minFontSize: 9,
//                                   maxLines: 1,
//                                   textAlign: TextAlign.center,
//                                   style: TextStyle(
//                                       color: Color(
//                                           controller.reviewsTextColor.value),
//                                       fontSize: 14,
//                                       fontWeight: FontWeight.w500,
//                                       fontFamily: 'Poppins')),
//                             ),
//                           ),
//                         ),
//                       ),
//                     ],
//                   )),
//             ),
//           ),
//           controller.selectedOption.value == "portfolio"
//               ? _buildPortfolioSection(context)
//               : _buildReviewsSection(context),
//         ],
//       ),
//     );
//   }

//   Widget _buildPortfolioSection(BuildContext context) {
//     final portfolios = controller.portfolioList;
//     if (portfolios == null) {
//       return const Center(
//         child: CircularProgressIndicator(
//           color: Color(MyColors.themeRedColor),
//         ),
//       );
//     }
//     return Column(
//       children: [
//         Padding(
//           padding: EdgeInsets.only(top: 12.0.h, left: 22.w),
//           child: Align(
//             alignment: Alignment.topLeft,
//             child: HeadingTextW600(
//                 text:
//                     "${Strings.portfolios(context)} (${controller.totalPortfolio.value})",
//                 centerAlign: false,
//                 size: 14.sp),
//           ),
//         ),
//         portfolios.isNotEmpty
//             ? ListView.builder(
//                 shrinkWrap: true,
//                 physics: const NeverScrollableScrollPhysics(),
//                 itemCount: portfolios.length,
//                 itemBuilder: (context, index) {
//                   return _buildPortfolioView(portfolios[index]);
//                 },
//               )
//             : Center(
//                 child: Padding(
//                 padding: EdgeInsets.all(8.0.r),
//                 child: Headingdescription(
//                     text: Strings.noPortfolioFound(context),
//                     centerAlign: false,
//                     size: 14.0.sp),
//               )),
//       ],
//     );
//   }

//   Widget _buildReviewsSection(BuildContext context) {
//     return Obx(() => controller.loadingReviews.value
//         ? Center(
//             child: Padding(
//               padding: EdgeInsets.only(top: 16.0.h),
//               child: const CircularProgressIndicator(
//                 color: Color(MyColors.themeRedColor),
//               ),
//             ),
//           )
//         : Column(
//             children: [
//               Padding(
//                 padding: EdgeInsets.only(top: 12.0.h, left: 22.w),
//                 child: Align(
//                   alignment: Alignment.topLeft,
//                   child: HeadingTextW600(
//                       text:
//                           "${Strings.reviews(Get.context!)} (${controller.totalReviews.value})",
//                       centerAlign: false,
//                       size: 14.sp),
//                 ),
//               ),
//               Obx(() {
//                 // Fix 5: null-safe review list
//                 final reviews = controller.reviewList ?? [];
//                 return Column(
//                   children: [
//                     reviews.isNotEmpty
//                         ? ListView.builder(
//                             shrinkWrap: true,
//                             physics: const NeverScrollableScrollPhysics(),
//                             itemCount: reviews.length + 1,
//                             itemBuilder: (context, index) {
//                               return index + 1 == reviews.length + 1
//                                   ? controller.totalReviews.value >
//                                           reviews.length
//                                       ? _buildLoadMoreButton(context)
//                                       : const SizedBox()
//                                   : _buildReviewView(reviews[index]);
//                             },
//                           )
//                         : Center(
//                             child: Padding(
//                               padding: EdgeInsets.all(8.0.r),
//                               child: Headingdescription(
//                                 text: Strings.noReviewFound(context),
//                                 centerAlign: false,
//                                 size: 14.0.sp,
//                               ),
//                             ),
//                           ),
//                   ],
//                 );
//               })
//             ],
//           ));
//   }

//   Widget _buildPortfolioView(Portfolio portfolio) {
//     // Fix 4: null-safe image list
//     final images = portfolio.imageList ?? [];
//     return Padding(
//       padding: EdgeInsets.only(left: 11.0.w, right: 11.0.w, top: 7.0.h),
//       child: Card(
//         shape: RoundedRectangleBorder(
//             side: const BorderSide(color: Color(MyColors.cardGrayColor200)),
//             borderRadius: BorderRadius.circular(12.0.r)),
//         elevation: 0,
//         color: const Color(MyColors.cardGrayColor100),
//         child: Padding(
//             padding: EdgeInsets.all(5.0.r),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Padding(
//                   padding:
//                       EdgeInsets.only(left: 12.0.w, right: 12.0.w, top: 8.0.h),
//                   child: HeadingTextW500(
//                       text: portfolio.title ?? "N/A",
//                       centerAlign: false,
//                       size: 17.sp),
//                 ),
//                 Padding(
//                   padding:
//                       EdgeInsets.only(left: 12.0.w, right: 12.0.w, top: 4.0.h),
//                   child: Headingdescription(
//                       text: portfolio.desc ?? "N/A",
//                       centerAlign: false,
//                       size: 14.sp),
//                 ),
//                 Padding(
//                   padding:
//                       EdgeInsets.only(left: 12.0.w, top: 8.0.h, right: 8.0.w),
//                   child: SingleChildScrollView(
//                     scrollDirection: Axis.horizontal,
//                     child: Row(
//                       children: List.generate(images.length, (index) {
//                         return SizedBox(
//                           height: 80.h,
//                           width: 70.w,
//                           child: Card(
//                             shape: RoundedRectangleBorder(
//                                 borderRadius: BorderRadius.circular(10.r)),
//                             elevation: 1,
//                             child: ClipRRect(
//                                 borderRadius: BorderRadius.circular(10),
//                                 child: PhotoViewerImage(
//                                   imageUrl: images[index],
//                                   errorWidget: (p0, p1, p2) {
//                                     return Center(
//                                         child: SvgPicture.asset(
//                                       "lib/assets/images/tradesmenplaceholdericon.svg",
//                                       fit: BoxFit.fill,
//                                       height: 20.h,
//                                       width: 20.w,
//                                     ));
//                                   },
//                                 )),
//                           ),
//                         );
//                       }),
//                     ),
//                   ),
//                 ),
//               ],
//             )),
//       ),
//     );
//   }

//   Widget _buildReviewView(Reviews review) {
//     final city = review.userCity;
//     return Padding(
//       padding: EdgeInsets.only(left: 11.0.w, right: 11.0.w, top: 7.0.h),
//       child: Card(
//         shape: RoundedRectangleBorder(
//             side: const BorderSide(color: Color(MyColors.cardGrayColor200)),
//             borderRadius: BorderRadius.circular(12.r)),
//         elevation: 0,
//         color: const Color(MyColors.cardGrayColor100),
//         child: Padding(
//             padding: EdgeInsets.all(5.0.r),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Padding(
//                   padding: EdgeInsets.all(8.0.r),
//                   child: Row(
//                     children: [
//                       Headingdescription(
//                           text: review.userName ?? "N/A",
//                           centerAlign: false,
//                           size: 13.sp),
//                       // Fix 2: only show ", city" when a city exists
//                       if (city != null && city.isNotEmpty) ...[
//                         Headingdescription(
//                             text: ", ", centerAlign: false, size: 14.sp),
//                         Headingdescription(
//                             text: city, centerAlign: false, size: 13.sp),
//                       ],
//                     ],
//                   ),
//                 ),
//                 Padding(
//                   padding: EdgeInsets.only(left: 8.0.w, bottom: 4.0.h),
//                   child: Row(
//                     mainAxisAlignment: MainAxisAlignment.start,
//                     children: [
//                       review.rating != null
//                           ? RatingBar.builder(
//                               initialRating: review.rating!.toDouble(),
//                               minRating: 1,
//                               direction: Axis.horizontal,
//                               allowHalfRating: true,
//                               itemCount: 5,
//                               itemSize: 20,
//                               itemPadding:
//                                   EdgeInsets.symmetric(horizontal: 2.0.w),
//                               itemBuilder: (context, _) => const Icon(
//                                 Icons.star,
//                                 color: Color(MyColors.themeRedColor),
//                               ),
//                               onRatingUpdate: (rating) {},
//                             )
//                           : const SizedBox(),
//                       const SizedBox(width: 4),
//                       Text(formatDate(review.createdAt ?? "N/A"),
//                           textAlign: TextAlign.start,
//                           style: const TextStyle(
//                               color: Colors.grey,
//                               fontSize: 12,
//                               fontWeight: FontWeight.w500,
//                               fontFamily: 'Poppins')),
//                     ],
//                   ),
//                 ),
//                 Padding(
//                   padding: EdgeInsets.only(left: 12.0.w, right: 8.0.w),
//                   child: Text(review.title ?? "N/A",
//                       textAlign: TextAlign.start,
//                       style: TextStyle(
//                           color: Colors.black,
//                           fontSize: 16.sp,
//                           fontWeight: FontWeight.w500,
//                           fontFamily: 'Poppins')),
//                 ),
//                 Padding(
//                   padding:
//                       EdgeInsets.only(left: 8.0.w, right: 8.0.w, top: 3.0.h),
//                   child: Card(
//                     elevation: 0,
//                     color: const Color(MyColors.infoPinkColor).withOpacity(0.5),
//                     shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.only(
//                             bottomLeft: Radius.circular(8.r),
//                             bottomRight: Radius.circular(8.r),
//                             topRight: Radius.circular(8.r))),
//                     child: Padding(
//                       padding: EdgeInsets.all(4.0.w),
//                       child: Text(review.comment ?? "N/A",
//                           textAlign: TextAlign.start,
//                           style: const TextStyle(
//                               color: Colors.black,
//                               fontSize: 14,
//                               fontWeight: FontWeight.w400,
//                               fontFamily: 'Poppins')),
//                     ),
//                   ),
//                 ),
//               ],
//             )),
//       ),
//     );
//   }

//   static String formatDate(String? raw, {String pattern = 'd MMM, yyyy'}) {
//     if (raw == null || raw.trim().isEmpty) return "";

//     final parsed = DateTime.tryParse(raw.trim());
//     if (parsed == null) return raw;
//     final date = parsed.toLocal();

//     try {
//       return DateFormat(pattern, Get.locale?.toString()).format(date);
//     } catch (_) {
//       return DateFormat(pattern).format(date);
//     }
//   }

//   Widget _buildLoadMoreButton(BuildContext context) {
//     return Obx(() {
//       final loading = controller.loadMore.value;

//       return Padding(
//         padding: EdgeInsets.symmetric(vertical: 12.h),
//         child: Center(
//           child: SizedBox(
//             width: MediaQuery.of(context).size.width / 1.6,
//             height: 42.h,
//             child: ElevatedButton(
//               onPressed: loading ? null : () => _loadMoreReviews(),
//               style: ElevatedButton.styleFrom(
//                 elevation: 0,
//                 padding: EdgeInsets.zero,
//                 backgroundColor:
//                     const Color(MyColors.themeRedColor).withOpacity(0.07),
//                 disabledBackgroundColor:
//                     const Color(MyColors.themeRedColor).withOpacity(0.04),
//                 foregroundColor: const Color(MyColors.themeRedColor),
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(21.r),
//                   side: BorderSide(
//                     color:
//                         const Color(MyColors.themeRedColor).withOpacity(0.25),
//                   ),
//                 ),
//               ),
//               child: AnimatedSwitcher(
//                 duration: const Duration(milliseconds: 200),
//                 child: loading
//                     ? SizedBox(
//                         key: const ValueKey(''),
//                         width: 18.w,
//                         height: 18.w,
//                         child: const CircularProgressIndicator(
//                           strokeWidth: 2,
//                           color: Color(MyColors.themeRedColor),
//                         ),
//                       )
//                     : Row(
//                         key: const ValueKey('label'),
//                         mainAxisSize: MainAxisSize.min,
//                         mainAxisAlignment: MainAxisAlignment.center,
//                         children: [
//                           Text(
//                             Strings.loadMoreText(context),
//                             style: TextStyle(
//                               fontSize: 14.sp,
//                               fontWeight: FontWeight.w500,
//                               fontFamily: 'Poppins',
//                               color: const Color(MyColors.themeRedColor),
//                             ),
//                           ),
//                           SizedBox(width: 6.w),
//                           Icon(Icons.keyboard_arrow_down, size: 19.sp),
//                         ],
//                       ),
//               ),
//             ),
//           ),
//         ),
//       );
//     });
//   }

//   void _loadMoreReviews() {
//     try {
//       final pagination = controller.tradesmenReview?.pagination;
//       if (pagination == null || !(pagination.hasMore ?? false)) return;

//       final current = pagination.currentPage;
//       if (current == null) return; // was currentPage! — would throw

//       controller.loadMore.value = true;
//       controller.getTradesmenReviews(current + 1);
//     } catch (e) {
//       debugPrint('load more failed: $e');
//       controller.loadMore.value = false; // never leave it spinning forever
//     }
//   }
// }
