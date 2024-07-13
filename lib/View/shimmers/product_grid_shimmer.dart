import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:water/Utils/ThemeData/themeColors.dart';

import '../../Utils/rgbo_to_hex.dart';

class ProductGridShimmer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GridView.custom(
      padding: EdgeInsets.all(4),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 15,
        mainAxisSpacing: 10,
        childAspectRatio: 0.73,
      ),
      shrinkWrap: true,
      primary: false,
      scrollDirection: Axis.vertical,
      childrenDelegate: SliverChildListDelegate(
        List<int>.generate(10, (i) => i + 1).map(
              (data) => Container(
            decoration: BoxDecoration(
              borderRadius:
              BorderRadius.all(Radius.circular(8)),
              color: MyColor.coreBackgroundColor,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.shade300,
                  offset: Offset(0, 1), //(x,y)
                  blurRadius: 4,
                ),
              ],
            ),
            padding: EdgeInsets.symmetric(
              horizontal: 0,
              vertical: 0,
            ),
            child: Shimmer.fromColors(
              baseColor:  !dark(context)? Colors.grey[200] ?? MyColor.lightShimmerBaseColor : MyColor.lightShimmerBaseColor,
              highlightColor:  !dark(context)? Colors.grey[300] ?? MyColor.lightShimmerHighlightColor :  MyColor.lightShimmerHighlightColor,
              child: Container(
//                width: MediaQuery.of(context).size.width*0.89,
                decoration: BoxDecoration(
                  color: Colors.amber,
                  borderRadius: BorderRadius.all(
                    Radius.circular(10),
                  ),
                ),
              ),
            ),
          ),
        ).toList(),
      ),
    );
  }
}
