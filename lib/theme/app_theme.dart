import 'package:flutter/material.dart';

import 'colors.dart';

class AppTheme {
  static ThemeData light = ThemeData(
    brightness: Brightness.light,
    primaryColor: AppColor.primary.shade500,
    primarySwatch: AppColor.primary,
    iconTheme: IconThemeData(
      color: AppColor.primary.shade500,
    ),
  );

  static ThemeData dark = ThemeData(
    brightness: Brightness.dark,
    primaryColor: AppColor.primary.shade500,
    scaffoldBackgroundColor: AppColor.background,
    primarySwatch: AppColor.primary,
    iconTheme: IconThemeData(color: AppColor.primary.shade500),
    buttonTheme: ButtonThemeData(buttonColor: AppColor.primary.shade500),
    floatingActionButtonTheme: FloatingActionButtonThemeData(
      elevation: 2,
      backgroundColor: AppColor.primary.shade500,
    ),
    textSelectionTheme: TextSelectionThemeData(
      cursorColor: AppColor.primary.shade500,
      selectionHandleColor: AppColor.primary.shade500,
    ),
    inputDecorationTheme: InputDecorationTheme(
      focusedBorder: UnderlineInputBorder(
        borderSide: BorderSide(
          color: AppColor.primary.shade500,
        ),
      ),
      focusColor: AppColor.primary.shade500,
    ),
  );
}
