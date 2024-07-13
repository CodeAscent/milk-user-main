import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import 'package:water/Utils/ThemeData/themeColors.dart';
import 'package:water/Utils/UtilHelper.dart';
import 'package:water/Utils/rgbo_to_hex.dart';

import '../Utils/local_data/app_state.dart';

class CustomDatePicker extends StatefulWidget {
  final DateRangePickerController controller;
  final String lang;
  final DateRangePickerSelectionMode selectionMode;
  final DateTime? initialSelectedDate;
  final List<DateTime>? initialSelectedDates;
  final PickerDateRange? initialSelectedRange;
  final DateRangePickerSelectionChangedCallback? onSelectionChanged;

  const CustomDatePicker(
      {Key? key,
      required this.controller,
      required this.lang,
      required this.selectionMode,
      this.initialSelectedDate,
      this.initialSelectedDates,
      this.initialSelectedRange,
      this.onSelectionChanged})
      : super(key: key);

  @override
  _CustomDatePickerState createState() => _CustomDatePickerState();
}

class _CustomDatePickerState extends State<CustomDatePicker> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: SfDateRangePicker(
          key: UniqueKey(),
          //          initialSelectedDates: [DateTime(2021,7,17), DateTime(2021,7,19)],
          initialSelectedDate: widget.initialSelectedDate,
          initialSelectedDates: widget.initialSelectedDates,
          initialSelectedRange: widget.initialSelectedRange,
          minDate: DateTime.now().add(Duration(days: 1)),
        
          controller: widget.controller,
          showNavigationArrow: true,
          backgroundColor: dark(context) ? Color.fromRGBO(30, 43, 51, 1) : Color(0xffF0F4F8),
          headerHeight: 0,
          //          initialSelectedDate: DateTime.now(),
          selectionColor:  MyColor.commonColorSet2,
          rangeSelectionColor: MyColor.commonColorSet2!.withOpacity(0.4),
          selectionRadius:100,
   
          endRangeSelectionColor: MyColor.commonColorSet2,
          startRangeSelectionColor: MyColor.commonColorSet2,
          selectionShape: DateRangePickerSelectionShape.circle,
      
          todayHighlightColor: dark(context)? MyColor.white :MyColor.commonColorSet2,
          selectionMode: widget.selectionMode,
          // cellBuilder: (context, cellDetails) {
          //   //  final bool isToday = cellDetails.date.day+1 == 4;
          //   // final bool isCurrentMonth = cellDetails.date.month == cellDetails.visibleDates[0].month;
          //   return  Container(
          //            width: cellDetails.bounds.width,
          //           height: cellDetails.bounds.height,
          //           alignment: Alignment.center,
          //           decoration: BoxDecoration(
          //             borderRadius: BorderRadius.circular(12)
          //           ),
          //           child: Text(cellDetails.date.day.toString().padLeft(2,'0')),
          //     );
          // },
          selectionTextStyle: TextStyle(
            color: MyColor.white,
            fontFamily:  !UtilsHelper.rightHandLang.contains(appState.languageItem.languageCode)
                    ? UtilsHelper.wr_default_font_family
                    : UtilsHelper.the_sans_font_family,
            fontWeight: FontWeight.w400,
          ),
        //  rangeTextStyle: ,
          monthCellStyle: DateRangePickerMonthCellStyle(
            disabledDatesTextStyle: TextStyle(
                fontWeight: FontWeight.bold,
                color: Theme.of(context).brightness == Brightness.dark
                    ? MyColor.white!.withOpacity(0.4)
                    : MyColor.commonColorSet1!.withOpacity(0.5)),
            textStyle: TextStyle(
              fontFamily:  !UtilsHelper.rightHandLang.contains(appState.languageItem.languageCode)
                    ? UtilsHelper.wr_default_font_family
                    : UtilsHelper.the_sans_font_family,
              fontWeight: FontWeight.w400,
              color: Theme.of(context).brightness == Brightness.dark
                  ? MyColor.white
                  : MyColor.commonColorSet1,
            ),
          ),
        
          monthViewSettings: DateRangePickerMonthViewSettings(
            enableSwipeSelection: false,
            dayFormat: 'EE',
            
            viewHeaderStyle: DateRangePickerViewHeaderStyle(
              textStyle: TextStyle(
                fontSize: widget.lang == 'en' ? 14 : 11,
                fontFamily: !UtilsHelper.rightHandLang.contains(widget.lang)
                    ? UtilsHelper.wr_default_font_family
                    : UtilsHelper.the_sans_font_family,
                fontWeight: FontWeight.w400,
                color: dark(context) ?Colors.white :Color(0xff748A9D),
              ),
            ),
          ),
          headerStyle: DateRangePickerHeaderStyle(
          //  backgroundColor: Color.fromRGBO(63, 76, 84, 1) ,
           textStyle: TextStyle(color: dark(context) ? Colors.white : MyColor.backgroundColor)),
          onSelectionChanged: widget.onSelectionChanged,
        ),
      ),
    );
  }
}
