import 'package:demo/core/ui/color.dart';
import 'package:flutter/material.dart';

abstract final class AppTheme {
  static final main = ThemeData(
      useMaterial3: true,
      scaffoldBackgroundColor: AppColors.white,
      colorSchemeSeed:
          MaterialStateColor.resolveWith((states) => AppColors.green),
      fontFamily: 'Avenir',
      appBarTheme: const AppBarTheme(
        color: AppColors.white,
        elevation: 0,
        surfaceTintColor: AppColors.white,
      ),
      inputDecorationTheme: InputDecorationTheme(
          hintStyle: const TextStyle(
            color: Color(0xFFB5B5B5),
            fontSize: 15,
            fontFamily: 'Avenir',
            fontWeight: FontWeight.w500,
            height: 0,
          ),
          fillColor: AppColors.white,
          filled: true,
          contentPadding: const EdgeInsets.all(18),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
          )),
      elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                  side: BorderSide.none),
              backgroundColor: AppColors.defaultButtonColor,
              padding: const EdgeInsets.symmetric(vertical: 12.73))),
      buttonTheme: ButtonThemeData(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15), side: BorderSide.none),
          colorScheme: ColorScheme.fromSeed(
            seedColor: AppColors.green,
          )),
  );
}
