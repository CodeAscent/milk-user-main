import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

Widget commonFloatingFormField(BuildContext _context, String title,
    {FormFieldSetter<String>? onSaved,
    TextEditingController? controller,
    Color? color,
    VoidCallback? callback,
    FormFieldValidator<String>? validator,
    bool? isObscureText,
    double? fieldHeight,
    int? maxLines,
    TextInputType? keyboardType,
    int? maxLength,
    String? hintText,
    Widget? suffixIcon,
    ValueChanged<String>? onChanged,
    ValueChanged<String>? onFieldSubmitted,
    TextInputAction? textInputAction,
    bool readOnly = false,
    bool autofocus = false,
    double? cornerRed,
    List<TextInputFormatter>? inputFormatters}) {
  return Container(
    height: fieldHeight ?? 50,
    decoration: BoxDecoration(
      color: color,
      borderRadius: BorderRadius.circular(cornerRed ?? 6),
    ),
    child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Center(
        child: TextFormField(
          controller: controller,
//          style: Theme.of(_context).textTheme.headline.copyWith(fontSize: 16),
          keyboardType: keyboardType,
          maxLength: maxLength,
          autofocus: autofocus,
          decoration: InputDecoration(
              contentPadding: EdgeInsets.zero,
              border: InputBorder.none,
              labelText: title,
//              labelStyle: Theme.of(_context).textTheme.headline.copyWith(
//                  fontSize: 13,
//                  color: AppThemes.lightTextGreyColor,
//                  fontWeight: FontWeight.w500),
              hintText: hintText,
              counterText: "",
              suffixIcon: suffixIcon),
          validator: validator,
          onSaved: onSaved,
          onChanged: onChanged,
          onFieldSubmitted: onFieldSubmitted,
          textInputAction: textInputAction,
          onTap: callback,
          readOnly: readOnly,
          obscureText: isObscureText ?? false,
          maxLines: maxLines ?? 1,
          inputFormatters: inputFormatters,
        ),
      ),
    ),
  );
}
