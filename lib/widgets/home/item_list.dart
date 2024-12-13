import 'package:app_local/app_local.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pricecal/blocs/item_list/bloc.dart';
import 'package:pricecal/blocs/item_list/state.dart';
import 'package:pricecal/ui_helpers.dart';
import 'package:pricecal/widgets/item_card.dart';

class ItemColumn extends StatelessWidget {
  const ItemColumn({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ItemListBloc, ItemListState>(
      bloc: BlocProvider.of<ItemListBloc>(context),
      builder: (context, state) {
        if (state is ItemListStateLoadInProcess) {
          return const LinearProgressIndicator();
        }

        if (state is ItemListStateLoadFailed) {
          return Text(context.localeString('failed_to_load'));
        }

        if (state is ItemListStateLoadSuccess) {
          return ListView.separated(
            padding: const EdgeInsets.symmetric(horizontal: kTinySize),
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemBuilder: (coontext, index) => ItemCard(baseItem: state.itemList[index]),
            separatorBuilder: (context, index) => verticalSpaceMedium,
            itemCount: state.itemList.length,
          );
        }

        return const SizedBox();
      },
    );
  }
}
