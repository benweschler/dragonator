import 'package:dragonator/styles/styles.dart';
import 'package:dragonator/styles/theme.dart';
import 'package:dragonator/widgets/buttons/expanding_buttons.dart';
import 'package:flutter/material.dart';

import 'popup_dialog.dart';

class TeamDeletedPopup extends StatelessWidget {
  const TeamDeletedPopup({super.key});

  @override
  Widget build(BuildContext context) {
    return PopupDialog(
      child: Padding(
        padding: EdgeInsets.all(Insets.lg),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Team Deleted', style: TextStyles.title1),
            const SizedBox(height: Insets.med),
            Text(
              //TODO: change to use team name
              'This team has been deleted by another collaborator.',
              style: TextStyles.body1,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: Insets.xl),
            ExpandingStadiumButton(
              onTap: Navigator.of(context).pop,
              color: AppColors.of(context).primary,
              label: 'Done',
            ),
            SizedBox(height: Insets.sm),
          ],
        ),
      ),
    );
  }
}
