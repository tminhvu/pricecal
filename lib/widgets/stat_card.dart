import 'package:flutter/material.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:pricecal/data/models/stat.dart';
import 'package:pricecal/my_navigator.dart';
import 'package:pricecal/ui_helpers.dart';
import 'package:pricecal/widgets/my_animated_neu_container.dart';

class StatCard extends StatelessWidget {
  final Stat stat;
  final Function()? onStatEdited;
  const StatCard({super.key, required this.stat, this.onStatEdited});

  @override
  Widget build(BuildContext context) {
    return _buildStatTile(context);
  }

  Widget _buildStatTile(BuildContext context) {
    DateTime day = DateTime.fromMicrosecondsSinceEpoch(
      int.parse(stat.key),
    );
    String d = MyDateFormatter.formatDateOnly(context, day);
    String h = MyDateFormatter.formatTimeOnly(context, day);

    String priceStr = MyCurrencyFormatter.formatDouble(context, stat.total);

    return MyNeuButton(
      enableAnimation: true,
      buttonColor: Colors.white,
      buttonHeight: kMassiveSize * 1.5,
      borderRadius: MyBorderRadius.baseRadius(context),
      onPressed: () {
        MyNavigator.navigateToStatDetail(context: context, stat: stat).then((res) {
          if (res == true && onStatEdited != null) onStatEdited!();
        });
      },
      child: ListTile(
        isThreeLine: true,
        title: Row(
          children: [
            const Icon(
              BoxIcons.bxs_calendar,
              size: kSmallIconSize,
            ),
            horizontalSpaceTiny,
            Text(
              d,
              style: MyPixelFontStyle.h4(context),
            ),
          ],
        ),
        subtitle: Row(
          children: [
            Flexible(
              flex: 4,
              child: Row(
                children: [
                  const Icon(
                    BoxIcons.bxs_time,
                    size: kTinyIconSize,
                  ),
                  horizontalSpaceTiny,
                  Text(h, style: MyPixelFontStyle.tileSubtitle(context)),
                ],
              ),
            ),
            Expanded(
              flex: 8,
              child: Text(
                priceStr,
                textAlign: TextAlign.right,
                style: MyPixelFontStyle.tileSubtitle(context).copyWith(
                  decoration: TextDecoration.underline,
                  decorationThickness: 1,
                  color: Colors.green.shade900,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
