import 'package:app_local/app_local.dart';
import 'package:flutter/material.dart';
import 'package:pricecal/my_release_note.dart';
import 'package:pricecal/ui_helpers.dart';

class MyReleaseNotesDialog extends StatelessWidget {
  final List<Release>? releases;
  const MyReleaseNotesDialog({super.key, this.releases});

  @override
  Widget build(BuildContext context) {
    Release lastestReleases = ReleaseNote.releases[context.currentLocale.toString()]!.first;
    List<Release> releases = this.releases ?? [lastestReleases];

    return Dialog(
      insetPadding: const EdgeInsets.symmetric(horizontal: kMassiveSize),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(kSurfaceRadius)),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: kMediumSize, vertical: kMediumSize),
        width: MediaQuery.sizeOf(context).width,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              this.releases == null ? context.localeString('whats_new') : context.localeString('change_logs'),
              style: const TextStyle(
                fontSize: kLargerFontSize,
                fontWeight: FontWeight.w500,
              ),
            ),
            verticalSpaceMedium,
            verticalSpaceTiny,
            Container(
              constraints: BoxConstraints.loose(Size(MediaQuery.sizeOf(context).width, MediaQuery.sizeOf(context).height / 2)),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: releases.map((e) => _buildReleaseSection(context, e)).toList(),
                ),
              ),
            ),
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: () {
                  Navigator.pop(context, true);
                },
                child: Text(
                  context.localeString('close'),
                  style: const TextStyle(
                    fontSize: kMediumFontSize,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildReleaseSection(BuildContext context, Release release) {
    String title = '# ${release.title}';

    List<ChangeGroup>? changes = release.changes;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: kBigFontSize,
            fontWeight: FontWeight.w500,
          ),
        ),
        verticalSpaceSmall,
        verticalSpaceTiny,
        ...changes.map((e) => _buildOneChangeSection(e, context)),
        verticalSpaceTiny,
        if (releases != null)
          const Divider(
            height: 1,
          ),
        verticalSpaceMedium,
      ],
    );
  }

  Widget _buildOneChangeSection(ChangeGroup change, BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          change.title,
          style: const TextStyle(
            fontSize: kNormalFontSize,
            decoration: TextDecoration.underline,
            fontWeight: FontWeight.w500,
          ),
        ),
        verticalSpaceTiny,
        ...change.changes.map(
          (e) => Text(
            '• $e',
            style: const TextStyle(fontSize: kMediumFontSize),
          ),
        ),
        verticalSpaceSmall,
      ],
    );
  }
}
