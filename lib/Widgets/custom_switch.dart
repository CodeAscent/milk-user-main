
import 'package:flutter/material.dart';
import 'package:water/Utils/ThemeData/themeColors.dart';
import 'package:water/Utils/UtilHelper.dart';
import 'package:water/Utils/rgbo_to_hex.dart';

import '../Utils/local_data/app_state.dart';
import '../repository/user_repository.dart';

class CustomSwitch extends StatefulWidget {
  const CustomSwitch({Key? key,this.isDark=false}) : super(key: key);
  final bool isDark;

  @override
  _CustomSwitchState createState() => _CustomSwitchState();
}

class _CustomSwitchState extends State<CustomSwitch> {
 late bool _isDark;

  

  @override
  void initState() {
   _isDark = widget.isDark;
    // TODO: implement initState
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      print(Theme.of(context).brightness);
      if (Theme.of(context).brightness == Brightness.dark) {
        _isDark = true;
        setState(() {});
      } else {
        _isDark = false;
        setState(() {});
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.all(
        Radius.circular(20),
      ),
      child: AnimatedContainer(
        height: 34,
        width: 50,
        decoration: BoxDecoration(
          color: dark(context) ? Colors.transparent : MyColor.white,
          borderRadius: BorderRadius.all(
            Radius.circular(20),
          ),
          border: Border.all(
            width: 2,
            color: _isDark ? MyColor.commonColorSet2  as Color: hexToRgb('#748A9D') ,
          ),
        ),
        duration: Duration(
          microseconds: 500,
        ),
        child: Stack(
          children: [
            AnimatedPositioned(
              duration: Duration(microseconds: 500),
              curve: Curves.easeIn,
              top: 0.0,
              left:_isDark ? UtilsHelper.rightHandLang.contains(appState.languageItem.languageCode) ? 0.0 : 17.0 : UtilsHelper.rightHandLang.contains(appState.languageItem.languageCode) ? 17.0 : 0.0,
              right:  _isDark ? UtilsHelper.rightHandLang.contains(appState.languageItem.languageCode) ? 17.0 :  0.0 :  UtilsHelper.rightHandLang.contains(appState.languageItem.languageCode) ? 0.0 :  17.0,
              child: SizedBox.fromSize(
                child: InkWell(
                  onTap: () {
                    setState(() {
                      _isDark = !_isDark;
                      if (Theme.of(context).brightness == Brightness.dark) {
                        setState(() {
                          _isDark = false;
                          MyColor.loadColor2(true);
                          // DynamicTheme.of(context)?.setState(() {
                          //   DynamicTheme.of(context)?.setTheme(AppThemes.Light);
                          // });
                          darkMode.value =false;
                        });
                      }
                      if (Theme.of(context).brightness == Brightness.light) {
                        setState(() {
                          _isDark = true;
                          MyColor.loadColor2(false);
                           darkMode.value = true;
                          // DynamicTheme.of(context)?.setState(() {
                          //   DynamicTheme.of(context)?.setTheme(AppThemes.Dark);
                          // });
                          print(Theme.of(context).brightness);
                        });
                      }
                    });
                  },
                  child: AnimatedSwitcher(
                    duration: Duration(microseconds: 500),
                    child:  _isDark == true
                        ? Container(
                            key: UniqueKey(),
                            height: 30,
                            width: 70,
                            decoration: BoxDecoration(
                              color: MyColor.commonColorSet2 ,
                              borderRadius: BorderRadius.all(
                                Radius.circular(20),
                              ),
                            ),
                            child: Center(
                              child: Icon(
                                Icons.done,
                                color: MyColor.white,
                                size: 15,
                              ),
                            ),
                          )
                        : Container(
                            key: UniqueKey(),
                            height: 30,
                            width: 70,
                            decoration: BoxDecoration(
                            color: hexToRgb('#748A9D'),
                              borderRadius: BorderRadius.all(
                                Radius.circular(20),
                              ),
                            ),
                            child: Center(
                              child: Icon(
                                Icons.close,
                                color: MyColor.white,
                                size: 15,
                              ),
                            ),
                          ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
