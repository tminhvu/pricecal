import 'package:app_local/app_local.dart';
import 'package:flutter/material.dart';
import 'package:pricecal/ui_helpers.dart';

class MySnackbar {
  static void showCustomSnackbar(
    BuildContext context, {
    required String text,
    String? actionLabel,
    Function()? onActionPressed,
    int? durationInSeconds,
    IconData? leadingIcon,
  }) {
    SnackBarAction? action2;

    if (onActionPressed != null) {
      action2 = SnackBarAction(
        label: actionLabel ?? context.localeString('Info'),
        onPressed: onActionPressed,
        backgroundColor: Colors.amber,
        textColor: Colors.black,
      );
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        showCloseIcon: true,
        closeIconColor: Colors.black,
        backgroundColor: Colors.amber,
        behavior: SnackBarBehavior.floating,
        content: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              Icon(
                leadingIcon ?? Icons.info,
                size: kMediumIconSize,
                color: Colors.black,
              ),
              horizontalSpaceSmall,
              Text(
                text,
                style: MyPixelFontStyle.h4(context),
              ),
            ],
          ),
        ),
        duration: durationInSeconds != null ? Duration(seconds: durationInSeconds) : const Duration(seconds: 2),
        shape: RoundedRectangleBorder(borderRadius: MyBorderRadius.baseRadius(context)),
        padding: const EdgeInsets.only(
          left: kMediumSize,
          right: kTinySize,
        ),
        action: action2,
      ),
    );
  }
}
