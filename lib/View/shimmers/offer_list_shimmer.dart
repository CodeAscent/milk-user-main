import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:water/Utils/ThemeData/themeColors.dart';

import '../../Utils/rgbo_to_hex.dart';

class OfferListShimmer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: 10,
      padding: EdgeInsets.zero,
      separatorBuilder: (context, index) {
        return SizedBox(height: 15);
      },
      itemBuilder: (context, index) {
        return Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(
              Radius.circular(5),
            ),
            // color: Colors.red,
          ),
          child: Shimmer.fromColors(
            baseColor:!dark(context) ? Colors.grey.shade100 :  MyColor.lightShimmerBaseColor,
            highlightColor: !dark(context) ? Colors.grey.shade300 : MyColor.lightShimmerHighlightColor,
            child: Container(
                width: MediaQuery.of(context).size.width*0.89,
              height: 152,
              decoration: BoxDecoration(
                color: Colors.amber,
                borderRadius: BorderRadius.all(
                  Radius.circular(10),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class OfferAlertListShimmer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: List.generate(10,
              (index) {
            return Container(
              margin: EdgeInsets.only(
                  bottom:
                  index == 9
                      ? 0
                      : 11),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(
                    Radius.circular(10),
                  ),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.all(
                    Radius.circular(10),
                  ),
                  child: Shimmer.fromColors(
                    baseColor:dark(context)? Colors.grey.shade800 : MyColor.lightShimmerBaseColor,
                    highlightColor:dark(context)? Colors.grey.shade900 : MyColor.lightShimmerHighlightColor,
                    child: Container(
                      width: MediaQuery.of(context).size.width*0.89,
                      height: 50,
                      decoration: BoxDecoration(
                        color: Colors.amber,
                        borderRadius: BorderRadius.all(
                          Radius.circular(10),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            );
          }),
    );
  }
}
