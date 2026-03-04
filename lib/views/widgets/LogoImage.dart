import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class LogoImage extends StatelessWidget {
  const LogoImage({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SvgPicture.asset("lib/assets/icons/auftragnowRedBalck.svg",
          fit: BoxFit.contain, height: 26.0, width: 146.0),
    );
  }
}
