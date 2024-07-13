import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:water/Utils/ThemeData/themeColors.dart';
import 'package:water/Utils/UtilHelper.dart';
import 'package:water/Utils/helper.dart';
import 'package:water/Utils/local_data/app_state.dart';
import 'package:water/Utils/text_input_formatter.dart';

import 'package:water/Widgets/textField.dart';
import 'package:water/controllers/card_controller.dart';
import 'package:water/model/card_item.dart';

import 'CommonButton.dart';

class AddCard extends StatefulWidget {
  final Function(int) callBack;
  final bool isDisableSelection,isPaying;
  const AddCard(
      {Key? key, required this.callBack,this.isPaying=false, this.isDisableSelection = true})
      : super(key: key);

  @override
  _AddCardState createState() => _AddCardState();
}

class _AddCardState extends StateMVC<AddCard> {
  _AddCardState() : super(CardController()) {
    con = controller as CardController;
  }

  late CardController con;
  TextEditingController _cardHolderName = TextEditingController();
  TextEditingController _cardNumber = TextEditingController();
  TextEditingController _cardExpiry = TextEditingController();
  TextEditingController _cardCv = TextEditingController();
  int selectedIndex = -1;

  @override
  void initState() {
    con.getCardListApi();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    var lang = appState.currentLanguageCode.value;

    return Column(
      children: [
        Padding(
            padding: const EdgeInsets.symmetric(horizontal: 26),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                UtilsHelper.getString(context, 'payment_methods'),
                style: Theme.of(context)
                    .textTheme
                    .headlineMedium
                    ?.copyWith(
                      fontFamily:
                          lang == 'en' ? 'Helvetica' : 'TheSans',
                      fontSize: widget.isPaying ? 18 : 22,
                      color: MyColor.textPrimaryDarkColor,
                    ),
              ),
              Spacer(),
                GestureDetector(
                  onTap: () {
                        print('add card pressed');
                      _cardHolderName.clear();
                      _cardNumber.clear();
                      _cardExpiry.clear();
                      _cardCv.clear();
                      openFormsheet(context, lang, null);
                  },
                  child: SvgPicture.asset(
                    "assets/add_rounded.svg",
                    width: widget.isPaying ? 25 : 30,
                    height: widget.isPaying ? 25 : 30,
                    colorFilter: ColorFilter.mode(MyColor.textSecondarySecondLightColor as Color, BlendMode.srcIn),
                  ),
                ),
                
            ],
          ),
        ),
    SizedBox(
      height: 29,
    ),
    appState.cardList.value.isNotEmpty ?
    Container(
      height: 196,
      child: ValueListenableBuilder<List<CardItem>>(
          valueListenable: appState.cardList,
          builder: (context, _cardList, child) {
            return ListView(
              shrinkWrap: true,
              primary: false,
              scrollDirection: Axis.horizontal,
              padding: EdgeInsets.only(left: 26,right: 20),
              children: [
                ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    scrollDirection: Axis.horizontal,
                    itemCount: _cardList.length,
                    reverse: true,
                    itemBuilder: (context, index) {
                      CardItem _cardItem = _cardList[index];
                      return InkWell(
                        onTap: () {
                          if (widget.isDisableSelection) {
                            selectedIndex = index;
                            widget.callBack.call(selectedIndex);
                            setState(() {});
                          }
                        },
                        child: Stack(
                          children: [
                            Container(
                              height: 196,
                              // width: 323,
                              padding: EdgeInsets.symmetric(horizontal: 25),
                              margin: EdgeInsets.only(right: 8),
                              decoration: BoxDecoration(
                                color: selectedIndex == index
                                    ? MyColor.commonColorSet2
                                    : Theme.of(context).brightness ==
                                            Brightness.light
                                        ? MyColor.textPrimaryColor
                                        : MyColor.baseColor,
                                borderRadius: BorderRadius.all(
                                  Radius.circular(8),
                                ),
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  SizedBox(),
                                  Row(
                                    children: [
                                      Text(
                                        displayCardNo(_cardItem.cardNo!),
                                        style: TextStyle(
                                          fontSize: 21,
                                          fontWeight: FontWeight.bold,
                                          color: MyColor.white,
                                        ),
                                      )
                                    ],
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        _cardItem.cardHolderName!,
                                        style: TextStyle(
                                          fontSize: 24,
                                          fontWeight: FontWeight.normal,
                                          color: MyColor.white,
                                        ),
                                      ),
                                      Text(
                                        '  ' + _cardItem.month.toString() +
                                            ' / ' +
                                            _cardItem.year.toString(),
                                        style: TextStyle(
                                          fontFamily: !UtilsHelper.rightHandLang
                                                  .contains(lang)
                                              ? UtilsHelper.wr_default_font_family
                                              : UtilsHelper.the_sans_font_family,
                                          fontSize: 24,
                                          fontWeight: FontWeight.normal,
                                          color: MyColor.white,
                                        ),
                                      )
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            Positioned(
                              top: 8,
                              right: 16,
                              child: InkWell(
                                onTap: () {
                                  con.cardDeleteApi(context, _cardItem);
                                },
                                child: ClipRRect(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10)),
                                  child: Container(
                                    width: 45,
                                    height: 45,
                                    color: MyColor.binBackground,
                                    child: Center(
                                      child: SvgPicture.asset(
                                        "assets/edit_delete.svg",
                                        colorFilter: ColorFilter.mode(MyColor.coreBackgroundColor as Color, BlendMode.srcIn),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Positioned(
                              top: 8,
                              right: 66,
                              child: InkWell(
                                onTap: () {
                                  _cardHolderName.text =
                                      _cardItem.cardHolderName!;
                                  _cardNumber.text = _cardItem.cardNo!
                                      .replaceAllMapped(RegExp(r".{4}"),
                                          (match) => "${match.group(0)} ");
                                  _cardExpiry.text = _cardItem.month!.toString() +
                                      "/" +
                                      _cardItem.year!.toString();
                                  _cardCv.text = _cardItem.cvv.toString();
                                  openFormsheet(context, lang, _cardItem);
                                },
                                child: ClipRRect(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10)),
                                  child: Container(
                                    width: 45,
                                    height: 45,
                                    color: MyColor.binBackground,
                                    child: Center(
                                      child: SvgPicture.asset(
                                        "assets/edit_icon.svg",
                                        colorFilter: ColorFilter.mode(MyColor.coreBackgroundColor as Color, BlendMode.srcIn),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    }),
              ],
            );
          }),         
       ) : Container(
        height: 196,
        alignment:Alignment.center,
        margin: EdgeInsets.symmetric(horizontal: 25),
        padding: EdgeInsets.symmetric(horizontal: 25),
        decoration: BoxDecoration(
          color:MyColor.coreBackgroundColor,
          borderRadius: BorderRadius.circular(12)
        ),
        child: Text(UtilsHelper.getString(context, 'no_card_is_available'),
        textAlign: TextAlign.center,
        style: TextStyle(
          fontWeight: FontWeight.w400,
          color: MyColor.textPrimaryDarkColor
        ),
        )
       )
    ]);
  }

  openFormsheet(BuildContext context, lang, CardItem? _cardUpdateItem) {
    return showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => SizedBox.fromSize(
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: SingleChildScrollView(
            child: Container(
              padding: MediaQuery.of(context).viewInsets,
              child: Container(
                width: double.infinity,
                margin: EdgeInsets.symmetric(horizontal: 24,vertical: 30),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: MyColor.coreBackgroundColor,
                ),
                padding: EdgeInsets.only(top:30),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          UtilsHelper.getString(context, 'add_card'),
                          style: Theme.of(context)
                              .textTheme
                              .displayMedium
                              ?.copyWith(
                                fontFamily:
                                    !UtilsHelper.rightHandLang.contains(lang)
                                        ? UtilsHelper.wr_default_font_family
                                        : UtilsHelper.the_sans_font_family,
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
                        controller: _cardHolderName,
                        placeholder:
                            UtilsHelper.getString(context, 'card_holder_name'),
                        prefixPath: "assets/user.svg",
                        lang: lang),
                    SizedBox(
                      height: 15,
                    ),
                    wrTextField(
                      context,
                      controller: _cardNumber,
                      keyboardType: TextInputType.number,
                      placeholder:
                          UtilsHelper.getString(context, 'card_number'),
                      prefixPath: "assets/card.svg",
                      lang: lang,
                      length : 19,
                      inputFormatters: [
                        // MaskedTextInputFormatter(
                        //   mask: 'xxxx xxxx xxxx xxxx',
                        //   separator: ' ',
                        // ),
                        CreditCardFormatter()
                      ],
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    wrTextField(
                      context,
                      controller: _cardExpiry,
                      keyboardType: TextInputType.number,
                      placeholder:
                          UtilsHelper.getString(context, 'expiry_date'),
                      prefixPath: "assets/calender.svg",
                      lang: lang,
                      inputFormatters: [
                        MaskedTextInputFormatter(
                          mask: 'xx/xx',
                          separator: '/',
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    wrTextField(
                      context,
                      controller: _cardCv,
                      keyboardType: TextInputType.number,
                      inputFormatters: [
                        MaskedTextInputFormatter(
                          mask: 'xxx',
                          separator: ' ',
                        ),
                      ],
                      placeholder:
                          UtilsHelper.getString(context, 'security_code'),
                      prefixPath: "assets/secure.svg",
                      lang: lang,
                    ),
                    SizedBox(
                      height: 40,
                    ),
                    Container(
                      width: double.infinity,
                      margin: EdgeInsets.symmetric(horizontal: 24),
                      child: commonButton(
                        onPress: () {
                          if (validateCardForm(
                              context,
                              _cardHolderName.text.trim(),
                              _cardNumber.text.trim(),
                              _cardExpiry.text.trim(),
                              _cardCv.text.trim())) {
                            print('save card pressed');
                            CardItem cardItem = CardItem(
                                id: _cardUpdateItem == null
                                    ? 0
                                    : _cardUpdateItem.id,
                                cardHolderName: _cardHolderName.text.trim(),
                                cardNo:
                                    _cardNumber.text.trim().replaceAll(" ", ""),
                                month: _cardExpiry.text.split("/").first,
                                year:
                                    int.parse(_cardExpiry.text.split("/").last),
                                cvv: int.parse(_cardCv.text.trim()));
                            con.cardAddUpdateApi(context, cardItem);
                          }
                        },
                        prefixPath: 'assets/icon_arrow.svg',
                        title: UtilsHelper.getString(context, 'save'),
                        textStyle:
                            Theme.of(context).textTheme.bodyLarge?.copyWith(
                                  fontFamily:
                                      !UtilsHelper.rightHandLang.contains(lang)
                                          ? UtilsHelper.wr_default_font_family
                                          : UtilsHelper.the_sans_font_family,
                                  color: MyColor.textPrimaryLightColor,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
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
      ),
    );
  }

  String displayCardNo(String number) {
    String num1 = number.replaceAll(RegExp(r'(?<=.{2})\d(?=.{4})'), 'X');
    String num =
        num1.replaceAllMapped(RegExp(r".{4}"), (match) => "${match.group(0)} ");
    return num;
  }
}

bool validateCardForm(BuildContext context, String name, String number,
    String expiryDate, String cvv) {
  if (name.isEmpty) {
    commonAlertNotification("Error",
        message: UtilsHelper.getString(context, "enter_card_holder_name"));
    return false;
  }
  if (number.isEmpty) {
    commonAlertNotification("Error",
        message: UtilsHelper.getString(context, "enter_card_number"));
    return false;
  }
  if (number.length < 19) {
    commonAlertNotification("Error",
        message: UtilsHelper.getString(context, "enter_valid_card_number"));
    return false;
  }
  if (expiryDate.isEmpty) {
    commonAlertNotification("Error",
        message: UtilsHelper.getString(context, "enter_expiry_date"));
    return false;
  }
  if (expiryDate.length < 5) {
    commonAlertNotification("Error",
        message: UtilsHelper.getString(context, "enter_valid_expiry_date"));
    return false;
  }
  if (cvv.isEmpty) {
    commonAlertNotification("Error",
        message: UtilsHelper.getString(context, "enter_cvv"));
    return false;
  }
  if (cvv.length < 3) {
    commonAlertNotification("Error",
        message: UtilsHelper.getString(context, "enter_valid_cvv"));
    return false;
  }
  return true;
}


class CreditCardFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    String formattedText = newValue.text;

    // Remove any non-digit characters
    formattedText = formattedText.replaceAll(RegExp(r'[^0-9]'), '');

    // Add spaces every four characters
    if (formattedText.length > 4) {
      formattedText = formattedText.substring(0, 4) +
          ' ' +
          formattedText.substring(4, formattedText.length);
    }
    if (formattedText.length > 9) {
      formattedText = formattedText.substring(0, 9) +
          ' ' +
          formattedText.substring(9, formattedText.length);
    }
    if (formattedText.length > 14) {
      formattedText = formattedText.substring(0, 14) +
          ' ' +
          formattedText.substring(14, formattedText.length);
    }

    return TextEditingValue(
      text: formattedText,
      selection: TextSelection.collapsed(offset: formattedText.length),
    );
  }
}