import 'package:flutter/material.dart';

class CustomTextFormFied extends StatelessWidget {
  final TextEditingController controller;
  final TextInputType keyboardType;
  final String hintText;
  final String? Function(String?)? validator;
  final bool obscureText;

  const CustomTextFormFied({
    Key? key,
    required this.controller,
    required this.hintText,
    this.keyboardType = TextInputType.text,
    this.validator,
    this.obscureText = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      style: const TextStyle(color: Colors.white),
      obscureText: obscureText,
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.grey[800],
        hintText: hintText,
        hintStyle: const TextStyle(color: Colors.white70),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
          borderSide: const BorderSide(color: Colors.transparent),
        ),
      ),
      validator: validator,
    );
  }
}
