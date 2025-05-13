import 'package:flutter/material.dart';
import 'package:shiftwheels/core/config/theme/app_colors.dart';

class ListWidget extends StatelessWidget {
  final String text;

  const ListWidget({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      height: 65,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: isDark ? AppColors.zSecondBackground : Colors.white,
        borderRadius: BorderRadius.circular(5),
        border:
            isDark ? null : Border.all(width: 1.5, color: AppColors.zfontColor),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(text, style: TextStyle(color: theme.textTheme.bodyLarge?.color)),
          const Icon(Icons.arrow_drop_down_outlined),
        ],
      ),
    );
  }
}
