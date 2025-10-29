import 'package:dragonator/styles/styles.dart';
import 'package:dragonator/styles/theme.dart';
import 'package:dragonator/widgets/buttons/expanding_buttons.dart';
import 'package:dragonator/widgets/popups/popup_dialog.dart';
import 'package:flutter/material.dart';

class TeamDetailDeletedPopup extends StatelessWidget {
  final String detailType;

  const TeamDetailDeletedPopup(this.detailType, {super.key});

  @override
  Widget build(BuildContext context) {
    return PopupDialog(
      child: Padding(
        padding: EdgeInsets.all(Insets.lg),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              '${detailType[0].toUpperCase()}${detailType.substring(1).toLowerCase()} Deleted',
              style: TextStyles.title1,
            ),
            const SizedBox(height: Insets.med),
            Text(
              'This ${detailType.toLowerCase()} has been deleted by a collaborator.',
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: Insets.xl),
            ExpandingStadiumButton(
              onTap: Navigator.of(context).pop,
              color: AppColors.of(context).primary,
              label: 'Dismiss',
            ),
            SizedBox(height: Insets.sm),
          ],
        ),
      ),
    );
  }
}
