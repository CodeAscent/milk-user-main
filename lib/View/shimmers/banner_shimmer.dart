import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:water/Utils/ThemeData/themeColors.dart';

import '../../Utils/rgbo_to_hex.dart';

class BannerShimmer extends StatefulWidget {

  @override
  _BannerShimmerState createState() => _BannerShimmerState();
}

class _BannerShimmerState extends State<BannerShimmer> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 220 ,
      margin: EdgeInsets.only(top: 20),
      child: CarouselSlider(
        options: CarouselOptions(
          viewportFraction: 1,
          enlargeCenterPage: false,
          // height: 179.0,
          aspectRatio: 16/9,
          onPageChanged: (index, reason) {
            setState(() {
              _currentIndex = index;
            });
          },
        ),
        items: [5].map((i) {
          return Builder(
            builder: (BuildContext context) {
              return ClipRRect(
                borderRadius: BorderRadius.all(
                  Radius.circular(8),
                ),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(
                      Radius.circular(5),
                    ),
                    // color: Colors.red,
                  ),
                  child:
                  Shimmer.fromColors(
                    baseColor: !dark(context)? Colors.grey[300] ??  MyColor.lightShimmerBaseColor : MyColor.lightShimmerBaseColor,
                    highlightColor:  !dark(context)? Colors.grey[200] ?? MyColor.lightShimmerHighlightColor :  MyColor.lightShimmerHighlightColor,
                    child: Container(
                      width: MediaQuery.of(context).size.width*0.89,
                      decoration: BoxDecoration(
                        color: Colors.amber,
                        borderRadius: BorderRadius.all(
                          Radius.circular(10),
                        ),
                      ),
                    ),
                  ),
                ),
              );
            },
          );
        }).toList(),
      ),
    );
  }
}
