import 'package:flutter/material.dart';

class Rectangleindicator extends StatelessWidget {
  final int color;
  final double size;
  const Rectangleindicator(
      {super.key, required this.size, required this.color});
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Padding(
        padding: const EdgeInsets.only(bottom: 25.0, left: 5.0),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(15),
          child: Container(
            width: size.toDouble(),
            height: 6.5,
            color: Color(color),
          ),
        ),
      ),
    );
  }
}
