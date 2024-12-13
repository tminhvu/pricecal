import 'dart:io';

import 'package:currency_formatter/currency_formatter.dart';
import 'package:currency_text_input_formatter/currency_text_input_formatter.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class MyPixelFontStyle {
  static TextStyle appBarTitle(BuildContext context) {
    return GoogleFonts.itim(
      textStyle: const TextStyle(
        fontSize: kMassiveFontSize,
        fontWeight: FontWeight.w300,
        overflow: TextOverflow.ellipsis,
        color: Colors.black,
      ),
    );
  }

  static TextStyle h1(BuildContext context) {
    return GoogleFonts.itim(
      textStyle: const TextStyle(
        fontSize: kMassiveFontSize * 1.5,
        fontWeight: FontWeight.w300,
        color: Colors.black,
      ),
    );
  }

  static TextStyle h2(BuildContext context) {
    return GoogleFonts.itim(
      textStyle: const TextStyle(
        fontSize: kLargerFontSize,
        fontWeight: FontWeight.w300,
        overflow: TextOverflow.ellipsis,
        color: Colors.black,
      ),
    );
  }

  static TextStyle h3(BuildContext context) {
    return GoogleFonts.itim(
      textStyle: const TextStyle(
        fontSize: kLargeFontSize,
        fontWeight: FontWeight.w300,
        overflow: TextOverflow.ellipsis,
        color: Colors.black,
      ),
    );
  }

  static TextStyle h4(BuildContext context) {
    return GoogleFonts.itim(
      textStyle: const TextStyle(
        fontSize: kBigFontSize,
        fontWeight: FontWeight.w300,
        overflow: TextOverflow.ellipsis,
        color: Colors.black,
      ),
    );
  }

  static TextStyle tileSubtitle(BuildContext context) {
    return GoogleFonts.itim(
      textStyle: const TextStyle(
        fontSize: kBigFontSize,
        fontWeight: FontWeight.w300,
        overflow: TextOverflow.ellipsis,
        color: Colors.black,
      ),
    );
  }
}

class MyBorderRadius {
  static BorderRadius baseRadius(BuildContext context) {
    return const BorderRadius.all(Radius.circular(kSurfaceRadius));
  }

  static BorderRadius circle(BuildContext context) {
    return const BorderRadius.all(Radius.circular(100));
  }
}

class MyCurrencyFormatter {
  static String languageCode = Platform.localeName.split('_')[0];
  static String formatDouble(BuildContext context, double number) {
    return CurrencyTextInputFormatter.simpleCurrency(locale: languageCode).formatDouble(number);
  }
}

class MyDateFormatter {
  static String languageCode = Platform.localeName.split('_')[0];
  static String formatDateOnly(BuildContext context, DateTime date) {
    return DateFormat.yMMMEd(languageCode).format(date);
  }

  static String formatTimeOnly(BuildContext context, DateTime date) {
    return DateFormat.Hm(languageCode).format(date);
  }
}

const double kSmallButtonSize = 33;
const double kMediumButtonSize = 44;
const double kBigButtonSize = 56;

const double kOpacityExtraExtraLight = 0.05;
const double kOpacityExtraLight = 0.1;
const double kOpacityLight = 0.45;
const double kOpacityMedium = 0.60;
const double kOpacityUpperMedium = 0.75;
const double kOpacityHigh = 0.90;

const int kAlphaExtraLight = 26;
const int kAlphaLight = 64;
const int kAlphaMedium = 128;
const int kAlphaHigh = 192;

const int kDarkenExtraLight = 5;
const int kDarkenLight = 10;
const int kDarkenMedium = 15;
const int kDarkenHard = 20;
const int kDarkenExtraHard = 25;

const int kBlendExtraExtraLight = 5;
const int kBlendExtraLight = 10;
const int kBlendLight = 20;
const int kBlendMedium = 30;
const int kBlendHigh = 40;
const int kBlendExtraHigh = 80;

const double kExtraTinySize = 4.0;
const double kTinySize = 6.0;
const double kSmallSize = 10.0;
const double kMediumSize = 18.0;
const double kBigSize = 22.0;
const double kLargeSize = 26.0;
const double kLargerSize = 30.0;
const double kMassiveSize = 56.0;

const double kStatHeight = kMassiveSize * 1.5;
const double kDrawerWidth = 200;

const double kSmallFontSize = 11;
const double kMediumFontSize = 14;
const double kNormalFontSize = 15;
const double kBigFontSize = 17;
const double kLargeFontSize = 20;
const double kLargerFontSize = 23;
const double kMassiveFontSize = 33;

const double kVeryTinyIconSize = 8;
const double kTinyIconSize = 13;
const double kSmallIconSize = 16;
const double kMediumIconSize = 22;
const double kLargeIconSize = 26;
const double kLargerIconSize = 32;
const double kMassiveIconSize = 48;

const double kSurfaceRadius = 8;

const Widget horizontalSpaceTiny = SizedBox(width: kTinySize);
const Widget horizontalSpaceSmall = SizedBox(width: kSmallSize);
const Widget horizontalSpaceMedium = SizedBox(width: kMediumSize);
const Widget horizontalSpaceLarge = SizedBox(width: kLargeSize);

const Widget verticalSpaceTiny = SizedBox(height: kTinySize);
const Widget verticalSpaceSmall = SizedBox(height: kSmallSize);
const Widget verticalSpaceMedium = SizedBox(height: kMediumSize);
const Widget verticalSpaceLarge = SizedBox(height: kLargeSize);
const Widget verticalSpaceMassive = SizedBox(height: kMassiveSize);

const kColorPink = Color.fromARGB(255, 234, 203, 214);

const vnd = CurrencyFormat(
  symbol: '₫',
  code: 'vnd',
  symbolSide: SymbolSide.right,
  symbolSeparator: ' ',
  decimalSeparator: ',',
  thousandSeparator: '.',
);
