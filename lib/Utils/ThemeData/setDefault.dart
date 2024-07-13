import 'package:flutter/material.dart';
import 'package:water/Utils/ThemeData/themeColors.dart';
import 'package:water/Utils/UtilHelper.dart';
import 'package:water/Utils/local_data/app_state.dart';

ThemeData themeData(ThemeData baseTheme, int isTheme, BuildContext context) {
  if (isTheme == 1) {
    MyColor.loadColor2(false);
    return baseTheme.copyWith(
      primaryColor: MyColor.commonColorSet1,
      primaryColorDark: MyColor.mainDarkColor,
      primaryColorLight: MyColor.mainLightColor,
      scaffoldBackgroundColor: MyColor.mainColor,
      brightness: Brightness.dark,
      textTheme: TextTheme(
        displayLarge: TextStyle(
            color: MyColor.textPrimaryColor,
            fontFamily: !UtilsHelper.rightHandLang
                    .contains(appState.currentLanguageCode.value)
                ? UtilsHelper.wr_default_font_family
                : UtilsHelper.the_sans_font_family),
        displayMedium: TextStyle(
            color: MyColor.textPrimaryColor,
            fontFamily: !UtilsHelper.rightHandLang
                    .contains(appState.currentLanguageCode.value)
                ? UtilsHelper.wr_default_font_family
                : UtilsHelper.the_sans_font_family),
        displaySmall: TextStyle(
            color: MyColor.textPrimaryColor,
            fontFamily: !UtilsHelper.rightHandLang
                    .contains(appState.currentLanguageCode.value)
                ? UtilsHelper.wr_default_font_family
                : UtilsHelper.the_sans_font_family),
        headlineMedium: TextStyle(
          color: MyColor.textPrimaryColor,
          fontFamily: !UtilsHelper.rightHandLang
                  .contains(appState.currentLanguageCode.value)
              ? UtilsHelper.wr_default_font_family
              : UtilsHelper.the_sans_font_family,
        ),
        headlineSmall: TextStyle(
            color: MyColor.textPrimaryColor,
            fontFamily: !UtilsHelper.rightHandLang
                    .contains(appState.currentLanguageCode.value)
                ? UtilsHelper.wr_default_font_family
                : UtilsHelper.the_sans_font_family,
            fontWeight: FontWeight.bold),
        titleLarge: TextStyle(
            color: MyColor.textPrimaryColor,
            fontFamily: !UtilsHelper.rightHandLang
                    .contains(appState.currentLanguageCode.value)
                ? UtilsHelper.wr_default_font_family
                : UtilsHelper.the_sans_font_family),
        titleMedium: TextStyle(
            color: MyColor.textPrimaryColor,
            fontFamily: !UtilsHelper.rightHandLang
                    .contains(appState.currentLanguageCode.value)
                ? UtilsHelper.wr_default_font_family
                : UtilsHelper.the_sans_font_family,
            fontWeight: FontWeight.bold),
        titleSmall: TextStyle(
            color: MyColor.textPrimaryColor,
            fontFamily: !UtilsHelper.rightHandLang
                    .contains(appState.currentLanguageCode.value)
                ? UtilsHelper.wr_default_font_family
                : UtilsHelper.the_sans_font_family,
            fontWeight: FontWeight.bold),
        bodyLarge: TextStyle(
          color: MyColor.textPrimaryColor,
          fontFamily: !UtilsHelper.rightHandLang
                  .contains(appState.currentLanguageCode.value)
              ? UtilsHelper.wr_default_font_family
              : UtilsHelper.the_sans_font_family,
        ),
        bodyMedium: TextStyle(
            color: MyColor.textPrimaryColor,
            fontFamily: !UtilsHelper.rightHandLang
                    .contains(appState.currentLanguageCode.value)
                ? UtilsHelper.wr_default_font_family
                : UtilsHelper.the_sans_font_family,
            fontWeight: FontWeight.bold),
        labelLarge: TextStyle(
            color: MyColor.textPrimaryColor,
            fontFamily: !UtilsHelper.rightHandLang
                    .contains(appState.currentLanguageCode.value)
                ? UtilsHelper.wr_default_font_family
                : UtilsHelper.the_sans_font_family),
        bodySmall: TextStyle(
            color: MyColor.textPrimaryLightColor,
            fontFamily: !UtilsHelper.rightHandLang
                    .contains(appState.currentLanguageCode.value)
                ? UtilsHelper.wr_default_font_family
                : UtilsHelper.the_sans_font_family),
        labelSmall: TextStyle(
            color: MyColor.textPrimaryColor,
            fontFamily: !UtilsHelper.rightHandLang
                    .contains(appState.currentLanguageCode.value)
                ? UtilsHelper.wr_default_font_family
                : UtilsHelper.the_sans_font_family),
      ),
      iconTheme: IconThemeData(color: MyColor.iconColor),
      appBarTheme: AppBarTheme(color: MyColor.coreBackgroundColor),
    );
  } else {
    MyColor.loadColor2(true);
    // White Theme
    return baseTheme.copyWith(
        primaryColor: MyColor.mainColor,
        primaryColorDark: MyColor.mainDarkColor,
        primaryColorLight: MyColor.mainLightColor,
        scaffoldBackgroundColor: MyColor.mainColor,
        brightness: Brightness.light,
        textTheme: TextTheme(
          displayLarge: TextStyle(
              color: MyColor.textPrimaryColor,
              fontFamily: !UtilsHelper.rightHandLang
                      .contains(appState.currentLanguageCode.value)
                  ? UtilsHelper.wr_default_font_family
                  : UtilsHelper.the_sans_font_family),
          displayMedium: TextStyle(
              color: MyColor.textPrimaryColor,
              fontFamily: !UtilsHelper.rightHandLang
                      .contains(appState.currentLanguageCode.value)
                  ? UtilsHelper.wr_default_font_family
                  : UtilsHelper.the_sans_font_family),
          displaySmall: TextStyle(
              color: MyColor.textPrimaryColor,
              fontFamily: !UtilsHelper.rightHandLang
                      .contains(appState.currentLanguageCode.value)
                  ? UtilsHelper.wr_default_font_family
                  : UtilsHelper.the_sans_font_family),
          headlineMedium: TextStyle(
            color: MyColor.textPrimaryColor,
            fontFamily: !UtilsHelper.rightHandLang
                    .contains(appState.currentLanguageCode.value)
                ? UtilsHelper.wr_default_font_family
                : UtilsHelper.the_sans_font_family,
          ),
          headlineSmall: TextStyle(
              color: MyColor.textPrimaryColor,
              fontFamily: !UtilsHelper.rightHandLang
                      .contains(appState.currentLanguageCode.value)
                  ? UtilsHelper.wr_default_font_family
                  : UtilsHelper.the_sans_font_family,
              fontWeight: FontWeight.bold),
          titleLarge: TextStyle(
              color: MyColor.textPrimaryColor,
              fontFamily: !UtilsHelper.rightHandLang
                      .contains(appState.currentLanguageCode.value)
                  ? UtilsHelper.wr_default_font_family
                  : UtilsHelper.the_sans_font_family),
          titleMedium: TextStyle(
              color: MyColor.textPrimaryColor,
              fontFamily: !UtilsHelper.rightHandLang
                      .contains(appState.currentLanguageCode.value)
                  ? UtilsHelper.wr_default_font_family
                  : UtilsHelper.the_sans_font_family,
              fontWeight: FontWeight.bold),
          titleSmall: TextStyle(
              color: MyColor.textPrimaryColor,
              fontFamily: !UtilsHelper.rightHandLang
                      .contains(appState.currentLanguageCode.value)
                  ? UtilsHelper.wr_default_font_family
                  : UtilsHelper.the_sans_font_family,
              fontWeight: FontWeight.bold),
          bodyLarge: TextStyle(
            color: MyColor.textPrimaryColor,
            fontFamily: !UtilsHelper.rightHandLang
                    .contains(appState.currentLanguageCode.value)
                ? UtilsHelper.wr_default_font_family
                : UtilsHelper.the_sans_font_family,
          ),
          bodyMedium: TextStyle(
              color: MyColor.textPrimaryColor,
              fontFamily: !UtilsHelper.rightHandLang
                      .contains(appState.currentLanguageCode.value)
                  ? UtilsHelper.wr_default_font_family
                  : UtilsHelper.the_sans_font_family,
              fontWeight: FontWeight.bold),
          labelLarge: TextStyle(
              color: MyColor.textPrimaryColor,
              fontFamily: !UtilsHelper.rightHandLang
                      .contains(appState.currentLanguageCode.value)
                  ? UtilsHelper.wr_default_font_family
                  : UtilsHelper.the_sans_font_family),
          bodySmall: TextStyle(
              color: MyColor.textPrimaryLightColor,
              fontFamily: !UtilsHelper.rightHandLang
                      .contains(appState.currentLanguageCode.value)
                  ? UtilsHelper.wr_default_font_family
                  : UtilsHelper.the_sans_font_family),
          labelSmall: TextStyle(
              color: MyColor.textPrimaryColor,
              fontFamily: !UtilsHelper.rightHandLang
                      .contains(appState.currentLanguageCode.value)
                  ? UtilsHelper.wr_default_font_family
                  : UtilsHelper.the_sans_font_family),
        ),
        iconTheme: IconThemeData(color: MyColor.iconColor),
        appBarTheme: AppBarTheme(color: MyColor.coreBackgroundColor));
  }
}
