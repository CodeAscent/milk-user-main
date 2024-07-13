import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:water/Utils/ThemeData/themeColors.dart';

Widget selectLanguageButton(
    {String? prefixPath,
    required onPress,
    required String? title,
    double? width,
    Color? borderColor,
    required TextStyle? textStyle,
    required Color? color}) {
  return Container(
    height: 55,
    width: width,
    child: ElevatedButton(
      onPressed: onPress,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        textDirection: TextDirection.ltr,
        children: [
        
          Text(
            title ?? '',
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: textStyle,
          ),
          SizedBox(
            width: 10,
          ),
            SvgPicture.asset(
            prefixPath ?? '',
            colorFilter: ColorFilter.mode(MyColor.white as Color, BlendMode.srcIn)
          ),
          
        ],
      ),
      style: ButtonStyle(
        elevation: MaterialStateProperty.all(0),
        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(50),
            side: BorderSide(width: 1,color : borderColor ?? Colors.transparent)
          ),
        ),
        backgroundColor:
            MaterialStateColor.resolveWith((states) => color ?? MyColor.white!),
      ),
    ),
  );
}
