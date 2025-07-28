import 'package:flutter/material.dart';
import 'package:shiftwheels/core/config/theme/app_colors.dart';
import 'package:shiftwheels/presentation/compare_screen/compare_screen.dart';
import 'package:shiftwheels/presentation/compare_screen/widget/saved_comparisons_widget.dart';

class ComparisonTabBar extends StatelessWidget {
  const ComparisonTabBar({super.key});

  @override
  Widget build(BuildContext context) {
    final isDarkMode =
        MediaQuery.of(context).platformBrightness == Brightness.dark;
    final theme = Theme.of(context);
    final backgroundColor =
        isDarkMode ? AppColors.zDarkBackground : AppColors.zLightAccentColor;
    final appBarColor =
        isDarkMode ? AppColors.zDarkBackground : AppColors.zLightAccentColor;
    final selectedTabColor =
        isDarkMode ? AppColors.zWhite : AppColors.zblack;
    final unselectedTabColor =
        isDarkMode ? AppColors.zDarkIconColor : AppColors.zWhite;
    final tabIndicatorColor =
        isDarkMode ? AppColors.zDarkAccentColor : AppColors.zWhite;

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: backgroundColor,
        appBar: AppBar(
          elevation: 2,
          backgroundColor: appBarColor,
          centerTitle: true,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(
              bottom: Radius.circular(16),
            ),
          ),
          title: Text(
            'Compare Cars',
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
              color: selectedTabColor,
            ),
          ),
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(48),
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: isDarkMode
                    ? AppColors.zDarkAccentColor.withOpacity(0.2)
                    : AppColors.zLightAccentColor.withOpacity(0.2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: TabBar(
                indicator: BoxDecoration(
                  color: tabIndicatorColor,
                  borderRadius: BorderRadius.circular(10),
                ),
                indicatorSize: TabBarIndicatorSize.tab,
                labelColor: selectedTabColor,
                unselectedLabelColor: unselectedTabColor,
                labelStyle: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
                unselectedLabelStyle: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w400,
                ),
                tabs: const [
                  Tab(text: 'New Comparison'),
                  Tab(text: 'Saved Comparisons'),
                ],
              ),
            ),
          ),
        ),
        body: const TabBarView(
          children: [
            CompareScreen(),
            SavedComparisonsWidget(),
          ],
        ),
      ),
    );
  }
}
