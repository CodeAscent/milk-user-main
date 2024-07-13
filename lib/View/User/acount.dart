import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:water/Utils/ThemeData/themeColors.dart';
import 'package:water/Utils/UtilHelper.dart';
import 'package:water/Utils/helper.dart';
import 'package:water/Utils/local_data/app_state.dart';
import 'package:water/Widgets/CommonButton.dart';
import 'package:water/Widgets/add_card_widget.dart';
import 'package:water/Widgets/header.dart';
import 'package:water/Widgets/notification_switch.dart';
import 'package:water/Widgets/textField.dart';
import 'package:water/controllers/auth_controller.dart';

class MyAccount extends StatefulWidget {
  const MyAccount({Key? key}) : super(key: key);

  @override
  _MyAccountState createState() => _MyAccountState();
}

class _MyAccountState extends StateMVC<MyAccount> {
  _MyAccountState() : super(AuthController()) {
    con = controller as AuthController;
  }

  late AuthController con;

  TextEditingController _nameController = TextEditingController();
  TextEditingController _mobileController = TextEditingController();

  @override
  void initState() {
    _nameController.text = appState.userModel.name ?? "";
    _mobileController.text = appState.userModel.phone ?? "";
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    var lang = appState.currentLanguageCode.value;

    return Scaffold(
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: headerWidget(
              title: UtilsHelper.getString(context, 'your_account'),
              onPress: () {
                Navigator.of(context).pop();
              },
              context: context,
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(
                    height: 20,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 26),
                    child: Row(
                      children: [
                        Text(
                          UtilsHelper.getString(context, 'your_information'),
                          style: Theme.of(context)
                              .textTheme
                              .headlineMedium
                              ?.copyWith(
                                fontFamily:
                                    lang == 'en' ? 'Helvetica' : 'TheSans',
                                fontSize: 22,
                                color: MyColor.textPrimaryDarkColor,
                              ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  Container(
                    padding: EdgeInsets.all(34),
                     margin: const EdgeInsets.symmetric(horizontal: 26),
                    decoration: BoxDecoration(
                      color: MyColor.coreBackgroundColor,
                      borderRadius: BorderRadius.all(
                        Radius.circular(8),
                      ),
                    ),
                    child: Column(
                      children: [
                        informationRow(
                          key: UtilsHelper.getString(context, 'full_name'),
                          value: appState.userModel.name ?? "",
//                            UtilsHelper.getString(context, "static_user_name"),
                          lang: lang,
                          suffixWidget: GestureDetector(
                            onTap: () {
                              changeNameBottomSheet(lang: lang);
                            },
                            child: SvgPicture.asset("assets/edit_icon.svg"),
                          ),
                          size: size,
                        ),
//                      SizedBox(
//                        height: 29,
//                      ),
//                      informationRow(
//                        key: UtilsHelper.getString(context, 'address'),
//                        value: UtilsHelper.getString(context, "static_address"),
//                        lang: lang,
//                        suffixWidget: GestureDetector(
//                          onTap: () {},
//                          child: SvgPicture.asset("assets/edit_icon.svg"),
//                        ),
//                        size: size,
//                      ),
                        SizedBox(
                          height: 29,
                        ),
                        informationRow(
                          key:
                              UtilsHelper.getString(context, 'phone_number'),
                          value: appState.userModel.phone ?? "",
                          lang: lang,
                          suffixWidget: GestureDetector(
                            onTap: () {
                              _mobileController.text= appState.userModel.phone ?? "";
                              setState(() { });
                              changeMobileBottomSheet(lang: lang);
                            },
                            child: SvgPicture.asset("assets/edit_icon.svg"),
                          ),
                          size: size,
                        ),
                        SizedBox(
                          height: 0,
                        ),
//                      informationRow(
//                        key: UtilsHelper.getString(context, 'password'),
//                        value: '**********',
//                        size: size,
//                        lang: lang,
//                        suffixWidget: GestureDetector(
//                          onTap: () {},
//                          child: SvgPicture.asset("assets/edit_icon.svg"),
//                        ),
//                      ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 33,
                  ),
                  Padding(
                     padding: const EdgeInsets.symmetric(horizontal: 26),
                    child: Row(
                      children: [
                        Text(
                          UtilsHelper.getString(context, 'your_preferences'),
                          style: Theme.of(context)
                              .textTheme
                              .headlineMedium
                              ?.copyWith(
                                fontFamily:
                                    lang == 'en' ? 'Helvetica' : 'TheSans',
                                fontSize: 22,
                                color: MyColor.textPrimaryDarkColor,
                              ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 29,
                  ),
                  Container(
                      margin: const EdgeInsets.symmetric(horizontal: 26),
                    padding:EdgeInsets.symmetric(horizontal: 34, vertical: 20),
                    decoration: BoxDecoration(
                      color: MyColor.coreBackgroundColor,
                      borderRadius: BorderRadius.all(
                        Radius.circular(8),
                      ),
                    ),
                    child: Column(
                      children: [
                        informationRow(
                          key:
                              UtilsHelper.getString(context, 'notifications'),
                          value: '',
                          suffixWidget: GestureDetector(
                            onTap: () {},
                            child: NotificationSwitch(),
                          ),
                          size: size,
                          lang: lang,
                        ),
                        /*SizedBox(
                          height: 29,
                        ),
                        informationRow(
                          key: UtilsHelper.getString(context, 'newsletter'),
                          value: '',
                          suffixWidget: GestureDetector(
                            onTap: () {},
                            child: CustomSwitch(),
                          ),
                          size: size,
                          lang: lang,
                        ),*/
                      ],
                    ),
                  ),
                  // SizedBox(
                  //   height: 29,
                  // ),
                  //    AddCard(
                  //       callBack: (int selectedCardIndex) {},
                  //       isDisableSelection: false),
                  // SizedBox(
                  //   height: 29,
                  // ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget informationRow(
      {required String key,
      required String value,
      required Size size,
      required Widget suffixWidget,
      required lang}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  key,
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      fontFamily: lang == 'en' ? 'Helvetica' : 'TheSans',
                      fontSize: 18,
                      color: MyColor.textPrimaryDarkColor),
                ),
                SizedBox(
                  height: lang == 'en' ? 7 : 0,
                ),
                if (value != '')
                  Container(
                    width: size.width - 200,
                    child: Text(
                      value,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context)
                          .textTheme
                          .headlineMedium
                          ?.copyWith(
                            fontFamily: lang == 'en' ? 'Helvetica' : 'TheSans',
                            fontSize: 18,
                            color: MyColor.textSecondarySecondLightColor
                                ?.withOpacity(0.9),
                          ),
                    ),
                  ),
              ],
            ),
          ],
        ),
        suffixWidget,
      ],
    );
  }

  Future<dynamic> changeNameBottomSheet({required lang}) {
    return showModalBottomSheet(
      context: context,
      backgroundColor: MyColor.transparent,
      isScrollControlled: true,
      builder: (context) => SizedBox.fromSize(
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: SingleChildScrollView(
            child: Container(
              
               margin: EdgeInsets.symmetric(horizontal: 24,vertical: 30),
              padding: MediaQuery.of(context).viewInsets,
              decoration: BoxDecoration(
                color: MyColor.coreBackgroundColor,
                  borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                children: [
                  SizedBox(
                    height: 30,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        UtilsHelper.getString(context, 'change_name'),
                        style:
                            Theme.of(context).textTheme.displayMedium?.copyWith(
                                  fontFamily:
                                      lang == 'en' ? 'Helvetica' : 'TheSans',
                                  fontSize: 24,
                                  color: MyColor.textPrimaryColor,
                                  fontWeight: FontWeight.bold,
                                ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  wrTextField(
                    context,
                      controller: _nameController,
                      placeholder: UtilsHelper.getString(context, 'full_name'),
                      prefixPath: "assets/user.svg",
                      lang: lang),
                  SizedBox(
                    height: 40,
                  ),
                  Container(
                    width: double.infinity,
                    margin: EdgeInsets.symmetric(horizontal: 27),
                    child: commonButton(
                      onPress: () {
//                        if (validateContactForm(context)) {
//                          ContactItem contactItem = ContactItem(
//                              name: _nameController.text.trim(),
//                              email: _emaiController.text.trim(),
//                              mobile: _mobileController.text.trim(),
//                              message: _noteController.text.trim()
//                          );
//                          con.contactUsApi(context, contactItem);
//                        }
                        if (_nameController.text.trim().isNotEmpty) {
                          con.userUpdateProfileAPI(
                              context, {"name": _nameController.text.trim(),"phone": appState.userModel.phone.toString()});
                        } else {
                          commonAlertNotification("Error",
                              message:
                                  UtilsHelper.getString(context, "enter_name"));
                        }
                      },
                      prefixPath: 'assets/icon_arrow.svg',
                      title: UtilsHelper.getString(context, 'update'),
                      textStyle: Theme.of(context)
                          .textTheme
                          .bodyLarge
                          ?.copyWith(
                            fontFamily: lang == 'en' ? 'Helvetica' : 'TheSans',
                            color: MyColor.textPrimaryLightColor,
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                      color: MyColor.commonColorSet2,
                    ),
                  ),
                  SizedBox(
                    height: 30,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<dynamic> changeMobileBottomSheet({required lang,String? initialValue}) {
    return showModalBottomSheet(
      context: context,
      backgroundColor: MyColor.transparent,
      isScrollControlled: true,
      builder: (context) => SizedBox.fromSize(
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: SingleChildScrollView(
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 24,vertical: 30),
              padding: MediaQuery.of(context).viewInsets,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                  color: MyColor.coreBackgroundColor,
              ),
              child: Column(
                children: [
                  SizedBox(
                    height: 30,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        UtilsHelper.getString(context, 'change_mobile'),
                        style:
                            Theme.of(context).textTheme.displayMedium?.copyWith(
                                  fontFamily:
                                      lang == 'en' ? 'Helvetica' : 'TheSans',
                                  fontSize: 24,
                                  color: MyColor.textPrimaryColor,
                                  fontWeight: FontWeight.bold,
                                ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  wrTextField(
                    context,
                     length: 10,
                      controller: _mobileController,
                      placeholder:UtilsHelper.getString(context, 'mobile_number'),
                      prefixPath: "assets/phone.svg",
                      keyboardType: TextInputType.phone,
                      lang: lang),
                  SizedBox(
                    height: 40,
                  ),
                  Container(
                    width: double.infinity,
                    margin: EdgeInsets.symmetric(horizontal: 27),
                    child: commonButton(
                      onPress: () {
                        if (_mobileController.text.trim().isNotEmpty && _mobileController.text.length != 10) {
                          commonAlertNotification("Error",message: UtilsHelper.getString(context, "valid_mobile_number_is_required"));
                        } else if (_mobileController.text.trim().isEmpty) {
                          commonAlertNotification("Error",message: UtilsHelper.getString(context, "enter_mobile"));
                        } else {
                            con.userUpdateProfileAPI(context,{"phone": _mobileController.text.trim()});
                          }
                        
                      },
                      prefixPath: 'assets/icon_arrow.svg',
                      title: UtilsHelper.getString(context, 'update'),
                      textStyle: Theme.of(context)
                          .textTheme
                          .bodyLarge
                          ?.copyWith(
                            fontFamily: lang == 'en' ? 'Helvetica' : 'TheSans',
                            color: MyColor.textPrimaryLightColor,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                      color: MyColor.commonColorSet2,
                    ),
                  ),
                  SizedBox(
                    height: 30,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
