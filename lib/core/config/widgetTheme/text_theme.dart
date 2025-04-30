import 'package:shiftwheels/core/config/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';


class ZTextTheme {
  static TextTheme lightTextTheme = TextTheme(
    //----Heading----//
    displayLarge: TextStyle(color: AppColors.zfontColor, fontSize: 24.sp,fontWeight: FontWeight.w600),//--appbar heading
    displayMedium: TextStyle(color: AppColors.zfontColor, fontSize: 15.sp),
    displaySmall: TextStyle(color: AppColors.zfontColor, fontSize: 10.sp),

    headlineLarge: TextStyle(color: AppColors.zfontColor, fontSize: 40.sp),
    headlineMedium: TextStyle(color: AppColors.zfontColor, fontSize: 18.sp),
    headlineSmall: TextStyle(color: AppColors.zfontColor, fontSize: 16.sp),

    titleLarge: TextStyle(color: AppColors.zfontColor, fontSize: 16.sp,fontWeight: FontWeight.w600),
    titleMedium: TextStyle(color: AppColors.zfontColor, fontSize: 14.sp,fontWeight: FontWeight.w600),
    titleSmall: TextStyle(color: AppColors.zfontColor, fontSize: 12.sp,fontWeight: FontWeight.w600),

    bodyLarge: TextStyle(color: AppColors.zfontColor, fontSize: 14.sp),
    bodyMedium: TextStyle(color: AppColors.zfontColor, fontSize: 12.sp),
    bodySmall: TextStyle(color: AppColors.zfontColor, fontSize: 10.sp),
  );

  static TextTheme darkTextTheme = TextTheme(
    //----Heading----//
    displayLarge: TextStyle(color: Colors.white, fontSize: 24.sp,fontWeight: FontWeight.w600),//--appbar heading
    displayMedium: TextStyle(color: Colors.white, fontSize: 15.sp),
    displaySmall: TextStyle(color: Colors.white, fontSize: 10.sp),

    headlineLarge: TextStyle(color: Colors.white, fontSize: 40.sp),
    headlineMedium: TextStyle(color: Colors.white, fontSize: 18.sp),
    headlineSmall: TextStyle(color: Colors.white, fontSize: 16.sp),
    
    titleLarge: TextStyle(color: Colors.white, fontSize: 19.sp,fontWeight: FontWeight.w600),
    titleMedium: TextStyle(color: Colors.white, fontSize: 13.sp,fontWeight: FontWeight.w400),
    titleSmall: TextStyle(color: Colors.white, fontSize: 12.sp,fontWeight: FontWeight.w600),

    bodyLarge: TextStyle(color: Colors.white, fontSize: 14.sp),
    bodyMedium: TextStyle(color: Colors.white, fontSize: 12.sp),
    bodySmall: TextStyle(color: Colors.white, fontSize: 10.sp),
  );
}