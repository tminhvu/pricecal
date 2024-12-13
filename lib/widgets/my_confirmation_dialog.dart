import 'package:app_local/app_local.dart';
import 'package:flutter/material.dart';
import 'package:pricecal/ui_helpers.dart';

enum ConfirmationResponse {
  confirm,
  dismiss,
}

class MyConfirmationDialog extends StatelessWidget {
  final String? titleText;
  final String? desciption;
  final String? confirmLabel;
  final String? dismissLabel;
  final bool? important;

  const MyConfirmationDialog({
    super.key,
    this.titleText,
    this.confirmLabel,
    this.dismissLabel,
    this.desciption,
    this.important = false,
  });

  @override
  Widget build(BuildContext context) {
    return SimpleDialog(
      title: Text(
        titleText ?? context.localeString('Are_you_sure'),
        style: MyPixelFontStyle.h2(context).copyWith(
          overflow: TextOverflow.visible,
        ),
      ),
      shape: RoundedRectangleBorder(
        borderRadius: MyBorderRadius.baseRadius(context),
      ),
      children: [
        if (desciption != null)
          Padding(
            padding: const EdgeInsets.only(
              left: kMediumSize,
              right: kMediumSize,
              bottom: kMediumSize,
            ),
            child: Text(
              desciption!,
              style: MyPixelFontStyle.h4(context).copyWith(
                overflow: TextOverflow.visible,
              ),
            ),
          ),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text(
                dismissLabel ?? context.localeString('No'),
                style: MyPixelFontStyle.h3(context).copyWith(
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
            ),
            horizontalSpaceMedium,
            FilledButton(
              onPressed: () {
                Navigator.pop(context, ConfirmationResponse.confirm);
              },
              style: FilledButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: MyBorderRadius.baseRadius(context),
                ),
                backgroundColor: important == true ? Colors.red.shade400 : Colors.amber,
              ),
              child: Text(
                confirmLabel ?? context.localeString('Yes'),
                style: MyPixelFontStyle.h3(context).copyWith(
                  color: important == true ? Colors.white : Colors.black,
                ),
              ),
            ),
            horizontalSpaceMedium,
          ],
        ),
      ],
    );
  }
}
