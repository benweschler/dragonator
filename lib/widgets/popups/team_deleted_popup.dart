import 'package:dragonator/styles/styles.dart';
import 'package:dragonator/styles/theme.dart';
import 'package:dragonator/widgets/buttons/expanding_buttons.dart';
import 'package:flutter/material.dart';

import 'popup_dialog.dart';

class TeamDeletedPopup extends StatelessWidget {
  final String teamName;

  const TeamDeletedPopup(this.teamName, {super.key});

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
            Text.rich(TextSpan(children: [
              TextSpan(text: 'The team '),
              TextSpan(
                text: teamName,
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              TextSpan(text: ' has been deleted by a collaborator.')
            ])),
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
