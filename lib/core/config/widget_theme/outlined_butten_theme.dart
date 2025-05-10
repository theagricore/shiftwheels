import 'package:flutter/material.dart';

class ZOutlinedButtonTheme {
  static final lightElevatedButtonTheme = OutlinedButtonThemeData(
    style: OutlinedButton.styleFrom(
      elevation: 0,
      backgroundColor: Colors.white,
      foregroundColor: Colors.black,
      side: const BorderSide(color: Colors.black),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
    ),
  );
  static final darkElevatedButtonTheme = OutlinedButtonThemeData(
    style: OutlinedButton.styleFrom(
      elevation: 0,
      backgroundColor: Colors.white,
      foregroundColor: Colors.black,
      side: const BorderSide(color: Colors.white),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
    ),
  );
}