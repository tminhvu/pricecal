import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pricecal/blocs/item_list/bloc.dart';
import 'package:pricecal/blocs/item_list/event.dart';
import 'package:pricecal/data/repository/item_list_repository.dart';
import 'package:pricecal/drawers/left_drawer.dart';
import 'package:pricecal/drawers/right_drawer.dart';
import 'package:pricecal/my_background_texture.dart';
import 'package:pricecal/ui_helpers.dart';
import 'package:pricecal/widgets/home/clear_all_button.dart';
import 'package:pricecal/widgets/home/floating_buttons.dart';
import 'package:pricecal/widgets/home/item_list.dart';
import 'package:pricecal/widgets/home/total.dart';
import 'package:pricecal/widgets/my_app_bar.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ItemListBloc(
        itemListRepository: RepositoryProvider.of<ItemListRepository>(context),
      )..add(
          ItemListEventLoad(),
        ),
      child: const MyBackgroundTexture(
        child: Scaffold(
          backgroundColor: Colors.transparent,
          drawer: LeftDrawer(),
          endDrawer: RightDrawer(),
          appBar: MyAppBar(),
          body: SafeArea(
            child: SingleChildScrollView(
              padding: EdgeInsets.only(
                left: kSmallSize,
                right: kSmallSize,
                bottom: kMassiveSize * 3,
              ),
              physics: BouncingScrollPhysics(),
              child: Column(
                children: [
                  verticalSpaceMedium,
                  Total(),
                  verticalSpaceMedium,
                  ClearAllButton(),
                  verticalSpaceSmall,
                  ItemColumn(),
                ],
              ),
            ),
          ),
          floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
          floatingActionButton: HomeFloatingButtons(),
        ),
      ),
    );
  }
}
