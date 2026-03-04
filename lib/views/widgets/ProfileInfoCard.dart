import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:workforceclientapp/Others/MyColors.dart';
import 'package:workforceclientapp/views/widgets/Headingdescription.dart';

class ProfileInfoCard extends StatelessWidget {
  final String text;
  final String icon;
  final VoidCallback onPressed;

  const ProfileInfoCard(
      {super.key,
      required this.text,
      required this.icon,
      required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Card(
        elevation: 0,
        color: const Color(MyColors.whiteColor),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Center(
              child: Row(
            children: [
              SvgPicture.asset(
                icon,
                height: 20,
                width: 20,
                fit: BoxFit.contain,
              ),
              Expanded(
                  child: Padding(
                padding: const EdgeInsets.only(left: 12.0),
                child: Headingdescription(
                    text: text, centerAlign: false, size: 14),
              )),
              const Align(
                alignment: Alignment.centerRight,
                child: Icon(
                  Icons.arrow_forward_ios,
                  size: 18,
                ),
              )
            ],
          )),
        ),
      ),
    );
  }
}
