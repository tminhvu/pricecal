import 'package:app_local/app_local.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:neubrutalism_ui/neubrutalism_ui.dart';
import 'package:pricecal/data/models/stat.dart';
import 'package:pricecal/data/repository/item_list_repository.dart';
import 'package:pricecal/ui_helpers.dart';
import 'package:pricecal/widgets/stat_card.dart';

class LeftDrawer extends StatefulWidget {
  const LeftDrawer({super.key});

  @override
  State<LeftDrawer> createState() => _LeftDrawerState();
}

class _LeftDrawerState extends State<LeftDrawer> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Drawer(
        width: MediaQuery.sizeOf(context).width * 0.75,
        clipBehavior: Clip.none,
        child: NeuContainer(
          height: MediaQuery.sizeOf(context).height,
          color: Theme.of(context).scaffoldBackgroundColor,
          borderRadius: MyBorderRadius.baseRadius(context).copyWith(
            topLeft: Radius.zero,
            bottomLeft: Radius.zero,
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: kMediumSize, horizontal: kSmallSize),
            child: Column(
              children: [
                Row(
                  children: [
                    const Icon(BoxIcons.bx_history),
                    horizontalSpaceTiny,
                    Text(context.localeString('history'), style: MyPixelFontStyle.h2(context)),
                  ],
                ),
                verticalSpaceMedium,
                Expanded(
                  child: FutureBuilder<List<Stat>>(
                    future: context.read<ItemListRepository>().getStatList(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.done && snapshot.hasData) {
                        List<Stat> statList = snapshot.data!;

                        String totalStr = MyCurrencyFormatter.formatDouble(
                          context,
                          _calculateTotalFromStats(statList),
                        );

                        return Column(
                          children: [
                            Align(
                              alignment: Alignment.centerLeft,
                              child: Row(
                                children: [
                                  Text(
                                    '${context.localeString('total')}: ',
                                    style: MyPixelFontStyle.h3(context),
                                  ),
                                  Text(
                                    totalStr,
                                    style: MyPixelFontStyle.h3(context).copyWith(
                                      color: Colors.green.shade900,
                                      decoration: TextDecoration.underline,
                                    ),
                                  )
                                ],
                              ),
                            ),
                            verticalSpaceSmall,
                            Expanded(
                              child: ListView.separated(
                                itemCount: statList.length,
                                separatorBuilder: (context, index) => verticalSpaceMedium,
                                itemBuilder: (context, index) {
                                  return StatCard(stat: statList[index], onStatEdited: () => setState(() {}));
                                },
                              ),
                            ),
                          ],
                        );
                      }
                      return const CircularProgressIndicator();
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  double _calculateTotalFromStats(List<Stat> list) {
    if (list.isEmpty) return 0;

    return list
        .reduce(
          (stat1, stat2) => Stat(key: 'total', total: stat1.total + stat2.total),
        )
        .total;
  }
}
