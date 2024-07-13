import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class CacheNetworkImageWidget extends StatelessWidget {
  final String image;

  CacheNetworkImageWidget(this.image);

  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
        imageUrl: image,
        errorWidget: (context, url, error) => Container(
          constraints: BoxConstraints(maxHeight: 152),
          decoration: BoxDecoration(
            color: Colors.grey.withOpacity(0.2),
            borderRadius: BorderRadius.all(
              Radius.circular(5),
            ),
          ),
          child: Image.asset(
            "assets/placeholder_image.png",
          ),
        ),
        placeholder: (context, url) => Container(
          constraints: BoxConstraints(maxHeight: 152),
          decoration: BoxDecoration(
            color: Colors.grey.withOpacity(0.2),
            borderRadius: BorderRadius.all(
              Radius.circular(5),
            ),
          ),
          child: Image.asset(
            "assets/placeholder_image.png",
          ),
        )
    );
  }
}
