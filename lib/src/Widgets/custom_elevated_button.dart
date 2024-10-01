import 'package:flutter/material.dart';

class CustomElevatedButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final String text;
  final bool isLoading;
  final bool enabled;

  const CustomElevatedButton({
    Key? key,
    required this.onPressed,
    required this.text,
    this.isLoading = false,
    this.enabled = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Container(
        decoration: BoxDecoration(
          gradient: enabled
              ? const LinearGradient(
                  colors: [Colors.red, Colors.orange],
                )
              : null,
          color: enabled ? null : Colors.grey,
          borderRadius: const BorderRadius.all(Radius.circular(25)),
        ),
        child: ElevatedButton(
          onPressed: enabled ? onPressed : null,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.transparent,
            shadowColor: Colors.transparent,
            padding: const EdgeInsets.symmetric(vertical: 15),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(25),
            ),
          ),
          child: isLoading
              ? const CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                )
              : Text(
                  text,
                  style: const TextStyle(fontSize: 18, color: Colors.white),
                ),
        ),
      ),
    );
  }
}
