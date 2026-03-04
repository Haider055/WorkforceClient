import 'package:flutter/material.dart';

class OptVerificationTextField extends StatelessWidget {
  final TextEditingController controller;
  final ValueChanged<String> callback;
  final int outlineTextColor;
  final FocusNode focusNode;

  const OptVerificationTextField(
      {super.key,
      required this.controller,
      required this.outlineTextColor,
      required this.callback,
      required this.focusNode});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Padding(
        padding: const EdgeInsets.all(4.0),
        child: SizedBox(
          width: 45, // Set width for rectangular box
          child: TextField(
            controller: controller,
            focusNode: focusNode,
            cursorColor: Colors.black,
            showCursor: true,
            textAlign: TextAlign.center,
            keyboardType: TextInputType.number,
            maxLength: 1, // Allow only 1 digit
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
            decoration: InputDecoration(
              counterText: "", // Hide character counter
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.0), // Rectangular shape
                borderSide:
                    BorderSide(color: Color(outlineTextColor), width: 1),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.0),
                borderSide:
                    BorderSide(color: Color(outlineTextColor), width: 1),
              ),
              enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                  borderSide:
                      BorderSide(color: Color(outlineTextColor), width: 1)),
            ),
            onChanged: callback,
          ),
        ),
      ),
    );
  }
}
