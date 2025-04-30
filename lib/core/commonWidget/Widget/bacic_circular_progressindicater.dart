import 'package:flutter/material.dart';
import 'package:shiftwheels/core/config/theme/app_colors.dart';

class BacicCircularprogressindicater extends StatelessWidget {
  final String message;
  final Color indicatorColor;
  final TextStyle? textStyle;

  const BacicCircularprogressindicater({
    super.key,
    this.message = 'Loading...',
    this.indicatorColor = AppColors.zPrimaryColor,
    this.textStyle,
  });

  static void show(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      barrierColor: Colors.black54,
      builder: (_) => const Center(
        child: BacicCircularprogressindicater(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
     final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    return Material(
      color: Colors.transparent,
      child: Container(
        padding: const EdgeInsets.all(20),
        margin: const EdgeInsets.symmetric(horizontal: 40),
        decoration: BoxDecoration(
          color: isDark ? AppColors.zSecondBackground : Colors.white,
          borderRadius: BorderRadius.circular(16),
        ),
        child: SizedBox(
          width: 100,
          height: 100,
          child: SizedBox(
            width: 80,
            height: 80,
            child: CircularProgressIndicator(
              color: indicatorColor,
              strokeWidth: 10,
            ),
          ),
        ),
      ),
    );
  }
}