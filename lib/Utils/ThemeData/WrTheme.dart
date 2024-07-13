import 'dart:ui';

import 'package:flutter/material.dart';

import '../WrColors.dart';

ThemeData WrTheme = ThemeData(
  visualDensity: VisualDensity.adaptivePlatformDensity,
  primaryTextTheme: TextTheme(bodyLarge: TextStyle(fontSize: 14)),
  textTheme: TextTheme(
    displayMedium: TextStyle(
        fontFamily: 'Helvetica',
        fontSize: 24,
        fontWeight: FontWeight.bold,
        color: MyColor.textPrimaryColor),
    displaySmall: TextStyle(
        fontFamily: 'Helvetica',
        fontSize: 19,
        fontWeight: FontWeight.bold,
        color: MyColor.textPrimaryColor),
    headlineMedium: TextStyle(
        fontFamily: 'Helvetica',
        fontSize: 15,
        fontWeight: FontWeight.normal,
        color: MyColor.textPrimaryColor),
    bodyLarge: TextStyle(
        fontFamily: 'Helvetica',
        fontSize: 15,
        fontWeight: FontWeight.bold,
        color: MyColor.white),
    bodyMedium: TextStyle(
        fontFamily: 'Helvetica',
        fontSize: 20,
        fontWeight: FontWeight.bold,
        color: MyColor.textPrimaryColor),
    bodySmall: TextStyle(
        fontSize: 13,
        fontWeight: FontWeight.normal,
        color: MyColor.black.withOpacity(0.5)),
  ),
);
