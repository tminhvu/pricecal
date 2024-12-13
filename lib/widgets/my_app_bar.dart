import 'package:app_local/app_local.dart';
import 'package:flutter/material.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:neubrutalism_ui/neubrutalism_ui.dart';
import 'package:pricecal/ui_helpers.dart';

class MyAppBar extends StatelessWidget implements PreferredSizeWidget {
  const MyAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.only(top: kSmallSize),
        child: Row(
          children: [
            horizontalSpaceSmall,
            Builder(builder: (context) {
              return NeuIconButton(
                buttonHeight: kMediumButtonSize,
                buttonWidth: kMediumButtonSize,
                enableAnimation: true,
                icon: const Icon(
                  BoxIcons.bx_history,
                  size: kLargeIconSize,
                ),
                buttonColor: Colors.white,
                borderRadius: MyBorderRadius.baseRadius(context),
                onPressed: () {
                  Scaffold.of(context).openDrawer();
                },
              );
            }),
            Expanded(
              child: Center(
                child: Text(
                  context.localeString('Price_cal'),
                  style: MyPixelFontStyle.appBarTitle(context),
                ),
              ),
            ),
            Builder(builder: (context) {
              return NeuIconButton(
                enableAnimation: true,
                icon: const Icon(
                  BoxIcons.bxs_cog,
                  size: kMediumIconSize,
                ),
                buttonWidth: kMediumButtonSize,
                buttonHeight: kMediumButtonSize,
                buttonColor: kColorPink,
                borderRadius: MyBorderRadius.baseRadius(context),
                onPressed: () {
                  Scaffold.of(context).openEndDrawer();
                },
              );
            }),
            horizontalSpaceSmall,
          ],
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight + kSmallSize);
}
