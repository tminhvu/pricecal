import 'dart:io';

import 'package:app_local/app_local.dart';
import 'package:currency_text_input_formatter/currency_text_input_formatter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:neubrutalism_ui/neubrutalism_ui.dart';
import 'package:pricecal/blocs/item_list/bloc.dart';
import 'package:pricecal/blocs/item_list/event.dart';
import 'package:pricecal/data/models/item.dart';
import 'package:pricecal/my_background_texture.dart';
import 'package:pricecal/my_navigator.dart';
import 'package:pricecal/ui_helpers.dart';
import 'package:pricecal/widgets/my_animated_neu_container.dart';

enum FabState {
  back,
  save,
  remove,
}

class ItemDetail extends StatefulWidget {
  final Item item;
  final bool? fromPicture;
  final CurrencyTextInputFormatter formatter;
  const ItemDetail({super.key, required this.item, this.fromPicture, required this.formatter});

  @override
  State<ItemDetail> createState() => _ItemDetailState();
}

class _ItemDetailState extends State<ItemDetail> {
  final priceTextFieldController = TextEditingController();
  final priceTextFieldFocusNode = FocusNode();
  final nameTextFieldController = TextEditingController();
  final nameTextFieldFocusNode = FocusNode();
  late final CurrencyTextInputFormatter formatter;

  double price = 0;
  String? picturePath;
  int count = 0;
  FabState fabState = FabState.back;

  @override
  void initState() {
    formatter = widget.formatter;

    priceTextFieldController.text = formatter.formatDouble(widget.item.price);
    nameTextFieldController.text = widget.item.name.isEmpty ? 'no name' : widget.item.name;

    count = widget.item.count;
    picturePath = widget.item.picturePath;
    price = widget.item.price;

    if (widget.fromPicture == true) fabState = FabState.save;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MyBackgroundTexture(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        floatingActionButton: _buildFab(),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(vertical: kMediumSize, horizontal: kSmallSize),
            child: Column(
              children: [
                if (picturePath != null) _buildPictureSection(context),
                verticalSpaceMedium,
                _buildPriceAndNameSection(context),
                verticalSpaceLarge,
                _buildCountSection(context),
              ],
            ),
          ),
        ),
      ),
    );
  }

  setFabStateByCountAndName({String? nameText}) {
    bool countHasChange = count != widget.item.count;
    bool nameHasChange = (nameText ?? nameTextFieldController.text) != widget.item.name;
    bool priceHasChange = formatter.getDouble().compareTo(widget.item.price) != 0;

    bool countIsZero = count == 0;

    if ((nameHasChange || priceHasChange) && countIsZero && !countHasChange) {
      count++;
      fabState = FabState.save;
      return;
    }

    if (countIsZero) {
      fabState = FabState.remove;
      return;
    }

    if (countHasChange || nameHasChange || priceHasChange) {
      fabState = FabState.save;
      return;
    }

    fabState = FabState.back;
  }

  onPlusCountPressed() {
    setState(() {
      count += 1;
      setFabStateByCountAndName();
    });
  }

  onMinusCountPressed() {
    if (count >= 1) {
      setState(() {
        count -= 1;
        setFabStateByCountAndName();
      });
    }
  }

  onItemNameChange(value) {
    setState(() {
      setFabStateByCountAndName(nameText: value);
    });
  }

  onItemPriceChange(value) {
    setState(() {
      setFabStateByCountAndName();
    });
  }

  NeuContainer _buildPriceAndNameSection(BuildContext context) {
    return NeuContainer(
      color: Colors.white,
      width: double.maxFinite,
      borderRadius: MyBorderRadius.baseRadius(context),
      child: Padding(
        padding: const EdgeInsets.only(top: kSmallSize, left: kSmallSize, right: kSmallSize, bottom: kMediumSize),
        child: Column(
          children: [
            horizontalSpaceSmall,
            _buildTopHalf(context),
            const Divider(
              height: 1,
              thickness: 2,
              color: Colors.black,
            ),
            verticalSpaceSmall,
            _buildBottomHalf(context),
          ],
        ),
      ),
    );
  }

  Row _buildBottomHalf(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _buildSpinningCoin(context),
        _buildNameTextField(context),
      ],
    );
  }

  Stack _buildTopHalf(BuildContext context) {
    return Stack(
      children: [
        Transform.translate(
          offset: Offset(
            0,
            MyPixelFontStyle.h1(context).fontSize!,
          ),
          child: Container(
            color: Colors.yellowAccent,
            height: 12,
          ),
        ),
        _buildPriceTextField(context),
      ],
    );
  }

  TextField _buildPriceTextField(BuildContext context) {
    return TextField(
      onChanged: (value) => onItemPriceChange(value),
      focusNode: priceTextFieldFocusNode,
      textAlign: TextAlign.right,
      style: MyPixelFontStyle.h1(context),
      decoration: InputDecoration(
        border: UnderlineInputBorder(
          borderRadius: BorderRadius.circular(kSmallSize - kSurfaceRadius),
        ),
        isDense: true,
        isCollapsed: true,
        contentPadding: const EdgeInsets.only(right: kSmallSize),
      ),
      autofocus: true,
      textInputAction: TextInputAction.next,
      onTap: () {
        if (!priceTextFieldFocusNode.hasFocus) {
          priceTextFieldController.selection = TextSelection(
            baseOffset: 0,
            extentOffset: priceTextFieldController.value.text.length,
          );
        }
      },
      onEditingComplete: () {
        nameTextFieldFocusNode.requestFocus();
        nameTextFieldController.selection = TextSelection(
          baseOffset: 0,
          extentOffset: nameTextFieldController.value.text.length,
        );
      },
      cursorWidth: 4,
      cursorHeight: MyPixelFontStyle.h1(context).fontSize,
      cursorColor: Colors.black,
      controller: priceTextFieldController,
      inputFormatters: [
        formatter,
      ],
      onTapOutside: (event) {
        //FocusManager.instance.primaryFocus?.unfocus();
      },
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
    );
  }

  Animate _buildSpinningCoin(BuildContext context) {
    return Animate(
      onComplete: (controller) {
        controller.repeat(reverse: true);
      },
      effects: const [
        FlipEffect(
          duration: Duration(milliseconds: 600),
          direction: Axis.horizontal,
          alignment: Alignment.center,
        ),
      ],
      child: NeuContainer(
        height: 44,
        width: 44,
        color: Colors.yellow,
        borderRadius: MyBorderRadius.circle(context),
        child: const Icon(
          BoxIcons.bxs_dollar_circle,
          size: 32,
          color: Colors.black,
        ),
      ),
    );
  }

  Expanded _buildNameTextField(BuildContext context) {
    return Expanded(
      child: TextField(
        focusNode: nameTextFieldFocusNode,
        onChanged: onItemNameChange,
        textAlign: TextAlign.right,
        style: MyPixelFontStyle.h2(context),
        decoration: const InputDecoration(
          border: InputBorder.none,
          contentPadding: EdgeInsets.only(
            right: kMediumSize,
          ),
        ),
        onTap: () {
          if (!nameTextFieldFocusNode.hasFocus) {
            nameTextFieldController.selection = TextSelection(
              baseOffset: 0,
              extentOffset: nameTextFieldController.value.text.length,
            );
          }
        },
        cursorWidth: 2,
        cursorHeight: MyPixelFontStyle.h2(context).fontSize,
        cursorColor: Colors.black,
        controller: nameTextFieldController,
        onTapOutside: (event) {
          //FocusManager.instance.primaryFocus?.unfocus();
        },
      ),
    );
  }

  Row _buildCountSection(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildDecreaseCountButton(context),
        horizontalSpaceMedium,
        Text(count.toString(), style: MyPixelFontStyle.h2(context).copyWith(fontSize: kMassiveFontSize)),
        horizontalSpaceMedium,
        _buildIncreateCountButton(context),
      ],
    );
  }

  NeuIconButton _buildDecreaseCountButton(BuildContext context) {
    return NeuIconButton(
      enableAnimation: true,
      onPressed: () => onMinusCountPressed(),
      buttonColor: Colors.red,
      buttonHeight: kMediumButtonSize,
      buttonWidth: kMediumButtonSize,
      borderRadius: MyBorderRadius.circle(context),
      icon: const Icon(BoxIcons.bx_minus, size: kMediumIconSize),
    );
  }

  NeuIconButton _buildIncreateCountButton(BuildContext context) {
    return NeuIconButton(
      enableAnimation: true,
      onPressed: () => onPlusCountPressed(),
      buttonHeight: kMediumButtonSize,
      buttonWidth: kMediumButtonSize,
      buttonColor: Colors.blueAccent,
      borderRadius: MyBorderRadius.circle(context),
      icon: const Icon(BoxIcons.bx_plus, size: kMediumIconSize),
    );
  }

  Widget _buildFab() {
    Widget backButton = Padding(
      padding: const EdgeInsets.only(right: kMediumSize),
      child: NeuIconButton(
        buttonColor: Colors.white,
        enableAnimation: true,
        borderRadius: MyBorderRadius.baseRadius(context),
        onPressed: () {
          Navigator.pop(context);
        },
        icon: const Icon(
          BoxIcons.bx_arrow_back,
          size: kMediumIconSize,
        ),
      ),
    );
    switch (fabState) {
      case FabState.save:
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: kMediumSize),
              child: NeuIconButton(
                buttonColor: Colors.green,
                enableAnimation: true,
                borderRadius: MyBorderRadius.baseRadius(context),
                onPressed: () => _onFabSavePressed(context),
                icon: const Icon(
                  BoxIcons.bxs_save,
                  size: kMediumIconSize,
                ),
              ),
            ),
            backButton,
          ],
        );
      case FabState.remove:
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: kMediumSize),
              child: NeuIconButton(
                buttonColor: Colors.red,
                enableAnimation: true,
                borderRadius: MyBorderRadius.baseRadius(context),
                onPressed: () => _onFabRemovePressed(context),
                icon: const Icon(
                  BoxIcons.bxs_trash,
                  size: kMediumIconSize,
                ),
              ),
            ),
            backButton,
          ],
        );
      default:
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            verticalSpaceTiny,
            backButton,
          ],
        );
    }
  }

  void _onFabRemovePressed(BuildContext context) {
    context.read<ItemListBloc>().add(
          ItemListEventRemoveItem(
            item: widget.item,
          ),
        );
    Navigator.pop(context);
  }

  void _onFabSavePressed(BuildContext context) {
    context.read<ItemListBloc>().add(
          ItemListEventAddItem(
            item: widget.item
              ..count = count
              ..name = nameTextFieldController.text
              ..price = formatter.getDouble(),
          ),
        );
    Navigator.pop(context);
  }

  Widget _buildPictureSection(BuildContext context) {
    return MyNeuButton(
      enableAnimation: true,
      buttonHeight: kMassiveSize,
      buttonWidth: double.maxFinite,
      buttonColor: Colors.white,
      shadowColor: Colors.transparent,
      onPressed: () async {
        MyNavigator.navigateToMyPhotoView(context: context, path: picturePath!);
      },
      borderRadius: MyBorderRadius.baseRadius(context),
      child: Row(
        children: [
          horizontalSpaceMedium,
          const Icon(BoxIcons.bxs_file_image, size: kMediumIconSize),
          horizontalSpaceSmall,
          Expanded(
            child: Text(context.localeString('picture'), style: MyPixelFontStyle.h3(context)),
          ),
          Expanded(
            child: Image.file(
              File(widget.item.picturePath!),
              fit: BoxFit.fitWidth,
              scale: 0.5,
              filterQuality: FilterQuality.low,
              isAntiAlias: false,
              frameBuilder: (context, widget, i, b) {
                return Container(
                  decoration: const BoxDecoration(
                    border: Border(
                      left: BorderSide(width: 2),
                      right: BorderSide(width: 2),
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
          horizontalSpaceSmall,
          const Icon(BoxIcons.bxs_chevron_right, size: kMediumIconSize),
          horizontalSpaceMedium,
        ],
      ),
    );
  }
}
