
import 'package:flutter/material.dart';

import 'app_color.dart';

class RoundedButton extends StatelessWidget {
  final Color backgroundColor;
  final VoidCallback onPressed;
  final String label;
  final double? height;

  const RoundedButton({
    Key? key,
    this.backgroundColor = AppColor.primary,
    required this.onPressed,
    required this.label, this.height,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      width: double.infinity, // Ensures the button takes the parent's width
      child: ElevatedButton(
        style: ButtonStyle(
          foregroundColor: WidgetStateProperty.all<Color>(Colors.white),
          backgroundColor: WidgetStateProperty.all<Color>(backgroundColor),
          shape: WidgetStateProperty.all<RoundedRectangleBorder>(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(18.0),
            ),
          ),
        ),
        onPressed: onPressed,
        child: Text(
          label,
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w500, fontFamily: 'Poppins')
        ),
      ),
    );
  }
}

class CustomTextButton extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;
  final Color backgroundColor;

  const CustomTextButton({
    Key? key,
    required this.label,
    required this.onPressed,
    this.backgroundColor = AppColor.primary, // Default background color
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextButton(
      style: TextButton.styleFrom(
        foregroundColor: AppColor.primary,
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 0.0), // No horizontal padding
      ),
      onPressed: onPressed,
      child: Text(
        label,
        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
      ),
    );
  }
}
