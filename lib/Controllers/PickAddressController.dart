import 'dart:convert';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:workforceclientapp/Others/Constants.dart';
import 'package:workforceclientapp/Others/MyColors.dart';
import 'package:workforceclientapp/Others/Strings.dart';

class SavedLocation {
  final String address;
  final String city;
  final String state;
  final String country;
  final String postcode;
  final String lat;
  final String lng;

  const SavedLocation({
    required this.address,
    required this.city,
    required this.state,
    required this.country,
    required this.postcode,
    required this.lat,
    required this.lng,
  });

  Map<String, dynamic> toJson() => {
        'address': address,
        'city': city,
        'state': state,
        'country': country,
        'postcode': postcode,
        'lat': lat,
        'lng': lng,
      };

  factory SavedLocation.fromJson(Map<String, dynamic> json) => SavedLocation(
        address: (json['address'] ?? "").toString(),
        city: (json['city'] ?? "").toString(),
        state: (json['state'] ?? "").toString(),
        country: (json['country'] ?? "").toString(),
        postcode: (json['postcode'] ?? "").toString(),
        lat: (json['lat'] ?? "").toString(),
        lng: (json['lng'] ?? "").toString(),
      );

  bool get isUsable => address.isNotEmpty && lat.isNotEmpty && lng.isNotEmpty;
}

class PickAddressController extends GetxController with WidgetsBindingObserver {
  static const String _prefsKey = 'last_job_location';

  final controllerTextField = TextEditingController();
  GoogleMapController? mapController;
  RxString currentAddress = "".obs;
  RxString currentCity = "".obs;

  Rx<LatLng> currentPosition = const LatLng(43.413029, 34.299316).obs;
  final Set<Marker> markers = {};
  RxString locationSource = "gps".obs;
  bool _programmaticMove = false;

  Rx<SavedLocation?> savedLocation = Rx<SavedLocation?>(null);

  RxBool isLocating = false.obs;
  bool _returningFromSettings = false;

  @override
  void onInit() {
    super.onInit();

    WidgetsBinding.instance.addObserver(this);
    loadSavedLocation();
    getCurrentLocation();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.resumed && _returningFromSettings) {
      _returningFromSettings = false;
      if (!Get.isDialogOpen!) {
        getCurrentLocation();
      }
    }
  }

  // ---------------------------------------------------------------- map

  void onMapCreated(GoogleMapController controller) {
    mapController = controller;
    moveCameraTo(currentPosition.value, animate: false);
  }

  /// Every camera move we trigger ourselves goes through here so the drag
  /// detection in onCameraMove can tell them apart.
  void moveCameraTo(LatLng target, {bool animate = true}) {
    _programmaticMove = true;
    if (animate) {
      mapController?.animateCamera(CameraUpdate.newLatLng(target));
    } else {
      mapController?.moveCamera(CameraUpdate.newLatLng(target));
    }
  }

  void onCameraMove(CameraPosition position) {
    currentPosition.value = position.target;

    // The user is panning the map, so the chosen point is now whatever is
    // under the centre pin — not GPS and not the saved address.
    if (!_programmaticMove && locationSource.value != "map") {
      locationSource.value = "map";
    }
  }

  void onCameraIdle() {
    _programmaticMove = false;
    getAddressFromLatLng(currentPosition.value);
  }

  // ------------------------------------------------------------ current

  Future<void> getCurrentLocation() async {
    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      // if (!serviceEnabled) {
      //   if (Platform.isAndroid) {
      //     locationPermissionDialog();
      //     return;
      //   }
      //   debugPrint("Location services are disabled.");
      // }

      LocationPermission permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied ||
          permission == LocationPermission.deniedForever) {
        locationPermissionDialog();
        debugPrint("Location permission not granted.");
        return;
      }

      isLocating.value = true;

      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      locationSource.value = "gps";
      currentPosition.value = LatLng(position.latitude, position.longitude);

      markers.clear();
      markers.add(
        Marker(
          markerId: const MarkerId("current_location"),
          position: currentPosition.value,
          infoWindow: InfoWindow(title: "", snippet: currentAddress.value),
        ),
      );

      moveCameraTo(currentPosition.value);

      await _getAddressFromPosition(position);
    } catch (e) {
      debugPrint("Error getting location: $e");
    } finally {
      // The progress dialog used to be left up on every early return.
      isLocating.value = false;
    }
  }

  Future<void> _getAddressFromPosition(Position position) async {
    try {
      List<Placemark> placemarks =
          await placemarkFromCoordinates(position.latitude, position.longitude);
      _applyPlacemark(placemarks.first,
          lat: position.latitude.toString(),
          lng: position.longitude.toString());
    } catch (e) {
      debugPrint("reverse geocode failed: $e");
    }
  }

  Future<void> getAddressFromLatLng(LatLng position) async {
    try {
      List<Placemark> placemarks =
          await placemarkFromCoordinates(position.latitude, position.longitude);
      _applyPlacemark(placemarks.first,
          lat: position.latitude.toString(),
          lng: position.longitude.toString());
    } catch (e) {
      debugPrint("reverse geocode failed: $e");
    }
  }

  void _applyPlacemark(Placemark place,
      {required String lat, required String lng}) {
    Constants.jobPostingLat = lat;
    Constants.jobPostingLng = lng;
    Constants.jobPostingCity = place.locality ?? "";
    Constants.jobPostingCountry = place.country ?? "";
    Constants.jobPostingPostcode = place.postalCode ?? "";
    Constants.jobPostingState = place.administrativeArea ?? "";

    final parts = [
      place.street,
      place.locality,
      place.administrativeArea,
      place.country,
    ].where((p) => p != null && p.trim().isNotEmpty).toList();

    currentAddress.value = parts.join(", ");
    currentCity.value = place.locality ?? place.administrativeArea ?? "";
    controllerTextField.text = currentAddress.value;
  }

  // ------------------------------------------------------- saved address

  Future<void> loadSavedLocation() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final raw = prefs.getString(_prefsKey);
      if (raw == null || raw.isEmpty) return;

      final loc = SavedLocation.fromJson(jsonDecode(raw));
      if (loc.isUsable) savedLocation.value = loc;
    } catch (e) {
      debugPrint("loadSavedLocation failed: $e");
    }
  }

  /// Overwrites the one remembered address. Called when the job is posted.
  Future<void> saveLastLocation() async {
    try {
      if (Constants.jobPostingLat.isEmpty ||
          Constants.jobPostingLng.isEmpty ||
          currentAddress.value.trim().isEmpty) {
        return;
      }

      final loc = SavedLocation(
        address: currentAddress.value.trim(),
        city: Constants.jobPostingCity,
        state: Constants.jobPostingState,
        country: Constants.jobPostingCountry,
        postcode: Constants.jobPostingPostcode,
        lat: Constants.jobPostingLat,
        lng: Constants.jobPostingLng,
      );

      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_prefsKey, jsonEncode(loc.toJson()));
      savedLocation.value = loc;
    } catch (e) {
      debugPrint("saveLastLocation failed: $e");
    }
  }

  Future<void> deleteSavedLocation() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_prefsKey);
      savedLocation.value = null;
      if (locationSource.value == "saved") locationSource.value = "gps";
    } catch (e) {
      debugPrint("deleteSavedLocation failed: $e");
    }
  }

  void applySavedLocation(SavedLocation loc) {
    final lat = double.tryParse(loc.lat);
    final lng = double.tryParse(loc.lng);
    if (lat == null || lng == null) return;

    locationSource.value = "saved";

    Constants.jobPostingLat = loc.lat;
    Constants.jobPostingLng = loc.lng;
    Constants.jobPostingCity = loc.city;
    Constants.jobPostingState = loc.state;
    Constants.jobPostingCountry = loc.country;
    Constants.jobPostingPostcode = loc.postcode;

    currentAddress.value = loc.address;
    currentCity.value = loc.city;
    controllerTextField.text = loc.address;
    currentPosition.value = LatLng(lat, lng);

    moveCameraTo(currentPosition.value);
  }

  /// Called from the search field once a prediction resolves.
  void applySearchResult(String description, double lat, double lng) {
    locationSource.value = "search";

    Constants.jobPostingLat = lat.toString();
    Constants.jobPostingLng = lng.toString();

    currentAddress.value = description;
    controllerTextField.text = description;
    controllerTextField.selection = TextSelection.collapsed(
      offset: controllerTextField.text.length,
    );

    currentPosition.value = LatLng(lat, lng);

    markers.add(
      Marker(
        markerId: const MarkerId("current_location"),
        position: currentPosition.value,
        infoWindow:
            InfoWindow(title: "You are here", snippet: currentAddress.value),
      ),
    );

    moveCameraTo(currentPosition.value, animate: false);
  }

  /// Empties the search box only. The pin, address and coordinates stay
  /// as they are, so clearing what you typed does not invalidate the
  /// location already chosen.
  void clearSearch() {
    controllerTextField.clear();
  }

  // Reads currentAddress rather than the raw text field: with a clear
  // button the field can be empty while a perfectly good location is
  // still selected on the map.
  bool get canPost =>
      currentAddress.value.trim().isNotEmpty &&
      Constants.jobPostingLat.isNotEmpty &&
      Constants.jobPostingLng.isNotEmpty;

  @override
  void onClose() {
    WidgetsBinding.instance.removeObserver(this);
    controllerTextField.dispose();
    mapController?.dispose();
    super.onClose();
  }

  void locationPermissionDialog() async {
    return Get.dialog(
      Dialog(
        backgroundColor: Colors.white,
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(14.r)),
        insetPadding: EdgeInsets.symmetric(horizontal: 24.w),
        child: Padding(
          padding: EdgeInsets.all(18.0.r),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: EdgeInsets.all(12.r),
                decoration: BoxDecoration(
                  color: const Color(MyColors.themeRedColor)
                      .withValues(alpha: 0.10),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.location_off,
                  color: const Color(MyColors.themeRedColor),
                  size: 24.sp,
                ),
              ),
              SizedBox(height: 14.h),
              AutoSizeText(
                Strings.permissionDenied(Get.context!),
                maxFontSize: 16,
                minFontSize: 12,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 13,
                  fontFamily: 'Poppins',
                  color: Colors.black,
                ),
              ),
              SizedBox(height: 8.h),
              AutoSizeText(
                Strings.mapPermissionDeniedDesc(Get.context!),
                maxFontSize: 13,
                minFontSize: 9,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 13,
                  fontFamily: 'Poppins',
                  color: Colors.grey,
                ),
              ),
              SizedBox(height: 20.h),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(
                            color: Color(MyColors.lightSilverColor)),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.r),
                        ),
                        padding: EdgeInsets.symmetric(vertical: 12.h),
                      ),
                      onPressed: () => Get.back(),
                      child: AutoSizeText(
                        Strings.cancelText(Get.context!),
                        maxFontSize: 14,
                        minFontSize: 11,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 14,
                          fontFamily: 'Poppins',
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 12.w),
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(MyColors.themeRedColor),
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.r),
                        ),
                        padding: EdgeInsets.symmetric(vertical: 12.h),
                      ),
                      onPressed: () async {
                        Get.back();
                        _returningFromSettings = true;
                        await Geolocator.openAppSettings();
                      },
                      child: AutoSizeText(
                        Strings.goToSettingsText(Get.context!),
                        maxFontSize: 14,
                        minFontSize: 9,
                        maxLines: 1,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 14,
                          fontFamily: 'Poppins',
                          color: Colors.white,
                        ),
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
}
