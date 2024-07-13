import 'package:flutter/material.dart';

import '../model/country.dart';

class DropDownCon extends StatefulWidget {
  const DropDownCon({Key? key}) : super(key: key);

  @override
  State<DropDownCon> createState() => _DropDownConState();
}

class _DropDownConState extends State<DropDownCon> {

String val = '+91';
  
  @override
  Widget build(BuildContext context) {
      return DropdownButton<String>(
        iconSize:12,
        // icon: SizedBox(),
        onChanged: (value) {
          val =value.toString();
          setState(() {    });
        },
        // selectedItemBuilder: (context) {
          
        // },
        underline: DropdownButtonHideUnderline(child: SizedBox()),
        // padding: EdgeInsets.symmetric(vertical: 0),
        value: val,
        items: [
         ...List.generate(codes.length, 
         (index) =>  DropdownMenuItem(
          value: codes[index],
          child: SizedBox(
            width: 35,
            child: Text(codes[index].toString(),
            style: TextStyle(
              fontSize: 14,
            )
            ),
          )))
        ],
      );
  }
}