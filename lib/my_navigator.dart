import 'package:currency_text_input_formatter/currency_text_input_formatter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pricecal/blocs/item_list/bloc.dart';
import 'package:pricecal/data/models/item.dart';
import 'package:pricecal/data/models/stat.dart';
import 'package:pricecal/data/repository/item_list_repository.dart';
import 'package:pricecal/my_release_note.dart';
import 'package:pricecal/pages/item_detail.dart';
import 'package:pricecal/pages/my_photo_view.dart';
import 'package:pricecal/pages/stat_detail.dart';
import 'package:pricecal/ui_helpers.dart';
import 'package:pricecal/widgets/my_confirmation_dialog.dart';
import 'package:pricecal/widgets/my_release_notes_dialog.dart';

class MyNavigator {
  static Future<dynamic> navigateToItemDetail({
    required BuildContext context,
    required ItemListBloc itemListBlocValue,
    required Item item,
    bool? isCommingFromML,
    String? defaultName,
  }) async {
    return Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) {
          return BlocProvider<ItemListBloc>.value(
            value: itemListBlocValue,
            child: ItemDetail(
              formatter: CurrencyTextInputFormatter.simpleCurrency(
                locale: MyCurrencyFormatter.languageCode,
              ),
              item: item,
              fromPicture: isCommingFromML,
            ),
          );
        },
      ),
    );
  }

  static Future<dynamic> navigateToMyPhotoView({
    required BuildContext context,
    required String path,
  }) async {
    return Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) {
          return MyPhotoView(path: path);
        },
      ),
    );
  }

  static Future<dynamic> navigateToStatDetail({
    required BuildContext context,
    required Stat stat,
  }) async {
    return Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => RepositoryProvider.value(
          value: context.read<ItemListRepository>(),
          child: StatDetail(stat: stat),
        ),
      ),
    );
  }

  static Future<dynamic> showConfirmationDialog({
    required BuildContext context,
    String? titleText,
    String? confirmLabel,
    String? dismissLabel,
    String? description,
    bool? important,
  }) async {
    return showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: 'my_confirmation_dialog',
      pageBuilder: (context, a1, a2) => MyConfirmationDialog(
        titleText: titleText,
        confirmLabel: confirmLabel,
        dismissLabel: dismissLabel,
        desciption: description,
        important: important,
      ),
    );
  }

  static Future<bool?> showReleaseDialog({required BuildContext context, List<Release>? releases}) async {
    return showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: 'my_release_dialog',
      pageBuilder: (context, a1, a2) {
        return MyReleaseNotesDialog(releases: releases);
      },
    );
  }

  static Future<void> showCustomSnackbar({required BuildContext context, required String text}) async {
  }
}
