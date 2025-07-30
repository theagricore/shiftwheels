import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shiftwheels/core/config/theme/app_colors.dart';

class ZTextTheme {
  static final double scale = kIsWeb ? 0.8 : 1.0;

  static TextTheme lightTextTheme = TextTheme(
    displayLarge: TextStyle(color: AppColors.zfontColor, fontSize: 24.sp * scale, fontWeight: FontWeight.w600),
    displayMedium: TextStyle(color: AppColors.zfontColor, fontSize: 15.sp * scale),
    displaySmall: TextStyle(color: AppColors.zfontColor, fontSize: 10.sp * scale),

    headlineLarge: TextStyle(color: AppColors.zfontColor, fontSize: 40.sp * scale),
    headlineMedium: TextStyle(color: AppColors.zfontColor, fontSize: 18.sp * scale),
    headlineSmall: TextStyle(color: AppColors.zfontColor, fontSize: 16.sp * scale),

    titleLarge: TextStyle(color: AppColors.zfontColor, fontSize: 16.sp * scale, fontWeight: FontWeight.w600),
    titleMedium: TextStyle(color: AppColors.zfontColor, fontSize: 13.sp * scale, fontWeight: FontWeight.w600),
    titleSmall: TextStyle(color: AppColors.zfontColor, fontSize: 10.sp * scale, fontWeight: FontWeight.w600),

    bodyLarge: TextStyle(color: AppColors.zfontColor, fontSize: 14.sp * scale),
    bodyMedium: TextStyle(color: AppColors.zfontColor, fontSize: 12.sp * scale),
    bodySmall: TextStyle(color: AppColors.zfontColor, fontSize: 10.sp * scale),

    labelLarge: TextStyle(color: AppColors.zfontColor, fontSize: 13.sp * scale),
    labelMedium: TextStyle(color: AppColors.zfontColor, fontSize: 10.sp * scale),
    labelSmall: TextStyle(color: AppColors.zfontColor, fontSize: 9.sp * scale),
  );

  static TextTheme darkTextTheme = TextTheme(
    displayLarge: TextStyle(color: AppColors.zdarkfontColor, fontSize: 24.sp * scale, fontWeight: FontWeight.w600),
    displayMedium: TextStyle(color: AppColors.zdarkfontColor, fontSize: 15.sp * scale),
    displaySmall: TextStyle(color: AppColors.zdarkfontColor, fontSize: 10.sp * scale),

    headlineLarge: TextStyle(color: AppColors.zdarkfontColor, fontSize: 40.sp * scale),
    headlineMedium: TextStyle(color: AppColors.zdarkfontColor, fontSize: 18.sp * scale),
    headlineSmall: TextStyle(color: AppColors.zdarkfontColor, fontSize: 16.sp * scale),

    titleLarge: TextStyle(color: AppColors.zdarkfontColor, fontSize: 16.sp * scale, fontWeight: FontWeight.w600),
    titleMedium: TextStyle(color: AppColors.zdarkfontColor, fontSize: 13.sp * scale, fontWeight: FontWeight.w400),
    titleSmall: TextStyle(color: AppColors.zdarkfontColor, fontSize: 10.sp * scale, fontWeight: FontWeight.w600),

    bodyLarge: TextStyle(color: AppColors.zdarkfontColor, fontSize: 14.sp * scale),
    bodyMedium: TextStyle(color: AppColors.zdarkfontColor, fontSize: 12.sp * scale),
    bodySmall: TextStyle(color: AppColors.zdarkfontColor, fontSize: 10.sp * scale),

    labelLarge: TextStyle(color: AppColors.zdarkfontColor, fontSize: 13.sp * scale),
    labelMedium: TextStyle(color: AppColors.zdarkfontColor, fontSize: 10.sp * scale),
    labelSmall: TextStyle(color: AppColors.zdarkfontColor, fontSize: 9.sp * scale),
  );
}
