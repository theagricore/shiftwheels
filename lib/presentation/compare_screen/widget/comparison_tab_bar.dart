import 'package:flutter/material.dart';
import 'package:shiftwheels/core/config/theme/app_colors.dart'; 
import 'package:shiftwheels/presentation/compare_screen/compare_screen.dart';
import 'package:shiftwheels/presentation/compare_screen/widget/saved_comparisons_widget.dart';

class ComparisonTabBar extends StatelessWidget {
  const ComparisonTabBar({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    final isDarkMode = theme.brightness == Brightness.dark;

    return LayoutBuilder(
      builder: (context, constraints) {
        final isWeb = constraints.maxWidth > 600;

        return MediaQuery(
          data: MediaQuery.of(
            context,
          ).copyWith(textScaleFactor: isWeb ? 0.9 : 1.0),
          child: DefaultTabController(
            length: 2,
            child: Scaffold(
              backgroundColor:
                  isDarkMode ? AppColors.zBackGround : AppColors.zWhite,
              appBar: AppBar(
                leading: IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: Icon(
                    Icons.keyboard_arrow_left,
                    color:
                        isDarkMode ? AppColors.zWhite : AppColors.zBackGround,
                  ),
                ),
                elevation: 4,
                centerTitle: true,
                backgroundColor:
                    isDarkMode
                        ? AppColors.zDarkBackground
                        : AppColors.zWhite,
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.vertical(
                    bottom: Radius.circular(20),
                  ),
                ),
                title: Text(
                  'Compare Cars',
                  style: textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color:
                        isDarkMode
                            ? AppColors.zDarkPrimaryText
                            : AppColors
                                .zLightPrimaryText, // Theme-aware title color
                    fontSize: isWeb ? 24 : null, // Adjust font size for web
                  ),
                ),
                bottom: PreferredSize(
                  preferredSize: Size.fromHeight(
                    isWeb ? 64 : 56,
                  ), // Increased height for tabs
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal:
                          isWeb ? 32 : 16, // Adjusted horizontal padding
                      vertical: isWeb ? 10 : 8, // Adjusted vertical padding
                    ),
                    child: Container(
                      decoration: BoxDecoration(
                        color:
                            isDarkMode
                                ? AppColors.zDarkCardBackground
                                : AppColors
                                    .zWhite, // Theme-aware background for tab container
                        borderRadius: BorderRadius.circular(
                          14,
                        ), // Rounded corners for the tab container
                        boxShadow: [
                          BoxShadow(
                            color: (isDarkMode
                                    ? Colors.black
                                    : Colors.grey.shade300)
                                .withOpacity(0.3),
                            spreadRadius: 1,
                            blurRadius: 6,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: TabBar(
                        // Removed the line by using a custom indicator
                        indicator: BoxDecoration(
                          borderRadius: BorderRadius.circular(
                            12,
                          ), // Rounded indicator
                          color: AppColors.zPrimaryColor, // Active tab color
                        ),
                        labelColor:
                            AppColors
                                .zblack, // Active label color (always black for contrast on primary)
                        unselectedLabelColor:
                            isDarkMode
                                ? AppColors.zDarkSecondaryText
                                : AppColors.zfontColor, // Inactive label color
                        labelStyle: textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w700, // Bolder active label
                          fontSize:
                              isWeb
                                  ? 17
                                  : null, // Slightly larger font for clarity
                        ),
                        unselectedLabelStyle: textTheme.titleMedium?.copyWith(
                          fontWeight:
                              FontWeight
                                  .w500, // Medium weight for inactive label
                          fontSize: isWeb ? 17 : null,
                        ),
                        indicatorSize:
                            TabBarIndicatorSize
                                .tab, // Make indicator fill the tab
                        dividerColor:
                            Colors
                                .transparent, // Remove divider line between tabs
                        splashBorderRadius: BorderRadius.circular(
                          12,
                        ), // Splash effect matches indicator
                        tabs: const [
                          Tab(text: 'New Comparison'),
                          Tab(text: 'Saved Comparisons'),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              body: const TabBarView(
                children: [CompareScreen(), SavedComparisonsWidget()],
              ),
            ),
          ),
        );
      },
    );
  }
}
