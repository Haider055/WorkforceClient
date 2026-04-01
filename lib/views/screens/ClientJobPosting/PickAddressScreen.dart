import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_places_flutter/google_places_flutter.dart';
import 'package:google_places_flutter/model/prediction.dart';
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
            title: const Text("Discard changes!"),
            content: const Text("Are you sure to end Job Posting process?"),
            contentTextStyle:
                const TextStyle(fontSize: 15.5, color: Colors.black),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            backgroundColor: const Color(MyColors.colorRed200),
            actions: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                      child: FullWidthOutlineButton(
                          text: Strings.noText(context),
                          fontsize: 15.0,
                          color: MyColors.themeRedColor,
                          onPressed: () {
                            Get.back();
                          }),
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                      child: FullWidthButtonPrimary(
                          text: Strings.yesText(context),
                          fontsize: 15.0,
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
              padding: const EdgeInsets.only(left: 8.0, right: 8.0),
              child: Text(Constants.selectedServiceName,
                  textAlign: TextAlign.center,
                  overflow: TextOverflow.ellipsis,
                  softWrap: true,
                  style: const TextStyle(
                      color: Colors.black,
                      fontSize: 16.0,
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
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10.0, vertical: 0),
                      child: LinearProgressBar(
                        maxSteps: Constants.jobPostingSteps,
                        progressType: LinearProgressBar.progressTypeLinear,
                        minHeight: 6,
                        currentStep: Constants.currentJobPostingStep,
                        progressColor: const Color(MyColors.themeRedColor),
                        backgroundColor: const Color(MyColors.lightSilverColor),
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                    Align(
                      alignment: Alignment.topRight,
                      child: Padding(
                        padding: const EdgeInsets.only(top: 5.0, right: 15),
                        child: Text(
                          "Step ${Constants.currentJobPostingStep}/${Constants.jobPostingSteps}",
                          style: const TextStyle(
                              fontSize: 14.5,
                              color: Color(MyColors.midGrayColor)),
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
                      padding: const EdgeInsets.all(8.0),
                      child: Card(
                        color: const Color(MyColors.cardGrayColor50),
                        child: Column(
                          children: [
                            Align(
                              alignment: Alignment.topLeft,
                              child: Padding(
                                padding: const EdgeInsets.only(
                                    top: 19.0, left: 16.0),
                                child: HeadingTextW500(
                                    text: Strings.findYourAddress(context),
                                    centerAlign: false,
                                    size: 18.0),
                              ),
                            ),
                            Padding(
                                padding: const EdgeInsets.all(15.0),
                                child: Container(
                                  padding:
                                      const EdgeInsets.symmetric(horizontal: 0),
                                  child: GooglePlaceAutoCompleteTextField(
                                    textEditingController:
                                        controller.controllerTextField,
                                    googleAPIKey:
                                        "AIzaSyBZz4unF-wEdjkLUM6jOI8TSKu8E-CisnM",
                                    inputDecoration: InputDecoration(
                                      hintText: Strings.searchYourLocationText(
                                          context),
                                      border: OutlineInputBorder(
                                        borderSide: const BorderSide(
                                            color:
                                                Color(MyColors.midGrayColor)),
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderSide: const BorderSide(
                                            color:
                                                Color(MyColors.midGrayColor)),
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                        borderSide: const BorderSide(
                                            color:
                                                Color(MyColors.midGrayColor)),
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                    ),
                                    debounceTime: 400,
                                    countries: const ["pk", "de"],
                                    isLatLngRequired: true,
                                    getPlaceDetailWithLatLng:
                                        (Prediction prediction) {
                                      try {
                                        Constants.jobPostingLat =
                                            prediction.lat ?? "";
                                        Constants.jobPostingLng =
                                            prediction.lng ?? "";
                                        controller.currentPosition.value =
                                            LatLng(
                                                double.parse(prediction.lat!),
                                                double.parse(prediction.lng!));
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
                                    itemClick: (Prediction prediction) {
                                      controller.controllerTextField.text =
                                          prediction.description ?? "";
                                      controller.controllerTextField.selection =
                                          TextSelection.fromPosition(
                                              TextPosition(
                                                  offset: prediction.description
                                                          ?.length ??
                                                      0));
                                    },
                                    seperatedBuilder: const Divider(),
                                    // OPTIONAL// If you want to customize list view item builder
                                    itemBuilder: (context, index,
                                        Prediction prediction) {
                                      return Container(
                                        padding: const EdgeInsets.all(10),
                                        child: Row(
                                          children: [
                                            const Icon(Icons.location_on),
                                            const SizedBox(
                                              width: 7,
                                            ),
                                            Expanded(
                                                child: Text(
                                                    prediction.description ??
                                                        ""))
                                          ],
                                        ),
                                      );
                                    },
                                    isCrossBtnShown: true,
                                    // default 600 ms ,
                                  ),
                                )),
                          ],
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(18.0),
                      child: SizedBox(
                        height: MediaQuery.of(context).size.height / 2.2,
                        width: MediaQuery.of(context).size.width,
                        child: Card(
                          shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.circular(10), // Adjust roundness
                          ),
                          elevation: 2,
                          shadowColor: Colors.black,
                          child: Obx(() {
                            return ClipRRect(
                              // Ensures child respects rounded corners
                              borderRadius: BorderRadius.circular(10),
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
                                      padding: const EdgeInsets.all(5.0),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Image.asset(
                                              "lib/assets/icons/dragdropicon.png",
                                              fit: BoxFit.fill,
                                              height: 12,
                                              width: 12),
                                          const SizedBox(width: 8),
                                          const Text(
                                              "Drag to move pin to exact location",
                                              textAlign: TextAlign.start,
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 12.0,
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
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Expanded(
                        child: Padding(
                          padding:
                              const EdgeInsets.only(left: 25.0, right: 12.0),
                          child: FullWidthOutlineButton(
                              text: Strings.back(context),
                              fontsize: 15.0,
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
                          padding:
                              const EdgeInsets.only(left: 12.0, right: 25.0),
                          child: FullWidthButtonPrimary(
                              text: Strings.postJob(context),
                              fontsize: 15.0,
                              color: MyColors.themeRedColor,
                              onPressed: () {
                                if (controller.controllerTextField.value.text
                                        .isNotEmpty &&
                                    Constants.jobPostingLat.isNotEmpty &&
                                    Constants.jobPostingLng.isNotEmpty) {
                                  Constants.jobPostingAddress =
                                      controller.controllerTextField.text;
                                  Get.offAllNamed(
                                      AppLinks.job_post_completed_screen);
                                } else {
                                  Fluttertoast.showToast(msg: "else");
                                }
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
