import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class CupertinoProgressDialog extends StatelessWidget {
  const CupertinoProgressDialog({super.key, required this.msg});
  final String msg;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 70,
      height: 70,
      child: Center(
        child: Lottie.asset(
          "lib/assets/images/PulseAG.json",
          height: 50,
          width: 50,
          fit: BoxFit.contain,
        ),
      ),
    );
  }
}
