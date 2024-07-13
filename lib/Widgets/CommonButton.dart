import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:water/Utils/ThemeData/themeColors.dart';
import 'package:water/Utils/local_data/app_state.dart';

Widget commonButton(
    {String? prefixPath,
    required onPress,
    required String? title,
    required TextStyle? textStyle,
    required Color? color}) {
  return Container(
   
    child: ElevatedButton(
      onPressed: onPress,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        textDirection: appState.languageItem.languageCode == 'ar' ? TextDirection.rtl : TextDirection.ltr,
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
            colorFilter:ColorFilter.mode( MyColor.white as Color, BlendMode.srcIn),
          ),
          
        ],
      ),
      style: ButtonStyle(
        elevation: MaterialStateProperty.all(0.0),
        padding:MaterialStatePropertyAll( EdgeInsets.symmetric(vertical: 16)),
        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(50),
          ),
        ),
        backgroundColor:
            MaterialStateColor.resolveWith((states) => color ?? MyColor.white!),
      ),
    ),
  );
}
