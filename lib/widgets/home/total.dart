import 'package:app_local/app_local.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:neubrutalism_ui/neubrutalism_ui.dart';
import 'package:pricecal/blocs/item_list/bloc.dart';
import 'package:pricecal/blocs/item_list/event.dart';
import 'package:pricecal/blocs/item_list/state.dart';
import 'package:pricecal/my_navigator.dart';
import 'package:pricecal/ui_helpers.dart';
import 'package:pricecal/widgets/my_confirmation_dialog.dart';

class Total extends StatefulWidget {
  const Total({super.key});

  @override
  State<Total> createState() => _TotalState();
}

class _TotalState extends State<Total> {
  @override
  Widget build(BuildContext context) {
    return NeuContainer(
      color: Colors.white,
      width: double.maxFinite,
      borderRadius: MyBorderRadius.baseRadius(context),
      child: Padding(
        padding: const EdgeInsets.all(kSmallSize),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: MyBorderRadius.baseRadius(context),
            color: Colors.yellow,
          ),
          padding: const EdgeInsets.only(left: kSmallSize),
          width: double.maxFinite,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                physics: const BouncingScrollPhysics(),
                child: _buildTotalNumber(context),
              ),
              _buildClearAllButton(context),
            ],
          ),
        ),
      ),
    );
  }

  Align _buildClearAllButton(BuildContext context) {
    return Align(
      alignment: Alignment.bottomRight,
      child: NeuIconButton(
        borderRadius: MyBorderRadius.baseRadius(context),
        buttonColor: Colors.white,
        buttonHeight: kMediumButtonSize,
        buttonWidth: kBigButtonSize,
        enableAnimation: true,
        onPressed: () {
          MyNavigator.showConfirmationDialog(
            context: context,
            titleText: context.localeString('saving_these_to_history'),
            description: context.localeString('it_will_also_clear_list'),
            confirmLabel: context.localeString('save'),
            dismissLabel: context.localeString('cancel'),
            important: false,
          ).then((res) {
            if (res == ConfirmationResponse.confirm && context.mounted) {
              context.read<ItemListBloc>().add(
                    ItemListEventClearAllItem(save: true),
                  );
            }
          });
        },
        icon: const Icon(
          BoxIcons.bxs_save,
          size: kLargeIconSize,
        ),
      ),
    );
  }

  BlocBuilder<ItemListBloc, ItemListState> _buildTotalNumber(BuildContext context) {
    return BlocBuilder<ItemListBloc, ItemListState>(
      bloc: BlocProvider.of<ItemListBloc>(context),
      builder: (context, state) {
        if (state is ItemListStateLoadInProcess) {
          return SizedBox(
            width: MediaQuery.sizeOf(context).width,
            child: const LinearProgressIndicator(),
          );
        }

        if (state is ItemListStateLoadFailed) {
          return Text(context.localeString('failed_to_load'));
        }

        if (state is ItemListStateLoadSuccess) {
          return Text(
            MyCurrencyFormatter.formatDouble(context, state.total),
            style: MyPixelFontStyle.h1(context),
          );
        }

        return const SizedBox();
      },
    );
  }
}
