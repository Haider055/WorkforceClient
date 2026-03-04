import 'package:flutter/material.dart';
import 'package:workforceclientapp/Others/MyColors.dart';

class CommonTextFieldWhite extends StatefulWidget {
  final String hint;
  final Icon prefixIcon;
  final bool needPasswordSuffixIcon;
  final bool needprefixIcon;
  final TextEditingController controller;
  final TextInputType inputType;
  final String errorText;
  final Function(String)? onChanged;
  final Function()? onTap;
  final Function()? onTapOutside;

  const CommonTextFieldWhite({
    super.key,
    required this.hint,
    this.onChanged,
    this.onTap,
    this.onTapOutside,
    required this.errorText,
    required this.controller,
    required this.prefixIcon,
    required this.inputType,
    required this.needPasswordSuffixIcon,
    required this.needprefixIcon,
  });

  @override
  State<CommonTextFieldWhite> createState() => _CommonTextFieldState();
}

class _CommonTextFieldState extends State<CommonTextFieldWhite> {
  late bool _isPasswordHidden;

  @override
  void initState() {
    super.initState();
    _isPasswordHidden = true;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 19.0),
      child: TextFormField(
        controller: widget.controller,
        keyboardType: widget.inputType,
        maxLines: 1,
        onChanged: widget.onChanged,
        obscureText: widget.needPasswordSuffixIcon ? _isPasswordHidden : false,
        obscuringCharacter: "*",
        validator: (value) {
          if (value == null || value.isEmpty) {
            return "Field cannot be empty!";
          } else if (value.length < 3) {
            return "Must be at least 3 characters long!";
          }
          return null;
        },
        decoration: InputDecoration(
          hintText: widget.hint,
          errorText: widget.errorText.isEmpty ? null : widget.errorText,
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.0),
            borderSide: BorderSide(
              width: 2.0,
              color: Colors.red.withOpacity(0.7),
            ),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.0),
            borderSide: BorderSide(
              width: 2.0,
              color: Colors.red.withOpacity(0.7),
            ),
          ),
          filled: true,
          fillColor: widget.errorText.isEmpty
              ? const Color(MyColors.whiteColor)
              : Colors.red.withOpacity(0.12),
          hintStyle: const TextStyle(
            fontFamily: 'Poppins',
            fontSize: 16.0,
            color: Color(0x66000000),
            fontWeight: FontWeight.w400,
          ),
          prefixIcon: widget.needprefixIcon ? widget.prefixIcon : null,
          prefixIconColor: const Color(0x66000000),
          suffixIcon: widget.needPasswordSuffixIcon
              ? IconButton(
                  icon: Icon(
                    _isPasswordHidden ? Icons.visibility_off : Icons.visibility,
                  ),
                  onPressed: () {
                    setState(() {
                      _isPasswordHidden = !_isPasswordHidden;
                    });
                  },
                )
              : null,
          suffixIconColor: const Color(0x66000000),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16.0,
            vertical: 14.0,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.0),
            borderSide: const BorderSide(
              width: 2.0,
              color: Color(MyColors.fieldBorderColor),
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.0),
            borderSide: const BorderSide(
              width: 2.0,
              color: Color(MyColors.fieldBorderColor),
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.0),
            borderSide: const BorderSide(
              width: 2.0,
              color: Color(MyColors.fieldBorderColor),
            ),
          ),
        ),
      ),
    );
  }
}
