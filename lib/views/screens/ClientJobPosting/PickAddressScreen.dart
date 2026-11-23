import 'dart:io';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_places_api_flutter/google_places_api_flutter.dart';
import 'package:linear_progress_bar/linear_progress_bar.dart';
import 'package:workforceclientapp/Controllers/PickAddressController.dart';
import 'package:workforceclientapp/Others/Commons.dart';
import 'package:workforceclientapp/Others/Constants.dart';
import 'package:workforceclientapp/Others/MyColors.dart';
import 'package:workforceclientapp/Others/Strings.dart';
import 'package:workforceclientapp/Others/routes.dart';
import 'package:workforceclientapp/views/widgets/FullWidthButtonPrimary.dart';
import 'package:workforceclientapp/views/widgets/FullWidthOutlineButton.dart';

import 'package:fluttertoast/fluttertoast.dart';

class PickAddressScreen extends GetView<PickAddressController> {
  const PickAddressScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: true,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) {
          Constants.currentJobPostingStep.value--;
        }
      },
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Colors.white,
        appBar: AppBar(
          leadingWidth: MediaQuery.of(context).size.width,
          leading: Card(
            color: const Color(MyColors.appbackgroundColor),
            shadowColor: const Color.fromARGB(158, 219, 219, 219),
            elevation: 2,
            shape: const Border(
                bottom: BorderSide(
                    color: Color.fromARGB(147, 203, 203, 203),
                    style: BorderStyle.solid)),
            child: Stack(
              children: [
                Center(
                    child: Padding(
                  padding: EdgeInsets.only(left: 8.0.w, right: 40.0.w),
                  child: AutoSizeText(
                    Constants.selectedServiceName,
                    maxLines: 2,
                    textAlign: TextAlign.center,
                    minFontSize: 9,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                        fontSize: 15, fontWeight: FontWeight.w600),
                  ),
                )),
                Positioned(
                    top: 0,
                    bottom: 0,
                    right: 12.w,
                    child: GestureDetector(
                        onTap: () {
                          Commons.showExitJobPostingDialog(Get.context!);
                        },
                        child: const Icon(Icons.close)))
              ],
            ),
          ),
        ),
        body: Column(
          children: [
            _buildProgress(context),
            Expanded(child: _buildMapArea(context)),
            // The panel sizes to its content, but never past 46% of the
            // screen — on short phones the three rows plus the buttons
            // were taller than the space left over, which is a RenderFlex
            // overflow (the yellow/black stripes).
            ConstrainedBox(
              constraints: BoxConstraints(
                maxHeight: MediaQuery.of(context).size.height * 0.46,
              ),
              child: SingleChildScrollView(
                child: _buildBottomPanel(context),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ------------------------------------------------------------ progress

  Widget _buildProgress(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(10.0.w, 6.h, 10.0.w, 2.h),
      child: Column(
        children: [
          Obx(() {
            return LinearProgressBar(
              maxSteps: Constants.jobPostingSteps,
              progressType: LinearProgressBar.progressTypeLinear,
              minHeight: 6,
              currentStep: Constants.currentJobPostingStep.value,
              progressColor: const Color(MyColors.themeRedColor),
              backgroundColor: const Color(MyColors.lightSilverColor),
              borderRadius: BorderRadius.circular(2.r),
            );
          }),
          Align(
            alignment: Alignment.topRight,
            child: Padding(
              padding: EdgeInsets.only(top: 4.0.h, right: 5.0.w),
              // The bar was reactive but this label was not.
              child: Obx(() {
                return Text(
                  "${Strings.step(Get.context!)} ${Constants.currentJobPostingStep.value}/${Constants.jobPostingSteps}",
                  style: TextStyle(
                      fontSize: 13.5.sp,
                      color: const Color(MyColors.midGrayColor)),
                );
              }),
            ),
          ),
        ],
      ),
    );
  }

  // ----------------------------------------------------------- map + search

  Widget _buildMapArea(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        GoogleMap(
          myLocationButtonEnabled: false,
          myLocationEnabled: true,
          onMapCreated: controller.onMapCreated,
          initialCameraPosition: CameraPosition(
            target: controller.currentPosition.value,
            zoom: 15.0,
          ),
          onCameraMove: controller.onCameraMove,
          onCameraIdle: controller.onCameraIdle,
          padding: EdgeInsets.only(top: 70.h, bottom: 12.h),
        ),

        IgnorePointer(
          child: Center(
            child: Padding(
              padding: EdgeInsets.only(bottom: 30.h),
              child: Icon(
                Icons.location_on,
                size: 42.sp,
                color: const Color(MyColors.themeRedColor),
              ),
            ),
          ),
        ),

        // Floating search bar over the map
        Positioned(
          top: 10.h,
          left: 14.w,
          right: 14.w,
          child: _buildSearchBar(context),
        ),

        // "Drag to move pin" hint, now a floating chip instead of a bar
        // Positioned(
        //   bottom: 7.h,
        //   left: 0,
        //   right: 0,
        //   child: Center(child: _buildDragHint()),
        // ),
      ],
    );
  }

  Widget _buildSearchBar(BuildContext context) {
    return Material(
      elevation: 4,
      borderRadius: BorderRadius.circular(12.r),
      color: Colors.white,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 10.w),
        child: Row(
          children: [
            Icon(Icons.search,
                size: 20.sp, color: const Color(MyColors.midGrayColor)),
            SizedBox(width: 8.w),
            Expanded(
              child: PlaceSearchField(
                apiKey: Constants.googleMapsAPIkey,
                isLatLongRequired: true,
                webCorsProxyUrl: "",
                hideOnSelect: false,
                hideOnEmpty: true,
                controller: controller.controllerTextField,
                onPlaceSelected: (prediction, p1) async {
                  FocusManager.instance.primaryFocus?.unfocus();
                  try {
                    controller.applySearchResult(
                      prediction.description ?? "",
                      p1!.result.geometry!.location.lat,
                      p1.result.geometry!.location.lng,
                    );
                  } catch (e) {
                    debugPrint("onPlaceSelected failed: $e");
                  }
                },
                decorationBuilder: (context, child) {
                  return Material(
                    type: MaterialType.card,
                    elevation: 4,
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                    child: child,
                  );
                },
                itemBuilder: (context, prediction) => ListTile(
                  leading: const Icon(Icons.location_on),
                  title: Text(
                    prediction.description,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
            ),

            // Clear button. A TextEditingController is itself a
            // ValueListenable, so this shows and hides as the user types
            // without needing an Rx for the field.
            ValueListenableBuilder<TextEditingValue>(
              valueListenable: controller.controllerTextField,
              builder: (context, value, _) {
                if (value.text.isEmpty) return const SizedBox.shrink();
                return GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: controller.clearSearch,
                  child: Padding(
                    padding: EdgeInsets.only(left: 6.w),
                    child: Icon(
                      Icons.close,
                      size: 18.sp,
                      color: const Color(MyColors.midGrayColor),
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDragHint() {
    return Padding(
      padding: const EdgeInsets.only(left: 10.0, right: 10.0),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 6.h),
        decoration: BoxDecoration(
          color: const Color(MyColors.blackColor80),
          borderRadius: BorderRadius.circular(20.r),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset("lib/assets/icons/dragdropicon.png",
                fit: BoxFit.fill, height: 12.h, width: 12.w),
            SizedBox(width: 6.w),
            Expanded(
              child: AutoSizeText(
                Strings.dragtomovePinText(Get.context!),
                minFontSize: 5,
                maxFontSize: 12,
                textAlign: TextAlign.center,
                maxLines: 2,
                style: const TextStyle(
                    color: Colors.white,
                    fontSize: 11,
                    fontWeight: FontWeight.w400,
                    fontFamily: 'Poppins'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRecenterButton() {
    return Material(
      color: Colors.white,
      elevation: 3,
      shape: const CircleBorder(),
      child: InkWell(
        customBorder: const CircleBorder(),
        onTap: controller.getCurrentLocation,
        child: Padding(
          padding: EdgeInsets.all(10.r),
          child: Icon(Icons.my_location,
              size: 20.sp, color: const Color(MyColors.themeRedColor)),
        ),
      ),
    );
  }

  // --------------------------------------------------------- bottom panel

  Widget _buildBottomPanel(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(18.r)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.10),
            blurRadius: 12,
            offset: const Offset(0, -3),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // grab handle
            Padding(
              padding: EdgeInsets.only(top: 8.h, bottom: 4.h),
              child: Container(
                width: 38.w,
                height: 4.h,
                decoration: BoxDecoration(
                  color: const Color(MyColors.lightSilverColor),
                  borderRadius: BorderRadius.circular(4.r),
                ),
              ),
            ),

            _buildSelectedRow(context),
            Divider(height: 1.h, color: const Color(MyColors.cardGrayColor100)),
            _buildCurrentLocationRow(context),
            Obx(() {
              final saved = controller.savedLocation.value;
              if (saved == null) return const SizedBox.shrink();
              return Column(
                children: [
                  Divider(
                      height: 1.h,
                      color: const Color(MyColors.cardGrayColor100)),
                  _buildSavedRow(context, saved),
                ],
              );
            }),
            Padding(
              padding: EdgeInsets.all(8.0.r),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.only(left: 25.0.w, right: 12.0.w),
                      child: FullWidthOutlineButton(
                          text: Strings.back(context),
                          fontsize: 15,
                          color: MyColors.themeRedColor,
                          onPressed: () {
                            FocusManager.instance.primaryFocus?.unfocus();
                            if (Platform.isIOS) {
                              // Constants.currentJobPostingStep.value--;
                            }
                            Get.back();
                          }),
                    ),
                  ),
                  Expanded(
                      child: Padding(
                    padding: EdgeInsets.only(left: 12.0.w, right: 25.0.w),
                    child: FullWidthButtonPrimary(
                      text: Strings.postJob(context),
                      fontsize: 15,
                      color: MyColors.themeRedColor,
                      onPressed: () => _onPost(context),
                    ),
                  ))
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSelectedRow(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(16.w, 12.h, 16.w, 12.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _iconBox(
            icon: Icons.location_on,
            background:
                const Color(MyColors.themeRedColor).withValues(alpha: 0.10),
            iconColor: const Color(MyColors.themeRedColor),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Obx(() {
              final address = controller.currentAddress.value;
              final city = controller.currentCity.value;
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    Strings.findYourAddress(context),
                    style: TextStyle(
                      fontSize: 12.5.sp,
                      color: const Color(MyColors.midGrayColor),
                      fontFamily: 'Poppins',
                    ),
                  ),
                  SizedBox(height: 2.h),
                  Text(
                    address.isEmpty ? "..." : address,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 15.sp,
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                      fontFamily: 'Poppins',
                    ),
                  ),
                  if (city.isNotEmpty) ...[
                    SizedBox(height: 2.h),
                    Text(
                      city,
                      style: TextStyle(
                        fontSize: 13.sp,
                        color: const Color(MyColors.midGrayColor),
                        fontFamily: 'Poppins',
                      ),
                    ),
                  ],
                ],
              );
            }),
          ),

          // Tick lands here once the user drags the map (or picks a search
          // result) — both mean "the address shown above is the choice".
          Obx(() {
            final src = controller.locationSource.value;
            if (src != "map" && src != "search") {
              return const SizedBox.shrink();
            }
            return Padding(
              padding: EdgeInsets.only(left: 8.w, top: 14.h),
              child: _tick(),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildCurrentLocationRow(BuildContext context) {
    return Obx(() {
      final selected = controller.locationSource.value == "gps";
      return InkWell(
        onTap: () {
          FocusManager.instance.primaryFocus?.unfocus();
          controller.getCurrentLocation();
        },
        child: Container(
          color: selected
              ? const Color(MyColors.themeRedColor).withValues(alpha: 0.05)
              : Colors.transparent,
          padding: EdgeInsets.fromLTRB(16.w, 12.h, 16.w, 12.h),
          child: Row(
            children: [
              _iconBox(
                icon: Icons.gps_fixed,
                background: const Color(0xFFE8F0FE),
                iconColor: const Color(0xFF1A73E8),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AutoSizeText(Strings.useCurrentLocation(context),
                        maxLines: 1,
                        minFontSize: 9,
                        maxFontSize: 15,
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          color: Colors.black,
                          fontFamily: 'Poppins',
                        )),
                    SizedBox(height: 1.h),
                  ],
                ),
              ),
              Obx(() {
                if (controller.isLocating.value) {
                  return SizedBox(
                    width: 20.w,
                    height: 20.w,
                    child: const CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Color(MyColors.themeRedColor),
                    ),
                  );
                }
                return selected ? _tick() : const SizedBox.shrink();
              }),
            ],
          ),
        ),
      );
    });
  }

  Widget _buildSavedRow(BuildContext context, SavedLocation saved) {
    final selected = controller.locationSource.value == "saved";
    return InkWell(
      onTap: () {
        FocusManager.instance.primaryFocus?.unfocus();
        controller.applySavedLocation(saved);
      },
      child: Container(
        color: selected
            ? const Color(MyColors.themeRedColor).withValues(alpha: 0.05)
            : Colors.transparent,
        padding: EdgeInsets.fromLTRB(16.w, 12.h, 16.w, 12.h),
        child: Row(
          children: [
            _iconBox(
              icon: Icons.history,
              background: const Color(MyColors.cardGrayColor100),
              iconColor: const Color(MyColors.darkGrayColor),
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AutoSizeText(Strings.lastUsedLocationText(context),
                      maxLines: 1,
                      minFontSize: 9,
                      maxFontSize: 14,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Colors.black,
                        fontFamily: 'Poppins',
                      )),
                  SizedBox(height: 1.h),
                  AutoSizeText(saved.address,
                      maxLines: 3,
                      minFontSize: 7,
                      maxFontSize: 13,
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w400,
                        color: Color(MyColors.midGrayColor),
                        fontFamily: 'Poppins',
                      )),
                ],
              ),
            ),
            if (selected) _tick(),
            GestureDetector(
              onTap: controller.deleteSavedLocation,
              child: Padding(
                padding: EdgeInsets.only(left: 8.w),
                child: Icon(Icons.delete_outline,
                    size: 20.sp, color: const Color(MyColors.midGrayColor)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _iconBox({
    required IconData icon,
    required Color background,
    required Color iconColor,
  }) {
    return Container(
      width: 38.w,
      height: 38.w,
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(10.r),
      ),
      child: Center(child: Icon(icon, size: 19.sp, color: iconColor)),
    );
  }

  Widget _tick() {
    return Container(
      width: 22.w,
      height: 22.w,
      decoration: const BoxDecoration(
        color: Color(MyColors.themeRedColor),
        shape: BoxShape.circle,
      ),
      child: Icon(Icons.check, size: 14.sp, color: Colors.white),
    );
  }

  Future<void> _onPost(BuildContext context) async {
    FocusManager.instance.primaryFocus?.unfocus();

    if (!controller.canPost) {
      // Previously an empty else — the button simply did nothing.
      Fluttertoast.showToast(msg: Strings.findYourAddress(context));
      return;
    }

    Constants.jobPostingAddress = controller.currentAddress.value.trim();

    // Remember this one address for the next job posting.
    await controller.saveLastLocation();

    Get.toNamed(AppLinks.job_post_completed_screen);
  }
}
