import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:workforceclientapp/Others/Constants.dart';

class KeyboardDismissOverlay extends StatelessWidget {
  final Widget child;

  final bool enabled;

  const KeyboardDismissOverlay({
    super.key,
    required this.child,
    this.enabled = true,
  });

  @override
  Widget build(BuildContext context) {
    final double keyboardHeight = MediaQuery.of(context).viewInsets.bottom;
    final bool keyboardOpen = keyboardHeight > 0;

    return Stack(
      children: [
        child,
        if (enabled && keyboardOpen)
          Positioned(
            right: 12.w,
            bottom: keyboardHeight + 5.h,
            child: !Constants.inConversationScreen.value
                ? _DismissButton()
                : const SizedBox(),
          ),
      ],
    );
  }
}

class _DismissButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.black.withValues(alpha: 0.78),
      shape: const CircleBorder(),
      elevation: 3,
      child: InkWell(
        customBorder: const CircleBorder(),
        onTap: () {
          // Not FocusScope.of(context).unfocus() — that does not reliably
          // drop focus and is what caused the keyboard flicker on Register.
          FocusManager.instance.primaryFocus?.unfocus();
        },
        child: Padding(
          padding: EdgeInsets.all(11.r),
          child: Icon(
            Icons.keyboard_hide_outlined,
            color: Colors.white,
            size: 22.sp,
          ),
        ),
      ),
    );
  }
}
