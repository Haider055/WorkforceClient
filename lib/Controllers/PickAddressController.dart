import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:workforceclientapp/Others/Commons.dart';
import 'package:workforceclientapp/Others/Constants.dart';

class PickAddressController extends GetxController {
  final controllerTextField = TextEditingController();
  GoogleMapController? mapController;
  String currentAddress = "";
  Rx<LatLng> currentPosition = const LatLng(43.413029, 34.299316).obs;
  final Set<Marker> markers = {};
  late Position position;

  @override
  void onInit() {
    super.onInit();
    getCurrentLocation();
  }

  void onMapCreated(GoogleMapController controller) {
    mapController = controller;

    mapController!.moveCamera(
      CameraUpdate.newLatLng(currentPosition.value),
    );
  }

  void onCameraMove(CameraPosition position) {
    currentPosition.value = position.target;
  }

  // When user stops moving the map
  void onCameraIdle() {
    _getAddressFromLatLng(currentPosition.value);
  }

  Future<void> getCurrentLocation() async {
    try {
      // Check if location services are enabled
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        print("Location services are disabled.");
        return;
      }

      // Request permission
      LocationPermission permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        print("Location permission denied.");
        return;
      } else if (permission == LocationPermission.deniedForever) {
        print("Location permission permanently denied. Open app settings.");
        return;
      }

      Commons.showProgressDialog(Get.context!);

      // Get current position
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      currentPosition.value = LatLng(position.latitude, position.longitude);
      markers.clear(); // Clear previous markers
      markers.add(
        Marker(
          markerId: const MarkerId("current_location"),
          position: currentPosition.value,
          infoWindow:
              InfoWindow(title: "You are here", snippet: currentAddress),
        ),
      );

      // Move camera to new position
      mapController
          ?.animateCamera(CameraUpdate.newLatLng(currentPosition.value));
      update();

      // Get address
      _getAddressFromPosition(position);
    } catch (e) {
      print("Error getting location: $e");
    }
  }

  Future<void> _getAddressFromPosition(Position position) async {
    try {
      List<Placemark> placemarks =
          await placemarkFromCoordinates(position.latitude, position.longitude);

      Placemark place = placemarks.first;
      Constants.jobPostingCity = place.locality ?? "";
      Constants.jobPostingCountry = place.country ?? "";
      Constants.jobPostingPostcode = place.postalCode ?? "";
      Constants.jobPostingState = place.administrativeArea ?? "";
      currentAddress =
          "${place.street}, ${place.locality}, ${place.administrativeArea}, ${place.country}";
      controllerTextField.text = currentAddress;
      Commons.hideProgressDialog();
    } catch (e) {
      currentAddress = "Error: $e";
    }
  }

  Future<void> _getAddressFromLatLng(LatLng position) async {
    try {
      Constants.jobPostingLat = position.latitude.toString();
      Constants.jobPostingLng = position.longitude.toString();
      List<Placemark> placemarks =
          await placemarkFromCoordinates(position.latitude, position.longitude);
      Placemark place = placemarks.first;
      Constants.jobPostingCity = place.locality ?? "";
      Constants.jobPostingCountry = place.country ?? "";
      Constants.jobPostingPostcode = place.postalCode ?? "";
      Constants.jobPostingState = place.administrativeArea ?? "";

      currentAddress =
          "${place.street}, ${place.locality}, ${place.administrativeArea}, ${place.country}";
      controllerTextField.text = currentAddress;
    } catch (e) {
      currentAddress = "Error: $e";
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }
}
