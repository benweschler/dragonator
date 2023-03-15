import 'package:dragonator/styles/styles.dart';
import 'package:dragonator/utils/iterable_utils.dart';
import 'package:flutter/material.dart';

import 'modal_sheet.dart';

//TODO: this is currently unused
class ContextMenu extends StatelessWidget {
  final List<ContextMenuAction> actions;

  const ContextMenu({
    Key? key,
    required this.actions,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ModalSheet(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      child: Scrollbar(
        thumbVisibility: true,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[...actions]
                //TODO: using divider here
                .separate(const Divider(height: 0.5, thickness: 0.5))
                .toList(),
          ),
        ),
      ),
    );
  }
}

class ContextMenuAction extends StatelessWidget {
  final IconData icon;
  final String label;
  final GestureTapCallback onTap;

  const ContextMenuAction({
    Key? key,
    required this.icon,
    required this.label,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        onTap();
        Navigator.of(context).pop();
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: Insets.offset,
          vertical: Insets.lg,
        ),
        child: Row(
          children: [
            Icon(icon),
            const SizedBox(width: Insets.lg),
            Expanded(
              child: Text(
                label,
                style: TextStyles.body1.copyWith(fontWeight: FontWeight.w600),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
