import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_places_api_flutter/google_places_api_flutter.dart';
import 'package:linear_progress_bar/linear_progress_bar.dart';
import 'package:workforceclientapp/Controllers/PickAddressController.dart';
import 'package:workforceclientapp/Others/Constants.dart';
import 'package:workforceclientapp/Others/MyColors.dart';
import 'package:workforceclientapp/Others/Strings.dart';
import 'package:workforceclientapp/Others/routes.dart';
import 'package:workforceclientapp/views/widgets/FullWidthButtonPrimary.dart';
import 'package:workforceclientapp/views/widgets/FullWidthOutlineButton.dart';
import 'package:workforceclientapp/views/widgets/HeadingTextW500.dart';

class PickAddressScreen extends GetView<PickAddressController> {
  const PickAddressScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text(Strings.discardChangesText(Get.context!)),
            content:
                Text(Strings.areYouSureToEndJobPostingProcess(Get.context!)),
            contentTextStyle: TextStyle(fontSize: 15.5.sp, color: Colors.black),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.r)),
            backgroundColor: const Color(MyColors.colorRed200),
            actions: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.only(left: 8.0.w, right: 8.0.w),
                      child: FullWidthOutlineButton(
                          text: Strings.noText(context),
                          fontsize: 15.0.sp,
                          color: MyColors.themeRedColor,
                          onPressed: () {
                            Get.back();
                          }),
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.only(left: 8.0.w, right: 8.0.w),
                      child: FullWidthButtonPrimary(
                          text: Strings.yesText(context),
                          fontsize: 15.0.sp,
                          color: MyColors.themeRedColor,
                          onPressed: () {
                            Get.back();
                            Get.offAllNamed(AppLinks.select_service_screen);
                          }),
                    ),
                  )
                ],
              ),
            ],
          ),
        );
        return true;
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
            child: Center(
                child: Padding(
              padding: EdgeInsets.only(left: 8.0.w, right: 8.0.w),
              child: Text(Constants.selectedServiceName,
                  textAlign: TextAlign.center,
                  overflow: TextOverflow.ellipsis,
                  softWrap: true,
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 16.0.sp,
                      fontWeight: FontWeight.w600,
                      fontFamily: 'Poppins')),
            )),
          ),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                flex: 1,
                child: Column(
                  children: [
                    Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: 10.0.w, vertical: 0),
                      child: LinearProgressBar(
                        maxSteps: Constants.jobPostingSteps,
                        progressType: LinearProgressBar.progressTypeLinear,
                        minHeight: 6,
                        currentStep: Constants.currentJobPostingStep,
                        progressColor: const Color(MyColors.themeRedColor),
                        backgroundColor: const Color(MyColors.lightSilverColor),
                        borderRadius: BorderRadius.circular(2.r),
                      ),
                    ),
                    Align(
                      alignment: Alignment.topRight,
                      child: Padding(
                        padding: EdgeInsets.only(top: 5.0.h, right: 15.0.w),
                        child: Text(
                          "${Strings.step(Get.context!)} ${Constants.currentJobPostingStep}/${Constants.jobPostingSteps}",
                          style: TextStyle(
                              fontSize: 14.5.sp,
                              color: const Color(MyColors.midGrayColor)),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                flex: 16,
                child: Column(
                  children: [
                    const Spacer(),
                    Padding(
                      padding: EdgeInsets.all(8.0.r),
                      child: Card(
                        color: const Color(MyColors.cardGrayColor50),
                        child: Column(
                          children: [
                            Align(
                              alignment: Alignment.topLeft,
                              child: Padding(
                                padding:
                                    EdgeInsets.only(top: 19.0.h, left: 16.0.w),
                                child: HeadingTextW500(
                                    text: Strings.findYourAddress(context),
                                    centerAlign: false,
                                    size: 18.0.sp),
                              ),
                            ),
                            Padding(
                                padding: EdgeInsets.all(15.0.r),
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 12, vertical: 0),
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                        color: Colors.grey, width: 1.2),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: PlaceSearchField(
                                    apiKey: Constants.googleMapsAPIkey,
                                    isLatLongRequired: true,
                                    webCorsProxyUrl: "",
                                    controller: controller.controllerTextField,
                                    onPlaceSelected: (prediction, p1) async {
                                      controller.controllerTextField.text =
                                          prediction.description ?? "";
                                      controller.controllerTextField.selection =
                                          TextSelection.fromPosition(
                                              TextPosition(
                                                  offset: prediction
                                                          .description.length ??
                                                      0));
                                      try {
                                        Constants.jobPostingLat = p1!
                                                .result.geometry!.location.lat
                                                .toString() ??
                                            "";
                                        Constants.jobPostingLng = p1
                                                .result.geometry!.location.lng
                                                .toString() ??
                                            "";
                                        controller.currentPosition.value =
                                            LatLng(
                                                p1.result.geometry!.location
                                                    .lat,
                                                p1.result.geometry!.location
                                                    .lng);
                                        controller.markers.add(
                                          Marker(
                                            markerId: const MarkerId(
                                                "current_location"),
                                            position: controller
                                                .currentPosition.value,
                                            infoWindow: InfoWindow(
                                                title: "You are here",
                                                snippet:
                                                    controller.currentAddress),
                                          ),
                                        );
                                        controller.mapController?.moveCamera(
                                            CameraUpdate.newLatLng(controller
                                                .currentPosition.value));
                                      } catch (e) {
                                        e.printError();
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
                                    itemBuilder: (context, prediction) =>
                                        ListTile(
                                      leading: const Icon(Icons.location_on),
                                      title: Text(
                                        prediction.description,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ),

                                  // child: GooglePlaceAutoCompleteTextField(
                                  //   textEditingController:
                                  //       controller.controllerTextField,
                                  //   googleAPIKey: Constants.googleMapsAPIkey,
                                  //   inputDecoration: InputDecoration(
                                  //     hintText: Strings.searchYourLocationText(
                                  //         context),
                                  //     border: OutlineInputBorder(
                                  //       borderSide: const BorderSide(
                                  //           color:
                                  //               Color(MyColors.midGrayColor)),
                                  //       borderRadius:
                                  //           BorderRadius.circular(10.r),
                                  //     ),
                                  //     focusedBorder: OutlineInputBorder(
                                  //       borderSide: const BorderSide(
                                  //           color:
                                  //               Color(MyColors.midGrayColor)),
                                  //       borderRadius:
                                  //           BorderRadius.circular(10.r),
                                  //     ),
                                  //     enabledBorder: OutlineInputBorder(
                                  //       borderSide: const BorderSide(
                                  //           color:
                                  //               Color(MyColors.midGrayColor)),
                                  //       borderRadius:
                                  //           BorderRadius.circular(10.r),
                                  //     ),
                                  //   ),
                                  //   debounceTime: 0,
                                  //   countries: const ["pk", "de"],
                                  //   isLatLngRequired: true,
                                  //   getPlaceDetailWithLatLng:
                                  //       (Prediction prediction) {
                                  // try {
                                  //   Constants.jobPostingLat =
                                  //       prediction.lat ?? "";
                                  //   Constants.jobPostingLng =
                                  //       prediction.lng ?? "";
                                  //   controller.currentPosition.value =
                                  //       LatLng(
                                  //           double.parse(prediction.lat!),
                                  //           double.parse(prediction.lng!));
                                  //   controller.markers.add(
                                  //     Marker(
                                  //       markerId: const MarkerId(
                                  //           "current_location"),
                                  //       position: controller
                                  //           .currentPosition.value,
                                  //       infoWindow: InfoWindow(
                                  //           title: "You are here",
                                  //           snippet:
                                  //               controller.currentAddress),
                                  //     ),
                                  //   );
                                  //   controller.mapController?.moveCamera(
                                  //       CameraUpdate.newLatLng(controller
                                  //           .currentPosition.value));
                                  // } catch (e) {
                                  //   e.printError();
                                  // }
                                  //   },
                                  //   itemClick: (Prediction prediction) {
                                  // FocusScope.of(context).unfocus();
                                  // // controller.controllerTextField.text =
                                  // //     prediction.description ?? "";
                                  // // controller.controllerTextField.selection =
                                  // //     TextSelection.fromPosition(
                                  // //         TextPosition(
                                  // //             offset: prediction.description
                                  // //                     ?.length ??
                                  // //                 0));
                                  //   },
                                  //   seperatedBuilder: const Divider(),
                                  //   // OPTIONAL// If you want to customize list view item builder
                                  //   itemBuilder: (context, index,
                                  //       Prediction prediction) {
                                  //     return Container(
                                  //       padding: EdgeInsets.all(10.r),
                                  //       child: Row(
                                  //         children: [
                                  //           const Icon(Icons.location_on),
                                  //           const SizedBox(
                                  //             width: 7,
                                  //           ),
                                  //           Expanded(
                                  //               child: Text(
                                  //                   prediction.description ??
                                  //                       ""))
                                  //         ],
                                  //       ),
                                  //     );
                                  //   },
                                  //   isCrossBtnShown: true,
                                  //   // default 600 ms ,
                                  // ),
                                )),
                          ],
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(18.0.r),
                      child: SizedBox(
                        height: MediaQuery.of(context).size.height.h / 2.2,
                        width: MediaQuery.of(context).size.width.w,
                        child: Card(
                          shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.circular(10.r), // Adjust roundness
                          ),
                          elevation: 2,
                          shadowColor: Colors.black,
                          child: Obx(() {
                            return ClipRRect(
                              // Ensures child respects rounded corners
                              borderRadius: BorderRadius.circular(10.r),
                              child: Stack(
                                children: [
                                  GoogleMap(
                                    myLocationButtonEnabled: true,
                                    myLocationEnabled: true,
                                    onMapCreated: controller.onMapCreated,
                                    initialCameraPosition: CameraPosition(
                                      target: controller.currentPosition.value,
                                      zoom: 13.0,
                                    ),
                                    markers: {
                                      Marker(
                                        markerId:
                                            const MarkerId("selected_location"),
                                        position:
                                            controller.currentPosition.value,
                                        draggable:
                                            false, // Marker moves with camera, not drag
                                      ),
                                    },
                                    onCameraMove: controller
                                        .onCameraMove, // Updates marker as the camera moves
                                    onCameraIdle: controller
                                        .onCameraIdle, // When the map stops moving
                                  ),
                                  Container(
                                    color: const Color(MyColors.blackColor80),
                                    child: Padding(
                                      padding: EdgeInsets.all(5.0.r),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Image.asset(
                                              "lib/assets/icons/dragdropicon.png",
                                              fit: BoxFit.fill,
                                              height: 12.h,
                                              width: 12.w),
                                          SizedBox(width: 8.w),
                                          Text(
                                              Strings.dragtomovePinText(
                                                  Get.context!),
                                              textAlign: TextAlign.start,
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 12.0.sp,
                                                  fontWeight: FontWeight.w400,
                                                  fontFamily: 'Poppins'))
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }),
                        ),
                      ),
                    ),
                    const Spacer(),
                  ],
                ),
              ),
              Expanded(
                flex: 2,
                child: Padding(
                  padding: EdgeInsets.all(8.0.r),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Expanded(
                        child: Padding(
                          padding: EdgeInsets.only(left: 25.0.w, right: 12.0.w),
                          child: FullWidthOutlineButton(
                              text: Strings.back(context),
                              fontsize: 15.0.sp,
                              color: MyColors.themeRedColor,
                              onPressed: () {
                                print("object");
                                Constants.currentJobPostingStep--;
                                Get.back();
                              }),
                        ),
                      ),
                      Expanded(
                        child: Padding(
                          padding: EdgeInsets.only(left: 12.0.w, right: 25.0.w),
                          child: FullWidthButtonPrimary(
                              text: Strings.postJob(context),
                              fontsize: 15.0.sp,
                              color: MyColors.themeRedColor,
                              onPressed: () {
                                if (controller.controllerTextField.value.text
                                        .isNotEmpty &&
                                    Constants.jobPostingLat.isNotEmpty &&
                                    Constants.jobPostingLng.isNotEmpty) {
                                  Constants.jobPostingAddress =
                                      controller.controllerTextField.text;
                                  Get.toNamed(
                                      AppLinks.job_post_completed_screen);
                                } else {}
                              }),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
