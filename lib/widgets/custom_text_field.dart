import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final String label;
  final bool obscureText;
  final TextEditingController? controller;
  final String? validatorMessage;
  final String? Function(String?)? validator;
  final TextInputType? keyboardType;
  final Function(String)? onChanged;
  final Widget? suffixIcon;
  final int? maxLength;

  CustomTextField({
    required this.label,
    this.obscureText = false,
    this.controller,
    this.validatorMessage,
    this.validator,
    this.keyboardType,
    this.onChanged,
    this.suffixIcon,
    this.maxLength,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 315,
      height: 60,
      child: TextFormField(
        controller: controller,
        obscureText: obscureText,
        keyboardType: keyboardType,
        onChanged: onChanged,
        maxLength: maxLength,
        decoration: InputDecoration(
          labelText: label,
          labelStyle: TextStyle(
            fontFamily: 'Montserrat',
            fontWeight: FontWeight.w400,
            fontSize: 12,
            height: 1,
            letterSpacing: -0.02 * 12,
            color: Color(0xFF3C4D18).withOpacity(0.5),
          ),
          suffixIcon: suffixIcon,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
            borderSide: BorderSide(color: Color(0xFF3C4D18)),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
            borderSide: BorderSide(color: Color(0xFF3C4D18)),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
            borderSide: BorderSide(color: Color(0xFF3C4D18)),
          ),
          filled: true,
          fillColor: Color(0x1CFA9500), // #FA95001C
          counterText: maxLength != null ? '' : null, // Esconde o contador de caracteres
          contentPadding: EdgeInsets.symmetric(horizontal: 15, vertical: 21),
        ),
        validator: validator ??
                (value) {
              if (value == null || value.isEmpty && validatorMessage != null) {
                return validatorMessage;
              }
              return null;
            },
      ),
    );
  }
}