import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';
import 'package:shiftwheels/core/config/theme/app_colors.dart';
import 'package:shiftwheels/presentation/search_screen/search_bloc/search_bloc.dart';

class ScreenAppbarWidget extends StatelessWidget implements PreferredSizeWidget {
  final TextEditingController searchController;
  final VoidCallback onFilterPressed;

  const ScreenAppbarWidget({
    super.key,
    required this.searchController,
    required this.onFilterPressed,
  });

  @override
  Size get preferredSize => const Size.fromHeight(80);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;
    final isWeb = MediaQuery.of(context).size.width > 600;

    return SafeArea(
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: isWeb ? 24.0 : 8.0,
          vertical: 12,
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(2),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: isDarkMode
                      ? AppColors.zDarkCardBorder
                      : AppColors.zLightCardBorder,
                  width: 1.5,
                ),
              ),
              child: CircleAvatar(
                backgroundColor:
                    isDarkMode ? AppColors.zBackGround : AppColors.zWhite,
                child: IconButton(
                  icon: Icon(
                    Icons.arrow_back_rounded,
                    color: isDarkMode
                        ? AppColors.zDarkIconColor
                        : AppColors.zIconColor,
                    size: isWeb ? 32 : 28,
                  ),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ),
            ),

            const SizedBox(width: 10),

            // Search Field
            Expanded(
              child: Container(
                height: isWeb ? 60 : 55,
                decoration: BoxDecoration(
                  color: isDarkMode
                      ? AppColors.zSecondBackground
                      : AppColors.zWhite,
                  borderRadius: BorderRadius.circular(30),
                  border: Border.all(
                    color: isDarkMode
                        ? AppColors.zDarkCardBorder
                        : AppColors.zLightCardBorder,
                    width: 1.5,
                  ),
                ),
                child: Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 12.0, right: 8.0),
                      child: Lottie.asset(
                        'assets/images/Animation - search-w1000-h1000.json',
                        height: isWeb ? 40 : 35,
                        width: isWeb ? 40 : 35,
                        fit: BoxFit.contain,
                        repeat: false,
                      ),
                    ),
                    Expanded(
                      child: TextField(
                        controller: searchController,
                        style: theme.textTheme.bodyLarge?.copyWith(
                          color: isDarkMode
                              ? AppColors.zDarkPrimaryText
                              : AppColors.zLightPrimaryText,
                          fontSize: isWeb ? 16 : null,
                        ),
                        decoration: InputDecoration(
                          hintText: "Search by brand, model, etc...",
                          hintStyle: TextStyle(
                            fontSize: isWeb ? 16 : null,
                          ),
                          border: InputBorder.none,
                          enabledBorder: InputBorder.none,
                          focusedBorder: InputBorder.none,
                          isDense: true,
                          contentPadding: EdgeInsets.zero,
                        ),
                        onChanged: (query) {
                          context.read<SearchBloc>().add(
                                SearchQueryChanged(query),
                              );
                        },
                      ),
                    ),
                    GestureDetector(
                      onTap: onFilterPressed,
                      child: Padding(
                        padding: const EdgeInsets.only(right: 12.0),
                        child: Lottie.asset(
                          'assets/images/Animation - filter-w560-h560.json',
                          height: isWeb ? 40 : 35,
                          width: isWeb ? 40 : 35,
                          fit: BoxFit.contain,
                          repeat: false,
                        ),
                      ),
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