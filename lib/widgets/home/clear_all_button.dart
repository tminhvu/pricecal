import 'package:app_local/app_local.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:pricecal/blocs/item_list/bloc.dart';
import 'package:pricecal/blocs/item_list/event.dart';
import 'package:pricecal/blocs/item_list/state.dart';
import 'package:pricecal/my_navigator.dart';
import 'package:pricecal/ui_helpers.dart';
import 'package:pricecal/widgets/my_confirmation_dialog.dart';

class ClearAllButton extends StatelessWidget {
  const ClearAllButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: BlocBuilder<ItemListBloc, ItemListState>(
        builder: (context, state) {
          return TextButton.icon(
            label: Text(
              context.localeString('Clear_all'),
              style: MyPixelFontStyle.h3(context).copyWith(
                decoration: TextDecoration.underline,
              ),
            ),
            icon: const Icon(BoxIcons.bx_trash, color: Colors.black),
            onPressed: () {
              MyNavigator.showConfirmationDialog(
                context: context,
                important: true,
                confirmLabel: context.localeString('clear'),
                dismissLabel: context.localeString('Cancel'),
                titleText: '${context.localeString('clear_all')}?',
              ).then((res) {
                if (res == ConfirmationResponse.confirm && context.mounted) {
                  context.read<ItemListBloc>().add(
                        ItemListEventClearAllItem(save: false),
                      );
                }
              });
            },
          );
        },
      ),
    );
  }
}
