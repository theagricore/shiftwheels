import 'package:flutter/material.dart';
import 'package:shiftwheels/core/config/theme/app_colors.dart';
import 'package:shimmer/shimmer.dart';

class ShimmerCard extends StatelessWidget {
  const ShimmerCard({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final baseColor = isDarkMode ? AppColors.zDarkGrey : Colors.grey[300]!;
    final highlightColor = isDarkMode ? AppColors.zLightGrey : Colors.grey[100]!;
    final shimmerColor = isDarkMode ? AppColors.zDarkGrey.withOpacity(0.5) : Colors.white;

    return ListView.builder(
      itemCount: 10,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      itemBuilder: (_, __) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Shimmer.fromColors(
            baseColor: baseColor,
            highlightColor: highlightColor,
            child: Row(
              children: [
                Container(
                  width: 52,
                  height: 52,
                  decoration: BoxDecoration(
                    color: shimmerColor,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        height: 16,
                        width: double.infinity,
                        color: shimmerColor,
                      ),
                      const SizedBox(height: 8),
                      Container(
                        height: 14, 
                        width: 120, 
                        color: shimmerColor,
                      ),
                      const SizedBox(height: 8),
                      Container(
                        height: 12, 
                        width: 80, 
                        color: shimmerColor,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}