import 'package:flutter/material.dart';
import 'package:water/Utils/ThemeData/themeColors.dart';
import 'package:water/Utils/UtilHelper.dart';
import 'package:water/Utils/local_data/app_state.dart';
import 'package:water/Utils/utils.dart';

class WalletHistoryTile extends StatelessWidget {
  final String? title;
  final double? amount;
  final bool isCredit;

  WalletHistoryTile(this.title, this.amount, this.isCredit);

  @override
  Widget build(BuildContext context) {
    var lang = appState.currentLanguageCode.value;

    return ClipRRect(
      
      child: Container(
        height: 62,
        decoration: BoxDecoration(
          color: MyColor.coreBackgroundColor,
          borderRadius: BorderRadius.all(Radius.circular(10)),
        ),
        padding: EdgeInsets.symmetric(horizontal: 12),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            RotatedBox(
              quarterTurns: amount.toString().contains('-') ? -2: 0,
              child: Icon(  Icons.arrow_outward_outlined,
              size: 20,
              color:  amount.toString().contains('-') ? 
                Colors.red.shade700 :Colors.green.shade700,
              ),
            ),
            SizedBox(width: 12),
            Expanded(
              child: Text(
                title ?? '',
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      fontSize: 12,
                      fontFamily: !UtilsHelper.rightHandLang.contains(lang) ?
                       UtilsHelper.wr_default_font_family : UtilsHelper.the_sans_font_family,
//                  color: MyColor.textPrimaryLightColor,
                  ),
              ),
            ),
            SizedBox(width: 12),
            Text(
              displayPriceDouble(amount!),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textDirection: TextDirection.ltr,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    fontWeight: FontWeight.w500,
                    fontFamily: !UtilsHelper.rightHandLang.contains(lang) ?
                     UtilsHelper.wr_default_font_family : UtilsHelper.the_sans_font_family,
                color:   amount.toString().contains('-') ? 
                     Colors.red.shade700 : Colors.green.shade700,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}
