import 'package:flutter/material.dart';

class SplashScreenimage extends StatelessWidget {
  final String path;

  const SplashScreenimage({super.key,required this.path});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Image.asset(
        path,
        height: 357.0,
        width: 287.0,
      ),
    );
  }
}
