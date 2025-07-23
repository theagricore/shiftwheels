import 'package:carousel_slider/carousel_options.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:shiftwheels/core/config/theme/app_colors.dart';
import 'package:shimmer/shimmer.dart';

class BrandSectionShimmer extends StatelessWidget {
  const BrandSectionShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final baseColor = isDarkMode ? AppColors.zDarkGrey  :   Colors.grey[300]!;
    final highlightColor =
        isDarkMode ? AppColors.zLightGrey : Colors.grey[100]!;

    return Shimmer.fromColors(
      baseColor: baseColor,
      highlightColor: highlightColor,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 10,),
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
                    color: isDarkMode
                        ? AppColors.zDarkGrey.withOpacity(0.5)
                        : Colors.grey[200],
                    borderRadius: BorderRadius.circular(12), 
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

class AdCardShimmer extends StatelessWidget {
  const AdCardShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Shimmer.fromColors(
      baseColor: isDark ? AppColors.zDarkGrey : Colors.grey[300]!,
      highlightColor: isDark ? AppColors.zLightGrey : Colors.grey[100]!,
      child: Container(
        decoration: BoxDecoration(
          color: isDark ? AppColors.zSecondBackground : Colors.white,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 4,
              child: Container(
                decoration: BoxDecoration(
                  color: isDark ? AppColors.zDarkGrey.withOpacity(0.5) : Colors.grey[200],
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                ),
              ),
            ),
            Expanded(
              flex: 3,
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container( 
                      width: double.infinity,
                      height: 16,
                      color: isDark ? AppColors.zDarkGrey.withOpacity(0.5) : Colors.grey[200],
                      margin: const EdgeInsets.only(bottom: 8),
                    ),
                    Container(
                      width: 100,
                      height: 14,
                      color: isDark ? AppColors.zDarkGrey.withOpacity(0.5) : Colors.grey[200],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class PremiumAdsCarouselShimmer extends StatelessWidget {
  const PremiumAdsCarouselShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final baseColor = isDarkMode ? AppColors.zDarkGrey : Colors.grey[300]!;
    final highlightColor =
        isDarkMode ? AppColors.zLightGrey : Colors.grey[100]!;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 15,),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
          child: Shimmer.fromColors(
            baseColor: baseColor,
            highlightColor: highlightColor,
            child: Container(
              width: 160, 
              height: 24,
              decoration: BoxDecoration(
                color: isDarkMode ? AppColors.zDarkGrey : Colors.grey[300],
                borderRadius: BorderRadius.circular(4),
              ),
            ),
          ),
        ),
        const SizedBox(height: 12), 
        CarouselSlider.builder(
          itemCount: 3, 
          itemBuilder: (context, index, realIndex) {
            return Shimmer.fromColors(
              baseColor: baseColor,
              highlightColor: highlightColor,
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 8),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20), 
                  color: isDarkMode ? AppColors.zDarkGrey : Colors.grey[300],
                ),
              ),
            );
          },
          options: CarouselOptions(
            height: 170, 
            enableInfiniteScroll:true,
            autoPlay: true,
            autoPlayInterval: const Duration(seconds: 5),
            autoPlayAnimationDuration: const Duration(milliseconds: 800),
            enlargeCenterPage: false,
            viewportFraction: 0.88, 
            aspectRatio: 16 / 9,
            pauseAutoPlayOnTouch: true,
            pageSnapping: true,
            scrollPhysics: const BouncingScrollPhysics(),
          ),
        ),
      ],
    );
  }
}
class SimmerWidget extends StatelessWidget {
  const SimmerWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SliverPadding(
      padding: const EdgeInsets.all(16), // Consistent padding
      sliver: SliverGrid(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 16, // Increased spacing
          mainAxisSpacing: 16, // Increased spacing
          childAspectRatio: 0.7,
        ),
        delegate: SliverChildBuilderDelegate(
          (context, index) => const AdCardShimmer(),
          childCount: 6,
        ),
      ),
    );
  }
}
class AdActiveCardShimmer extends StatelessWidget {
  const AdActiveCardShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Shimmer.fromColors(
      baseColor: isDark ? AppColors.zDarkGrey : Colors.grey[300]!,
      highlightColor: isDark ? AppColors.zLightGrey : Colors.grey[100]!,
      child: Card( 
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
        ),
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        elevation: 10,
        color: isDark ? AppColors.zDarkCardBackground : AppColors.zWhite,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AspectRatio(
                aspectRatio: 1.8,
                child: Container(
                  color: isDark ? AppColors.zDarkGrey.withOpacity(0.5) : Colors.grey[200],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: double.infinity,
                      height: 24,
                      color: isDark ? AppColors.zDarkGrey.withOpacity(0.5) : Colors.grey[200],
                      margin: const EdgeInsets.only(bottom: 10),
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width * 0.6,
                      height: 16,
                      color: isDark ? AppColors.zDarkGrey.withOpacity(0.5) : Colors.grey[200],
                      margin: const EdgeInsets.only(bottom: 20),
                    ),
                    Wrap(
                      spacing: 8.0,
                      runSpacing: 8.0,
                      children: List.generate(4, (index) =>
                        Container(
                          width: 80,
                          height: 28,
                          decoration: BoxDecoration(
                            color: isDark ? AppColors.zDarkGrey.withOpacity(0.5) : Colors.grey[200],
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Row(
                      children: List.generate(2, (index) =>
                        Padding(
                          padding: const EdgeInsets.only(right: 16.0),
                          child: Container(
                            width: 100,
                            height: 36,
                            decoration: BoxDecoration(
                              color: isDark ? AppColors.zDarkGrey.withOpacity(0.5) : Colors.grey[200],
                              borderRadius: BorderRadius.circular(30),
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    Align(
                      alignment: Alignment.center,
                      child: Container(
                        width: double.infinity,
                        height: 50,
                        decoration: BoxDecoration(
                          color: isDark ? AppColors.zDarkGrey.withOpacity(0.5) : Colors.grey[200],
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}