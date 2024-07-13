import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:water/Utils/ThemeData/themeColors.dart';
import 'package:water/Utils/UtilHelper.dart';
import 'package:water/Utils/rgbo_to_hex.dart';

Widget wrTextField(
  context,
    {required controller,
    required String? placeholder,
    String? prefixPath,
    Widget? suffixWidget, 
    bool? isMultiline,
    TextInputType? keyboardType,
    int? length,
    String? Function(String?)? onvalidate,
    EdgeInsetsGeometry? margin,
    List<TextInputFormatter>? inputFormatters,
    required lang}) {
  return Container(
    padding: EdgeInsets.only(left: 10, right: 10),
    margin: margin ?? EdgeInsets.symmetric(horizontal: 30),
    decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
         color: dark(context) ? Color.fromRGBO(63, 76, 84, 1) :MyColor.white),
    child: TextFormField(
      onTap: () {},
      controller: controller,
      maxLines: isMultiline != null && isMultiline == true ? 5 : null,
      keyboardType: keyboardType,
      inputFormatters: inputFormatters,
       validator : onvalidate,
      decoration: InputDecoration(
        counterText: "",
        // fillColor: MyColor.white,
        // filled: true,
        contentPadding: EdgeInsets.only(top: 2),
        border: InputBorder.none,
       prefixIconConstraints: BoxConstraints(
        minWidth: 48
       ),
       
        prefixIcon: prefixPath != null
            ? Container(
              margin: EdgeInsets.only(left:  !UtilsHelper.rightHandLang.contains(lang) ? 0 :12),
                child: SvgPicture.asset(
                  prefixPath,
                  fit: BoxFit.scaleDown,
                  colorFilter: ColorFilter.mode(dark(context) ? Colors.white : MyColor.iconColor as Color, BlendMode.srcIn),
                ),
              )
            : null,
            hintStyle: TextStyle(
              color: dark(context) ? Colors.white70 : Color.fromRGBO(166, 188, 208, 1)
            ),
        suffix: suffixWidget != null ? suffixWidget : null,
        labelText: placeholder ?? '',
        labelStyle: TextStyle(
          color:dark(context) ? Colors.white : MyColor.baseDarkColor,
          fontFamily: lang == 'en' ? 'Helvetica' : 'TheSans',
          fontSize: 16,
          fontWeight: FontWeight.normal,
        ),
      ),
      maxLength: length,
      style: TextStyle(fontSize: 16,
         fontFamily: lang == 'en' ? 'Helvetica' : 'TheSans',
      color:dark(context) ? Colors.white70 : MyColor.black,fontWeight: FontWeight.w400),
    ),
  );
}
