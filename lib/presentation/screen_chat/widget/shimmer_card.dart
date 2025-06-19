import 'package:flutter/material.dart';
import 'package:shiftwheels/core/config/theme/app_colors.dart';
import 'package:shimmer/shimmer.dart';

class ShimmerCard extends StatelessWidget {
  const ShimmerCard({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: 10,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      itemBuilder: (_, __) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Shimmer.fromColors(
            baseColor: AppColors.zSecondBackground,
            highlightColor: AppColors.zBackGround,
            child: Row(
              children: [
                Container(
                  width: 52,
                  height: 52,
                  decoration: BoxDecoration(
                    color: Colors.white,
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
                        color: Colors.white,
                      ),
                      const SizedBox(height: 6),
                      Container(height: 14, width: 120, color: Colors.white),
                      const SizedBox(height: 6),
                      Container(height: 12, width: 80, color: Colors.white),
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

