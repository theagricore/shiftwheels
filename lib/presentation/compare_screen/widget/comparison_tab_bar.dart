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
                                .zLightPrimaryText, 
                    fontSize: isWeb ? 24 : null, 
                  ),
                ),
                bottom: PreferredSize(
                  preferredSize: Size.fromHeight(
                    isWeb ? 64 : 56,
                  ), 
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal:
                          isWeb ? 32 : 16, 
                      vertical: isWeb ? 10 : 8, 
                    ),
                    child: Container(
                      decoration: BoxDecoration(
                        color:
                            isDarkMode
                                ? AppColors.zDarkCardBackground
                                : AppColors
                                    .zWhite, 
                        borderRadius: BorderRadius.circular(
                          14,
                        ), 
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
                        indicator: BoxDecoration(
                          borderRadius: BorderRadius.circular(
                            12,
                          ),
                          color: AppColors.zPrimaryColor, 
                        ),
                        labelColor:
                            AppColors
                                .zblack, 
                        unselectedLabelColor:
                            isDarkMode
                                ? AppColors.zDarkSecondaryText
                                : AppColors.zfontColor, 
                        labelStyle: textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w700, 
                          fontSize:
                              isWeb
                                  ? 17
                                  : null, 
                        ),
                        unselectedLabelStyle: textTheme.titleMedium?.copyWith(
                          fontWeight:
                              FontWeight
                                  .w500, 
                          fontSize: isWeb ? 17 : null,
                        ),
                        indicatorSize:
                            TabBarIndicatorSize
                                .tab, 
                        dividerColor:
                            Colors
                                .transparent, 
                        splashBorderRadius: BorderRadius.circular(
                          12,
                        ),
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
