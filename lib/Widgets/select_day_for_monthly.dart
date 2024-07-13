import 'package:flutter/material.dart';
import 'package:water/Utils/ThemeData/themeColors.dart';
import 'package:water/Utils/UtilHelper.dart';

class SelectDaysForMonthly extends StatefulWidget {
  final List<int>? selectedDayOfMonth;

  SelectDaysForMonthly({Key? key, this.selectedDayOfMonth}) : super(key: key);

  @override
  _SelectDaysForMonthlyState createState() => _SelectDaysForMonthlyState();
}

class _SelectDaysForMonthlyState extends State<SelectDaysForMonthly> {
  var monthlyDayList = new List<int>.generate(31, (i) => i + 1);
  List<int> selectedDayOfMonth = [];

  @override
  void initState() {
    super.initState();
    if (widget.selectedDayOfMonth != null) {
      selectedDayOfMonth = widget.selectedDayOfMonth!;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            alignment: Alignment.centerLeft,
            padding: EdgeInsets.only(left: 20, top: 20),
            child: Text(
              UtilsHelper.getString(
                  context, "select_date_for_monthly_delivery"),
              style: Theme.of(context).textTheme.displayMedium!.copyWith(
                    fontWeight: FontWeight.w500,
                    fontSize: 18,
                  ),
            ),
          ),
          SizedBox(height: 15),
          Wrap(
            children: monthlyDayList
                .map((item) {
                  bool isSelected = selectedDayOfMonth.contains(item);
                  return Container(
                    margin:
                        EdgeInsets.only(left: 15, right: 15, top: 4, bottom: 4),
                    child: InkWell(
                      onTap: () {
                        if (isSelected) {
                          selectedDayOfMonth.remove(item);
                        } else {
                          selectedDayOfMonth.add(item);
                        }
                        setState(() {});
                      },
                      child: ClipOval(
                          child: Container(
                              alignment: Alignment.center,
                              color:
                                  isSelected ? MyColor.commonColorSet1 : null,
                              height: 30,
                              width: 30,
                              child: Text(item.toString(),
                                  style: TextStyle(
                                      color: isSelected
                                          ? Theme.of(context).primaryColor
                                          : null)))),
                    ),
                  );
                })
                .toList()
                .cast<Widget>(),
          ),
          SizedBox(height: 15),
          Row(
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Container(
                    margin: EdgeInsets.only(left: 20, right: 10),
                    decoration: BoxDecoration(
                        color: MyColor.commonColorSet2,
                        borderRadius: BorderRadius.all(Radius.circular(25)),
                        border: Border.all(color: MyColor.commonColorSet2!)),
                    child: Center(
                      child: Container(
                        padding: EdgeInsets.only(
                            left: 15, right: 15, top: 15, bottom: 15),
                        child: Text(
                          UtilsHelper.getString(context, "cancel"),
                          style: Theme.of(context)
                              .textTheme
                              .headlineSmall!
                              .copyWith(
                                  color: Theme.of(context).primaryColor,
                                  fontSize: 15,
                                  fontWeight: FontWeight.w600),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    Navigator.pop(context, selectedDayOfMonth);
                  },
                  child: Container(
                    margin: EdgeInsets.only(left: 10, right: 20),
                    decoration: BoxDecoration(
                        color: MyColor.commonColorSet1,
                        borderRadius: BorderRadius.all(Radius.circular(25)),
                        border: Border.all(color: MyColor.commonColorSet1!)),
                    child: Center(
                      child: Container(
                        padding: EdgeInsets.only(
                            left: 15, right: 15, top: 15, bottom: 15),
                        child: Text(
                          UtilsHelper.getString(context, "confirm"),
                          style: Theme.of(context)
                              .textTheme
                              .headlineSmall!
                              .copyWith(
                                  color: Theme.of(context).primaryColor,
                                  fontSize: 15,
                                  fontWeight: FontWeight.w600),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 10),
        ],
      ),
    );
  }
}
