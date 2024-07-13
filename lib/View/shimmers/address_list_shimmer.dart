import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:water/Utils/ThemeData/themeColors.dart';
import 'package:water/Utils/local_data/app_state.dart';
import 'package:water/Utils/rgbo_to_hex.dart';

class AddressListShimmer extends StatelessWidget {
  final double? separatorHeight;

  AddressListShimmer({this.separatorHeight});

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        itemCount: 5,
        padding: EdgeInsets.zero,
        separatorBuilder: (context, index){
          return SizedBox(height: separatorHeight??10);
        },
        itemBuilder: (context, index){
      return Container(
        margin: EdgeInsets.only(
            bottom:
            index == 9
                ? 0
                : 11),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(
              Radius.circular(5),
            ),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.all(
              Radius.circular(5),
            ),
            child: Shimmer.fromColors(
              baseColor:  !dark(context)? Colors.grey[200] ??MyColor.lightShimmerBaseColor : MyColor.lightShimmerBaseColor,
              highlightColor:  !dark(context)? Colors.grey[300]??MyColor.lightShimmerHighlightColor : MyColor.lightShimmerHighlightColor,
              direction: appState.languageItem.languageCode == 'ar' ?
               ShimmerDirection.rtl : ShimmerDirection.ltr,
              child: Container(
                width: MediaQuery.of(context).size.width*0.89,
                height: 63,
                decoration: BoxDecoration(
                  color: MyColor.commonColorSet1,
                  borderRadius: BorderRadius.all(
                    Radius.circular(10),
                  ),
                ),
              ),
            ),
          ),
        ),
      );
    });
  }
}