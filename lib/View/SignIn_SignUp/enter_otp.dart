import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:pinput/pinput.dart';
import 'package:water/Utils/ThemeData/themeColors.dart';
import 'package:water/Utils/UtilHelper.dart';
import 'package:water/Utils/local_data/app_state.dart';

import 'package:water/Widgets/CommonButton.dart';
import 'package:water/controllers/auth_controller.dart';
import 'package:water/repository/setting_repository.dart';

import '../../Utils/rgbo_to_hex.dart';

class EnterOtp extends StatefulWidget {
  final String? phone, verificationId;

  const EnterOtp({Key? key, this.verificationId, this.phone}) : super(key: key);

  @override
  _EnterOtpState createState() => _EnterOtpState();
}

class _EnterOtpState extends StateMVC<EnterOtp> {
  _EnterOtpState() : super(AuthController()) {
    con = controller as AuthController;
  }

  late AuthController con;
  TextEditingController _enterOtp = TextEditingController();
  final _pinPutFocusNode = FocusNode();
  late int endTime;

  @override
  void initState() {
    updateTime();
    super.initState();
  }

  updateTime() {
    DateTime _dateTime = DateTime.now().add(Duration(minutes: 2));
    endTime = _dateTime.millisecondsSinceEpoch;
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    var lang = appState.currentLanguageCode.value;

    final PinTheme pinPutDecoration = PinTheme(
        decoration: BoxDecoration(
      color: Theme.of(context).brightness != Brightness.light
          ? Color.fromRGBO(50, 50, 50, 1)
          : Colors.white,
      borderRadius: BorderRadius.circular(5.0),
    ));
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Column(
        children: [
          SizedBox(
            height: 100,
          ),
          Text(
            UtilsHelper.getString(context, 'verification_code'),
            style: Theme.of(context).textTheme.displayMedium?.copyWith(
                  fontFamily: !UtilsHelper.rightHandLang.contains(lang)
                      ? UtilsHelper.wr_default_font_family
                      : UtilsHelper.the_sans_font_family,
                  fontSize: 28,
                  color: MyColor.textPrimaryColor,
                  fontWeight: FontWeight.w400,
                ),
          ),
          SizedBox(
            height: 60,
          ),
          Container(
            width: size.width,
            margin: EdgeInsets.symmetric(horizontal: 27),
            decoration: BoxDecoration(
              color: MyColor.coreBackgroundColor,
              // boxShadow: [
              //   BoxShadow(
              //     color: Colors.grey.shade300,
              //     offset: Offset(0, 2), //(x,y)
              //     blurRadius: 9,
              //   ),
              // ],
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              children: [
                SizedBox(height: 50),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Text(
                    isfirebase == false
                        ? "${UtilsHelper.getString(context, "We have sent a 4 digit code to your mobile number")}"
                        : "${UtilsHelper.getString(context, 'otp_sent_text')}",
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          fontFamily: !UtilsHelper.rightHandLang.contains(lang)
                              ? UtilsHelper.wr_default_font_family
                              : UtilsHelper.the_sans_font_family,
                          fontSize: 16,
                          color: MyColor.descriptionColor,
                          fontWeight: FontWeight.normal,
                        ),
                    textAlign: TextAlign.center,
                  ),
                ),
                SizedBox(
                  height: 30,
                ),
                Text(
                  "+91 ${UtilsHelper.getString(context, widget.phone.toString())}",
                  style: Theme.of(context).textTheme.displayMedium?.copyWith(
                      fontSize: 24,
                      color: MyColor.textPrimaryColor,
                      fontWeight: FontWeight.w400),
                ),
                SizedBox(
                  height: 15,
                ),
                Container(
                  width: MediaQuery.of(context).size.width,
                  height: 60.0,
                  padding: EdgeInsets.symmetric(horizontal: 35),
                  child: Pinput(
                    isCursorAnimationEnabled: true,
                    length: isfirebase ? 6 : 4,
                    focusNode: _pinPutFocusNode,
                    controller: _enterOtp,
                    submittedPinTheme: pinPutDecoration,
                    focusedPinTheme: pinPutDecoration,
                    followingPinTheme: pinPutDecoration,
                    pinAnimationType: PinAnimationType.scale,
                    autofocus: true,
                    onCompleted: (value) {
                      con.verifyOTPApiCall(context, _enterOtp.text,
                          widget.phone!, widget.verificationId.toString());
                    },
                    defaultPinTheme: pinPutDecoration,
                    errorTextStyle: TextStyle(
                        color: dark(context) ? Colors.red : Colors.black,
                        fontSize: 20.0),
                  ),
                ),
                SizedBox(height: 16),
                if (isfirebase == false && kDebugMode)
                  Text('Enter: 1234',
                      style:
                          TextStyle(fontSize: 12, fontWeight: FontWeight.w400)),
                SizedBox(
                  height: 36,
                ),
                // CountdownTimer(
                //   endTime: endTime,
                //   widgetBuilder: (_, CurrentRemainingTime? time) {
                //     if (time == null) {
                //       return InkWell(
                //         onTap: () async {
                //           con.userResendOtpApiCall(context, widget.phone!);
                //           updateTime();
                //           setState(() {});
                //         },
                //         child: Text(
                //           UtilsHelper.getString(context, 'resend_again'),
                //           style: Theme.of(context)
                //               .textTheme
                //               .displaySmall
                //               ?.copyWith(
                //                 fontFamily:
                //                     !UtilsHelper.rightHandLang.contains(lang)
                //                         ? UtilsHelper.wr_default_font_family
                //                         : UtilsHelper.the_sans_font_family,
                //                 fontSize: 19,
                //                 color: MyColor.textPrimaryColor,
                //                 fontWeight: FontWeight.bold,
                //               ),
                //         ),
                //       );
                //     }
                //     return Text(
                //       _displayTime(context, time),
                //       style:
                //           Theme.of(context).textTheme.displaySmall?.copyWith(
                //                 fontFamily:
                //                     !UtilsHelper.rightHandLang.contains(lang)
                //                         ? UtilsHelper.wr_default_font_family
                //                         : UtilsHelper.the_sans_font_family,
                //                 fontSize: 19,
                //                 color: MyColor.textPrimaryColor,
                //                 fontWeight: FontWeight.bold,
                //               ),
                //     );
                //   },
                // ),
                // SizedBox(
                //   height: 46,
                // ),
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 30),
                  child: commonButton(
                    onPress: () {
                      con.verifyNonFirebase(
                          widget.phone!, _enterOtp.text, context);
                      //   con.verifyOTPApiCall(context, _enterOtp.text,
                      //       widget.phone!, widget.verificationId.toString());
                    },
                    prefixPath: 'assets/icon_arrow.svg',
                    title: UtilsHelper.getString(context, 'verify_now'),
                    textStyle: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          fontFamily: !UtilsHelper.rightHandLang.contains(lang)
                              ? UtilsHelper.wr_default_font_family
                              : UtilsHelper.the_sans_font_family,
                          color: MyColor.textPrimaryLightColor,
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                    color: MyColor.commonColorSet2,
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                InkWell(
                  onTap: () async {
                    if (isfirebase == true) {
                      con.resendOTP(phone: widget.phone!);
                    } else {
                      con.userResendOtpApiCall(context, widget.phone!);
                      updateTime();
                    }
                    setState(() {});
                  },
                  child: Text(UtilsHelper.getString(context, 'resend_again'),
                      style: TextStyle(
                          fontFamily: 'TheSans',
                          fontSize: 20,
                          color: dark(context)
                              ? Colors.white
                              : hexToRgb("#5F6D79"),
                          fontWeight: FontWeight.w400)),
                ),
                SizedBox(
                  height: 30,
                ),
              ],
            ),
          ),
          Spacer(
            flex: 2,
          ),
        ],
      ),
    );
  }
}

// String _displayTime(BuildContext context, String? time) {
//   if (time.min != null) {
//     return '${time.min}' +
//         ' ' +
//         UtilsHelper.getString(context, 'min') +
//         ' ' +
//         '${time.sec}' +
//         ' ' +
//         UtilsHelper.getString(context, 'sec');
//   } else {
//     return '${time.sec}' + ' ' + UtilsHelper.getString(context, 'sec');
//   }
// }
