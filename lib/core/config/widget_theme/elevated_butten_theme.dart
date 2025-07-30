import 'package:shiftwheels/core/config/theme/app_colors.dart';
import 'package:flutter/material.dart';


class ZElevatedButtonTheme {
  ZElevatedButtonTheme._();
  static final lightElevatedButtonTheme = ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
        elevation: 0,
        backgroundColor: AppColors.zPrimaryColor,
        textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
          
        )),
  );
  static final darkElevatedButtonTheme = ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
        elevation: 0,
        backgroundColor: AppColors.zPrimaryColor,
        textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        )),
  );
}