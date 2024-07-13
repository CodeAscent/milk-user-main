import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_svg/svg.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import 'package:water/Utils/ThemeData/themeColors.dart';
import 'package:flutter/material.dart';
import 'package:water/Utils/UtilHelper.dart';
import 'package:water/Utils/local_data/app_state.dart';
import 'package:water/Utils/local_data/local_data_storage.dart';
import 'package:water/Utils/rgbo_to_hex.dart';
import 'package:water/model/product/product_item.dart';
import 'package:water/Utils/urls.dart';
import 'package:water/Utils/utils.dart';

import 'date_picker.dart';

class CartProductWidget extends StatefulWidget {
  final Product? product;
  final bool? isSelected;
  final Function? close;
  final Function? open;
  final int index;

  CartProductWidget(
      {this.product,
      this.isSelected = false,
      this.close,
      this.open,
      required this.index});

  @override
  _CartProductWidgetState createState() => _CartProductWidgetState();
}

class _CartProductWidgetState extends State<CartProductWidget> {
  LocalDataStorage localDataStorage = LocalDataStorage();
  List<String> orderFrequency = [
    'once',
    'daily',
    // 'weekly',
    'flexible',
    'alternative'
  ];
  List<String> months = [
    'JANUARY',
    'FEBRUARY',
    'MARCH',
    'APRIL',
    'MAY',
    'JUNE',
    'JULY',
    'AUGUST',
    'SEPTEMBER',
    'OCTOBER',
    'NOVEMBER',
    'DECEMBER'
  ];
  final daysOfDays = List.filled(7, false);
  DateTime? _initialSelectedDate;
  List<DateTime>? _initialSelectedDates;
  PickerDateRange? _initialSelectedRange;
  String _timeSpan = '';
  ValueNotifier<DateRangePickerSelectionMode> selectionMode =
      new ValueNotifier(DateRangePickerSelectionMode.single);
  DateRangePickerController _dateRangePickerController =
      DateRangePickerController();

  void _onSelectionChanged(DateRangePickerSelectionChangedArgs args) {
    if (args.value is PickerDateRange) {
      print("PickerDateRange -->>");
      print(args.value.startDate);
      print(args.value.endDate);
      appState.carts.value[widget.index].startDate = args.value.startDate;
      appState.carts.value[widget.index].endDate = args.value.endDate;
//      if(args.value.endDate!=null && _timeSpan==orderFrequency[1]) {
//        int days = args.value.endDate.difference(args.value.startDate).inDays;
//        List<DateTime> _list = [];
//        for(int i=0; i<days; i++) {
//          _list.add(DateTime(args.value.startDate).add(Duration(days: i)));
//        }
//        appState.carts.value[_index].selectedDates = _list;
//      } else if(args.value.endDate!=null && _timeSpan==orderFrequency[2]) {
//        int days = args.value.endDate.difference(args.value.startDate).inDays;
//        List<DateTime> _list = [];
//        DateTime _dateTime;
//        for(int i=0; i<days; i++) {
//          _dateTime = DateTime(args.value.startDate).add(Duration(days: i));
//          if(appState.carts.value[_index].days!=null && appState.carts.value[_index].days!.contains(_dateTime.weekday)) {
//            _list.add(_dateTime);
//          }
//        }
//        appState.carts.value[_index].selectedDates = _list;
//      } else {
//        int days = args.value.endDate.difference(args.value.startDate).inDays;
//        List<DateTime> _list = [];
//        for(int i=0; i<days; i++) {
//          _list.add(DateTime(args.value.startDate).add(Duration(days: i)));
//        }
//        appState.carts.value[_index].selectedDates = _list;
//      }
    } else if (args.value is DateTime) {
      print("DateTime -->>");
      print(args.value);
      appState.carts.value[widget.index].startDate = args.value;
      appState.carts.value[widget.index].endDate = args.value;
      appState.carts.value[widget.index].selectedDates = [args.value];
    } else if (args.value is List<DateTime>) {
      print("DateTime -->>");
      print(args.value);
      if (args.value.length > 0) {
        appState.carts.value[widget.index].startDate = args.value.first;
        appState.carts.value[widget.index].endDate = args.value.last;
      }
      appState.carts.value[widget.index].selectedDates = args.value;
    } else {
      print(">><<");
    }
    appState.carts.notifyListeners();
    localDataStorage.updateProduct(appState.carts.value[widget.index],
        appState.carts.value[widget.index].id!);
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    var lang = appState.currentLanguageCode.value;

    ///initialize default frequency selection
    _timeSpan =
        appState.carts.value[widget.index].orderFrequency ?? orderFrequency[0];

    if (widget.isSelected!) {
      if (appState.carts.value[widget.index].selectedDates != null &&
          appState.carts.value[widget.index].selectedDates!.length > 0) {
        _initialSelectedDate =
            appState.carts.value[widget.index].selectedDates!.first;
      } else {
        ///initialize default date selection
        _initialSelectedDate = (DateTime.now().add(Duration(days: 1)));
      }

      if (appState.carts.value[widget.index].selectedDates != null) {
        _initialSelectedDates =
            appState.carts.value[widget.index].selectedDates;
      }

      if (appState.carts.value[widget.index].startDate != null &&
          appState.carts.value[widget.index].endDate != null) {
        _initialSelectedRange = PickerDateRange(
            appState.carts.value[widget.index].startDate,
            appState.carts.value[widget.index].endDate);
      }

      updateCalenderSelectionMode(
          appState.carts.value[widget.index].orderFrequency);

      for (int i = 0; i < 7; i++) {
        if (appState.carts.value[widget.index].days != null &&
            appState.carts.value[widget.index].days!.contains(i)) {
          daysOfDays[i] = true;
        } else {
          daysOfDays[i] = false;
        }
      }
    }

    return widget.isSelected!
        ? Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  InkWell(
                    onTap: () {
                      widget.close!.call();
                      setState(() {});
                    },
                    child: Container(
                      height: 80,
                      width: size.width - 60,
                      padding: EdgeInsets.symmetric(vertical: 8),
                      decoration: BoxDecoration(
                        color: Theme.of(context).brightness == Brightness.light
                            ? Color(0xffF0F4F8)
                            : Color.fromRGBO(30, 43, 51, 1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: Container(
                              // width: (size.width - 65) / 2,
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  SizedBox(width: 8),
                                  Container(
                                    width: 60,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(8),
                                        image: DecorationImage(
                                          fit: BoxFit.contain,
                                          image: CachedNetworkImageProvider(
                                            Urls.getImageUrlFromName(
                                                widget.product!.image ?? ""),
                                          ),
                                        )),
                                  ),
                                  SizedBox(width: 8),
                                  Expanded(
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        SizedBox(height: 3),
                                        Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Expanded(
                                              child: Text(
                                                widget.product!.name!,
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .displaySmall
                                                    ?.copyWith(
                                                      fontFamily: !UtilsHelper
                                                              .rightHandLang
                                                              .contains(lang)
                                                          ? UtilsHelper
                                                              .wr_default_font_family
                                                          : UtilsHelper
                                                              .the_sans_font_family,
                                                      fontSize: 14,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      color: Theme.of(context)
                                                                  .brightness ==
                                                              Brightness.light
                                                          ? MyColor
                                                              .commonColorSet1
                                                          : MyColor.white,
                                                    ),
                                              ),
                                            ),
                                            Container(
                                              // height: 5,
                                              child: RotatedBox(
                                                quarterTurns:
                                                    widget.isSelected == true
                                                        ? 1
                                                        : 3,
                                                child: SvgPicture.asset(
                                                  "assets/icon-chevron.svg",
                                                  fit: BoxFit.fitHeight,
                                                  width: 8,
                                                  color: Color(0xFF748A9D),
                                                ),
                                              ),
                                            ),
                                            SizedBox(width: 12)
                                          ],
                                        ),
                                        Spacer(),
                                        Row(
                                          children: [
                                            Text(
                                              (widget.product!.discountPrice !=
                                                          null &&
                                                      widget.product!
                                                              .discountPrice! >
                                                          0)
                                                  ? displayPrice(widget
                                                      .product!.discountPrice)
                                                  : displayPrice(
                                                      widget.product!.price),
                                              // textDirection: TextDirection.ltr,
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .displaySmall
                                                  ?.copyWith(
                                                    fontFamily: !UtilsHelper
                                                            .rightHandLang
                                                            .contains(lang)
                                                        ? UtilsHelper
                                                            .wr_default_font_family
                                                        : UtilsHelper
                                                            .the_sans_font_family,
                                                    fontSize: 16,
                                                    color: Theme.of(context)
                                                                .brightness ==
                                                            Brightness.light
                                                        ? MyColor
                                                            .commonColorSet1
                                                        : MyColor.white,
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                            ),
                                            Spacer(flex: 3),
                                            GestureDetector(
                                              onTap: () {
                                                if (widget.product!.quantity ==
                                                    widget.product!
                                                        .mininumOrderQuantity) {
                                                  appState.removeProductFromCart(
                                                      widget.product!,
                                                      selectedQuatity: widget
                                                          .product!
                                                          .mininumOrderQuantity);
                                                } else if (widget
                                                        .product!.quantity >
                                                    widget.product!
                                                        .mininumOrderQuantity!
                                                        .toInt()) {
                                                  appState.decreaseProduct(
                                                      widget.product!);
                                                }
                                              },
                                              child: Container(
                                                height: 27,
                                                width: 27,
                                                decoration: BoxDecoration(
                                                  color: MyColor
                                                      .mainColorWithBlack,
                                                  borderRadius:
                                                      BorderRadius.all(
                                                    Radius.circular(20),
                                                  ),
                                                ),
                                                child: Center(
                                                  child: Icon(
                                                    Icons.remove,
                                                    size: 15,
                                                  ),
                                                ),
                                              ),
                                            ),
                                            Spacer(),
                                            Text(
                                              widget.product!.quantity
                                                  .toString(),
                                              style: TextStyle(
                                                fontFamily: !UtilsHelper
                                                        .rightHandLang
                                                        .contains(lang)
                                                    ? UtilsHelper
                                                        .wr_default_font_family
                                                    : UtilsHelper
                                                        .the_sans_font_family,
                                                fontSize: 16,
                                                color: dark(context)
                                                    ? Colors.white
                                                    : MyColor.commonColorSet1,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            Spacer(),
                                            GestureDetector(
                                              onTap: () {
                                                appState.increaseProduct(
                                                    widget.product!);
                                              },
                                              child: Container(
                                                height: 27,
                                                width: 27,
                                                decoration: BoxDecoration(
                                                  color: MyColor
                                                      .mainColorWithBlack,
                                                  borderRadius:
                                                      BorderRadius.all(
                                                    Radius.circular(20),
                                                  ),
                                                ),
                                                child: Center(
                                                  child: Icon(
                                                    Icons.add,
                                                    size: 15,
                                                  ),
                                                ),
                                              ),
                                            ),
                                            SizedBox(width: 12),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          // Row(
                          //   children: [
                          //     Container(
                          //       width: (size.width - 99) / 2,
                          //       child: Container(
                          //         height: 22,
                          //         decoration: BoxDecoration(
                          //           borderRadius: BorderRadius.all(
                          //             Radius.circular(5),
                          //           ),
                          //         ),
                          //         child: Row(
                          //           mainAxisAlignment:
                          //           MainAxisAlignment.spaceEvenly,
                          //           textDirection: TextDirection.ltr,
                          //           children: [
                          //
                          //           ],
                          //         ),
                          //       ),
                          //     ),
                          //
                          //   ],
                          // ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 6,
              ),
              Container(
                margin: EdgeInsets.only(
                  right: lang == 'en' ? 6 : 0,
                  left: lang != 'en' ? 6 : 0,
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.all(
                    Radius.circular(8),
                  ),
                  child: Container(
//                                  height: 479,
                    width: size.width,
                    padding: EdgeInsets.only(
                      top: 26,
                      left: 10,
                      right: 10,
                    ),
                    decoration: BoxDecoration(
                      color: Theme.of(context).brightness == Brightness.light
                          ? Color(0xffF0F4F8)
                          : Color.fromRGBO(30, 43, 51, 1),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    selectionMode.value =
                                        DateRangePickerSelectionMode.single;
                                    appState.carts.value[widget.index]
                                        .orderFrequency = orderFrequency[0];
                                    appState.carts.notifyListeners();
                                    localDataStorage.updateProduct(
                                        appState.carts.value[widget.index],
                                        appState.carts.value[widget.index].id!);
                                    setState(() {
                                      _timeSpan = orderFrequency[0];
                                    });
                                  },
                                  child: Container(
                                    height: 36,
                                    width: size.width * 0.23,
                                    decoration: BoxDecoration(
                                      color: _timeSpan == orderFrequency[0]
                                          ? MyColor.commonColorSet2
                                          : Theme.of(context).brightness !=
                                                  Brightness.light
                                              ? MyColor.darkModeLightcolor
                                              : MyColor.mainColorWithBlack,
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(8),
                                      ),
                                    ),
                                    child: Center(
                                      child: Text(
                                        UtilsHelper.getString(context, 'once'),
                                        style: Theme.of(context)
                                            .textTheme
                                            .headlineMedium
                                            ?.copyWith(
                                                fontFamily: !UtilsHelper
                                                        .rightHandLang
                                                        .contains(lang)
                                                    ? UtilsHelper
                                                        .wr_default_font_family
                                                    : UtilsHelper
                                                        .the_sans_font_family,
                                                fontSize: 14,
                                                color: _timeSpan ==
                                                        orderFrequency[0]
                                                    ? MyColor
                                                        .textPrimaryLightColor
                                                    : Color(0xffA6BCD0)),
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width: 11,
                                ),
                                GestureDetector(
                                  onTap: () {
                                    selectionMode.value =
                                        DateRangePickerSelectionMode.range;
                                    appState.carts.value[widget.index]
                                        .orderFrequency = orderFrequency[1];
                                    appState.carts.notifyListeners();
                                    localDataStorage.updateProduct(
                                        appState.carts.value[widget.index],
                                        appState.carts.value[widget.index].id!);
                                    setState(() {
                                      _timeSpan = orderFrequency[1];
                                    });
                                  },
                                  child: Container(
                                    height: 36,
                                    width: size.width * 0.23,
                                    decoration: BoxDecoration(
                                      color: _timeSpan == orderFrequency[1]
                                          ? MyColor.commonColorSet2
                                          : Theme.of(context).brightness !=
                                                  Brightness.light
                                              ? Color.fromRGBO(63, 76, 84, 1)
                                              : MyColor.mainColorWithBlack,
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(8),
                                      ),
                                    ),
                                    child: Center(
                                      child: Text(
                                        UtilsHelper.getString(context, 'daily'),
                                        style: Theme.of(context)
                                            .textTheme
                                            .headlineMedium
                                            ?.copyWith(
                                                fontFamily: !UtilsHelper
                                                        .rightHandLang
                                                        .contains(lang)
                                                    ? UtilsHelper
                                                        .wr_default_font_family
                                                    : UtilsHelper
                                                        .the_sans_font_family,
                                                fontSize: 14,
                                                color: _timeSpan ==
                                                        orderFrequency[1]
                                                    ? MyColor
                                                        .textPrimaryLightColor
                                                    : Color(0xffA6BCD0)),
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width: 11,
                                ),
                                // GestureDetector(
                                //   onTap: () {
                                //     selectionMode.value =
                                //         DateRangePickerSelectionMode.range;
                                //     appState.carts.value[widget.index]
                                //         .orderFrequency = orderFrequency[2];
                                //     appState.carts.notifyListeners();
                                //     localDataStorage.updateProduct(
                                //         appState.carts.value[widget.index],
                                //         appState.carts.value[widget.index].id!);
                                //     setState(() {
                                //       _timeSpan = orderFrequency[2];
                                //     });
                                //   },
                                //   child: Container(
                                //     height: 36,
                                //     width: size.width * 0.23,
                                //     decoration: BoxDecoration(
                                //       color: _timeSpan == orderFrequency[2]
                                //           ? MyColor.commonColorSet2
                                //           : Theme.of(context).brightness !=
                                //                   Brightness.light
                                //               ? Color.fromRGBO(63, 76, 84, 1)
                                //               : MyColor.mainColorWithBlack,
                                //       borderRadius: BorderRadius.all(
                                //         Radius.circular(8),
                                //       ),
                                //     ),
                                //     child: Center(
                                //       child: Text(
                                //         UtilsHelper.getString(
                                //             context, 'weekly'),
                                //         style: Theme.of(context)
                                //             .textTheme
                                //             .headlineMedium
                                //             ?.copyWith(
                                //                 fontFamily: !UtilsHelper
                                //                         .rightHandLang
                                //                         .contains(lang)
                                //                     ? UtilsHelper
                                //                         .wr_default_font_family
                                //                     : UtilsHelper
                                //                         .the_sans_font_family,
                                //                 fontSize: 14,
                                //                 color: _timeSpan ==
                                //                         orderFrequency[2]
                                //                     ? MyColor
                                //                         .textPrimaryLightColor
                                //                     : Color(0xffA6BCD0)),
                                //       ),
                                //     ),
                                //   ),
                                // ),
                              ],
                            ),
                            SizedBox(
                              height: 6,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                GestureDetector(
                                  onTap: () async {
                                    selectionMode.value =
                                        DateRangePickerSelectionMode.multiple;
                                    appState.carts.value[widget.index]
                                        .orderFrequency = orderFrequency[2];
                                    appState.carts.notifyListeners();
                                    localDataStorage.updateProduct(
                                        appState.carts.value[widget.index],
                                        appState.carts.value[widget.index].id!);
                                    setState(() {
                                      _timeSpan = orderFrequency[2];
                                    });
                                  },
                                  child: Container(
                                    height: 36,
                                    width: size.width * 0.23,
                                    decoration: BoxDecoration(
                                      color: _timeSpan == orderFrequency[2]
                                          ? MyColor.commonColorSet2
                                          : Theme.of(context).brightness !=
                                                  Brightness.light
                                              ? Color.fromRGBO(63, 76, 84, 1)
                                              : MyColor.mainColorWithBlack,
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(8),
                                      ),
                                    ),
                                    child: Center(
                                      child: Text(
                                        UtilsHelper.getString(
                                            context, 'Flexible'),
                                        style: Theme.of(context)
                                            .textTheme
                                            .headlineMedium
                                            ?.copyWith(
                                                fontFamily: !UtilsHelper
                                                        .rightHandLang
                                                        .contains(lang)
                                                    ? UtilsHelper
                                                        .wr_default_font_family
                                                    : UtilsHelper
                                                        .the_sans_font_family,
                                                fontSize: 14,
                                                color: _timeSpan ==
                                                        orderFrequency[2]
                                                    ? MyColor
                                                        .textPrimaryLightColor
                                                    : Color(0xffA6BCD0)),
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width: 11,
                                ),
                                GestureDetector(
                                  onTap: () {
                                    selectionMode.value =
                                        DateRangePickerSelectionMode.range;
                                    appState.carts.value[widget.index]
                                        .orderFrequency = orderFrequency[3];
                                    appState.carts.notifyListeners();
                                    localDataStorage.updateProduct(
                                        appState.carts.value[widget.index],
                                        appState.carts.value[widget.index].id!);
                                    setState(() {
                                      _timeSpan = orderFrequency[3];
                                    });
                                  },
                                  child: Container(
                                    height: 36,
                                    width: size.width * 0.49,
                                    decoration: BoxDecoration(
                                      color: _timeSpan == orderFrequency[3]
                                          ? MyColor.commonColorSet2
                                          : Theme.of(context).brightness !=
                                                  Brightness.light
                                              ? Color.fromRGBO(63, 76, 84, 1)
                                              : MyColor.mainColorWithBlack,
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(8),
                                      ),
                                    ),
                                    child: Center(
                                      child: Text(
                                        UtilsHelper.getString(
                                            context, 'alternative'),
                                        style: Theme.of(context)
                                            .textTheme
                                            .headlineMedium
                                            ?.copyWith(
                                                fontFamily: !UtilsHelper
                                                        .rightHandLang
                                                        .contains(lang)
                                                    ? UtilsHelper
                                                        .wr_default_font_family
                                                    : UtilsHelper
                                                        .the_sans_font_family,
                                                fontSize: 14,
                                                color: _timeSpan ==
                                                        orderFrequency[3]
                                                    ? MyColor
                                                        .textPrimaryLightColor
                                                    : Color(0xffA6BCD0)),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 14,
                        ),
                        _timeSpan == orderFrequency[3]
                            ? Row(
                                children: [
                                  Icon(Icons.info_outline,
                                      color: Theme.of(context).brightness ==
                                              Brightness.dark
                                          ? Color(0xffF0F4F8)
                                          : MyColor.commonColorSet1),
                                  SizedBox(width: 10),
                                  Expanded(
                                    child: Container(
                                      alignment: Alignment.centerLeft,
                                      child: Text(
                                        UtilsHelper.getString(context,
                                            "select_alternative_days_instruction"),
//                                                    textAlign: TextAlign.center,
                                        style: Theme.of(context)
                                            .textTheme
                                            .headlineMedium
                                            ?.copyWith(
                                              fontFamily: !UtilsHelper
                                                      .rightHandLang
                                                      .contains(lang)
                                                  ? UtilsHelper
                                                      .wr_default_font_family
                                                  : UtilsHelper
                                                      .the_sans_font_family,
                                              fontSize: 12,
                                              color: Theme.of(context)
                                                          .brightness ==
                                                      Brightness.dark
                                                  ? Color(0xffF0F4F8)
                                                  : MyColor.commonColorSet1,
                                            ),
                                      ),
                                    ),
                                  ),
                                ],
                              )
                            : SizedBox(height: 20),
                        _timeSpan == orderFrequency[2]
                            ? Column(
                                children: [
                                  SizedBox(height: 6),
                                  Align(
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                      UtilsHelper.getString(
                                          context, "select_days_for_delivery"),
                                      style: Theme.of(context)
                                          .textTheme
                                          .headlineMedium
                                          ?.copyWith(
                                              fontFamily: !UtilsHelper
                                                      .rightHandLang
                                                      .contains(lang)
                                                  ? UtilsHelper
                                                      .wr_default_font_family
                                                  : UtilsHelper
                                                      .the_sans_font_family,
                                              fontSize: 14,
                                              color: dark(context)
                                                  ? Colors.white
                                                  : MyColor.commonColorSet1,
                                              fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                  SizedBox(height: 8),
                                  //   WeekdaySelector(
                                  //     disabledShape: CircleBorder(
                                  //         side: BorderSide(
                                  //             width: 1, color: Colors.white)),
                                  //     selectedColor: Colors.white,
                                  //     selectedFillColor:
                                  //         Theme.of(context).brightness ==
                                  //                 Brightness.dark
                                  //             ? MyColor.commonColorSet2
                                  //             : MyColor.commonColorSet1,
                                  //     onChanged: (int day) {
                                  //       setState(() {
                                  //         // Use module % 7 as Sunday's index in the array is 0 and
                                  //         // DateTime.sunday constant integer value is 7.
                                  //         final _index = day % 7;
                                  //         // We "flip" the value in this example, but you may also
                                  //         // perform validation, a DB write, an HTTP call or anything
                                  //         // else before you actually flip the value,
                                  //         // it's up to your app's needs.
                                  //         daysOfDays[_index] =
                                  //             !daysOfDays[_index];
                                  //         List<int> _selectedDate = [];
                                  //         for (int i = 0; i < 7; i++) {
                                  //           if (daysOfDays[i]) {
                                  //             _selectedDate.add(i);
                                  //           }
                                  //         }
                                  //         appState.carts.value[widget.index]
                                  //             .days = _selectedDate;
                                  //         appState.carts.notifyListeners();
                                  //         localDataStorage.updateProduct(
                                  //             appState.carts.value[widget.index],
                                  //             appState
                                  //                 .carts.value[widget.index].id!);
                                  //       });
                                  //     },
                                  //     values: daysOfDays,
                                  //   ),
                                  //   SizedBox(height: 8),
                                  Row(
                                    children: [
                                      Text(
                                        UtilsHelper.getString(
                                            context, "quick_selection"),
                                        style: Theme.of(context)
                                            .textTheme
                                            .headlineMedium
                                            ?.copyWith(
                                                fontFamily: !UtilsHelper
                                                        .rightHandLang
                                                        .contains(lang)
                                                    ? UtilsHelper
                                                        .wr_default_font_family
                                                    : UtilsHelper
                                                        .the_sans_font_family,
                                                fontSize: 12,
                                                color: dark(context)
                                                    ? Colors.white
                                                    : MyColor.black,
                                                fontWeight: FontWeight.bold),
                                      ),
                                      SizedBox(width: 8),
                                      InkWell(
                                        onTap: () {
                                          List<int> _selectedDate = [];
                                          for (int i = 0; i < 7; i++) {
                                            if (0 <= i && i < 5) {
                                              daysOfDays[i] = true;
                                              _selectedDate.add(i);
                                            } else {
                                              daysOfDays[i] = false;
                                            }
                                          }
//                              List<int> selectedDate = [];
//                              for(int i=0; i<daysOfDays.length; i++) {
//                                if(daysOfDays[i]) {
//                                  selectedDate.add(i);
//                                }
//                              }
                                          appState.carts.value[widget.index]
                                              .days = _selectedDate;
                                          appState.carts.notifyListeners();
                                          localDataStorage.updateProduct(
                                              appState
                                                  .carts.value[widget.index],
                                              appState.carts.value[widget.index]
                                                  .id!);
//                              setState(() {});
                                        },
                                        child: Container(
                                          decoration: BoxDecoration(
                                              color: appState
                                                          .carts
                                                          .value[widget.index]
                                                          .days !=
                                                      null
                                                  ? appState
                                                              .carts
                                                              .value[
                                                                  widget.index]
                                                              .days!
                                                              .length !=
                                                          2
                                                      ? MyColor.commonColorSet2
                                                      : Colors.transparent
                                                  : Colors.transparent,
                                              border: Border.all(
                                                  color: appState
                                                              .carts
                                                              .value[
                                                                  widget.index]
                                                              .days !=
                                                          null
                                                      ? appState
                                                                  .carts
                                                                  .value[widget
                                                                      .index]
                                                                  .days!
                                                                  .length !=
                                                              2
                                                          ? Colors.transparent
                                                          : dark(context)
                                                              ? Colors.white
                                                                  .withOpacity(
                                                                      0.2)
                                                              : Colors.grey.withOpacity(
                                                                  0.5)
                                                      : Colors.transparent),
                                              borderRadius:
                                                  BorderRadius.all(Radius.circular(40))),
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 12, vertical: 6),
                                          child: Text(
                                            UtilsHelper.getString(
                                                context, "weekdays"),
                                            style: Theme.of(context)
                                                .textTheme
                                                .headlineMedium
                                                ?.copyWith(
                                                    fontFamily: !UtilsHelper
                                                            .rightHandLang
                                                            .contains(lang)
                                                        ? UtilsHelper
                                                            .wr_default_font_family
                                                        : UtilsHelper
                                                            .the_sans_font_family,
                                                    fontSize: 10,
                                                    color: dark(context)
                                                        ? appState.carts.value[widget.index].days !=
                                                                    null &&
                                                                appState.carts.value[widget.index].days!.length !=
                                                                    2
                                                            ? MyColor.white
                                                            : Colors.white
                                                                .withOpacity(
                                                                    0.5)
                                                        : appState.carts.value[widget.index].days !=
                                                                    null &&
                                                                appState
                                                                        .carts
                                                                        .value[widget.index]
                                                                        .days!
                                                                        .length !=
                                                                    2
                                                            ? MyColor.white
                                                            : MyColor.black!.withOpacity(0.5),
                                                    fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                      ),
                                      SizedBox(width: 8),
                                      InkWell(
                                        onTap: () {
                                          List<int> _selectedDate = [];
                                          for (int i = 0; i < 7; i++) {
                                            if (0 <= i && i < 5) {
                                              daysOfDays[i] = false;
                                            } else {
                                              daysOfDays[i] = true;
                                              _selectedDate.add(i);
                                            }
                                          }
//                              List<int> selectedDate = [];
//                              for(int i=0; i<daysOfDays.length; i++) {
//                                if(daysOfDays[i]) {
//                                  selectedDate.add(i);
//                                }
//                              }
                                          appState.carts.value[widget.index]
                                              .days = _selectedDate;
                                          appState.carts.notifyListeners();
                                          localDataStorage.updateProduct(
                                              appState
                                                  .carts.value[widget.index],
                                              appState.carts.value[widget.index]
                                                  .id!);
//                              setState(() {});
                                        },
                                        child: Container(
                                          decoration: BoxDecoration(
                                              color:
                                                  appState.carts.value[widget.index].days !=
                                                              null &&
                                                          appState
                                                                  .carts
                                                                  .value[widget
                                                                      .index]
                                                                  .days!
                                                                  .length ==
                                                              2
                                                      ? MyColor.commonColorSet2
                                                          as Color
                                                      : Colors.transparent,
                                              border: Border.all(
                                                  color: appState
                                                                  .carts
                                                                  .value[widget
                                                                      .index]
                                                                  .days !=
                                                              null &&
                                                          appState
                                                                  .carts
                                                                  .value[widget.index]
                                                                  .days!
                                                                  .length ==
                                                              2
                                                      ? dark(context)
                                                          ? Colors.transparent
                                                          : Colors.transparent
                                                      : dark(context)
                                                          ? MyColor.white!.withOpacity(0.5)
                                                          : Colors.grey!.withOpacity(0.5)),
                                              borderRadius: BorderRadius.all(Radius.circular(40))),
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 12, vertical: 6),
                                          child: Text(
                                              UtilsHelper.getString(
                                                  context, "weekend"),
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .headlineMedium
                                                  ?.copyWith(
                                                      fontFamily: !UtilsHelper
                                                              .rightHandLang
                                                              .contains(lang)
                                                          ? UtilsHelper
                                                              .wr_default_font_family
                                                          : UtilsHelper
                                                              .the_sans_font_family,
                                                      fontSize: 10,
                                                      color: appState
                                                                      .carts
                                                                      .value[widget
                                                                          .index]
                                                                      .days !=
                                                                  null &&
                                                              appState
                                                                      .carts
                                                                      .value[widget.index]
                                                                      .days!
                                                                      .length ==
                                                                  2
                                                          ? Colors.white
                                                          : dark(context)
                                                              ? Colors.white
                                                              : MyColor.black!.withOpacity(0.5),
                                                      fontWeight: FontWeight.bold)),
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 15)
                                ],
                              )
                            : SizedBox(height: 20),
                        ValueListenableBuilder(
                            valueListenable: selectionMode,
                            builder: (context,
                                DateRangePickerSelectionMode _selectionMode,
                                _) {
                              return Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Container(
                                    padding: lang == 'en'
                                        ? EdgeInsets.symmetric(horizontal: 14)
                                        : EdgeInsets.only(right: 14),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          UtilsHelper.getString(
                                              context, 'select_date'),
                                          style: Theme.of(context)
                                              .textTheme
                                              .headlineMedium
                                              ?.copyWith(
                                                fontFamily: !UtilsHelper
                                                        .rightHandLang
                                                        .contains(lang)
                                                    ? UtilsHelper
                                                        .wr_default_font_family
                                                    : UtilsHelper
                                                        .the_sans_font_family,
                                                color: Theme.of(context)
                                                            .brightness ==
                                                        Brightness.light
                                                    ? MyColor.commonColorSet1
                                                    : Colors.white,
                                                fontSize: 12,
                                                fontWeight: FontWeight.bold,
                                              ),
                                        ),
                                        Container(
                                          child: Row(
                                            textDirection: TextDirection.ltr,
                                            children: [
                                              Container(
                                                margin:
                                                    EdgeInsets.only(right: 14),
                                                child: GestureDetector(
                                                  onTap: () {
                                                    setState(() {
                                                      _dateRangePickerController
                                                          .backward
                                                          ?.call();
                                                    });
                                                  },
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            3.0),
                                                    child: Icon(
                                                      Icons.arrow_back,
                                                      textDirection:
                                                          TextDirection.ltr,
                                                      size: 15,
                                                      color: dark(context)
                                                          ? Colors.white
                                                          : null,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              if (lang != 'en')
                                                SizedBox(
                                                  width: 10,
                                                ),
                                              Container(
                                                alignment: Alignment.center,
                                                child: Text(
                                                  UtilsHelper.getString(
                                                          context,
                                                          months[_dateRangePickerController
                                                                      .displayDate
                                                                      ?.month !=
                                                                  null
                                                              ? _dateRangePickerController
                                                                      .displayDate!
                                                                      .month -
                                                                  1
                                                              : DateTime.now()
                                                                      .month -
                                                                  1]) +
                                                      " ${_dateRangePickerController.displayDate?.year ?? DateTime.now().year}"
                                                          .toUpperCase(),
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .headlineMedium
                                                      ?.copyWith(
                                                          fontFamily: !UtilsHelper
                                                                  .rightHandLang
                                                                  .contains(
                                                                      lang)
                                                              ? UtilsHelper
                                                                  .wr_default_font_family
                                                              : UtilsHelper
                                                                  .the_sans_font_family,
                                                          fontSize: 12,
                                                          color: Theme.of(context)
                                                                      .brightness ==
                                                                  Brightness
                                                                      .light
                                                              ? MyColor
                                                                  .commonColorSet1
                                                              : Colors.white,
                                                          fontWeight:
                                                              FontWeight.w400),
                                                ),
                                              ),
                                              if (lang != 'en')
                                                SizedBox(
                                                  width: 10,
                                                ),
                                              Container(
                                                margin:
                                                    EdgeInsets.only(left: 14),
                                                child: GestureDetector(
                                                  onTap: () {
                                                    setState(() {
                                                      _dateRangePickerController
                                                          .forward
                                                          ?.call();
                                                    });
                                                  },
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            3.0),
                                                    child: Icon(
                                                        Icons.arrow_forward,
                                                        size: 15,
                                                        color: dark(context)
                                                            ? Colors.white
                                                            : null,
                                                        textDirection:
                                                            TextDirection.ltr),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Container(
                                    height: 300,
                                    // color: MyColor.mainColor,
                                    child: CustomDatePicker(
                                      controller: _dateRangePickerController,
                                      lang: lang,
                                      selectionMode: _selectionMode,
                                      initialSelectedDate: _initialSelectedDate,
                                      initialSelectedDates:
                                          _initialSelectedDates,
                                      initialSelectedRange:
                                          _initialSelectedRange,
                                      onSelectionChanged:
                                          (DateRangePickerSelectionChangedArgs
                                              args) {
                                        //                                  print(index);
                                        _onSelectionChanged.call(args);
                                      },
                                    ),
                                  ),
                                ],
                              );
                            }),
                        /*Container(
                                        margin: EdgeInsets.only(left: 10, right: 10, bottom: 2),
                                        child: Row(
                                          children: [
                                          Expanded(
                                            child: Text(UtilsHelper.getString(context, "start_from")),
                                          ),
                                          Container(
                                            padding: EdgeInsets.only(left: 10),
                                          ),
                                          Expanded(
                                            child: Text(UtilsHelper.getString(
                                                context,
                                                "select_deliveries")),
                                          ),
                                          ],
                                        ),
                                      ),
                                      Container(
                                        margin: EdgeInsets.only(left: 5, right: 5, bottom: 15),
                                        child: Row(
                                          children: [
                                            Expanded(
                                                child: InkWell(
                                                  onTap: () async {
                                                    if (DateTime.now()
                                                        .difference(
                                                        fromDate ?? DateTime.now())
                                                        .inDays >
                                                        0) {
                                                      fromDate =
                                                          DateTime.now().add(Duration(days: 1));
                                                    }
                                                    print("fromDate $fromDate");
                                                    fromDate = await selectDateFromPicker(
                                                      context,
                                                      startDate: DateTime.now().add(
                                                        Duration(days: 1),
                                                      ),
                                                      endDate: DateTime.now().add(
                                                        Duration(days: 7),
                                                      ),
                                                    );
                                                    if (fromDate != null) {
                                                      fromDateController.text =
                                                          ddMMMYYYYFormat.format(fromDate!);
                                                    }
                                                    setState(() {});
                                                  },
                                                  child: IgnorePointer(
                                                    child: commonFloatingFormField(context, "",
                                                        fieldHeight: 60,
                                                        color: Theme.of(context).hoverColor,
                                                        controller: fromDateController,
                                                        hintText: UtilsHelper.getString(
                                                            context, "start_from"),
                                                        cornerRed: 15),
                                                  ),
                                                )),
                                            Container(
                                              padding: EdgeInsets.only(left: 10),
                                            ),
                                            Expanded(
                                                child: Container(
                                                  height: 60,
                                                  child: noOfDeliveryList != null
                                                      ? FormField<String>(
                                                    builder:
                                                        (FormFieldState<String> state) {
                                                      return InputDecorator(
                                                        decoration: InputDecoration(
//                                                          fillColor: AppThemes
//                                                              .lightTextFieldBackGroundColor,
                                                          filled: true,
                                                          errorStyle: TextStyle(
                                                              color: Colors.redAccent,
                                                              fontSize: 16.0),
                                                          hintText: UtilsHelper.getString(
                                                              context,
                                                              "select_deliveries") +
                                                              " ",
                                                          border: OutlineInputBorder(
                                                              borderRadius:
                                                              BorderRadius.all(
                                                                  Radius.circular(15)),
                                                              borderSide: BorderSide(
                                                                  color: Theme.of(context)
                                                                      .focusColor
                                                                      .withOpacity(0.0))),
                                                          focusedBorder: OutlineInputBorder(
                                                              borderRadius:
                                                              BorderRadius.all(
                                                                  Radius.circular(15)),
                                                              borderSide: BorderSide(
                                                                  color: Theme.of(context)
                                                                      .focusColor
                                                                      .withOpacity(0.0))),
                                                          enabledBorder: OutlineInputBorder(
                                                              borderRadius:
                                                              BorderRadius.all(
                                                                  Radius.circular(15)),
                                                              borderSide: BorderSide(
                                                                  color: Theme.of(context)
                                                                      .focusColor
                                                                      .withOpacity(0.0))),
                                                        ),
                                                        isEmpty: selectedDeliveries == null,
                                                        child: DropdownButtonHideUnderline(
                                                          child: DropdownButton<String>(
                                                            isExpanded: true,
                                                            value: selectedDeliveries,
                                                            items: noOfDeliveryList
                                                                .map<
                                                                DropdownMenuItem<
                                                                    String>>(
                                                                    (String value) {
                                                                  return DropdownMenuItem<
                                                                      String>(
                                                                    value: value,
                                                                    child: Text("$value"),
                                                                  );
                                                                }).toList(),
                                                            hint: Text(
                                                          UtilsHelper.getString(
                                                          context, "select_deliveries") +
                                                                  " ",
                                                            ),
                                                            onChanged: (String? value) {
                                                              setState(() {
                                                                selectedDeliveries = value;
                                                              });
                                                            },
                                                          ),
                                                        ),
                                                      );
                                                    },
                                                  )
                                                      : Container(),
                                                )
                                            ),
                                          ],
                                        ),
                                      ),*/
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 12,
              ),
            ],
          )
        : Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: Theme.of(context).brightness == Brightness.light
                  ? Color(0xffF0F4F8)
                  : Color.fromRGBO(30, 43, 51, 1),
            ),
            margin: EdgeInsets.only(
                right: lang == 'en' ? 6 : 0, left: lang != 'en' ? 6 : 0),
            child: InkWell(
              onTap: () {
                widget.open!.call();
                setState(() {});
              },
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Container(
                  height: 80,
                  padding: EdgeInsets.symmetric(vertical: 8),
                  // constraints: BoxConstraints(minHeight: 60),
                  width: size.width - 60,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Container(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SizedBox(width: 8),
                        ClipRRect(
                          child: Container(
                            width: 60,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                image: DecorationImage(
                                    fit: BoxFit.contain,
                                    image: CachedNetworkImageProvider(
                                      Urls.getImageUrlFromName(
                                          widget.product!.image ?? ""),
                                    ))),
                          ),
                        ),
                        SizedBox(width: 8),
                        Expanded(
                          child: Container(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SizedBox(height: 3),
                                Row(
                                  children: [
                                    Expanded(
                                      child: Text(
                                        widget.product!.name!,
                                        style: Theme.of(context)
                                            .textTheme
                                            .displaySmall
                                            ?.copyWith(
                                              fontFamily: !UtilsHelper
                                                      .rightHandLang
                                                      .contains(lang)
                                                  ? UtilsHelper
                                                      .wr_default_font_family
                                                  : UtilsHelper
                                                      .the_sans_font_family,
                                              fontSize: 14,
                                              fontWeight: FontWeight.w600,
                                              color: Theme.of(context)
                                                          .brightness ==
                                                      Brightness.light
                                                  ? MyColor.commonColorSet1
                                                  : MyColor.white,
                                            ),
                                      ),
                                    ),
                                  ],
                                ),
                                Spacer(),
                                Text(
                                  (widget.product!.discountPrice != null &&
                                          widget.product!.discountPrice! > 0)
                                      ? displayPrice(
                                          widget.product!.discountPrice)
                                      : displayPrice(widget.product!.price),
                                  textDirection: TextDirection.ltr,
                                  style: Theme.of(context)
                                      .textTheme
                                      .displaySmall
                                      ?.copyWith(
                                          fontFamily: !UtilsHelper.rightHandLang
                                                  .contains(lang)
                                              ? UtilsHelper
                                                  .wr_default_font_family
                                              : UtilsHelper
                                                  .the_sans_font_family,
                                          fontSize: 16,
                                          // color: Color(0xffA6BCD0),
                                          fontWeight: FontWeight.normal),
                                ),
                                SizedBox(height: 3)
                              ],
                            ),
                          ),
                        ),
                        IconButton(
                          onPressed: () {
                            appState.removeProductFromCart(widget.product!);
                          },
                          icon: Container(
                            width: 30,
                            height: 30,
                            // decoration: BoxDecoration(
                            //   color: MyColor.commonColorSet1,
                            //   borderRadius: BorderRadius.circular(8)
                            // ),
                            child: Center(
                              child: SvgPicture.asset(
                                "assets/edit_delete.svg",
                                colorFilter: ColorFilter.mode(
                                    Colors.red, BlendMode.srcIn),
                                fit: BoxFit.fitHeight,
                              ),
                            ),
                          ),
                        ),
                        Container(
                          height: 8,
                          padding: EdgeInsets.only(left: 10, right: 10),
                          child: RotatedBox(
                            quarterTurns: 3,
                            child: SvgPicture.asset(
                              "assets/icon-chevron.svg",
                              fit: BoxFit.fitHeight,
                              width: 8,
                              colorFilter: ColorFilter.mode(
                                  MyColor.binBackground as Color,
                                  BlendMode.srcIn),
                            ),
                          ),
                        ),
                        SizedBox(width: 8)
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
  }

  void updateCalenderSelectionMode(String? orderFrequency) {
    switch (orderFrequency) {
      case 'once':
        selectionMode.value = DateRangePickerSelectionMode.single;
        break;
      case 'daily':
        selectionMode.value = DateRangePickerSelectionMode.range;
        break;
      // case 'weekly':
      //   selectionMode.value = DateRangePickerSelectionMode.range;
      //   break;
      case 'flexible':
        selectionMode.value = DateRangePickerSelectionMode.multiple;
        break;
      case 'alternative':
        selectionMode.value = DateRangePickerSelectionMode.range;
        break;
      default:
        selectionMode.value = DateRangePickerSelectionMode.single;
        break;
    }
  }
}
