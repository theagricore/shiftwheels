import 'package:shiftwheels/core/config/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';


class ZTextFormFieldTheme {
  ZTextFormFieldTheme._();

  static InputDecorationTheme lightInputDecorationTheme = InputDecorationTheme(
      filled: true,
      fillColor: AppColors.zWhite,
      hintStyle: const TextStyle(
        color: Color.fromARGB(255, 154, 148, 148),
        fontWeight: FontWeight.w600,
      ),
      contentPadding: EdgeInsets.all(18.sp),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(4),
        borderSide: const BorderSide(color: AppColors.zfontColor, width: 1.5),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(4),
        borderSide: const BorderSide(color: AppColors.zfontColor, width: 1.5),
      ),
      focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(4),
          borderSide:
              const BorderSide(color: AppColors.zPrimaryColor, width: 1.8)));

  static InputDecorationTheme darkInputDecorationTheme = InputDecorationTheme(
    filled: true,
    fillColor: AppColors.zSecondBackground,
    hintStyle: const TextStyle(
      color: Color(0xffA7A7A7),
      fontWeight: FontWeight.w600,
    ),
    contentPadding: EdgeInsets.all(18.sp),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(4),
      borderSide: BorderSide.none,
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(4),
      borderSide: BorderSide.none,
    ),
  );
}