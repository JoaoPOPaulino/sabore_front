import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final String label;
  final bool obscureText;
  final TextEditingController? controller;
  final String? validatorMessage;

  CustomTextField({required this.label, this.obscureText = false, this.controller, this.validatorMessage});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      decoration: InputDecoration(labelText: label),
      validator: (value) => value!.isEmpty ? validatorMessage : null,
    );
  }
}