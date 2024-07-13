import 'dart:ui';

import 'package:flutter/material.dart';

Color hexToRgb(String? hexColor) {
  if (hexColor != 'null') {
    hexColor = hexColor!.replaceAll('#', '');
  int hexValue = int.parse(hexColor, radix: 16);
  int alpha = 255;
  int red = (hexValue >> 16) & 0xFF;
  int green = (hexValue >> 8) & 0xFF;
  int blue = hexValue & 0xFF;
   return Color.fromARGB(alpha, red, green, blue);
  }
   return const Color.fromRGBO(255, 134, 44,1);
}

bool dark(context){
 return Theme.of(context).brightness == Brightness.dark;
}