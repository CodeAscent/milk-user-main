import 'package:flutter/material.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:water/Utils/ThemeData/themeColors.dart';
import 'package:water/Utils/local_data/app_state.dart';
import 'package:water/Utils/rgbo_to_hex.dart';
import 'package:water/controllers/auth_controller.dart';

import '../Utils/UtilHelper.dart';

class NotificationSwitch extends StatefulWidget {
  @override
  _NotificationSwitchState createState() => _NotificationSwitchState();
}

class _NotificationSwitchState extends StateMVC<NotificationSwitch> {
  _NotificationSwitchState() : super(AuthController()) {
    con = controller as AuthController;
  }

  late AuthController con;

  bool _isNotificationOn = false;
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      print(appState.userModel.enableNotificaton);
      if (appState.userModel.enableNotificaton == 0) {
        _isNotificationOn = false;
      } else {
        _isNotificationOn = true;
      }
      setState(() {});
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
          color:  dark(context) ? Colors.transparent :MyColor.white,
          borderRadius: BorderRadius.all(
            Radius.circular(20),
          ),
          border: Border.all(
            width: 2,
            color: _isNotificationOn ? MyColor.commonColorSet2 as Color : hexToRgb('#748A9D') ,
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
                left:_isNotificationOn ? UtilsHelper.rightHandLang.contains(appState.languageItem.languageCode) ? 0.0 : 17.0 : UtilsHelper.rightHandLang.contains(appState.languageItem.languageCode) ? 17.0 : 0.0,
              right:  _isNotificationOn ? UtilsHelper.rightHandLang.contains(appState.languageItem.languageCode) ? 17.0 :  0.0 :  UtilsHelper.rightHandLang.contains(appState.languageItem.languageCode) ? 0.0 :  17.0,
              child: SizedBox.fromSize(
                child: InkWell(
                  onTap: () {
                    setState(() {
                      _isNotificationOn = !_isNotificationOn;
                      if (appState.userModel.enableNotificaton == 1) {
                        setState(() {
                          _isNotificationOn = false;
                        });
                      }
                      if (appState.userModel.enableNotificaton == 0) {
                        setState(() {
                          _isNotificationOn = true;
                        });
                      }
                      con.userUpdateNotificationAPI(context, _isNotificationOn);
                      print(_isNotificationOn);
                    });
                  },
                  child: AnimatedSwitcher(
                    duration: Duration(microseconds: 500),
                    child: _isNotificationOn == true
                        ? Container(
                            key: UniqueKey(),
                            height: 30,
                            width: 70,
                            decoration: BoxDecoration(
                              color: MyColor.commonColorSet2,
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
                              color: MyColor.commonColorSet1 as Color,
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
