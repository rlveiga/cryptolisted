import 'package:flutter/material.dart';

ThemeData appTheme() {
  return ThemeData(
      primaryColor: Colors.purple,
      buttonTheme: ButtonThemeData(
          buttonColor: Colors.white, textTheme: ButtonTextTheme.accent));
}
