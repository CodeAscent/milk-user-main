import 'package:flutter/material.dart';
import 'package:water/Utils/Router/route_path.dart';
import 'package:water/Utils/ThemeData/themeColors.dart';
import 'package:water/Utils/UtilHelper.dart';
import 'package:water/Utils/local_data/app_state.dart';

import 'package:water/Widgets/CommonButton.dart';
import 'package:water/Widgets/textField.dart';

class SignUp extends StatefulWidget {
  const SignUp({Key? key}) : super(key: key);

  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  TextEditingController _name = TextEditingController();
  TextEditingController _mobilePhone = TextEditingController();
  TextEditingController _password = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    var lang = appState.currentLanguageCode.value;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 30,vertical: 12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  textDirection: TextDirection.ltr,
                  children: [
                    Icon(
                      Icons.close,
                      size: 24,
                    ),
                  ],
                ),
              ),
               SizedBox(
                height: 43,
              ),
                Text(
                UtilsHelper.getString(
                    context, 'create_account_title'),
                style: Theme.of(context)
                    .textTheme
                    .displayMedium
                    ?.copyWith(
                      fontFamily:
                          lang == 'en' ? 'Helvetica' : 'TheSans',
                      fontWeight: FontWeight.bold,
                      color: MyColor.textPrimaryColor,
                      fontSize: 24,
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
                  borderRadius: BorderRadius.circular(
                    20
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    SizedBox.fromSize(
                      child: Column(
                        children: [
                          SizedBox(
                            height: 50,
                          ),
                          wrTextField(
                            context,
                              controller: _name,
                              placeholder:UtilsHelper.getString(context, 'name'),
                              prefixPath: "assets/user.svg",
                              lang: lang),
                          SizedBox(
                            height: 15,
                          ),
                          wrTextField(
                            context,
                              controller: _mobilePhone,
                              placeholder: UtilsHelper.getString(context, 'mobile_number'),
                              prefixPath: "assets/phone.svg",
                              lang: lang),
                          SizedBox(
                            height: 15,
                          ),
                          wrTextField(
                            context,
                              controller: _password,
                              placeholder:UtilsHelper.getString(context, 'password'),
                              prefixPath: "assets/lock.svg",
                              lang: lang)
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 48,
                    ),
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 30),
                      child: commonButton(
                        onPress: () {},
                        prefixPath: 'assets/icon_arrow.svg',
                        title: UtilsHelper.getString(context, 'create_account'),
                        textStyle:Theme.of(context).textTheme.bodyLarge?.copyWith(
                                  fontFamily:lang == 'en' ? 'Helvetica' : 'TheSans',
                                  color: MyColor.textPrimaryLightColor,
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                ),
                        color: MyColor.commonColorSet2,
                      ),
                    ),

                    SizedBox(
                      height: 20
                    ),
                     GestureDetector(
                      onTap: () {
                        Navigator.of(context).pushNamed(RoutePath.sign_in);
                      },
                      child: Text(
                        UtilsHelper.getString(context, 'sign_in').toUpperCase(),
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                              fontFamily: lang == 'en' ? 'Helvetica' : 'TheSans',
                              color: MyColor.textSecondarySecondLightColor,
                              fontWeight: FontWeight.w400,
                              fontSize: 14,
                            ),
                      ),
                    ),
                    SizedBox(
                      height: 30,
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 42,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
