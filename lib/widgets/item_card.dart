import 'dart:io';

import 'package:app_local/app_local.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:neubrutalism_ui/neubrutalism_ui.dart';
import 'package:pricecal/blocs/item_list/bloc.dart';
import 'package:pricecal/data/models/item.dart';
import 'package:pricecal/my_navigator.dart';
import 'package:pricecal/ui_helpers.dart';
import 'package:pricecal/widgets/my_animated_neu_container.dart';

class ItemCard extends StatelessWidget {
  final Item baseItem;
  const ItemCard({super.key, required this.baseItem});

  void onCardPressed(BuildContext context) {
    MyNavigator.navigateToItemDetail(
      context: context,
      itemListBlocValue: BlocProvider.of<ItemListBloc>(context),
      item: baseItem,
    );
    return;
  }

  @override
  Widget build(BuildContext context) {
    String itemName = baseItem.name;

    String basePriceStr = MyCurrencyFormatter.formatDouble(context, baseItem.price);

    String priceTimeCount = '${baseItem.count}${baseItem.count > 1 ? ' x $basePriceStr ' : 'x'}';

    String totalPrice = MyCurrencyFormatter.formatDouble(context, baseItem.price * baseItem.count);

    return MyNeuButton(
      enableAnimation: true,
      buttonHeight: null,
      onPressed: () => onCardPressed(context),
      buttonColor: Colors.white,
      borderRadius: MyBorderRadius.baseRadius(context),
      child: ListTile(
        leading: NeuContainer(
          width: 33,
          height: 33,
          color: Colors.yellow,
          borderRadius: MyBorderRadius.circle(context),
          child: const Icon(BoxIcons.bx_dollar, size: 21, color: Colors.black),
        ),
        trailing: Container(
          width: MediaQuery.sizeOf(context).width / 4,
          alignment: Alignment.centerRight,
          child: baseItem.picturePath == null
              ? Text(
                  itemName,
                  textAlign: TextAlign.right,
                  style: MyPixelFontStyle.h3(context).copyWith(
                    overflow: TextOverflow.visible,
                  ),
                )
              : Image.file(
                  File(baseItem.picturePath!),
                  fit: BoxFit.fitWidth,
                  scale: 0.5,
                  filterQuality: FilterQuality.low,
                  isAntiAlias: false,
                  frameBuilder: (context, widget, i, b) {
                    return Container(
                      decoration: BoxDecoration(
                        border: Border.all(
                          width: 2,
                        ),
                      ),
                      child: widget,
                    );
                  },
                  errorBuilder: (context, obj, stackTrace) {
                    return SizedBox(
                      width: kMassiveSize,
                      child: Placeholder(
                        color: Colors.red,
                        child: Text(
                          context.localeString('error'),
                          style: MyPixelFontStyle.h4(context).copyWith(
                            color: Colors.red,
                            overflow: TextOverflow.visible,
                          ),
                        ),
                      ),
                    );
                  },
                ),
        ),
        subtitle: Text(priceTimeCount, style: MyPixelFontStyle.tileSubtitle(context)),
        title: Text(totalPrice, style: MyPixelFontStyle.h2(context)),
      ),
    );
  }
}
