import 'package:flutter/material.dart';

class Skipandnexttext extends StatelessWidget {
  final String text;
  const Skipandnexttext({required this.text, super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text(text,
            style: const TextStyle(
                color: Colors.black,
                fontSize: 16.0,
                fontWeight: FontWeight.w600,
                fontFamily: 'Poppins')),
      ),
    );
  }
}
