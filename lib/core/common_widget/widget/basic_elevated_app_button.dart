import 'package:shiftwheels/core/config/theme/app_colors.dart';
import 'package:flutter/material.dart';

class BasicElevatedAppButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String title;
  final double? height;
  final Color? backgroundcolor;
  final Color? textcolor;
  final String? image;
  final bool isLoading;

  const BasicElevatedAppButton({
    super.key,
    required this.onPressed,
    required this.title,
    this.height,
    this.backgroundcolor,
    this.textcolor,
    this.image,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: isLoading ? null : onPressed,
      style: ElevatedButton.styleFrom(
        minimumSize: Size.fromHeight(height ?? 50),
        backgroundColor: backgroundcolor ?? AppColors.zPrimaryColor,
      ),
      child: isLoading
          ? const SizedBox(
              height: 24,
              width: 24,
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(AppColors.zPrimaryColor),
                strokeWidth: 3,
              ),
            )
          : Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (image != null) ...[
                  Image.asset(
                    image!,
                    height: 40,
                    width: 40,
                  ),
                  const SizedBox(width: 8),
                ],
                Text(
                  title,
                  style: TextStyle(
                    color: textcolor ?? AppColors.zWhite,
                    fontSize: 25,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
    );
  }
}