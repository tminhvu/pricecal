import 'dart:io';

import 'package:app_local/app_local.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:neubrutalism_ui/neubrutalism_ui.dart';
import 'package:pricecal/data/models/item.dart';
import 'package:pricecal/data/models/stat.dart';
import 'package:pricecal/data/repository/item_list_repository.dart';
import 'package:pricecal/my_navigator.dart';
import 'package:pricecal/ui_helpers.dart';
import 'package:pricecal/widgets/my_confirmation_dialog.dart';

class StatDetail extends StatelessWidget {
  final Stat stat;
  const StatDetail({super.key, required this.stat});

  @override
  Widget build(BuildContext context) {
    DateTime day = DateTime.fromMicrosecondsSinceEpoch(
      int.parse(stat.key),
    );
    String d = MyDateFormatter.formatDateOnly(context, day);
    String h = MyDateFormatter.formatTimeOnly(context, day);

    String priceStr = MyCurrencyFormatter.formatDouble(context, stat.total);

    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            color: Colors.red.shade700,
            onPressed: () {
              MyNavigator.showConfirmationDialog(
                context: context,
                titleText: context.localeString('removing_this_stat'),
                confirmLabel: context.localeString('Remove'),
                dismissLabel: context.localeString('Cancel'),
                important: true,
              ).then(
                (res) {
                  if (res == ConfirmationResponse.confirm && context.mounted) {
                    context.read<ItemListRepository>().clearStat(stat.key);
                    Navigator.pop(context, true);
                  }
                },
              );
            },
            icon: const Icon(
              BoxIcons.bxs_trash,
              size: kMediumIconSize,
            ),
          ),
          horizontalSpaceSmall,
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: kSmallSize,
          ),
          child: Column(
            children: [
              Row(
                children: [
                  const Icon(
                    BoxIcons.bxs_calendar,
                    size: kSmallIconSize,
                  ),
                  horizontalSpaceTiny,
                  Text(
                    d,
                    style: MyPixelFontStyle.h2(context).copyWith(
                      overflow: TextOverflow.visible,
                    ),
                  ),
                ],
              ),
              Row(
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
                        Text(
                          h,
                          style: MyPixelFontStyle.h2(context).copyWith(
                            overflow: TextOverflow.visible,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    flex: 8,
                    child: Text(
                      priceStr,
                      textAlign: TextAlign.right,
                      style: MyPixelFontStyle.h2(context).copyWith(
                        decoration: TextDecoration.underline,
                        decorationThickness: 1,
                        color: Colors.green.shade900,
                        overflow: TextOverflow.visible,
                      ),
                    ),
                  ),
                ],
              ),
              verticalSpaceMedium,
              Expanded(
                child: FutureBuilder(
                  future: context.read<ItemListRepository>().getItemList(key: stat.key),
                  builder: (context, snapshot) {
                    List<Item>? list = snapshot.data;
                    if (list == null) return const SizedBox();

                    list.sort((b, a) => (a.price * a.count).compareTo(b.price * b.count));

                    return ListView.separated(
                      itemBuilder: (context, index) => _buildItemTile(context, list[index]),
                      itemCount: list.length,
                      separatorBuilder: (context, index) => verticalSpaceMedium,
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildItemTile(BuildContext context, Item item) {
    String itemName = item.name;

    String basePriceStr = MyCurrencyFormatter.formatDouble(context, item.price);

    String priceTimeCount = '${item.count}${item.count > 1 ? ' x $basePriceStr ' : 'x'}';

    String totalPrice = MyCurrencyFormatter.formatDouble(context, item.price * item.count);

    return NeuCard(
      cardColor: Colors.amber.shade50,
      borderRadius: MyBorderRadius.baseRadius(context),
      child: ListTile(
        shape: RoundedRectangleBorder(
          borderRadius: MyBorderRadius.baseRadius(context),
        ),
        trailing: Container(
          width: MediaQuery.sizeOf(context).width / 4,
          alignment: Alignment.centerRight,
          child: item.picturePath == null
              ? Text(
                  itemName,
                  textAlign: TextAlign.right,
                  style: MyPixelFontStyle.h3(context).copyWith(
                    overflow: TextOverflow.visible,
                  ),
                )
              : Image.file(
                  File(item.picturePath!),
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
        subtitle: Text(
          priceTimeCount,
          style: MyPixelFontStyle.tileSubtitle(context).copyWith(
            overflow: TextOverflow.visible,
          ),
        ),
        title: Text(totalPrice,
            style: MyPixelFontStyle.h2(context).copyWith(
              overflow: TextOverflow.visible,
            )),
      ),
    );
  }
}
