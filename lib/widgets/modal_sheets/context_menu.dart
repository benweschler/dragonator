import 'package:dragonator/styles/styles.dart';
import 'package:dragonator/utils/iterable_utils.dart';
import 'package:flutter/material.dart';

import 'modal_sheet.dart';

class ContextMenu extends StatelessWidget {
  final List<ContextMenuAction> actions;

  const ContextMenu(this.actions, {super.key});

  @override
  Widget build(BuildContext context) {
    return ModalSheet(
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
  final GestureTapCallback onTap;
  final String label;

  const ContextMenuAction({
    super.key,
    required this.icon,
    required this.onTap,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        onTap();
        // Modal sheets are shown on the root navigator.
        Navigator.of(context, rootNavigator: true).pop();
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
            Expanded(child: Text(label)),
          ],
        ),
      ),
    );
  }
}
