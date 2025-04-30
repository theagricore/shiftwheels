import 'package:shiftwheels/core/config/theme/app_colors.dart';
import 'package:shiftwheels/core/config/widgetTheme/elevated_butten_theme.dart';

import 'package:shiftwheels/core/config/widgetTheme/input_decoration_theme.dart';
import 'package:shiftwheels/core/config/widgetTheme/outlined_butten_theme.dart';

import 'package:shiftwheels/core/config/widgetTheme/text_theme.dart';
import 'package:flutter/material.dart';


class ZAppTheme {
  static ThemeData lightTheme = ThemeData(
    primaryColor: AppColors.zPrimaryColor,
    scaffoldBackgroundColor: AppColors.zWhite,
    fontFamily: 'CircularStd',
    brightness: Brightness.light,
    textTheme: ZTextTheme.lightTextTheme,
    appBarTheme: const AppBarTheme(
      backgroundColor: AppColors.zPrimaryColor,
      foregroundColor: AppColors.zWhite,
    ),
    textSelectionTheme:const  TextSelectionThemeData(
      cursorColor: AppColors.zPrimaryColor
    ),
    outlinedButtonTheme: ZOutlinedButtonTheme.lightElevatedButtonTheme,
    elevatedButtonTheme: ZElevatedButtonTheme.lightElevatedButtonTheme,
    inputDecorationTheme: ZTextFormFieldTheme.lightInputDecorationTheme,
  );

  static ThemeData darkTheme = ThemeData(
    primaryColor: AppColors.zPrimaryColor,
    scaffoldBackgroundColor: AppColors.zBackGround,
    fontFamily: 'CircularStd',
    brightness: Brightness.dark,
    textTheme: ZTextTheme.darkTextTheme,
    appBarTheme: const AppBarTheme(
      backgroundColor: AppColors.zPrimaryColor,
      foregroundColor: AppColors.zWhite,
    ),
     textSelectionTheme:const  TextSelectionThemeData(
      cursorColor: AppColors.zPrimaryColor
    ),
    outlinedButtonTheme: ZOutlinedButtonTheme.darkElevatedButtonTheme,
    elevatedButtonTheme: ZElevatedButtonTheme.darkElevatedButtonTheme,
    inputDecorationTheme: ZTextFormFieldTheme.darkInputDecorationTheme,
  );
}