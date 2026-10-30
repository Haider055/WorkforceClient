import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:photo_viewer/photo_viewer.dart';
import 'package:workforceclientapp/Controllers/TradesmenDetailController.dart';
import 'package:workforceclientapp/Models/Portfolio.dart';
import 'package:workforceclientapp/Models/Reviews.dart';
import 'package:workforceclientapp/Others/MyColors.dart';
import 'package:workforceclientapp/Others/Strings.dart';
import 'package:workforceclientapp/Others/routes.dart';
import 'package:workforceclientapp/views/widgets/Headingdescription.dart';

class TradesmenDetailScreen extends GetView<TradesmenDetailController> {
  const TradesmenDetailScreen({super.key});

  // ---------------------------------------------------------- design tokens
  // One place for the surface colours so every card on the screen matches.
  static const Color _red = Color(MyColors.themeRedColor);
  static const Color _surface = Colors.white;
  static const Color _canvas = Color(0xFFF6F6F8); // page background
  static const Color _border = Color(0xFFEDEDEF); // hairline card border
  static const Color _muted = Color(0xFF8A8A8E); // secondary labels
  static const Color _body = Color(MyColors.darkGrayColor);

  String _shortRating(String? rating) {
    final r = rating ?? "0";
    return r.length > 3 ? r.substring(0, 3) : r;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _canvas,
      // Was a Card stuffed into `leading` with leadingWidth set to the full
      // screen width. A plain AppBar gives the same look, centres the title
      // properly and keeps the back button / menu hit areas correct.
      appBar: AppBar(
        backgroundColor: _surface,
        surfaceTintColor: _surface,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: true,
        shape: const Border(bottom: BorderSide(color: _border)),
        leading: IconButton(
          icon:
              Icon(Icons.arrow_back_ios_new, size: 18.sp, color: Colors.black),
          onPressed: Get.back,
        ),
        title: Text(
          Strings.overview(context),
          style: TextStyle(
            fontSize: 17.sp,
            fontWeight: FontWeight.w600,
            fontFamily: 'Poppins',
            color: Colors.black,
          ),
        ),
        actions: [
          PopupMenuButton<String>(
            color: Colors.white,
            icon: const Icon(Icons.more_vert, color: Colors.black),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12.r),
            ),
            onSelected: (value) {
              if (value == "report") {
                Get.toNamed(
                  AppLinks.report_screen,
                  arguments: {
                    'reportableType': "user",
                    'reportableId': controller.tradesmenId.value,
                  },
                );
              }
            },
            itemBuilder: (context) => [
              PopupMenuItem(
                value: "report",
                child: Row(
                  children: [
                    Icon(Icons.flag_outlined,
                        size: 17.r, color: Colors.black87),
                    SizedBox(width: 8.w),
                    Headingdescription(
                      text: Strings.reportText(Get.context!),
                      centerAlign: false,
                      size: 13,
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(width: 4.w),
        ],
      ),
      body: Obx(() {
        if (controller.loading.value) {
          return const Center(child: CircularProgressIndicator(color: _red));
        }
        if (controller.tradesmen == null) {
          return Center(
            child: Padding(
              padding: EdgeInsets.all(16.0.r),
              child: Headingdescription(
                text: Strings.somethingWentWrong(context),
                centerAlign: true,
                size: 14.sp,
              ),
            ),
          );
        }
        return _buildContent(context);
      }),
    );
  }

  Widget _buildContent(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.only(bottom: 28.h),
      child: Column(
        children: [
          _profileHeader(context),
          SizedBox(height: 12.h),
          _servicesSection(context),
          SizedBox(height: 12.h),
          _aboutSection(context),
          SizedBox(height: 16.h),
          _segmentedTabs(context),
          controller.selectedOption.value == "portfolio"
              ? _buildPortfolioSection(context)
              : _buildReviewsSection(context),
        ],
      ),
    );
  }

  // ------------------------------------------------------------------ header

  Widget _profileHeader(BuildContext context) {
    final t = controller.tradesmen!;
    final verified = t.tradesmenProfile?.isVerified ?? false;

    return Container(
      width: double.infinity,
      color: _surface,
      padding: EdgeInsets.fromLTRB(20.w, 20.h, 20.w, 18.h),
      child: Column(
        children: [
          // --- avatar -------------------------------------------------------
          Container(
            width: 92.r,
            height: 92.r,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: _border, width: 2),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.07),
                  blurRadius: 14,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: ClipOval(
              child: t.profileImg != null
                  ? PhotoViewerImage(
                      imageUrl: t.profileImg!.toString(),
                      errorWidget: (p0, p1, p2) => _avatarFallback(),
                    )
                  : _avatarFallback(),
            ),
          ),
          SizedBox(height: 12.h),

          // --- name + verified ---------------------------------------------
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Flexible(
                child: Text(
                  t.name ?? "N/A",
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 20.sp,
                    fontWeight: FontWeight.w700,
                    fontFamily: 'Poppins',
                    color: Colors.black,
                    height: 1.2,
                  ),
                ),
              ),
              if (verified) ...[
                SizedBox(width: 6.w),
                SvgPicture.asset(
                  "lib/assets/icons/verifiedIcon.svg",
                  height: 17.0.h,
                  width: 17.0.w,
                ),
              ],
            ],
          ),
          SizedBox(height: 8.h),

          // --- rating pill ---------------------------------------------------
          Container(
            padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
            decoration: BoxDecoration(
              color: _red.withValues(alpha: 0.07),
              borderRadius: BorderRadius.circular(30.r),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                SvgPicture.asset(
                  "lib/assets/icons/starIcon.svg",
                  height: 14.r,
                  width: 14.r,
                ),
                SizedBox(width: 6.w),
                Text(
                  "${_shortRating(t.rating)}/5",
                  style: TextStyle(
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w700,
                    fontFamily: 'Poppins',
                    color: Colors.black,
                  ),
                ),
                SizedBox(width: 4.w),
                Text(
                  "(${t.reviewsCount ?? 0} ${Strings.reviews(context)})",
                  style: TextStyle(
                    fontSize: 12.sp,
                    fontFamily: 'Poppins',
                    color: _body,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 16.h),

          // --- stat tiles ----------------------------------------------------
          Row(
            children: [
              Expanded(
                child: _statTile(
                  iconAsset: "lib/assets/icons/thumbIcon.svg",
                  value: "${t.jobsCompleted ?? 0}",
                  label: Strings.totalJobText(context),
                ),
              ),
              SizedBox(width: 10.w),
              Expanded(
                child: _statTile(
                  iconAsset: null,
                  fallbackIcon: Icons.chat_bubble_outline_rounded,
                  value: "${t.reviewsCount ?? 0}",
                  label: Strings.reviews(context),
                ),
              ),
            ],
          ),
          SizedBox(height: 16.h),

          // --- quiet meta rows -----------------------------------------------
          _metaRow(
            iconAsset: "lib/assets/icons/locationIcon.svg",
            text: t.serviceArea != null
                ? "${Strings.activeWithinText(context)} ${t.serviceArea?.radius ?? 'N/A'} KM ${Strings.activeWithinOfText(context)} ${t.serviceArea?.city ?? 'N/A'}"
                : "${Strings.activeWithinText(context)} N/A",
          ),
          SizedBox(height: 7.h),
          _metaRow(
            iconAsset: "lib/assets/icons/member_since_icon.svg",
            text:
                "${Strings.memberSinceText(context)} ${t.memberSince ?? 'N/A'}",
          ),
        ],
      ),
    );
  }

  Widget _avatarFallback() {
    return Container(
      color: _canvas,
      child: Center(
        child: SvgPicture.asset(
          "lib/assets/images/tradesmenplaceholdericon.svg",
          fit: BoxFit.contain,
          height: 44.r,
          width: 44.r,
        ),
      ),
    );
  }

  Widget _statTile({
    required String? iconAsset,
    IconData? fallbackIcon,
    required String value,
    required String label,
  }) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 6.w),
      decoration: BoxDecoration(
        color: _canvas,
        borderRadius: BorderRadius.circular(14.r),
        border: Border.all(color: _border),
      ),
      child: Column(
        children: [
          iconAsset != null
              ? SvgPicture.asset(iconAsset, height: 16.r, width: 16.r)
              : Icon(fallbackIcon, size: 16.r, color: _red),
          SizedBox(height: 6.h),
          AutoSizeText(
            value,
            maxLines: 1,
            minFontSize: 11,
            style: TextStyle(
              fontSize: 17.sp,
              fontWeight: FontWeight.w700,
              fontFamily: 'Poppins',
              color: Colors.black,
              height: 1.1,
            ),
          ),
          SizedBox(height: 2.h),
          AutoSizeText(
            label,
            maxLines: 1,
            minFontSize: 8,
            style: TextStyle(
              fontSize: 11.5.sp,
              fontFamily: 'Poppins',
              color: _muted,
            ),
          ),
        ],
      ),
    );
  }

  Widget _metaRow({required String iconAsset, required String text}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Padding(
          padding: EdgeInsets.only(top: 2.5.h),
          child: SvgPicture.asset(iconAsset, height: 14.h, width: 14.w),
        ),
        SizedBox(width: 7.w),
        Flexible(
          child: Text(
            text,
            textAlign: TextAlign.center,
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 12.5.sp,
              fontFamily: 'Poppins',
              color: _body,
              height: 1.35,
            ),
          ),
        ),
      ],
    );
  }

  // ---------------------------------------------------------------- sections

  Widget _sectionShell({required Widget child}) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 14.w),
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: _surface,
          borderRadius: BorderRadius.circular(16.r),
          border: Border.all(color: _border),
        ),
        padding: EdgeInsets.fromLTRB(16.w, 14.h, 16.w, 16.h),
        child: child,
      ),
    );
  }

  Widget _sectionTitle(String text, {String? iconAsset, IconData? icon}) {
    return Row(
      children: [
        if (iconAsset != null)
          SvgPicture.asset(iconAsset, height: 17.r, width: 17.r)
        else if (icon != null)
          Icon(icon, size: 17.r, color: _red),
        SizedBox(width: 8.w),
        Text(
          text,
          style: TextStyle(
            fontSize: 15.5.sp,
            fontWeight: FontWeight.w600,
            fontFamily: 'Poppins',
            color: Colors.black,
          ),
        ),
      ],
    );
  }

  Widget _servicesSection(BuildContext context) {
    final professions = controller.professionsList;

    return _sectionShell(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _sectionTitle(
            Strings.servicesText(context),
            iconAsset: "lib/assets/icons/workerIcon.svg",
          ),
          SizedBox(height: 12.h),
          if (professions.isEmpty)
            Text(
              "N/A",
              style: TextStyle(
                fontSize: 13.sp,
                color: _muted,
                fontFamily: 'Poppins',
              ),
            )
          else
            // Chips that wrap, instead of one full-width bordered row per
            // service — a tradesman with six trades no longer pushes the
            // tabs off the first screen.
            Wrap(
              spacing: 8.w,
              runSpacing: 8.h,
              children: professions.map((profession) {
                return Container(
                  padding: EdgeInsets.fromLTRB(7.w, 6.h, 12.w, 6.h),
                  decoration: BoxDecoration(
                    color: _red.withValues(alpha: 0.055),
                    borderRadius: BorderRadius.circular(30.r),
                    border: Border.all(color: _red.withValues(alpha: 0.16)),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 24.r,
                        height: 24.r,
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                        ),
                        child: Center(
                          child: profession.icon?.url != null
                              ? SvgPicture.network(
                                  profession.icon!.url!,
                                  height: 14.r,
                                  width: 14.r,
                                  fit: BoxFit.contain,
                                )
                              : Icon(
                                  Icons.handyman_outlined,
                                  size: 13.r,
                                  color: _red,
                                ),
                        ),
                      ),
                      SizedBox(width: 7.w),
                      Text(
                        profession.name ?? "N/A",
                        style: TextStyle(
                          fontSize: 12.5.sp,
                          fontWeight: FontWeight.w500,
                          fontFamily: 'Poppins',
                          color: Colors.black87,
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
        ],
      ),
    );
  }

  Widget _aboutSection(BuildContext context) {
    final bio = controller.tradesmen!.tradesmenProfile?.bio;

    return _sectionShell(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _sectionTitle(
            Strings.aboutText(context),
            icon: Icons.info_outline_rounded,
          ),
          SizedBox(height: 10.h),
          Text(
            (bio == null || bio.trim().isEmpty) ? "N/A" : bio,
            style: TextStyle(
              fontSize: 13.5.sp,
              height: 1.55,
              fontFamily: 'Poppins',
              color: _body,
            ),
          ),
        ],
      ),
    );
  }

  // -------------------------------------------------------------------- tabs

  Widget _segmentedTabs(BuildContext context) {
    final portfolioActive = controller.selectedOption.value == "portfolio";

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 14.w),
      child: Container(
        padding: EdgeInsets.all(4.r),
        decoration: BoxDecoration(
          color: const Color(MyColors.cardGrayColor100),
          borderRadius: BorderRadius.circular(14.r),
        ),
        child: Row(
          children: [
            Expanded(
              child: _segment(
                label: Strings.portfolioText(context),
                active: portfolioActive,
                onTap: () {
                  if (controller.selectedOption.value != "portfolio") {
                    controller.selectedOption.value = "portfolio";
                  }
                },
              ),
            ),
            Expanded(
              child: _segment(
                label: Strings.reviews(context),
                active: !portfolioActive,
                onTap: () {
                  if (controller.selectedOption.value != "reviews") {
                    controller.selectedOption.value = "reviews";
                  }
                  if (controller.tradesmenReview == null) {
                    controller.loadingReviews.value = true;
                    controller.getTradesmenReviews(1);
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _segment({
    required String label,
    required bool active,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        curve: Curves.easeOut,
        padding: EdgeInsets.symmetric(vertical: 10.h),
        decoration: BoxDecoration(
          color: active ? _red : Colors.transparent,
          borderRadius: BorderRadius.circular(11.r),
          boxShadow: active
              ? [
                  BoxShadow(
                    color: _red.withValues(alpha: 0.25),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ]
              : null,
        ),
        child: AutoSizeText(
          label,
          maxLines: 1,
          minFontSize: 9,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 13.5.sp,
            fontWeight: FontWeight.w600,
            fontFamily: 'Poppins',
            color: active ? Colors.white : _body,
          ),
        ),
      ),
    );
  }

  Widget _listHeader(String text) {
    return Padding(
      padding: EdgeInsets.fromLTRB(20.w, 18.h, 20.w, 2.h),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(
          text,
          style: TextStyle(
            fontSize: 14.sp,
            fontWeight: FontWeight.w600,
            fontFamily: 'Poppins',
            color: _body,
          ),
        ),
      ),
    );
  }

  Widget _emptyState(IconData icon, String text) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 40.h, horizontal: 24.w),
      child: Column(
        children: [
          Icon(icon, size: 36.r, color: _muted.withValues(alpha: 0.6)),
          SizedBox(height: 10.h),
          Text(
            text,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 13.sp,
              fontFamily: 'Poppins',
              color: _muted,
            ),
          ),
        ],
      ),
    );
  }

  // --------------------------------------------------------------- portfolio

  Widget _buildPortfolioSection(BuildContext context) {
    final portfolios = controller.portfolioList;

    if (portfolios == null) {
      return Padding(
        padding: EdgeInsets.symmetric(vertical: 40.h),
        child: const Center(child: CircularProgressIndicator(color: _red)),
      );
    }

    if (portfolios.isEmpty) {
      return _emptyState(
        Icons.photo_library_outlined,
        Strings.noPortfolioFound(context),
      );
    }

    return Column(
      children: [
        _listHeader(
          "${Strings.portfolios(context)} (${controller.totalPortfolio.value})",
        ),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          padding: EdgeInsets.zero,
          itemCount: portfolios.length,
          itemBuilder: (context, index) =>
              _buildPortfolioView(portfolios.elementAt(index)),
        ),
      ],
    );
  }

  Widget _buildPortfolioView(Portfolio portfolio) {
    final images = portfolio.imageList ?? [];

    return Padding(
      padding: EdgeInsets.fromLTRB(14.w, 8.h, 14.w, 0),
      child: Container(
        decoration: BoxDecoration(
          color: _surface,
          borderRadius: BorderRadius.circular(16.r),
          border: Border.all(color: _border),
        ),
        padding: EdgeInsets.fromLTRB(14.w, 14.h, 14.w, 14.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              portfolio.title ?? "N/A",
              style: TextStyle(
                fontSize: 15.sp,
                fontWeight: FontWeight.w600,
                fontFamily: 'Poppins',
                color: Colors.black,
              ),
            ),
            SizedBox(height: 4.h),
            Text(
              portfolio.desc ?? "N/A",
              style: TextStyle(
                fontSize: 13.sp,
                height: 1.5,
                fontFamily: 'Poppins',
                color: _body,
              ),
            ),
            if (images.isNotEmpty) ...[
              SizedBox(height: 12.h),
              SizedBox(
                // Bigger thumbnails: the old 80x70 cards were too small to
                // judge a job from.
                height: 92.r,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  padding: EdgeInsets.zero,
                  itemCount: images.length,
                  separatorBuilder: (_, __) => SizedBox(width: 8.w),
                  itemBuilder: (context, index) {
                    return ClipRRect(
                      borderRadius: BorderRadius.circular(12.r),
                      child: SizedBox(
                        height: 92.r,
                        width: 92.r,
                        child: PhotoViewerImage(
                          imageUrl: images.elementAt(index),
                          errorWidget: (p0, p1, p2) => Container(
                            color: _canvas,
                            child: Center(
                              child: SvgPicture.asset(
                                "lib/assets/images/tradesmenplaceholdericon.svg",
                                fit: BoxFit.contain,
                                height: 26.r,
                                width: 26.r,
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  // ----------------------------------------------------------------- reviews

  Widget _buildReviewsSection(BuildContext context) {
    return Obx(() {
      if (controller.loadingReviews.value) {
        return Padding(
          padding: EdgeInsets.symmetric(vertical: 40.h),
          child: const Center(child: CircularProgressIndicator(color: _red)),
        );
      }

      final reviews = controller.reviewList ?? [];

      if (reviews.isEmpty) {
        return _emptyState(
          Icons.rate_review_outlined,
          Strings.noReviewFound(context),
        );
      }

      return Column(
        children: [
          _listHeader(
            "${Strings.reviews(context)} (${controller.totalReviews.value})",
          ),
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            padding: EdgeInsets.zero,
            itemCount: reviews.length,
            itemBuilder: (context, index) =>
                _buildReviewView(reviews.elementAt(index)),
          ),
          if (controller.totalReviews.value > reviews.length)
            _buildLoadMoreButton(context),
        ],
      );
    });
  }

  Widget _buildReviewView(Reviews review) {
    final name = review.userName ?? "N/A";
    final city = review.userCity;
    final initial = name.trim().isEmpty ? "?" : name.trim()[0].toUpperCase();

    return Padding(
      padding: EdgeInsets.fromLTRB(14.w, 8.h, 14.w, 0),
      child: Container(
        decoration: BoxDecoration(
          color: _surface,
          borderRadius: BorderRadius.circular(16.r),
          border: Border.all(color: _border),
        ),
        padding: EdgeInsets.all(14.r),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Initial avatar — gives every review a visual anchor so the
                // list doesn't read as one grey block of text.
                Container(
                  width: 38.r,
                  height: 38.r,
                  decoration: BoxDecoration(
                    color: _red.withValues(alpha: 0.10),
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Text(
                      initial,
                      style: TextStyle(
                        fontSize: 15.sp,
                        fontWeight: FontWeight.w700,
                        fontFamily: 'Poppins',
                        color: _red,
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 10.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        (city != null && city.isNotEmpty)
                            ? "$name, $city"
                            : name,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 13.5.sp,
                          fontWeight: FontWeight.w600,
                          fontFamily: 'Poppins',
                          color: Colors.black,
                        ),
                      ),
                      SizedBox(height: 4.h),
                      Row(
                        children: [
                          if (review.rating != null)
                            RatingBar.builder(
                              initialRating: review.rating!.toDouble(),
                              minRating: 1,
                              ignoreGestures: true,
                              direction: Axis.horizontal,
                              allowHalfRating: true,
                              itemCount: 5,
                              itemSize: 13.r,
                              itemPadding: EdgeInsets.only(right: 2.w),
                              itemBuilder: (context, _) =>
                                  const Icon(Icons.star_rounded, color: _red),
                              onRatingUpdate: (rating) {},
                            ),
                          SizedBox(width: 6.w),
                          Flexible(
                            child: Text(
                              formatDate(review.createdAt),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                color: _muted,
                                fontSize: 11.5.sp,
                                fontFamily: 'Poppins',
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 12.h),
            if ((review.title ?? "").trim().isNotEmpty) ...[
              Text(
                review.title!,
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w600,
                  fontFamily: 'Poppins',
                ),
              ),
              SizedBox(height: 6.h),
            ],
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(11.r),
              decoration: BoxDecoration(
                color: _canvas,
                borderRadius: BorderRadius.circular(10.r),
                border: Border(
                  left: BorderSide(
                    color: _red.withValues(alpha: 0.35),
                    width: 3.w,
                  ),
                ),
              ),
              child: Text(
                review.comment ?? "N/A",
                style: TextStyle(
                  color: _body,
                  fontSize: 13.sp,
                  height: 1.5,
                  fontFamily: 'Poppins',
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  static String formatDate(String? raw, {String pattern = 'd MMM, yyyy'}) {
    if (raw == null || raw.trim().isEmpty) return "";

    final parsed = DateTime.tryParse(raw.trim());
    if (parsed == null) return raw;
    final date = parsed.toLocal();

    try {
      return DateFormat(pattern, Get.locale?.toString()).format(date);
    } catch (_) {
      return DateFormat(pattern).format(date);
    }
  }

  Widget _buildLoadMoreButton(BuildContext context) {
    return Obx(() {
      final loading = controller.loadMore.value;

      return Padding(
        padding: EdgeInsets.symmetric(vertical: 16.h),
        child: Center(
          child: SizedBox(
            width: MediaQuery.of(context).size.width / 1.8,
            height: 42.h,
            child: ElevatedButton(
              onPressed: loading ? null : () => _loadMoreReviews(),
              style: ElevatedButton.styleFrom(
                elevation: 0,
                padding: EdgeInsets.zero,
                backgroundColor: _surface,
                disabledBackgroundColor: _surface,
                foregroundColor: _red,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(21.r),
                  side: BorderSide(color: _red.withValues(alpha: 0.35)),
                ),
              ),
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 200),
                child: loading
                    ? SizedBox(
                        key: const ValueKey('loading'),
                        width: 18.w,
                        height: 18.w,
                        child: const CircularProgressIndicator(
                          strokeWidth: 2,
                          color: _red,
                        ),
                      )
                    : Row(
                        key: const ValueKey('label'),
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            Strings.loadMoreText(context),
                            style: TextStyle(
                              fontSize: 13.5.sp,
                              fontWeight: FontWeight.w600,
                              fontFamily: 'Poppins',
                              color: _red,
                            ),
                          ),
                          SizedBox(width: 5.w),
                          Icon(Icons.keyboard_arrow_down, size: 18.sp),
                        ],
                      ),
              ),
            ),
          ),
        ),
      );
    });
  }

  void _loadMoreReviews() {
    try {
      final pagination = controller.tradesmenReview?.pagination;
      if (pagination == null || !(pagination.hasMore ?? false)) return;

      final current = pagination.currentPage;
      if (current == null) return;

      controller.loadMore.value = true;
      controller.getTradesmenReviews(current + 1);
    } catch (e) {
      debugPrint('load more failed: $e');
      controller.loadMore.value = false;
    }
  }
}
