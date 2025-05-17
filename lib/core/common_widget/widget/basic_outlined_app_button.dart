import 'package:flutter/material.dart';
import 'package:shiftwheels/core/config/theme/app_colors.dart';

class BasicOutlinedAppButton extends StatelessWidget {
  final String title;
  final String image;
  final VoidCallback onPressed;
  final double height;
  final bool isLoading;

  const BasicOutlinedAppButton({
    super.key,
    required this.title,
    required this.image,
    required this.onPressed,
    required this.height,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      width: double.infinity,
      child: OutlinedButton(
        onPressed: isLoading ? null : onPressed,
        child: isLoading
            ? const CircularProgressIndicator()
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    image,
                    height: 24,
                    width: 24,
                  ),
                  const SizedBox(width: 10),
                  Text(title,style: TextStyle(color: AppColors.zfontColor),),
                ],
              ),
      ),
    );
  }
}