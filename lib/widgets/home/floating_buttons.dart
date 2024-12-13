import 'dart:io';

import 'package:app_local/app_local.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:image_picker/image_picker.dart';
import 'package:neubrutalism_ui/neubrutalism_ui.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:pricecal/blocs/item_list/bloc.dart';
import 'package:pricecal/data/models/item.dart';
import 'package:pricecal/my_navigator.dart';
import 'package:pricecal/my_snackbar.dart';
import 'package:pricecal/ui_helpers.dart';

class HomeFloatingButtons extends StatelessWidget {
  const HomeFloatingButtons({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: kSmallSize),
          child: NeuIconButton(
            enableAnimation: true,
            buttonColor: Colors.orangeAccent,
            borderRadius: MyBorderRadius.baseRadius(context),
            icon: const Icon(
              BoxIcons.bxs_edit_alt,
            ),
            onPressed: () {
              MyNavigator.navigateToItemDetail(
                context: context,
                itemListBlocValue: BlocProvider.of<ItemListBloc>(context),
                item: Item(
                  price: 0,
                  name: context.localeString('item'),
                  count: 0,
                  picturePath: null,
                ),
              );
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(right: kSmallSize),
          child: NeuIconButton(
            enableAnimation: true,
            buttonColor: Colors.greenAccent,
            borderRadius: MyBorderRadius.baseRadius(context),
            icon: const Icon(
              BoxIcons.bxs_camera,
            ),
            onPressed: () async {
              String name = context.localeString('item');

              var path = await onTakePictureTapped(context);

              if (path == null) return;

              Item item = Item(price: 0, count: 1, name: name, picturePath: path);

              if (context.mounted) {
                MyNavigator.navigateToItemDetail(
                  context: context,
                  itemListBlocValue: BlocProvider.of<ItemListBloc>(context),
                  item: item,
                  isCommingFromML: true,
                );
              }
            },
          ),
        ),
      ],
    );
  }

  Future<String?> onTakePictureTapped(BuildContext context) async {
    bool hasCamera = await Permission.camera.request() == PermissionStatus.granted;

    if (hasCamera == false) {
      if (context.mounted) {
        MySnackbar.showCustomSnackbar(context, text: context.localeString('cannot_get_camera_permission'));
      }
      return null;
    }

    XFile? pickedFile = await ImagePicker().pickImage(
      source: ImageSource.camera,
      requestFullMetadata: false,
    );

    if (pickedFile == null) {
      if (context.mounted) MySnackbar.showCustomSnackbar(context, text: context.localeString('cannot_take_picture'));
      return null;
    }

    String? path = await _saveToDir(pickedFile);
    if (path == null) {
      if (context.mounted) MySnackbar.showCustomSnackbar(context, text: context.localeString('cannot_save_picture'));
      return null;
    }

    return path;
  }

  Future<String?> _saveToDir(XFile pickedFile) async {
    var path = (await getApplicationCacheDirectory()).path;

    var folderName = 'pictures';

    await Directory.fromUri(Uri(path: path + folderName)).create(recursive: true);

    var finalPath = '$path$folderName/${DateTime.now().millisecondsSinceEpoch}.jpg';

    await pickedFile.saveTo(finalPath);

    return finalPath;
  }
}
