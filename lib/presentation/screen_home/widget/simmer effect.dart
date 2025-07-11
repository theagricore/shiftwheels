import 'package:flutter/material.dart';
import 'package:shiftwheels/core/config/theme/app_colors.dart';
import 'package:shimmer/shimmer.dart';

class BrandSectionShimmer extends StatelessWidget {
  const BrandSectionShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final baseColor = isDarkMode ? AppColors.zDarkGrey : Colors.grey[300]!;
    final highlightColor = isDarkMode ? AppColors.zLightGrey : Colors.grey[100]!;

    return Shimmer.fromColors(
      baseColor: baseColor,
      highlightColor: highlightColor,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
            child: Container(
              width: 150,
              height: 24,
              decoration: BoxDecoration(
                color: isDarkMode ? AppColors.zDarkGrey.withOpacity(0.5) : Colors.grey[200],
                borderRadius: BorderRadius.circular(4),
              ),
            ),
          ),
          Container(
            height: 40,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: 5,
              separatorBuilder: (_, __) => const SizedBox(width: 10),
              itemBuilder: (context, index) {
                return Container(
                  width: 70,
                  height: 50,
                  decoration: BoxDecoration(
                    color: isDarkMode ? AppColors.zDarkGrey.withOpacity(0.5) : Colors.grey[200],
                    borderRadius: BorderRadius.circular(10),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class AdListShimmer extends StatelessWidget {
  const AdListShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final baseColor = isDarkMode ? AppColors.zDarkGrey : Colors.grey[300]!;
    final highlightColor = isDarkMode ? AppColors.zLightGrey : Colors.grey[100]!;

    return Shimmer.fromColors(
      baseColor: baseColor,
      highlightColor: highlightColor,
      child: GridView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        itemCount: 6,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          childAspectRatio: 0.7,
        ),
        itemBuilder: (context, index) {
          return Container(
            decoration: BoxDecoration(
              color: isDarkMode ? AppColors.zSecondBackground : Colors.white,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 4,
                  child: Container(
                    decoration: BoxDecoration(
                      color: isDarkMode ? AppColors.zDarkGrey.withOpacity(0.5) : Colors.grey[200],
                      borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                    ),
                  ),
                ),
                Expanded(
                  flex: 3,
                  child: Padding(padding: const EdgeInsets.all(12)),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}