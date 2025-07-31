import 'dart:ui';

import 'package:flutter/material.dart';

class AppColors {
  static const zPrimaryColor = Color(0xFFFFCC00);
  static const zfontColor = Color(0xFF5E5A5A);
  static const zIconColor = Color(0xFF5E5A5A);
  static const zdarkfontColor = Colors.white;
  static const zDarkIconColor = Colors.white;
  static const zBackGround = Color(0xff1D182A);
  static const zSecondBackground = Color(0xff342f3f);

  static const zWhite = Colors.white;
  static const zblack = Colors.black;
  static const zGrey = Colors.grey;
  static const zred = Colors.red;
  static const zTransprant = Colors.transparent;
  static const zGreen = Colors.green;
  static const zBlue = Colors.blue;
  static const zOrange = Color.fromARGB(255, 230, 209, 22);
  static Color zlite = Color(0xFFFFCC00).withOpacity(0.1);
  static const zGold = Color(0xFFFFD700);
  static const Color zDarkGrey = Color(
    0xFF424242,
  ); // A darker grey for shimmer base in dark mode
  static const Color zLightGrey = Color(0xFF616161);

  // Light Mode Colors
  static Color zLightPrimaryText = const Color(
    0xFF333333,
  ); // Darker text for readability
  static Color zLightSecondaryText = const Color(
    0xFF666666,
  ); // Slightly lighter for secondary info
  static Color zLightCardBackground = Colors.white;
  static Color zLightCardBorder = Colors.grey.shade300;
  static Color zLightDivider = Colors.grey.shade200;
  static Color zLightCountButton = Colors.grey.shade100;
  static Color zLightAccentColor = const Color(0xFFFFCC00); // Same as primary
  static Color zLightIconColor = const Color(0xFF666666);

  // Dark Mode Colors
  static const zDarkBackground = Color(0xFF1C1C1E); // Very dark gray
  static const zDarkCardBackground = Color(
    0xFF2C2C2E,
  ); // Slightly lighter than background
  static const zDarkPrimaryText = Colors.white;
  static const zDarkSecondaryText = Color(
    0xFFAAAAAA,
  ); // Lighter gray for secondary info
  static Color zDarkCardBorder = Colors.grey.shade700;
  static Color zDarkDivider = Colors.grey.shade700;
  static Color zDarkCountButton = const Color(0xFF3A3A3C);
  static Color zDarkAccentColor = const Color(
    0xFFFFD700,
  ); // Slightly more vibrant gold
}