import 'dart:async';
import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:workforceclientapp/Controllers/AllChatsContoller.dart';
import 'package:workforceclientapp/Controllers/NotificationScreenContoller.dart';
import 'package:workforceclientapp/Controllers/PostedOrdersController.dart';
import 'package:workforceclientapp/Controllers/SelectServiceController.dart';
import 'package:workforceclientapp/Others/Commons.dart';
import 'package:workforceclientapp/Others/MyColors.dart';
import 'package:workforceclientapp/Others/Strings.dart';

class NetworkController extends GetxController {
  final Connectivity _connectivity = Connectivity();

  // connectivity_plus 6.x emits a List. On 5.x and below this is
  // StreamSubscription<ConnectivityResult> instead.
  StreamSubscription<List<ConnectivityResult>>? _subscription;

  /// Watch this anywhere in the app: Obx(() => ...isOnline.value...)
  final RxBool isOnline = true.obs;

  bool _offlineBannerShown = false;
  bool _firstCheckDone = false;

  @override
  void onInit() {
    super.onInit();
    _init();
  }

  Future<void> _init() async {
    final result = await _connectivity.checkConnectivity();
    await _handleChange(result);
    _subscription = _connectivity.onConnectivityChanged.listen(_handleChange);
  }

  Future<void> _handleChange(List<ConnectivityResult> results) async {
    final hasInterface =
        results.isNotEmpty && !results.contains(ConnectivityResult.none);

    // An interface alone doesn't mean the internet works (captive portals,
    // router with no uplink), so confirm with a real lookup.
    final online = hasInterface && await _hasRealInternet();

    final wasOnline = isOnline.value;
    isOnline.value = online;

    if (!_firstCheckDone) {
      _firstCheckDone = true;
      // On a cold start only complain if we're actually offline;
      // never greet the user with "back online".
      if (!online) _showOfflineBanner();
      return;
    }

    if (wasOnline == online) return; // no real change, ignore

    if (online) {
      _showBackOnline();
    } else {
      _showOfflineBanner();
    }
  }

  Future<bool> _hasRealInternet() async {
    try {
      final result = await InternetAddress.lookup('one.one.one.one')
          .timeout(const Duration(seconds: 3));
      return result.isNotEmpty && result.first.rawAddress.isNotEmpty;
    } catch (_) {
      return false;
    }
  }

  void _showOfflineBanner() {
    if (_offlineBannerShown) return;
    _offlineBannerShown = true;
    Commons.hideProgressDialog();

    Get.rawSnackbar(
      messageText: Text(
        Strings.noInternetText(Get.context!),
        style: const TextStyle(
          color: Colors.white,
          fontSize: 13,
          fontWeight: FontWeight.w500,
          fontFamily: 'Poppins',
        ),
      ),
      icon: const Icon(Icons.wifi_off, color: Colors.white, size: 20),
      backgroundColor: const Color(MyColors.themeRedColor),
      snackPosition: SnackPosition.BOTTOM,
      isDismissible: false,
      margin: EdgeInsets.zero,
      borderRadius: 0,
      duration: null,
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
    );
  }

  void _showBackOnline() async {
    if (_offlineBannerShown) {
      if (Get.isSnackbarOpen) {
        Get.closeCurrentSnackbar();
      }
      _offlineBannerShown = false;
    }
    Commons.hideProgressDialog();
    await Future.delayed(const Duration(seconds: 1));

    Get.rawSnackbar(
      messageText: Text(
        Strings.onlineText(Get.context!),
        style: TextStyle(
          color: Colors.white,
          fontSize: 13.5.sp,
          fontWeight: FontWeight.w500,
          fontFamily: 'Poppins',
        ),
      ),
      icon: const Icon(Icons.wifi, color: Colors.white, size: 20),
      backgroundColor: Colors.green.shade600,
      snackPosition: SnackPosition.BOTTOM,
      isDismissible: true,
      margin: EdgeInsets.zero,
      borderRadius: 0,
      duration: const Duration(seconds: 2),
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
    );
    await Future.delayed(const Duration(seconds: 1));
    if (Get.isRegistered<SelectServiceController>()) {
      Get.find<SelectServiceController>().refreshData();
      // Get.put(AllChatsContoller());
    }
    if (Get.isRegistered<AllChatsContoller>()) {
      Get.find<AllChatsContoller>().refreshData();
    }
    if (Get.isRegistered<PostedOrdersController>()) {
      Get.find<PostedOrdersController>().isLoading.value = false;
      Get.find<PostedOrdersController>().refreshData();
    }
    if (Get.isRegistered<NotificationScreenContoller>()) {
      Get.find<NotificationScreenContoller>().isLoading.value = false;
      Get.find<NotificationScreenContoller>().refreshData();
    }
    // if (Get.isRegistered<AllChatsContoller>()) {
    //   Get.find<AllChatsContoller>().onInit();
    // } else {
    // Get.put(AllChatsContoller());
    // }
    // Get.offAllNamed(AppLinks.select_service_screen);
  }

  /// Call before any API hit if you want to fail fast with a message
  /// instead of waiting out the 5s timeout.
  Future<bool> checkBeforeRequest() async {
    final results = await _connectivity.checkConnectivity();
    final hasInterface =
        results.isNotEmpty && !results.contains(ConnectivityResult.none);
    if (!hasInterface) {
      isOnline.value = false;
      _showOfflineBanner();
      return false;
    }
    return true;
  }

  @override
  void onClose() {
    _subscription?.cancel();
    super.onClose();
  }
}
