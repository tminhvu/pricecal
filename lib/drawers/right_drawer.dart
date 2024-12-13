import 'package:app_local/app_local.dart';
import 'package:country_flags/country_flags.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:neubrutalism_ui/neubrutalism_ui.dart';
import 'package:pricecal/data/repository/item_list_repository.dart';
import 'package:pricecal/my_links.dart';
import 'package:pricecal/my_navigator.dart';
import 'package:pricecal/my_release_note.dart';
import 'package:pricecal/ui_helpers.dart';
import 'package:pricecal/widgets/my_confirmation_dialog.dart';
import 'package:url_launcher/url_launcher.dart';

class RightDrawer extends StatefulWidget {
  const RightDrawer({super.key});

  @override
  State<RightDrawer> createState() => _RightDrawerState();
}

class _RightDrawerState extends State<RightDrawer> {
  bool _isSendingDiagnostics = FirebaseCrashlytics.instance.isCrashlyticsCollectionEnabled;

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
            topRight: Radius.zero,
            bottomRight: Radius.zero,
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: kMediumSize, horizontal: kSmallSize),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  children: [
                    const Icon(
                      BoxIcons.bxs_cog,
                    ),
                    horizontalSpaceTiny,
                    Text(context.localeString('settings'), style: MyPixelFontStyle.h2(context)),
                  ],
                ),
                verticalSpaceLarge,
                TextButton(
                  onPressed: () {
                    onRateFiveStarsPressed(context);
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        context.localeString('Rate_five_Stars'),
                        style: MyPixelFontStyle.h3(context),
                      ),
                      const Icon(BoxIcons.bxl_play_store, size: kMediumIconSize),
                    ],
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextButton(
                      onPressed: () {},
                      style: const ButtonStyle(splashFactory: NoSplash.splashFactory),
                      child: Text(
                        '${context.localeString('language')}:',
                        style: MyPixelFontStyle.h3(context),
                      ),
                    ),
                    Expanded(
                      child: DropdownButton(
                        isExpanded: true,
                        items: [
                          DropdownMenuItem(
                            value: 'en',
                            child: Row(
                              children: [
                                CountryFlag.fromLanguageCode(
                                  'en',
                                  height: kMediumIconSize,
                                  width: kLargeIconSize,
                                ),
                                horizontalSpaceSmall,
                                Expanded(
                                  child: Text(
                                    context.localeString('English'),
                                    style: MyPixelFontStyle.h3(context),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          DropdownMenuItem(
                            value: 'vi',
                            child: Row(
                              children: [
                                CountryFlag.fromCountryCode(
                                  'vn',
                                  height: kMediumIconSize,
                                  width: kLargeIconSize,
                                ),
                                horizontalSpaceSmall,
                                Expanded(
                                  child: Text(
                                    context.localeString('vietnamese'),
                                    style: MyPixelFontStyle.h3(context),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                        value: context.currentLocale!.languageCode,
                        onChanged: (value) {
                          context.changeLocale(value!);
                        },
                        style: MyPixelFontStyle.h3(context),
                      ),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: TextButton(
                        onPressed: () {
                          setState(() {
                            _isSendingDiagnostics = !_isSendingDiagnostics;
                            FirebaseCrashlytics.instance.setCrashlyticsCollectionEnabled(_isSendingDiagnostics);
                          });
                        },
                        style: const ButtonStyle(splashFactory: NoSplash.splashFactory),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            context.localeString('send_diagnostics'),
                            style: MyPixelFontStyle.h3(context).copyWith(
                              overflow: TextOverflow.visible,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Switch(
                      value: _isSendingDiagnostics,
                      onChanged: (value) {
                        setState(() {
                          _isSendingDiagnostics = value;
                          FirebaseCrashlytics.instance.setCrashlyticsCollectionEnabled(value);
                        });
                      },
                    ),
                  ],
                ),
                verticalSpaceLarge,
                TextButton(
                  onPressed: () {
                    onAboutPressed(context);
                  },
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      context.localeString('about'),
                      style: MyPixelFontStyle.h3(context),
                    ),
                  ),
                ),
                TextButton(
                  onPressed: () {
                    onChangeLogPressed(context);
                  },
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      context.localeString('change_logs'),
                      style: MyPixelFontStyle.h3(context),
                    ),
                  ),
                ),
                TextButton(
                  onPressed: () {
                    onPrivacyPressed(context);
                  },
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      context.localeString('privacy_policy'),
                      style: MyPixelFontStyle.h3(context),
                    ),
                  ),
                ),
                TextButton(
                  onPressed: () {
                    onTermsConditionPressed(context);
                  },
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      context.localeString('terms_conditions'),
                      style: MyPixelFontStyle.h3(context),
                    ),
                  ),
                ),
                verticalSpaceLarge,
                TextButton.icon(
                  onPressed: () {
                    onClearAllDataPressed(context);
                  },
                  label: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      context.localeString('clear_all_data'),
                      style: MyPixelFontStyle.h3(context).copyWith(
                        color: Colors.red.shade700,
                      ),
                    ),
                  ),
                  icon: Icon(
                    BoxIcons.bxs_trash,
                    color: Colors.red.shade700,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void onRateFiveStarsPressed(BuildContext context) async {
    await launchUrl(
      MyLinks.googlePlay,
    ).onError(
      (error, stackTrace) {
        throw Exception(
          'Can not open Google Play $error',
        );
      },
    );
  }

  void onClearAllDataPressed(BuildContext context) {
    MyNavigator.showConfirmationDialog(
      context: context,
      description: context.localeString('Clear_all_data'),
      titleText: context.localeString('This_action_cannot_be_undone'),
      confirmLabel: context.localeString('clear'),
      dismissLabel: context.localeString('cancel'),
      important: true,
    ).then((res) {
      if (res == ConfirmationResponse.confirm && context.mounted) {
        RepositoryProvider.of<ItemListRepository>(context).clearAllData();
      }
    });
  }

  void onChangeLogPressed(BuildContext context) {
    MyNavigator.showReleaseDialog(
      context: context,
      releases: ReleaseNote.releases[context.currentLocale.toString()],
    );
  }

  void onAboutPressed(BuildContext context) async {
    showAboutDialog(
      context: context,
      applicationName: 'Price Scanner',
      applicationVersion: ReleaseNote.version,
      applicationIcon: const Padding(
        padding: EdgeInsets.only(
          top: kMediumSize,
        ),
        child: Icon(
          BoxIcons.bx_scan,
          size: 64,
        ),
      ),
      applicationLegalese: context.localeString('thank_you'),
      children: [
        verticalSpaceMedium,
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            TextButton(
              child: const Row(
                children: [
                  Icon(BoxIcons.bxl_github, size: kMediumIconSize),
                  horizontalSpaceSmall,
                  Text('Github'),
                ],
              ),
              onPressed: () async {
                if (!await launchUrl(
                  MyLinks.githubLink,
                  mode: LaunchMode.externalApplication,
                )) {
                  throw Exception('Could not launch');
                }
              },
            ),
            TextButton(
              child: const Row(
                children: [
                  Icon(BoxIcons.bxs_envelope, size: kMediumIconSize),
                  horizontalSpaceSmall,
                  Text('Email'),
                ],
              ),
              onPressed: () async {
                if (!await launchUrl(MyLinks.emailLink)) {
                  throw Exception('Could not launch');
                }
              },
            ),
          ],
        ),
      ],
    );
  }

  void onPrivacyPressed(BuildContext context) async {
    String privacy = await DefaultAssetBundle.of(context).loadString('assets/markdowns/privacy.md');

    if (!context.mounted) return;

    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: context.localeString('privacy_policy'),
      pageBuilder: (context, animation, secondaryAnimation) {
        return SafeArea(
          child: Dialog(
            shape: RoundedRectangleBorder(borderRadius: MyBorderRadius.baseRadius(context)),
            child: Container(
              padding: const EdgeInsets.all(kMediumSize),
              child: SingleChildScrollView(
                child: MarkdownBody(data: privacy),
              ),
            ),
          ),
        );
      },
    );
  }

  void onTermsConditionPressed(BuildContext context) async {
    String privacy = await DefaultAssetBundle.of(context).loadString('assets/markdowns/terms_conditions.md');

    if (!context.mounted) return;

    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: context.localeString('terms_conditions'),
      pageBuilder: (context, animation, secondaryAnimation) {
        return SafeArea(
          child: Dialog(
            shape: RoundedRectangleBorder(borderRadius: MyBorderRadius.baseRadius(context)),
            child: Container(
              padding: const EdgeInsets.all(kMediumSize),
              child: SingleChildScrollView(child: MarkdownBody(data: privacy)),
            ),
          ),
        );
      },
    );
  }
}
