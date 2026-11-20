import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:upgrader/upgrader.dart';
import 'package:workforceclientapp/Others/MyColors.dart';
import 'package:workforceclientapp/Others/Strings.dart';

class CheckUpdateScreen extends StatefulWidget {
  const CheckUpdateScreen({super.key});

  @override
  State<CheckUpdateScreen> createState() => _CheckUpdateScreenState();
}

class _CheckUpdateScreenState extends State<CheckUpdateScreen> {
  Upgrader _upgrader = Upgrader(
    durationUntilAlertAgain: Duration.zero,
  );

  bool _loading = true;
  bool _updateAvailable = false;
  String _currentVersion = '';
  String _storeVersion = '';

  @override
  void initState() {
    super.initState();
    _checkUpdate();
  }

  Future<void> _checkUpdate() async {
    _upgrader = Upgrader(
      durationUntilAlertAgain: Duration.zero,
    );
    setState(() => _loading = true);

    try {
      await _upgrader.initialize();

      final hasUpdate = _upgrader.isUpdateAvailable();
      final current = _upgrader.currentInstalledVersion ?? '';
      final store = _upgrader.currentAppStoreVersion ?? '';

      setState(() {
        _updateAvailable = hasUpdate;
        _currentVersion = current;
        _storeVersion = store;
        _loading = false;
      });
    } catch (e) {
      setState(() {
        _loading = false;
        _updateAvailable = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: true,
        shape: const Border(
          bottom: BorderSide(color: Color(0xFFEDEDEF)),
        ),
        leading: IconButton(
          icon:
              Icon(Icons.arrow_back_ios_new, size: 18.sp, color: Colors.black),
          onPressed: Get.back,
        ),
        title: Text(
          Strings.updateText(Get.context!),
          style: TextStyle(
            fontSize: 17.sp,
            fontWeight: FontWeight.w600,
            fontFamily: 'Poppins',
            color: Colors.black,
          ),
        ),
      ),
      body: _loading ? _buildLoading() : _buildContent(),
    );
  }

  Widget _buildLoading() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const CircularProgressIndicator(
            color: Color(MyColors.themeRedColor),
          ),
          SizedBox(height: 20.h),
          Text(
            Strings.checkingForUpdates(Get.context!),
            style: TextStyle(
              fontSize: 14.sp,
              fontFamily: 'Poppins',
              color: const Color(MyColors.darkGrayColor),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContent() {
    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Icon
            Container(
              width: 90.r,
              height: 90.r,
              decoration: BoxDecoration(
                color: _updateAvailable
                    ? const Color(MyColors.themeRedColor)
                        .withValues(alpha: 0.08)
                    : const Color(0xFFE8F5E9),
                shape: BoxShape.circle,
              ),
              child: Icon(
                _updateAvailable
                    ? Icons.system_update_rounded
                    : Icons.check_circle_outline_rounded,
                size: 44.r,
                color: _updateAvailable
                    ? const Color(MyColors.themeRedColor)
                    : const Color(0xFF4CAF50),
              ),
            ),
            SizedBox(height: 24.h),

            // Title
            Text(
              _updateAvailable
                  ? Strings.updateAvailableText(Get.context!)
                  : Strings.youareuptodateText(Get.context!),
              textAlign: TextAlign.center,
              maxLines: 2,
              style: TextStyle(
                fontSize: 22.sp,
                fontWeight: FontWeight.w700,
                fontFamily: 'Poppins',
                color: Colors.black,
              ),
            ),
            SizedBox(height: 10.h),

            // Description
            Text(
              _updateAvailable
                  ? Strings.updateAppDesc1(Get.context!)
                  : Strings.updateAppDesc2(Get.context!),
              textAlign: TextAlign.center,
              maxLines: 3,
              style: TextStyle(
                fontSize: 14.sp,
                fontFamily: 'Poppins',
                color: const Color(MyColors.darkGrayColor),
                height: 1.5,
              ),
            ),
            SizedBox(height: 20.h),

            // Version info
            Container(
              padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 12.h),
              decoration: BoxDecoration(
                color: const Color(0xFFF7F7F8),
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'v$_currentVersion',
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w600,
                      fontFamily: 'Poppins',
                      color: Colors.black,
                    ),
                  ),
                  if (_updateAvailable) ...[
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 10.w),
                      child: Icon(Icons.arrow_forward_rounded,
                          size: 16.r,
                          color: const Color(MyColors.themeRedColor)),
                    ),
                    Text(
                      'v$_storeVersion',
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w600,
                        fontFamily: 'Poppins',
                        color: const Color(MyColors.themeRedColor),
                      ),
                    ),
                  ],
                ],
              ),
            ),
            SizedBox(height: 30.h),

            // Button
            if (_updateAvailable)
              SizedBox(
                width: double.infinity,
                height: 50.h,
                child: ElevatedButton(
                  onPressed: () => _upgrader.sendUserToAppStore(),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(MyColors.themeRedColor),
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14.r),
                    ),
                  ),
                  child: Text(
                    Strings.updateNowText(context),
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w600,
                      fontFamily: 'Poppins',
                    ),
                  ),
                ),
              )
            else
              SizedBox(
                width: double.infinity,
                height: 50.h,
                child: OutlinedButton(
                  onPressed: () => _checkUpdate(),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: const Color(MyColors.themeRedColor),
                    side: const BorderSide(
                      color: Color(MyColors.themeRedColor),
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14.r),
                    ),
                  ),
                  child: Text(
                    Strings.checkAgainText(Get.context!),
                    style: TextStyle(
                      fontSize: 15.sp,
                      fontWeight: FontWeight.w600,
                      fontFamily: 'Poppins',
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
