import 'package:dragonator/styles/styles.dart';
import 'package:dragonator/styles/theme.dart';
import 'package:dragonator/widgets/buttons/expanding_buttons.dart';
import 'package:dragonator/widgets/popups/popup_dialog.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class PaddlerDeletedPopup extends StatelessWidget {
  final List<String> deletedPaddlerNames;

  const PaddlerDeletedPopup(this.deletedPaddlerNames, {super.key});

  @override
  Widget build(BuildContext context) {
    assert(deletedPaddlerNames.isNotEmpty);

    final Widget content;
    if (deletedPaddlerNames.length == 1) {
      content = Text.rich(TextSpan(children: [
        TextSpan(text: 'The paddler '),
        TextSpan(
          text: deletedPaddlerNames.first,
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        TextSpan(text: ' has been deleted by a collaborator.')
      ]));
    } else if (deletedPaddlerNames.length == 2) {
      content = Text.rich(TextSpan(children: [
        TextSpan(text: 'The paddlers '),
        TextSpan(
          text: deletedPaddlerNames[0],
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        TextSpan(text: ' and '),
        TextSpan(
          text: deletedPaddlerNames[1],
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        TextSpan(text: ' have been deleted by a collaborator.')
      ]));
    } else {
      final lastDeletedName = deletedPaddlerNames.removeLast();
      content = Text.rich(TextSpan(children: [
        TextSpan(text: 'The paddlers '),
        TextSpan(
          text: deletedPaddlerNames.join(', '),
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        TextSpan(text: ' and '),
        TextSpan(
          text: lastDeletedName,
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        TextSpan(text: ' have been deleted by a collaborator.')
      ]));
    }

    return PopupDialog(
      child: Padding(
        padding: EdgeInsets.all(Insets.lg),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              '${deletedPaddlerNames.length > 1 ? 'Paddlers' : 'Paddler'} Deleted',
              style: TextStyles.title1,
            ),
            SizedBox(height: Insets.med),
            content,
            SizedBox(height: Insets.xl),
            ExpandingStadiumButton(
              onTap: context.pop,
              color: AppColors.of(context).primary,
              label: 'Confirm',
            ),
            SizedBox(height: Insets.sm),
          ],
        ),
      ),
    );
  }
}
