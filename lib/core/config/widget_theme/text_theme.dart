import 'package:shiftwheels/core/config/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ZTextTheme {
  static TextTheme lightTextTheme = TextTheme(
    //----Heading----//
    displayLarge: TextStyle(  color: AppColors.zfontColor, fontSize: 24.sp, fontWeight: FontWeight.w600,), //--appbar heading
    displayMedium: TextStyle(color: AppColors.zfontColor, fontSize: 15.sp),
    displaySmall: TextStyle(color: AppColors.zfontColor, fontSize: 10.sp),

    headlineLarge: TextStyle(color: AppColors.zfontColor, fontSize: 40.sp),
    headlineMedium: TextStyle(color: AppColors.zfontColor, fontSize: 18.sp),
    headlineSmall: TextStyle(color: AppColors.zfontColor, fontSize: 16.sp),

    titleLarge: TextStyle(
      color: AppColors.zfontColor,
      fontSize: 16.sp,
      fontWeight: FontWeight.w600,
    ),
    titleMedium: TextStyle(
      color: AppColors.zfontColor,
      fontSize: 13.sp,
      fontWeight: FontWeight.w600,
    ),
    titleSmall: TextStyle(
      color: AppColors.zfontColor,
      fontSize: 10.sp,
      fontWeight: FontWeight.w600,
    ),

    bodyLarge: TextStyle(color: AppColors.zfontColor, fontSize: 14.sp),
    bodyMedium: TextStyle(color: AppColors.zfontColor, fontSize: 12.sp),
    bodySmall: TextStyle(color: AppColors.zfontColor, fontSize: 10.sp),

    labelLarge: TextStyle(color: AppColors.zfontColor, fontSize: 13.sp),
    labelMedium: TextStyle(color: AppColors.zfontColor, fontSize: 10.sp),
    labelSmall: TextStyle(color: AppColors.zfontColor, fontSize: 9.sp),
  );

  static TextTheme darkTextTheme = TextTheme(
    //----Heading----//
    displayLarge: TextStyle(
      color: AppColors.zdarkfontColor,
      fontSize: 24.sp,
      fontWeight: FontWeight.w600,
    ), //--appbar heading
    displayMedium: TextStyle(color: AppColors.zdarkfontColor, fontSize: 15.sp),
    displaySmall: TextStyle(color: AppColors.zdarkfontColor, fontSize: 10.sp),

    headlineLarge: TextStyle(color: AppColors.zdarkfontColor, fontSize: 40.sp),
    headlineMedium: TextStyle(color: AppColors.zdarkfontColor, fontSize: 18.sp),
    headlineSmall: TextStyle(color: AppColors.zdarkfontColor, fontSize: 16.sp),

    titleLarge: TextStyle(
      color: AppColors.zdarkfontColor,
      fontSize: 16.sp,
      fontWeight: FontWeight.w600,
    ),
    titleMedium: TextStyle(
      color: AppColors.zdarkfontColor,
      fontSize: 13.sp,
      fontWeight: FontWeight.w400,
    ),
    titleSmall: TextStyle(
      color: AppColors.zdarkfontColor,
      fontSize: 10.sp,
      fontWeight: FontWeight.w600,
    ),

    bodyLarge: TextStyle(color: AppColors.zdarkfontColor, fontSize: 14.sp),
    bodyMedium: TextStyle(color: AppColors.zdarkfontColor, fontSize: 12.sp),
    bodySmall: TextStyle(color: AppColors.zdarkfontColor, fontSize: 10.sp),

    labelLarge: TextStyle(color: AppColors.zdarkfontColor, fontSize: 13.sp),
    labelMedium: TextStyle(color: AppColors.zdarkfontColor, fontSize: 10.sp),
    labelSmall: TextStyle(color: AppColors.zdarkfontColor, fontSize: 9.sp),
  );
}
